import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class ClienteCard extends StatelessWidget {
  final String nombreUsuario;
  final String cedula;
  final String correo;
  final Responsive size;
  final int perId;
  final bool redirect;
  final String fotoUrl;
  const ClienteCard({
    Key? key,
    required this.nombreUsuario,
    required this.cedula,
    required this.correo,
    required this.size,
    required this.perId,
    this.redirect = true,
    this.fotoUrl = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.iScreen(1), vertical: size.iScreen(0.5)),
      child: Slidable(
        key: ValueKey(perId),
        startActionPane: ActionPane(
          motion:
              const DrawerMotion(), // Puedes cambiar ScrollMotion por otro tipo de Motion
          children: [
            SlidableAction(
              onPressed: (context) {
                // Acción de editar
                context.push('/cliente/$perId');
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Editar',
            ),
            SlidableAction(
              onPressed: (context) {
                // Acción de eliminar
                // Implementa la lógica de eliminación aquí
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Eliminar',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion:
              const DrawerMotion(), // Puedes cambiar DrawerMotion por otro tipo de Motion
          children: [
            SlidableAction(
              onPressed: (context) {
                // Acción adicional
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Compartir',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: redirect
              ? () {
                  context.push('/cliente/$perId');
                }
              : null,
          child: Container(
            padding: EdgeInsets.all(size.iScreen(1.0)),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombreUsuario,
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        cedula,
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
                        ),
                      ),
                      Text(
                        correo,
                        style: TextStyle(
                          fontSize: size.iScreen(1.5),
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
