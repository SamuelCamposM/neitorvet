import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/cierre_surtidor.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/card/card_mar_pad.dart';
import 'package:neitorvet/features/shared/widgets/card/card_container.dart';

class CierreSurtidorCard extends ConsumerWidget {
  final CierreSurtidor cierreSurtidor;
  final Responsive size;
  final bool redirect;

  const CierreSurtidorCard({
    Key? key,
    required this.cierreSurtidor,
    required this.size,
    this.redirect = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    return CardMarPad(
      size: size,
      child: Slidable(
        key: ValueKey(cierreSurtidor.idcierre),
        startActionPane: const ActionPane(
          motion:
              DrawerMotion(), // Puedes cambiar ScrollMotion por otro tipo de Motion
          children: [],
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
                  context.push('/cierre_surtidores/${cierreSurtidor.uuid}');
                }
              : null,
          child: CardContainer(
            colors: colors,
            size: size,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3, // 75% del ancho 3/4
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cierre de Surtidor",
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Fecha: ${Format.formatFechaHora(cierreSurtidor.fecReg)}",
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                        ),
                      ),
                      Text(
                        "User: ${cierreSurtidor.userCierre}",
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  flex: 2, // 25% del ancho 1/4
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Text(
                      //   "Inicio: \$${cierreSurtidor.totInicioCierre.toStringAsFixed(2)}",
                      //   style: TextStyle(
                      //     fontSize: size.iScreen(1.5),
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // Text(
                      //   "Final: \$${cierreSurtidor.totFinalCierre.toStringAsFixed(2)}",
                      //   style: TextStyle(
                      //     fontSize: size.iScreen(1.5),
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // Text(
                      //   "Galones: ${cierreSurtidor.totalDiaGalonesCierre.toStringAsFixed(2)}",
                      //   style: TextStyle(
                      //     fontSize: size.iScreen(1.5),
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // Text(
                      //   "Valor: \$${cierreSurtidor.totalDiaValorCierre.toStringAsFixed(2)}",
                      //   style: TextStyle(
                      //     fontSize: size.iScreen(1.5),
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
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
