import 'package:intl/intl.dart';

class CombustibleInfo {
  final String descripcion;
  final String codigo;

  CombustibleInfo({required this.descripcion, required this.codigo});
}

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

  /// Quita las dobles comillas al inicio y final de un string, si existen
  static String limpiarComillas(String valor) {
    // Quita todas las comillas dobles
    return valor.replaceAll('"', '');
  }

  static String getNombreCombustible(dynamic codigoCombustible) {
    final intCodigo = int.tryParse(codigoCombustible.toString());
    switch (intCodigo) {
      case 57:
        return 'GASOLINA EXTRA';
      case 58:
        return 'GASOLINA SUPER';
      case 59:
        return 'DIESEL PREMIUM';
      default:
        return 'DESCONOCIDO';
    }
  }

  static int getCodigoCombustibleFromCodigo(String codigo) {
    switch (codigo) {
      case '0101':
        return 57;
      case '0185':
        return 58;
      case '0121':
        return 59;
      default:
        return -1;
    }
  }

  static int getCodigoCombustible(int tanque) {
    switch (tanque) {
      case 1:
        return 58; // GASOLINA SUPER
      case 2:
        return 57; // GASOLINA EXTRA
      case 3:
        return 59; // DIESEL PREMIUM
      default:
        return 0; // DESCONOCIDO
    }
  }

   static CombustibleInfo getCombustibleInfo(int? codigoCombustible) {
    switch (codigoCombustible) {
      case 57:
        return CombustibleInfo(descripcion: 'GASOLINA EXTRA', codigo: '0101');
      case 58:
        return CombustibleInfo(descripcion: 'GASOLINA SUPER', codigo: '0185');
      case 59:
        return CombustibleInfo(descripcion: 'DIESEL PREMIUM', codigo: '0121');
      default:
        return CombustibleInfo(descripcion: 'DESCONOCIDO', codigo: '0000');
    }
  }
}
