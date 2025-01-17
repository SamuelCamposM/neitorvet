import 'package:dio/dio.dart';

class ErrorApi {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      return error.response?.data['msg'] ?? 'Unknown error';
    }
    return 'Unknown error';
  }
}
