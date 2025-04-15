import 'package:intl/intl.dart';

class Format {
  /// Formatea una fecha (String) a un formato local con el nombre del día (3 letras), día/mes/año (ejemplo: mié, 26/03/2025)
  static String formatFecha(String fecha) {
    try {
      final DateTime parsedDate = DateTime.parse(fecha).toLocal();
      return DateFormat('EEE, dd/MM/yyyy', 'es_ES').format(parsedDate);
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  /// Formatea una fecha (String) a un formato local con el nombre del día (3 letras), día/mes/año y hora (ejemplo: mié, 26/03/2025 14:30)
  static String formatFechaHora(String fecha) {
    try {
      final DateTime parsedDate = DateTime.parse(fecha).toLocal();
      return DateFormat('EEE, dd/MM/yyyy HH:mm', 'es_ES').format(parsedDate);
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  /// Aproxima un número a 2 decimales
  static double roundToTwoDecimals(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  static String formatValorPreset(String valorPreset) {
    // Convierte el valor a un entero y multiplica por 100 si es necesario
    final intValue = int.parse(valorPreset) * 100;

    // Devuelve el valor como una cadena con ceros a la izquierda (mínimo 9 caracteres)
    return intValue.toString().padLeft(8, '0');
  }
}
