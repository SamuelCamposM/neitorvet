import 'package:intl/intl.dart';

class GetDate {
  /// Devuelve el día actual en formato "YYYY-MM-DD" (ejemplo: "2025-03-28")
  static String get today {
    final DateTime now = DateTime.now().toLocal();
    return DateFormat('yyyy-MM-dd').format(now);
  }
}
