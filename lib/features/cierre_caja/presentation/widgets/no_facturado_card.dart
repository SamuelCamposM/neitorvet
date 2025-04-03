import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/no_facturado.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/card/card_mar_pad.dart';
import 'package:neitorvet/features/shared/widgets/card/card_container.dart';

class NoFacturadoCard extends ConsumerWidget {
  final NoFacturado noFacturado;
  final Responsive size;
  final bool redirect;

  const NoFacturadoCard({
    Key? key,
    required this.noFacturado,
    required this.size,
    required this.redirect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;

    return CardMarPad(
      size: size,
      child: Slidable(
        key: ValueKey(noFacturado.idRegistro),
        startActionPane: const ActionPane(
          motion: DrawerMotion(), // Puedes cambiar ScrollMotion por otro tipo de Motion
          children: [],
        ),
        child: GestureDetector(
          onTap: redirect
              ? () {
                  // Acción al hacer clic en la tarjeta
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ID Registro: ${noFacturado.idRegistro}')),
                  );
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
                        "Pistola: ${noFacturado.pistola}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.iScreen(1.5),
                        ),
                      ),
                      Text(
                        "Fecha: ${Format.formatFechaHora(noFacturado.fechaHora)}",
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                        ),
                      ),
                      Text(
                        "Total Inicial: ${noFacturado.totInicio.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                        ),
                      ),
                      Text(
                        "Total Final: ${noFacturado.totFinal.toStringAsFixed(2)}",
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
                          fontSize: size.iScreen(1.5),
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
                          fontSize: size.iScreen(1.5),
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