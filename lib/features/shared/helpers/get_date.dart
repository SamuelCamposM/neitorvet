import 'package:intl/intl.dart';

class GetDate {
  /// Devuelve el día actual en formato "YYYY-MM-DD" (ejemplo: "2025-03-28")
  static String get today {
    final DateTime now = DateTime.now().toLocal();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  static String fechaHoraActual() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  static bool noEsHoraDeIniciarTurno(String fechaHoraEntrada) {
    final ahora = DateTime.now();
    final formato = DateFormat('yyyy-MM-dd HH:mm:ss');
    final fechaTurno = formato.parse(fechaHoraEntrada);

    return ahora.isBefore(fechaTurno);
  }
}
