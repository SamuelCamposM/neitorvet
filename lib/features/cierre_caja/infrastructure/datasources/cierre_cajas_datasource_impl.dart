import 'package:dio/dio.dart';
import 'package:neitorvet/features/cierre_caja/domain/datasources/cierre_cajas_datasource.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/shared/errors/error_api.dart';

class CierreCajasDatasourceImpl extends CierreCajasDatasource {
  final Dio dio;
  final String rucempresa;
  CierreCajasDatasourceImpl({required this.dio, required this.rucempresa});

  @override
  Future<ResponseCierreCajasPaginacion> getCierreCajasByPage(
      {required int cantidad,
      required int page,
      required String search,
      required String input,
      required bool orden,
      required BusquedaCierreCaja busquedaCierreCaja,
      required String estado}) async {
    try {
      final response = await dio.get(
        '/cajas',
        queryParameters: {
          'search': search,
          'cantidad': cantidad,
          'page': page,
          'input': input,
          'orden': orden,
          'estado': estado, 'datos': busquedaCierreCaja.toJsonString(), // Co
        },
      );
      final List<CierreCaja> newCierreCajas = response.data['data']['results']
          .map<CierreCaja>((e) => CierreCaja.fromJson(e))
          .toList();

      return ResponseCierreCajasPaginacion(
          resultado: newCierreCajas,
          error: '',
          total: response.data['data']['pagination']['numRows'] ?? 0);
    } on DioException catch (e) {
      return ResponseCierreCajasPaginacion(
          resultado: [], error: ErrorApi.getErrorMessage(e));
    }
  }
}
