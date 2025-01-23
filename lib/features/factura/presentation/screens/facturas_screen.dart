import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class FacturasScreen extends StatelessWidget {
  const FacturasScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Facturas'),
      ),
      body: const _FacturasView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/factura/0');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FacturasView extends StatelessWidget {
  const _FacturasView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);

    final List<Map<String, dynamic>> invoices = List.generate(
      20,
      (index) => {
        'numeroFactura': '001-012-0000000-${index + 1}',
        'cliente': 'GONZALEZ REVELO EDUARDO DARIO ',
        'documento': '18${index + 1}4234234',
        'fecha': '2025-01-${(index % 31) + 1}'.padLeft(2, '0'),
        'total': (100 + index * 5000).toDouble(),
        'invoiceId': index + 1,
      },
    );

    return Scaffold(
      body: ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          final invoice = invoices[index];
          return InvoiceInfoCard(
            numeroFactura: invoice['numeroFactura'],
            cliente: invoice['cliente'],
            documento: invoice['documento'],
            fecha: invoice['fecha'],
            total: invoice['total'],
            invoiceId: invoice['invoiceId'],
            size: size,
          );
        },
      ),
    );
  }
}

class InvoiceInfoCard extends StatelessWidget {
  final String numeroFactura;
  final String cliente;
  final String documento;
  final String fecha;
  final double total;
  final Responsive size;
  final int invoiceId;
  final bool redirect;

  const InvoiceInfoCard({
    Key? key,
    required this.numeroFactura,
    required this.cliente,
    required this.fecha,
    required this.total,
    required this.size,
    required this.invoiceId,
    this.redirect = true,
    required this.documento,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: redirect
          ? () {
              context.push('/factura/$invoiceId');
            }
          : null,
      child: Container(
        width: size.wScreen(100),
        padding: EdgeInsets.all(size.iScreen(1.0)),
        margin: EdgeInsets.symmetric(
            horizontal: size.iScreen(1.2), vertical: size.iScreen(0.5)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha((0.5 * 255).toInt()),
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
                    "# $numeroFactura",
                    style: TextStyle(
                        fontSize: size.iScreen(1.5),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: size.wScreen(60.0),
                  child: Text(
                    "$cliente",
                    style: TextStyle(
                      fontSize: size.iScreen(1.5),
                    ),
                  ),
                ),
                Text(
                  "$documento",
                  style: TextStyle(
                    fontSize: size.iScreen(1.5),
                  ),
                ),
                Text(
                  "Fecha: $fecha",
                  style: TextStyle(
                    fontSize: size.iScreen(1.5),
                  ),
                ),
              ],
            ),
            Container(
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
                    "\$${total.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: size.iScreen(1.7),
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {},
                      onLongPress: () {},
                      child: Text(
                        'PDF',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: size.iScreen(1.7),
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
