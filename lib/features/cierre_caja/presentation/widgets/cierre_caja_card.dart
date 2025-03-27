import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/card/card_mar_pad.dart';
import 'package:neitorvet/features/shared/widgets/card/card_container.dart';

class CierreCajaCard extends StatelessWidget {
  final CierreCaja cierreCaja;
  final Responsive size;
  final bool redirect;
  const CierreCajaCard({
    Key? key,
    required this.cierreCaja,
    required this.size,
    required this.redirect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return CardMarPad(
      size: size,
      child: Slidable(
        key: ValueKey(cierreCaja.cajaId),
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
                  context.push('/cierre_cajas/${cierreCaja.cajaId}');
                }
              : null,
          child: CardContainer(
            colors: colors,
            size: size,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cierreCaja.cajaDetalle,
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        cierreCaja.cajaMonto.toString(),
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                          fontWeight: FontWeight.bold,
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
