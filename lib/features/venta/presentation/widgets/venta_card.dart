import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:neitorvet/config/config.dart';
import 'package:neitorvet/features/shared/provider/download_pdf.dart';
import 'package:neitorvet/features/shared/provider/send_email/send_email_provider.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class VentaCard extends ConsumerWidget {
  final Venta venta;
  final Responsive size;
  final bool redirect;

  const VentaCard({
    Key? key,
    required this.venta,
    required this.size,
    this.redirect = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.iScreen(1), vertical: size.iScreen(0.5)),
      child: Slidable(
        key: ValueKey(venta.venId),
        startActionPane: ActionPane(
          motion:
              const DrawerMotion(), // Puedes cambiar ScrollMotion por otro tipo de Motion
          children: [
            SlidableAction(
              onPressed: (context) {
                final pdfUrl =
                    '${Environment.serverPhpUrl}reportes/factura.php?codigo=${venta.venId}&empresa=${venta.venEmpresa}';
                ref
                    .read(downloadPdfProvider.notifier)
                    .downloadPDF(context, pdfUrl);
                // context.push(
                // '/PDF/Factura/${Uri.encodeComponent('${Environment.serverPhpUrl}reportes/factura.php?codigo=${venta.venId}&empresa=${venta.venEmpresa}')}');
              },
              icon: Icons.picture_as_pdf,
              label: 'PDF',
            ),
            SlidableAction(
              onPressed: (context) {
                //SI MANDAR A ALLAMAR EL PROVIDER EMAIL ACA, daria problema por que se destruiria al instante ref.read
                final initialEmails = venta.venEmailCliente;

                final initialLabels = [
                  Labels(label: 'Ruc Cliente', value: venta.venRucCliente),
                  Labels(label: 'Cliente', value: venta.venNomCliente)
                ];
                final emailsParam = initialEmails.join(',');
                final labelsParam = initialLabels
                    .map((label) => '${label.label}:${label.value}')
                    .join(',');

                context.push(
                    '/send-email?emails=$emailsParam&labels=$labelsParam&idRegistro=${venta.venId}');
              },
              icon: Icons.email,
              label: 'Email',
            ),
          ],
        ),
        // endActionPane: ActionPane(
        //   motion: const DrawerMotion(), // Puedes cambiar DrawerMotion por otro tipo de Motion
        //   children: [
        //     SlidableAction(
        //       onPressed: (context) {
        //         // Acción adicional
        //       },
        //       backgroundColor: Colors.green,
        //       foregroundColor: Colors.white,
        //       icon: Icons.share,
        //       label: 'Compartir',
        //     ),
        //   ],
        // ),
        child: GestureDetector(
          onTap: redirect
              ? () {
                  // context.push('/venta/${venta.venId}');
                }
              : null,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.iScreen(1.0), vertical: size.iScreen(1.0)),
            width: size.wScreen(100),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow
                      .withAlpha((0.2 * 255).toInt()), // Reduce la opacidad
                  spreadRadius: 0,
                  blurRadius:
                      4, // Reduce el desenfoque para una sombra más suave
                  offset: const Offset(0,
                      2), // Ajusta el desplazamiento para una sombra más sutil
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 4, // 75% del ancho 3/4
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        venta.venEstado,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: venta.venEstado == "PENDIENTE"
                              ? Colors.orange // rojo tomate
                              : venta.venEstado == "AUTORIZADO" ||
                                      venta.venEstado == "ACTIVA"
                                  ? Colors.green.shade800 // verde
                                  : venta.venEstado == "ANULADA"
                                      ? Colors.red // rojo
                                      : Colors.orange, // default
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          "# ${venta.venNumFactura}",
                          style: TextStyle(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          venta.venNomCliente,
                          style: TextStyle(
                            fontSize: size.iScreen(1.5),
                          ),
                        ),
                      ),
                      Text(
                        venta.venRucCliente,
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                        ),
                      ),
                      Text(
                        "Fecha: ${venta.venFechaFactura}",
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2, // 25% del ancho 1/4
                  child: Column(
                    children: [
                      Text(
                        "Total",
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${venta.venTotal.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: size.iScreen(1.7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          final pdfUrl =
                              '${Environment.serverPhpUrl}reportes/facturaticket.php?codigo=${venta.venId}&empresa=${venta.venEmpresa}';
                          ref
                              .read(downloadPdfProvider.notifier)
                              .downloadPDF(context, pdfUrl);
                          // context.push('/PDF/Factura/$pdfUrl');
                        },
                        icon: Icon(Icons.receipt, color: colors.secondary),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.email,
                              color: venta.venEnvio == "ENVIADO"
                                  ? Colors.green.shade800
                                  : Colors.red),
                          // SizedBox(
                          //   width: size.iScreen(0.5),
                          // ), // Espacio entre el icono y el texto
                          // Text(
                          //   venta.venEnvio,
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //     color: venta.venEnvio == "ENVIADO"
                          //         ? Colors.green.shade800
                          //         : Colors.red,
                          //   ),
                          // ),
                        ],
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
