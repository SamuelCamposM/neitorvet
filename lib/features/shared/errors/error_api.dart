import 'package:dio/dio.dart';

class ErrorApi {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      try {
        return error.response?.data['msg'] as String? ?? 'Unknown error';
      } catch (e) {
        return 'Unknown error';
      }
    }
    return 'Unknown error';
  }
}
