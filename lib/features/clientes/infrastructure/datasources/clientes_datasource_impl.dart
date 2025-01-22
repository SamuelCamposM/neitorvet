import 'package:dio/dio.dart';
import 'package:neitorvet/features/clientes/domain/datasources/clientes_datasource.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/shared/errors/error_api.dart';

class ClientesDatasourceImpl extends ClientesDatasource {
  final Dio dio;
  ClientesDatasourceImpl({required this.dio});

  @override
  Future<ResponseClientes> getClientesByPage(
      {int cantidad = 10,
      int page = 0,
      String perfil = 'CLIENTES',
      String input = 'perId',
      bool orden = false,
      String search = ''}) async {
    try {
      print(search);
      final response = await dio.post(
        '/proveedores/byPagination/app',
        data: {
          'search': search,
          'cantidad': cantidad,
          'page': page,
          'input': input,
          'orden': orden,
        },
      );
      final List<Cliente> newClientes = response.data['data']['results']
          .map<Cliente>((e) => Cliente.fromJson(e))
          .toList();

      return ResponseClientes(
          resultado: newClientes,
          error: '',
          total: response.data['data']['pagination']['numRows'] ?? 0);
    } on DioException catch (e) {
      return ResponseClientes(
          resultado: [], error: ErrorApi.getErrorMessage(e));
    }
  }
}
