import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/card/card_mar_pad.dart';
import 'package:neitorvet/features/shared/widgets/card/card_container.dart';
import 'package:neitorvet/features/venta/presentation/widgets/prit_Sunmi.dart';

class CierreCajaCard extends ConsumerWidget {
  final CierreCaja cierreCaja;
  final Responsive size;
  final bool redirect;
  final bool isAdmin;
  final Future<void> Function() onDelete; // Función para eliminar con Future

  const CierreCajaCard({
    Key? key,
    required this.cierreCaja,
    required this.size,
    required this.redirect,
    required this.isAdmin,
    required this.onDelete, // Recibir la función de eliminación
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final user = ref.read(authProvider).user;

    // Asignar colores según el tipo de documento
    Color getColorByTipoDocumento(String tipoDocumento) {
      switch (tipoDocumento) {
        case 'APERTURA':
          return Colors.blue;
        case 'INGRESO':
          return Colors.green;
        case 'EGRESO':
          return Colors.red;
        case 'DEPOSITO':
          return Colors.purple;
        case 'CAJA CHICA':
          return Colors.orange;
        case 'TRANSFERENCIA':
          return Colors.teal;
        default:
          return Colors.grey;
      }
    }

    Color getColorByTipoCaja(String tipoCaja) {
      switch (tipoCaja) {
        case 'EFECTIVO':
          return Colors.green;
        case 'CHEQUE':
          return Colors.blue;
        case 'TRANSFERENCIA':
          return Colors.teal;
        case 'DEPOSITO':
          return Colors.purple;
        default:
          return Colors.grey;
      }
    }

    return CardMarPad(
      size: size,
      child: Slidable(
        key: ValueKey(cierreCaja.cajaId),
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (context) async {
                await onDelete(); // Llamar a la función de eliminación con await
              },
              foregroundColor: Colors.black,
              icon: Icons.delete,
              label: 'Eliminar',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: redirect
              ? () {
                  if (isAdmin) {
                    context.push('/cierre_cajas/${cierreCaja.cajaId}');
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
                  flex: 4,
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
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        cierreCaja.cajaTipoCaja,
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                          fontWeight: FontWeight.bold,
                          color: getColorByTipoCaja(cierreCaja.cajaTipoCaja),
                        ),
                      ),
                      Text(
                        "\$${cierreCaja.cajaProcedencia == 'VENTA' && (cierreCaja.cajaTipoCaja == 'CREDITO' || cierreCaja.cajaTipoCaja == 'TRANSFERENCIA') ? cierreCaja.cajaCredito : cierreCaja.cajaMonto}",
                        style: TextStyle(
                          fontSize: size.iScreen(1.7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          printTicketDesdeLista(cierreCaja, user!);
                        },
                        icon: const Icon(
                          Icons.print_outlined,
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
