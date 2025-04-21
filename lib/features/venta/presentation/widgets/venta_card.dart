import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:neitorvet/config/config.dart';
import 'package:neitorvet/features/auth/domain/domain.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:neitorvet/features/shared/provider/download_pdf.dart';
import 'package:neitorvet/features/shared/provider/send_email/send_email_provider.dart';
import 'package:neitorvet/features/shared/widgets/card/card_container.dart';
import 'package:neitorvet/features/shared/widgets/card/card_mar_pad.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/venta/presentation/widgets/prit_Sunmi.dart';

class VentaCard extends ConsumerWidget {
  final Venta venta;
  final Responsive size;
  final bool redirect;
  final User? user;
  final void Function(
    Venta venta,
    BuildContext context,
  )? verificarEstadoVenta;
  const VentaCard({
    Key? key,
    required this.venta,
    required this.size,
    required this.user,
    this.verificarEstadoVenta,
    this.redirect = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    final color = Theme.of(context).colorScheme.primary;

    return CardMarPad(
      size: size,
      child: Slidable(
        key: ValueKey(venta.venId),
        startActionPane: ActionPane(
          motion:
              const DrawerMotion(), // Puedes cambiar ScrollMotion por otro tipo de Motion
          children: [
            // SlidableAction(
            //   backgroundColor: color.withAlpha(90),
            //   onPressed: (context) {
            //     final pdfUrl =
            //         '${Environment.serverPhpUrl}reportes/facturaticket.php?codigo=${venta.venId}&empresa=${venta.venEmpresa}';
            //     ref
            //         .read(downloadPdfProvider.notifier)
            //         .downloadPDF(context, pdfUrl);
            //   },
            //   icon: Icons.receipt_long,
            //   label: 'Tick',
            // ),
            SlidableAction(
              backgroundColor: color.withAlpha(100),
              onPressed: (context) {
                final pdfUrl =
                    '${Environment.serverPhpUrl}reportes/factura.php?codigo=${venta.venId}&empresa=${venta.venEmpresa}';
                ref
                    .read(downloadPdfProvider.notifier)
                    .downloadPDF(context, pdfUrl);
                // context.push(
                // '/PDF/Factura/${Uri.encodeComponent('${Environment.serverPhpUrl}reportes/factura.php?codigo=${venta.venId}&empresa=${venta.venEmpresa}')}');
              },
              foregroundColor: colors.onPrimary,
              icon: Icons.picture_as_pdf,
              label: 'PDF',
            ),
            SlidableAction(
              backgroundColor: color.withAlpha(90),
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
        //   motion:
        //       const DrawerMotion(), // Puedes cambiar DrawerMotion por otro tipo de Motion
        //   children: [],
        // ),
        child: GestureDetector(
          onTap: redirect
              ? () {
                  if (verificarEstadoVenta != null) {
                    verificarEstadoVenta!(venta, context);
                  } else {
                    // context.push('/ventas/${venta.venId}');
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
                        Format.formatFechaHora(venta.venFecReg),
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                        ),
                      ),
                      Text(
                        "Usuario: ${venta.venUser}",
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
                          printTicket(
                            venta,
                            user,
                          );
                        },
                        icon: Icon(Icons.print, color: colors.secondary),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            venta.venOtrosDetalles,
                            style: TextStyle(
                              fontSize: size.iScreen(1.7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
