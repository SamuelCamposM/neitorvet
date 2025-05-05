import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/datasources/cierre_surtidores_datasource.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/provider/cierre_surtidores_repository_provider.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/surtidor.dart';
import 'package:neitorvet/features/venta/infrastructure/delegatesFunction/delegates.dart';
import 'package:neitorvet/features/venta/presentation/provider/form/venta_form_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/tabs_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/venta_abastecimiento_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_provider.dart';

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
    final ventaFormProviderParams =
        VentaFormProviderParams(editar: false, id: ventaId);

    return BodyMenuDespacho(
      ventaFormProviderParams: ventaFormProviderParams,
    );
  }
}

class BodyMenuDespacho extends ConsumerStatefulWidget {
  final VentaFormProviderParams ventaFormProviderParams;

  const BodyMenuDespacho({
    Key? key,
    required this.ventaFormProviderParams,
  }) : super(key: key);

  @override
  BodyMenuDespachoState createState() => BodyMenuDespachoState();
}

class BodyMenuDespachoState extends ConsumerState<BodyMenuDespacho> {
  late List<Surtidor> uniqueSurtidores;

  @override
  void initState() {
    super.initState();
    // Inicializar los valores necesarios
    uniqueSurtidores = ref.read(ventasProvider.notifier).getUniqueSurtidores();
  }

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);

    ref.watch(ventasProvider);
    final ventaFState =
        ref.watch(ventaFormProvider(widget.ventaFormProviderParams));
    final ventaFormNotifier =
        ref.watch(ventaFormProvider(widget.ventaFormProviderParams).notifier);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Despacho'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.wScreen(100.0),
          padding: EdgeInsets.only(top: size.iScreen(1.0)),
          child: Column(
            children: [
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

                    ventaFormNotifier.updateState(
                        nuevoProducto: Producto(
                      cantidad: 0,
                      codigo: inventario.invSerie,
                      descripcion: inventario.invNombre,
                      valUnitarioInterno:
                          Parse.parseDynamicToDouble(inventario.invprecios[0]),
                      valorUnitario:
                          Parse.parseDynamicToDouble(inventario.invprecios[0]),
                      llevaIva: inventario.invIva,
                      incluyeIva: inventario.invIncluyeIva,
                      recargoPorcentaje: 0,
                      recargo: 0,
                      descPorcentaje: ventaFState.ventaForm.venDescPorcentaje,
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
                          ventaFState: ventaFState,
                          ventaFormNotifier: ventaFormNotifier,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardSurtidor extends ConsumerWidget {
  final Responsive size;
  final Surtidor surtidor;
  final VentaFormState ventaFState;
  final VentaFormNotifier ventaFormNotifier;
  const _CardSurtidor({
    required this.size,
    required this.surtidor,
    required this.ventaFState,
    required this.ventaFormNotifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getLados = ref.read(ventasProvider.notifier).getLados;

    return Card(
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
                      fontSize: size.iScreen(2.0), fontWeight: FontWeight.bold),
                ),
                Wrap(
                  children: getLados(surtidor.nombreSurtidor).map((surtidor) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: size.iScreen(0.5)),
                      padding: const EdgeInsets.all(2.0),
                      child: TextButton(
                        onPressed: () async {
                          final List<Estacion> estaciones = [
                            surtidor.estacion1,
                            surtidor.estacion2,
                            surtidor.estacion3,
                          ]
                              .where(
                                  (element) => element?.nombreProducto != null)
                              .cast<Estacion>()
                              .toList();
                          if (estaciones.isEmpty) {
                            return NotificationsService.show(
                                context,
                                'Este lado no tiene productos',
                                SnackbarCategory.error);
                          }
                          ResponseModal? responseModal = await _surtidorModal(
                              context, size, surtidor, estaciones);

                          if (responseModal != null) {
                            // final res = await ref
                            //     .read(ventasRepositoryProvider)
                            //     .getInventarioByPistola(
                            //         pistola: responseModal
                            //             .estacion.numeroPistola
                            //             .toString(),
                            //         codigoCombustible: responseModal
                            //             .estacion.codigoProducto
                            //             .toString(),
                            //         numeroTanque: responseModal
                            //             .estacion.numeroTanque
                            //             .toString());
                            // if (res.error.isNotEmpty && context.mounted) {
                            //   NotificationsService.show(
                            //       context, res.error, SnackbarCategory.error);
                            //   return;
                            // }

                            // ventaFormNotifier.updateState(
                            //     monto: res.total,
                            //     ventaForm: ventaFState.ventaForm.copyWith(
                            //       idAbastecimiento: res.idAbastecimiento,
                            //       totInicio: res.totInicio,
                            //       totFinal: res.totFinal,
                            //     ),
                            //     nuevoProducto: Producto(
                            //       cantidad: 0,
                            //       codigo: res.resultado!.invSerie,
                            //       descripcion: res.resultado!.invNombre,
                            //       valUnitarioInterno: double.parse(
                            //         Parse.parseDynamicToDouble(
                            //                 res.resultado!.invprecios[0])
                            //             .toStringAsFixed(3),
                            //       ),
                            //       valorUnitario: double.parse(
                            //         Parse.parseDynamicToDouble(
                            //                 res.resultado!.invprecios[0])
                            //             .toStringAsFixed(3),
                            //       ),
                            //       llevaIva: res.resultado!.invIva,
                            //       incluyeIva: res.resultado!.invIncluyeIva,
                            //       recargoPorcentaje: 0,
                            //       recargo: 0,
                            //       descPorcentaje:
                            //           ventaFState.ventaForm.venDescPorcentaje,
                            //       descuento: 0,
                            //       precioSubTotalProducto: 0,
                            //       valorIva: 0,
                            //       costoProduccion: 0,
                            //     ));
                            final responseGetStatus = await ref
                                .read(cierreSurtidoresRepositoryProvider)
                                .getStatusPicos(
                                    manguera: responseModal
                                        .estacion.numeroPistola
                                        .toString());

                            if (!responseGetStatus.success && context.mounted) {
                              ref
                                  .read(cierreSurtidoresRepositoryProvider)
                                  .setModoManguera(
                                      manguera: responseModal
                                          .estacion.numeroPistola
                                          .toString(),
                                      modo: '03');
                              NotificationsService.show(
                                  context,
                                  'No se puede despachar',
                                  SnackbarCategory.error);

                              return;
                            }
                            if (context.mounted) {
                              final res = await mostrarModalCentrado(
                                context: context,
                                numeroPistola: responseModal
                                    .estacion.numeroPistola
                                    .toString(),
                                presetExtendido: ref
                                    .read(cierreSurtidoresRepositoryProvider)
                                    .presetExtendido,
                                venId: ventaFState.ventaForm.venId,
                              );

                              if (res == 'cerrar') {
                                return;
                              }
                            }
                            ref
                                .read(cierreSurtidoresRepositoryProvider)
                                .setModoManguera(
                                    manguera: responseModal
                                        .estacion.numeroPistola
                                        .toString(),
                                    modo: '01');

                            //* ESTADO DEL FORM
                            ventaFormNotifier.setManguera(responseModal
                                .estacion.numeroPistola
                                .toString());
                            ventaFormNotifier.setNombreCombustible(responseModal
                                .estacion.nombreProducto
                                .toString());
                            //* ESTADO DEL TAB
                            ref.read(tabsProvider.notifier).updateTabManguera(
                                  ventaFState.ventaFormProviderParams.id,
                                  manguera: responseModal.estacion.numeroPistola
                                      .toString(),
                                  nombreCombustible:
                                      responseModal.estacion.nombreProducto,
                                );
                            // nombreCombustible:
                            //     responseModal.estacion.nombreProducto);
                            if (context.mounted) {
                              context.pop();
                            }
                            // final errorAgregar =
                            //     ventaFormNotifier.agregarProducto(null);

                            // if (context.mounted && !errorAgregar) {
                            //   context.pop(context);
                            // }
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
            )));
  }
}

Future<ResponseModal?> _surtidorModal(BuildContext context, Responsive size,
    Surtidor data, List<Estacion> estaciones) async {
  return await showCupertinoModalPopup<ResponseModal>(
    context: context,
    builder: (BuildContext builder) {
      return CupertinoActionSheet(
        title: Text(
          '${data.nombreSurtidor.toUpperCase()} Lado ${data.lado.toUpperCase()} ',
          style: TextStyle(
            fontSize: size.iScreen(2.0),
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: estaciones.map<CupertinoActionSheetAction>((Estacion e) {
          return CupertinoActionSheetAction(
            child: Text('${e.nombreProducto ?? ""} - ${e.numeroPistola}'),
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

Future<String?> mostrarModalCentrado({
  required BuildContext context,
  required String numeroPistola,
  required int venId,
  required Future<ResponsePresetExtendido> Function({
    required String manguera,
    required String valorPreset,
    required String tipoPreset,
    required String nivelPrecio,
  }) presetExtendido,
}) async {
  final TextEditingController valorController = TextEditingController();
  final TextEditingController galonesController = TextEditingController();

  return await showDialog<String>(
    context: context,
    barrierDismissible: false, // Evita que se cierre al tocar fuera del modal
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0), // Bordes redondeados
            ),
            contentPadding: const EdgeInsets.all(16.0),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Despacho",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  CustomInputField(
                    controller: valorController,
                    maxDigits: 3,
                    onlyInt: true,
                    keyboardType: TextInputType.number,
                    label: 'Valor \$',
                    onChanged: (p0) {
                      // Borra el valor de galones y actualiza el estado
                      setState(() {
                        final int? parsedValue = int.tryParse(p0);
                        valorController.value = TextEditingValue(
                          text:
                              parsedValue != null ? parsedValue.toString() : '',
                        );
                        galonesController.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  CustomInputField(
                    controller: galonesController,
                    maxDigits: 2,
                    onlyInt: true,
                    keyboardType: TextInputType.number,
                    label: 'Galones',
                    onChanged: (p0) {
                      // Borra el valor de valor y actualiza el estado
                      setState(() {
                        final int? parsedValue = int.tryParse(p0);
                        galonesController.value = TextEditingValue(
                          text:
                              parsedValue != null ? parsedValue.toString() : '',
                        );
                        valorController.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 32.0),
                  SizedBox(
                    width: double.infinity, // Ocupa todo el ancho disponible
                    child: ElevatedButton(
                      onPressed: () async {
                        if (valorController.text.isEmpty ||
                            galonesController.text.isEmpty) {
                          context
                              .pop("no cerrar"); // Devuelve "cerrar" al cerrar
                          return;
                        }
                        presetExtendido(
                            manguera: numeroPistola,
                            valorPreset: valorController.text != ''
                                ? valorController.text
                                : galonesController.text,
                            tipoPreset: valorController.text != '' ? '0' : '1',
                            nivelPrecio: '0');
                        final int valor =
                            int.tryParse(valorController.text) ?? 0;
                        final int galones =
                            int.tryParse(galonesController.text) ?? 0;
                        print("Valor: $valor, Galones: $galones");

                        context.pop("no cerrar"); // Devuelve "cerrar" al cerrar
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blue, // Color de fondo del botón
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0), // Altura del botón
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Bordes redondeados
                        ),
                      ),
                      child: const Text(
                        "Liberar",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Color del texto
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop("cerrar"); // Devuelve "cerrar"
                      },
                      child: const Text("Cerrar"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
