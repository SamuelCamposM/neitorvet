
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/config/menu/menu_item.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
class ItemMenu extends StatelessWidget {
  final MenuItem menuItem;

  const ItemMenu({
    super.key,
    required this.size,
    required this.menuItem,
  });

  final Responsive size;

  @override
  Widget build(BuildContext context) {
    final colorSecundario = Theme.of(context).colorScheme;
    final colorPrimario = Theme.of(context).appBarTheme.backgroundColor;
    return SizedBox(
      width: size.iScreen(14.0), // Ajustar el ancho de los elementos
      height: size.iScreen(14.0), // Ajustar el ancho de los elementos
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 4.0), // Espacio entre los elementos
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(10.0), // Reducir el radio de los bordes
          child: Material(
            color: Colors.transparent, // Color de fondo transparente
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  10.0), // Radio de los bordes redondeados
            ),
            child: InkWell(
              onTap: () {
                // Acción al presionar el botón
                context.push(menuItem.link);
              },
              splashColor: colorPrimario!
                  .withAlpha((0.7 * 255).toInt()), // Color del splash
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: colorSecundario.secondary,
                      width: 2.0), // Borde gris
                ),
                child: Center(
                  // Centrar el contenido
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        menuItem.icon,
                        height: size.iScreen(7.0),
                        color: colorSecundario
                            .secondary, // Reducir el tamaño de la imagen
                      ),
                      const SizedBox(height: 4), // Reducir el espacio
                      Text(
                        menuItem.title,
                        style: TextStyle(
                          fontSize:
                              size.iScreen(1.8), // Reducir el tamaño del texto
                          fontWeight: FontWeight.bold,
                          color: colorSecundario.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2), // Reducir el espacio
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
