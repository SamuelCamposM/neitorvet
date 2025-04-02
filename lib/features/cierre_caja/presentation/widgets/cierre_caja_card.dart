import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
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
    // Asignar colores según el tipo de documento
    Color getColorByTipoDocumento(String tipoDocumento) {
      switch (tipoDocumento) {
        case 'APERTURA':
          return Colors.blue; // Azul para APERTURA
        case 'INGRESO':
          return Colors.green; // Verde para INGRESO
        case 'EGRESO':
          return Colors.red; // Rojo para EGRESO
        case 'DEPOSITO':
          return Colors.purple; // Morado para DEPOSITO
        case 'CAJA CHICA':
          return Colors.orange; // Naranja para CAJA CHICA
        case 'TRANSFERENCIA':
          return Colors.teal; // Verde azulado para TRANSFERENCIA
        default:
          return Colors.grey; // Gris para cualquier otro valor
      }
    }

    Color getColorByTipoCaja(String tipoCaja) {
      switch (tipoCaja) {
        case 'EFECTIVO':
          return Colors.green; // Verde para EFECTIVO
        case 'CHEQUE':
          return Colors.blue; // Azul para CHEQUE
        case 'TRANSFERENCIA':
          return Colors.teal; // Verde azulado para TRANSFERENCIA
        case 'DEPOSITO':
          return Colors.purple; // Morado para DEPOSITO
        default:
          return Colors.grey; // Gris para cualquier otro valor
      }
    }

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
                  flex: 4, // 75% del ancho 3/4
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cierreCaja.cajaTipoDocumento,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: getColorByTipoDocumento(
                              cierreCaja.cajaTipoDocumento),
                        ),
                      ),
                      Text(
                        cierreCaja.cajaNumero,
                        style: TextStyle(
                            fontSize: size.iScreen(1.5),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Fecha: ${Format.formatFecha(cierreCaja.cajaFecha)}",
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                        ),
                      ),
                      Text(
                        "Usuario: ${cierreCaja.cajaUser}",
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
                        cierreCaja.cajaTipoCaja,
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                          fontWeight: FontWeight.bold,
                          color: getColorByTipoCaja(cierreCaja
                              .cajaTipoCaja), // Asignar color dinámico
                        ),
                      ),
                      Text(
                        "\$${cierreCaja.cajaTipoDocumento == 'INGRESO' ? cierreCaja.cajaIngreso : cierreCaja.cajaTipoDocumento == 'EGRESO' ? cierreCaja.cajaEgreso : cierreCaja.cajaCredito}",
                        style: TextStyle(
                          fontSize: size.iScreen(1.7),
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
