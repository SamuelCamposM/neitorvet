import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static initEnvironment() async {
    await dotenv.load(fileName: '.env');
  }

  static String apiUrl = dotenv.env['API_URL'] ?? '';
  static String socketUrl = dotenv.env['SOCKET_URL'] ?? '';
  static String serverPhpUrl = dotenv.env['SERVER_PHP'] ?? '';
}
