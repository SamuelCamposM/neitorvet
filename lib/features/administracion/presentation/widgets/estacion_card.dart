import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/surtidor.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/card/card_mar_pad.dart';
import 'package:neitorvet/features/shared/widgets/card/card_container.dart';

class EstacionCard extends ConsumerWidget {
  final Estacion estacion;
  final Responsive size;
  final bool redirect;

  const EstacionCard({
    Key? key,
    required this.estacion,
    required this.size,
    this.redirect = true,
  }) : super(key: key);

  // Método para obtener el color de fondo según el códigoProducto
  Color _getBackgroundColor(String codigoProducto) {
    switch (codigoProducto) {
      case "0101":
        return Colors.blue.shade100.withAlpha(230);
      case "0185":
        return Colors.green.shade100.withAlpha(230);
      case "0121":
        return Colors.orange.shade100.withAlpha(230);
      default:
        return Colors.grey.shade200; // Color por defecto
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;

    return CardMarPad(
      size: size,
      child: Slidable(
        key: ValueKey(estacion.numeroPistola),
        startActionPane: const ActionPane(
          motion: DrawerMotion(),
          children: [],
        ),
        child: GestureDetector(
          onTap: redirect
              ? () {
                  // Acción al tocar el widget
                }
              : null,
          child: CardContainer(
            colors: colors,
            size: size,
            child: Container(
              decoration: BoxDecoration(
                color: _getBackgroundColor(estacion.codigoProducto ?? ""),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((25).toInt()),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ), 
              child: Row(
                children: [
                  // Imagen con fondo dinámico
                  Container(
                    width: size.iScreen(5),
                    height: size.iScreen(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/gasolinera.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: size.iScreen(2)),
                  // Información de la estación
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Manguera: ${estacion.numeroPistola}",
                          style: TextStyle(
                            fontSize: size.iScreen(1.6),
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          "${estacion.nombreProducto}",
                          style: TextStyle(
                            fontSize: size.iScreen(1.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Botón de acción (opcional)
                  Icon(
                    Icons.arrow_forward_ios,
                    size: size.iScreen(2),
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
