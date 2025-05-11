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
    try {
      // Convierte el valor a un número de punto flotante
      final doubleValue = double.parse(valorPreset);

      // Multiplica por 100 y convierte a entero
      final intValue = (doubleValue * 100).round();

      // Devuelve el valor como una cadena con ceros a la izquierda (mínimo 8 caracteres)
      return intValue.toString().padLeft(8, '0');
    } catch (e) {
      // Manejo de errores en caso de que el valor no sea válido
      throw FormatException('Invalid valorPreset: $valorPreset');
    }
  }
}
