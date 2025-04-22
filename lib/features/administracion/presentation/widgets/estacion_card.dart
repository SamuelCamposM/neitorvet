import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:neitorvet/features/administracion/domain/entities/live_visualization.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/surtidor.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/card/card_mar_pad.dart';
import 'package:neitorvet/features/shared/widgets/card/card_container.dart';
import 'package:neitorvet/features/administracion/domain/entities/manguera_status.dart';

class EstacionCard extends ConsumerWidget {
  final Estacion estacion;
  final Responsive size;
  final bool redirect;
  final Datum? dato;
  final LiveVisualization visualization;
  const EstacionCard({
    Key? key,
    required this.estacion,
    required this.size,
    required this.dato,
    required this.visualization,
    this.redirect = true,
  }) : super(key: key);
  // Método para obtener el color de fondo según el códigoProducto
  /// Método para obtener un color según el tipo de `Datum`.
  Color _getColorForDatum(Datum? datum) {
    switch (datum) {
      case Datum.L:
        return Colors.green; // Libre
      case Datum.B:
        return Colors.red; // Bloqueado
      case Datum.A:
        return Colors.green; // Abasteciendo
      case Datum.E:
        return Colors.orange; // En Espera
      case Datum.P:
        return Colors.lightGreen; // Pronto para abastecer
      case Datum.F:
        return Colors.red; // En Falla
      case Datum.C:
        return Colors.yellowAccent; // En Falla
      case Datum.hash:
        return Colors.grey; // Ocupado
      case Datum.exclamation:
        return Colors.black; // Error genérico
      default:
        return Colors.black; // Color predeterminado
    }
  }

  // Nueva función para obtener el color según el producto y el dato
  Color _getColorForProducto(String nombreProducto, Datum? dato) {
    if (nombreProducto == 'DIESEL PREMIUN' &&
        (dato == Datum.L || dato == Datum.B)) {
      return Colors.yellow.shade300;
    } else if (nombreProducto == 'GASOLINA EXTRA' &&
        (dato == Datum.L || dato == Datum.B)) {
      return Colors.lightBlue.shade300;
    } else if (nombreProducto == 'GASOLINA SUPER' &&
        (dato == Datum.L || dato == Datum.B)) {
      return Colors.blueGrey.shade200;
    }
    return _getColorForDatum(dato);
    // Color predeterminado si no coincide
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
                color:
                    _getColorForProducto(estacion.nombreProducto ?? '', dato),
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
                          "${estacion.nombreProducto == 'DIESEL PREMIUN' ? 'DIESEL PREMIUM' : estacion.nombreProducto}",
                          style: TextStyle(
                            fontSize: size.iScreen(1.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Botón de acción (opcional)
                  if (visualization.valorActual != 0)
                    Text(
                      "\$${visualization.valorActual.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: size.iScreen(1.8),
                        fontWeight: FontWeight.bold,
                      ),
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
