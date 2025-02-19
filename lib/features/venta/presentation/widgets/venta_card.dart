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
    return Slidable(
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
          width: size.wScreen(100),
          padding: EdgeInsets.all(size.iScreen(1.0)),
          margin: EdgeInsets.symmetric(
              horizontal: size.iScreen(1.2), vertical: size.iScreen(0.5)),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withAlpha((0.5 * 255).toInt()),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4), // Desplazamiento de la sombra
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.wScreen(60.0),
                    child: Text(
                      "# ${venta.venNumFactura}",
                      style: TextStyle(
                          fontSize: size.iScreen(1.5),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: size.wScreen(60.0),
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
              SizedBox(
                width: size.wScreen(20),
                child: Column(
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                          fontSize: size.iScreen(1.5),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${venta.venTotal.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: size.iScreen(1.7),
                          fontWeight: FontWeight.bold),
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
