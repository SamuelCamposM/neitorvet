import 'package:dio/dio.dart';
import 'package:neitorvet/features/clientes/domain/datasources/clientes_datasource.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente_foreign.dart';
import 'package:neitorvet/features/shared/errors/error_api.dart';

class ClientesDatasourceImpl extends ClientesDatasource {
  final Dio dio;
  final String rucempresa;
  ClientesDatasourceImpl({required this.dio, required this.rucempresa});

  @override
  Future<ResponseClientesPaginacion> getClientesByPage(
      {int cantidad = 10,
      int page = 0,
      String perfil = 'CLIENTES',
      String input = 'perId',
      bool orden = false,
      String search = ''}) async {
    try {
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

      return ResponseClientesPaginacion(
          resultado: newClientes,
          error: '',
          total: response.data['data']['pagination']['numRows'] ?? 0);
    } on DioException catch (e) {
      return ResponseClientesPaginacion(
          resultado: [], error: ErrorApi.getErrorMessage(e));
    }
  }

  @override
  Future<ResponseClientesForeign> getClientesByQueryInVentas(
      String search) async {
    try {
      final response = await dio.get(
        rucempresa == "TE2021"
            ? "/proveedores/listar_clientes_factura/0"
            : "/proveedores/filtro/0",
        queryParameters: {
          'search': search,
          'estado': 'CLIENTE',
          'tabla': 'ventas'
        },
      );
      final List<ClienteForeign> newClientes = response.data['data']
          .map<ClienteForeign>((e) => ClienteForeign.fromJson(e))
          .toList();

      return ResponseClientesForeign(
        resultado: newClientes,
        error: '',
      );
    } on DioException catch (e) {
      return ResponseClientesForeign(
          resultado: [], error: ErrorApi.getErrorMessage(e));
    }
  }

  @override
  Future<ResponseClienteForeign> getNewClienteByDoc(String doc) async {
    try {
      final response = await dio.get(
        "/proveedores/searchByCedulaOfRuc/0",
        queryParameters: {
          'search': doc,
          'rol': 'CLIENTE',
        },
      );
      final Cliente cliente = Cliente.fromJson(response.data);

      return ResponseClienteForeign(
        resultado: cliente,
        error: '',
      );
    } on DioException catch (e) {
      return ResponseClienteForeign(
          resultado: null, error: ErrorApi.getErrorMessage(e));
    }
  }

  @override
  Future<ResponseClienteForeign> getNewClienteByPlaca(String placa) async {
    try {
// get => api/proveedores/searchByPlaca/0?placa=IW571H
      final response = await dio.get(
        "/proveedores/searchByPlaca/0",
        queryParameters: {
          'placa': placa,
        },
      );
      final Cliente cliente = Cliente.fromJson(response.data);

      return ResponseClienteForeign(
        resultado: cliente,
        error: '',
      );
    } on DioException catch (e) {
      return ResponseClienteForeign(
          resultado: null, error: ErrorApi.getErrorMessage(e));
    }
  }
}
