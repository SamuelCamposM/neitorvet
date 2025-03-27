import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/provider/cierre_surtidores_repository_provider.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/surtidor.dart';
import 'package:neitorvet/features/venta/infrastructure/delegatesFunction/delegates.dart';
import 'package:neitorvet/features/venta/presentation/provider/form/venta_form_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/venta_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_repository_provider.dart';

class ResponseModal {
  Estacion estacion;
  Surtidor surtidor;

  ResponseModal({
    required this.estacion,
    required this.surtidor,
  });
}

class MenuDespacho extends ConsumerWidget {
  final int ventaId;
  const MenuDespacho({super.key, required this.ventaId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ventaState = ref.watch(ventaProvider(ventaId));
    return BodyMenuDespacho(ventaState: ventaState);
  }
}

class BodyMenuDespacho extends ConsumerWidget {
  final VentaState? ventaState;

  const BodyMenuDespacho({
    Key? key,
    required this.ventaState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final VentaFormState? ventaFState = ventaState?.venta != null
        ? ref.watch(ventaFormProvider(ventaState!.venta!))
        : null;
    final size = Responsive.of(context);
    ref.watch(ventasProvider);
    final uniqueSurtidores =
        ref.read(ventasProvider.notifier).getUniqueSurtidores();

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(ventaState != null ? 'Despacho' : "Cierre de Caja"),
      ),
      body: Container(
        width: size.wScreen(100.0),
        height: size.hScreen(100.0),
        padding: EdgeInsets.only(top: size.iScreen(1.0)),
        child: Column(
          children: [
            if (ventaFState != null && ventaState != null)
              OutlinedButton.icon(
                onPressed: () async {
                  final inventario = await searchInventario(
                      context: context, ref: ref, filterByCategory: true);
                  if (inventario != null) {
                    final exist = ventaFState.ventaForm.venProductosInput.value
                        .any((e) => e.codigo == inventario.invSerie);
                    if (exist) {
                      if (context.mounted) {
                        NotificationsService.show(
                            context,
                            'Este Producto ya se encuentra en la lista',
                            SnackbarCategory.error);
                      }
                      return;
                    }
                    ref
                        .read(ventaFormProvider(ventaState!.venta!).notifier)
                        .updateState(
                            nuevoProducto: Producto(
                          cantidad: 0,
                          codigo: inventario.invSerie,
                          descripcion: inventario.invNombre,
                          valUnitarioInterno: Parse.parseDynamicToDouble(
                              inventario.invprecios[0]),
                          valorUnitario: Parse.parseDynamicToDouble(
                              inventario.invprecios[0]),
                          llevaIva: inventario.invIva,
                          incluyeIva: inventario.invIncluyeIva,
                          recargoPorcentaje: 0,
                          recargo: 0,
                          descPorcentaje: ventaState!.venta!.venDescPorcentaje,
                          descuento: 0,
                          precioSubTotalProducto: 0,
                          valorIva: 0,
                          costoProduccion: 0,
                        ));
                    if (context.mounted) {
                      context.pop(context);
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: ventaFState.nuevoProducto.errorMessage != null
                          ? Colors.red
                          : Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                icon: const Icon(Icons.create),
                label: Text(
                  ventaFState.nuevoProducto.errorMessage != null
                      ? ventaFState.nuevoProducto.errorMessage!
                      : ventaFState.nuevoProducto.value.descripcion == ''
                          ? "Otros Productos*"
                          : '${ventaFState.nuevoProducto.value.descripcion} \$${ventaFState.nuevoProducto.value.valorUnitario}',
                ),
              ),
            Wrap(
              alignment: WrapAlignment.center,
              children: uniqueSurtidores
                  .map((e) => _CardSurtidor(
                        size: size,
                        surtidor: e,
                        ventaState: ventaState,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardSurtidor extends ConsumerWidget {
  final Responsive size;
  final Surtidor surtidor;
  final VentaState? ventaState;
  const _CardSurtidor(
      {required this.size, required this.surtidor, this.ventaState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getLados = ref.read(ventasProvider.notifier).getLados;
    final generarCierre =
        ref.read(cierreSurtidoresRepositoryProvider).generarCierre;
    return GestureDetector(
      onTap: () async {
        if (ventaState == null) {
          String? responseModal = await _cierreModal(context, size, surtidor);
          responseModal;
          if (responseModal == 'SI') {
            final surtidores = getLados(surtidor.nombreSurtidor);
            List<String> codCombustible = [];
            List<String> pistolas = [];
            for (var element in surtidores) {
              final List<Estacion> estaciones = [
                element.estacion1,
                element.estacion2,
                element.estacion3,
              ]
                  .where((estacion) => estacion?.nombreProducto != null)
                  .cast<Estacion>()
                  .toList();

              for (var estacion in estaciones) {
                pistolas.add(estacion.numeroPistola.toString());
                if (!codCombustible
                    .contains(estacion.codigoProducto.toString())) {
                  codCombustible.add(estacion.codigoProducto.toString());
                }
              }
            }

            final response = await generarCierre(
                codCombustible: codCombustible, pistolas: pistolas);
            if (response.error.isNotEmpty && context.mounted) {
              NotificationsService.show(
                  context, response.error, SnackbarCategory.error);
            } else {
              if (context.mounted) {
                context.push('/cierre_surtidores/${response.uuid}');
              }
            }
          }
        }
      },
      child: Card(
          color: const Color.fromARGB(255, 110, 107, 107),
          elevation: 5.0, // Agrega una elevación para la sombra
          shadowColor: Colors.grey
              .withAlpha((0.5 * 255).toInt()), // Color de la sombra (opcional)
          child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: size.iScreen(1.0), vertical: size.iScreen(1.0)),
              padding: EdgeInsets.symmetric(horizontal: size.iScreen(0.5)),
              child: Column(
                children: [
                  Image(
                    image: const AssetImage('assets/images/gas2.png'),
                    width: size.iScreen(7.0),
                  ),
                  SizedBox(
                    height: size.iScreen(1.0),
                  ),
                  Text(
                    surtidor.nombreSurtidor,
                    style: TextStyle(
                        fontSize: size.iScreen(2.0),
                        fontWeight: FontWeight.bold),
                  ),
                  if (ventaState != null)
                    Wrap(
                      children:
                          getLados(surtidor.nombreSurtidor).map((surtidor) {
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: size.iScreen(0.5)),
                          padding: const EdgeInsets.all(2.0),
                          child: TextButton(
                            onPressed: () async {
                              final List<Estacion> estaciones = [
                                surtidor.estacion1,
                                surtidor.estacion2,
                                surtidor.estacion3,
                              ]
                                  .where((element) =>
                                      element?.nombreProducto != null)
                                  .cast<Estacion>()
                                  .toList();
                              if (estaciones.isEmpty) {
                                return NotificationsService.show(
                                    context,
                                    'Este lado no tiene productos',
                                    SnackbarCategory.error);
                              }
                              ResponseModal? responseModal =
                                  await _surtidorModal(
                                      context, size, surtidor, estaciones);

                              if (responseModal != null) {
                                final res = await ref
                                    .read(ventasRepositoryProvider)
                                    .getInventarioByPistola(
                                        pistola: responseModal
                                            .estacion.numeroPistola
                                            .toString(),
                                        codigoCombustible: responseModal
                                            .estacion.codigoProducto
                                            .toString(),
                                        numeroTanque: responseModal
                                            .estacion.numeroTanque
                                            .toString());
                                if (res.error.isNotEmpty && context.mounted) {
                                  NotificationsService.show(context, res.error,
                                      SnackbarCategory.error);
                                  return;
                                }
                                final venta = ref
                                    .read(ventaFormProvider(ventaState!.venta!))
                                    .ventaForm;
                                ref
                                    .read(ventaFormProvider(ventaState!.venta!)
                                        .notifier)
                                    .updateState(
                                        monto: res.total,
                                        ventaForm: venta.copyWith(
                                          idAbastecimiento:
                                              res.idAbastecimiento,
                                          totInicio: res.totInicio,
                                          totFinal: res.totFinal,
                                        ),
                                        nuevoProducto: Producto(
                                          cantidad: 0,
                                          codigo: res.resultado!.invSerie,
                                          descripcion: res.resultado!.invNombre,
                                          valUnitarioInterno:
                                              Parse.parseDynamicToDouble(
                                                  res.resultado!.invprecios[0]),
                                          valorUnitario:
                                              Parse.parseDynamicToDouble(
                                                  res.resultado!.invprecios[0]),
                                          llevaIva: res.resultado!.invIva,
                                          incluyeIva:
                                              res.resultado!.invIncluyeIva,
                                          recargoPorcentaje: 0,
                                          recargo: 0,
                                          descPorcentaje:
                                              venta.venDescPorcentaje,
                                          descuento: 0,
                                          precioSubTotalProducto: 0,
                                          valorIva: 0,
                                          costoProduccion: 0,
                                        ));
                                ref
                                    .read(ventaFormProvider(ventaState!.venta!)
                                        .notifier)
                                    .agregarProducto(null);

                                if (context.mounted) {
                                  context.pop(context);
                                }
                              }
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.iScreen(2.0), vertical: 1.0),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              surtidor.lado,
                              style: TextStyle(
                                  fontSize: size.iScreen(3.0),
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                ],
              ))),
    );
  }
}

Future<ResponseModal?> _surtidorModal(BuildContext context, Responsive size,
    Surtidor data, List<Estacion> estaciones) async {
  return await showCupertinoModalPopup<ResponseModal>(
    context: context,
    builder: (BuildContext builder) {
      return CupertinoActionSheet(
        title: Text(
          '${data.nombreSurtidor.toUpperCase()}   Lado ${data.lado.toUpperCase()} ',
          style: TextStyle(
            fontSize: size.iScreen(2.0),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: estaciones.map<CupertinoActionSheetAction>((Estacion e) {
          return CupertinoActionSheetAction(
            child: Text(e.nombreProducto ?? ""),
            onPressed: () {
              Navigator.pop(
                  context, ResponseModal(estacion: e, surtidor: data));
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    },
  );
}

Future<String?> _cierreModal(
  BuildContext context,
  Responsive size,
  Surtidor data,
) async {
  return await showCupertinoModalPopup<String>(
    context: context,
    builder: (BuildContext builder) {
      return CupertinoActionSheet(
        title: Text(
          'CIERRE SURTIDOR: ${data.nombreSurtidor.toUpperCase()}',
          style: TextStyle(
            fontSize: size.iScreen(2.0),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: ['SI', 'NO'].map<CupertinoActionSheetAction>((String e) {
          return CupertinoActionSheetAction(
            child: Text(e),
            onPressed: () {
              Navigator.pop(context, e);
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    },
  );
}
