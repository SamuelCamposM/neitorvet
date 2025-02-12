import 'package:dio/dio.dart';
import 'package:neitorvet/config/config.dart';
import 'package:neitorvet/features/auth/domain/domain.dart';
import 'package:neitorvet/features/auth/infrastructure/infrastructure.dart';
import 'package:neitorvet/features/shared/errors/error_api.dart';

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
          options: Options(headers: {'x-auth-token': token}));
      final user = UserMapper.userJsonToEntity(res.data);
      return user;
    } on DioException catch (e) {
      throw CustomError(ErrorApi.getErrorMessage(e));
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
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      throw CustomError(ErrorApi.getErrorMessage(e));
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    throw UnimplementedError();
  }
}
