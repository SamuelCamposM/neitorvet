import 'package:dio/dio.dart';
import 'package:neitorvet/config/config.dart';
import 'package:neitorvet/features/auth/domain/domain.dart';
import 'package:neitorvet/features/auth/infrastructure/infrastructure.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
    ),
  );
  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final res = await dio.get('/auth',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      final user = UserMapper.userJsonToEntity(res.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credentials are wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet o intentar más tarde');
      }
      throw Exception('Something went wrong');
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }

  @override
  Future<User> login(String empresa, String usuario, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'empresa': empresa,
          'password': password,
          'usuario': usuario,
        },
      );
      print(response.data);
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credentials are wrong');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet o intentar más tarde');
      }
      throw Exception('Something went wrong');
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    throw UnimplementedError();
  }
}
