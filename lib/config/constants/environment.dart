import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironment() async {
    await dotenv.load(fileName: '.env');
  }

  static String apiUrl = dotenv.env['API_URL'] ?? '';
  static String apiUrlZaracay = dotenv.env['API_URL_ZARACAY'] ?? '';
  static String socketUrl = dotenv.env['SOCKET_URL'] ?? '';
  static String socketUrlZaracay = dotenv.env['SOCKET_URL_ZARACAY'] ?? '';
  static String serverPhpUrl = dotenv.env['SERVER_PHP'] ?? '';
}
