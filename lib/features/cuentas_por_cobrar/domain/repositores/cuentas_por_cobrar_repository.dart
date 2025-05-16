import 'package:dio/dio.dart';
import 'package:neitorvet/features/cuentas_por_cobrar/domain/entities/banco.dart';
import 'package:neitorvet/features/cuentas_por_cobrar/domain/entities/cuenta_por_cobrar.dart';
import 'package:neitorvet/features/shared/errors/error_api.dart';

class ResponseCuentasPorCobrar {
  final List<CuentaPorCobrar> resultado;
  final int total;
  final String error;

  ResponseCuentasPorCobrar(
      {required this.resultado, required this.error, this.total = 0});
}

class ResponseBancos {
  final List<Banco> bancos;
  final String error;

  ResponseBancos({
    required this.bancos,
    required this.error,
  });
}

class CuentasPorCobrarRepository {
  final Dio dio;
  CuentasPorCobrarRepository({required this.dio});
  Future<ResponseCuentasPorCobrar> getCuentasPorCobrarByPage(
      {required int cantidad,
      required int page,
      required String estado,
      required String input,
      required bool orden,
      required String search,
      required BusquedaCuentasPorCobrar busquedaCuentasPorCobrar}) async {
    try {
      final queryParameters = {
        'search': search,
        'cantidad': cantidad,
        'page': page,
        'input': input,
        'orden': orden,
        'estado': estado,
        'mis_facturas_emitidas': 'SI',
        'fromApp': true,
        'datos': busquedaCuentasPorCobrar.toJsonString(), // Con
      };
      final response =
          await dio.get('/cuentasporcobrar/', queryParameters: queryParameters);
      final List<CuentaPorCobrar> newCuentasPorCobrar = response.data['data']
              ['results']
          .map<CuentaPorCobrar>((e) => CuentaPorCobrar.fromJson(e))
          .toList();

      return ResponseCuentasPorCobrar(
          resultado: newCuentasPorCobrar,
          error: '',
          total: response.data['data']['pagination']['numRows'] ?? 0);
    } on DioException catch (e) {
      return ResponseCuentasPorCobrar(
          resultado: [],
          error: ErrorApi.getErrorMessage(e, 'getCuentasPorCobrarByPage'));
    }
  }

  Future<ResponseBancos> getBancos() async {
    try {
      // final queryParameters = {};
      final response = await dio.get('/bancos/filtro/0');
      final List<Banco> bancos =
          response.data['data'].map<Banco>((e) => Banco.fromJson(e)).toList();

      return ResponseBancos(
        bancos: bancos,
        error: '',
      );
    } on DioException catch (e) {
      return ResponseBancos(
          bancos: [], error: ErrorApi.getErrorMessage(e, 'getBancos'));
    }
  }
}
