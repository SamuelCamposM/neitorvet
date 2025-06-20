import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/no_facturado.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/card/card_mar_pad.dart';
import 'package:neitorvet/features/shared/widgets/card/card_container.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/venta/presentation/provider/form/venta_form_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_repository_provider.dart';

class NoFacturadoCard extends ConsumerWidget {
  final NoFacturado noFacturado;
  final Responsive size;
  final bool redirect;
  final Venta venta;
  final VentaFormState ventaFState;
  final VentaFormNotifier ventaFormNotifier;
  const NoFacturadoCard({
    Key? key,
    required this.noFacturado,
    required this.size,
    required this.redirect,
    required this.venta,
    required this.ventaFState,
    required this.ventaFormNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return CardMarPad(
      size: size,
      child: Slidable(
        key: ValueKey(noFacturado.idRegistro),
        startActionPane: const ActionPane(
          motion:
              DrawerMotion(), // Puedes cambiar ScrollMotion por otro tipo de Motion
          children: [],
        ),
        child: GestureDetector(
          onTap: redirect
              ? () async {
                  // Acción al hacer clic en la tarjeta
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //       content:
                  //           Text('ID Registro: ${noFacturado.idRegistro}')),
                  // );
                  final res = await ref
                      .read(ventasRepositoryProvider)
                      .getInventarioByPistola(
                          pistola:
                              Parse.parseDynamicToString(noFacturado.pistola),
                          codigoCombustible: Parse.parseDynamicToString(
                              noFacturado.tipoCombustible[0]),
                          numeroTanque: Parse.parseDynamicToString(
                            noFacturado.numeroTanque,
                          ),
                          idRegistroNoFacturado: noFacturado.idRegistro);

                  if (res.error.isNotEmpty && context.mounted) {
                    NotificationsService.show(
                        context, res.error, SnackbarCategory.error);
                    return;
                  }
                  final ventaResponse = ventaFState.ventaForm;
                  ventaFormNotifier.updateState(
                      monto: res.total,
                      ventaForm: ventaResponse.copyWith(
                        idAbastecimiento: res.idAbastecimiento,
                        totInicio: res.totInicio,
                        totFinal: res.totFinal,
                        venProductos: [],
                      ),
                      nuevoProducto: Producto(
                        cantidad: 0,
                        codigo: res.resultado!.invSerie,
                        descripcion: res.resultado!.invNombre,
                        valUnitarioInterno: double.parse(
                          Parse.parseDynamicToDouble(
                                  res.resultado!.invprecios[0])
                              .toStringAsFixed(3),
                        ),
                        valorUnitario: double.parse(
                          Parse.parseDynamicToDouble(
                                  res.resultado!.invprecios[0])
                              .toStringAsFixed(3),
                        ),
                        llevaIva: res.resultado!.invIva,
                        incluyeIva: res.resultado!.invIncluyeIva,
                        recargoPorcentaje: 0,
                        recargo: 0,
                        descPorcentaje: ventaResponse.venDescPorcentaje,
                        descuento: 0,
                        precioSubTotalProducto: 0,
                        valorIva: 0,
                        costoProduccion: 0,
                      ));
                  final errorAgregar =
                      ventaFormNotifier.agregarProducto(null, null);
                  if (context.mounted && !errorAgregar) {
                    context.push('/venta/${0}');
                  }
                }
              : null,
          child: CardContainer(
            colors: colors,
            size: size,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4, // 75% del ancho
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Manguera: ${noFacturado.pistola} - Vol: ${noFacturado.volTotal}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.iScreen(1.5),
                        ),
                      ),
                      Text(
                        Format.formatFechaHora(noFacturado.fechaHora),
                        style: TextStyle(
                            fontSize: size.iScreen(1.6),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Lectura Inicial: ${noFacturado.totInicio.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                        ),
                      ),
                      Text(
                        "Lectura Final: ${noFacturado.totFinal.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2, // 25% del ancho
                  child: Column(
                    children: [
                      Text(
                        "Valor Total",
                        style: TextStyle(
                          fontSize: size.iScreen(1.4),
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        "\$${noFacturado.valorTotal.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: size.iScreen(1.7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Combustible:",
                        style: TextStyle(
                          fontSize: size.iScreen(1.4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        noFacturado.tipoCombustible.join(", "),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.iScreen(1.3),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
