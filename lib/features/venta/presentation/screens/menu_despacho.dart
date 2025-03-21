import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';
import 'package:neitorvet/features/venta/domain/entities/surtidor.dart';
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

    final size = Responsive.of(context);
    final uniqueSurtidores =
        ref.read(ventasProvider.notifier).getUniqueSurtidores();
    final getLados = ref.read(ventasProvider.notifier).getLados;
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: const Text('Despacho'),
        ),
        body: Container(
          width: size.wScreen(100.0),
          height: size.hScreen(100.0),
          padding: EdgeInsets.only(top: size.iScreen(1.0)),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: uniqueSurtidores
                .map((e) => Card(
                    color: Colors.white,
                    elevation: 5.0, // Agrega una elevación para la sombra
                    shadowColor: Colors.grey.withAlpha(
                        (0.5 * 255).toInt()), // Color de la sombra (opcional)
                    child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: size.iScreen(1.0),
                            vertical: size.iScreen(1.0)),
                        padding:
                            EdgeInsets.symmetric(horizontal: size.iScreen(0.5)),
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
                              e.nombreSurtidor,
                              style: TextStyle(
                                  fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              children: getLados(e.nombreSurtidor).map((lado) {
                                return Container(
                                  // Agregando Padding para mejor apariencia
                                  margin: EdgeInsets.symmetric(
                                      horizontal: size.iScreen(
                                          0.5)), // Ajusta el padding según necesites
                                  padding: const EdgeInsets.all(
                                      2.0), // Ajusta el padding según necesites
                                  child: TextButton(
                                    onPressed: () async {
                                      final List<Estacion> estaciones = [
                                        lado.estacion1,
                                        lado.estacion2,
                                        lado.estacion3,
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
                                              context, size, lado, estaciones);

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
                                        if (res.error.isNotEmpty &&
                                            context.mounted) {
                                          NotificationsService.show(
                                              context,
                                              res.error,
                                              SnackbarCategory.error);
                                          return;
                                        }
                                        final venta = ref
                                            .read(ventaFormProvider(
                                                ventaState.venta!))
                                            .ventaForm;
                                        ref
                                            .read(ventaFormProvider(
                                                    ventaState.venta!)
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
                                                  codigo:
                                                      res.resultado!.invSerie,
                                                  descripcion:
                                                      res.resultado!.invNombre,
                                                  valUnitarioInterno: Parse
                                                      .parseDynamicToDouble(res
                                                          .resultado!
                                                          .invprecios[0]),
                                                  valorUnitario: Parse
                                                      .parseDynamicToDouble(res
                                                          .resultado!
                                                          .invprecios[0]),
                                                  llevaIva:
                                                      res.resultado!.invIva,
                                                  incluyeIva: res
                                                      .resultado!.invIncluyeIva,
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
                                            .read(ventaFormProvider(
                                                    ventaState.venta!)
                                                .notifier)
                                            .agregarProducto(null);

                                        if (context.mounted) {
                                          context.pop(context);
                                        }
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),

                                      // Ajusta el padding
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.iScreen(2.0),
                                          vertical: 1.0), // Ajusta el padding
                                      minimumSize: Size
                                          .zero, // Elimina el tamaño mínimo predeterminado
                                      tapTargetSize: MaterialTapTargetSize
                                          .shrinkWrap, // Ajusta el tamaño del área de toque
                                    ),
                                    child: Text(
                                      lado.lado,
                                      style: TextStyle(
                                          fontSize: size.iScreen(3.0),
                                          fontWeight: FontWeight.normal),
                                    ), // Ajusta el tamaño del texto
                                  ),
                                );
                              }).toList(),
                            )
                          ],
                        ))))
                .toList(),
          ),
        ));
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
}
