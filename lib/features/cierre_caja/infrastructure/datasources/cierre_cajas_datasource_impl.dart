import 'package:dio/dio.dart';
import 'package:neitorvet/features/cierre_caja/domain/datasources/cierre_cajas_datasource.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/shared/errors/error_api.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';

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
      print(
        {
          'search': search,
          'cantidad': cantidad,
          'page': page,
          'input': input,
          'orden': orden,
          'estado':
              estado == 'ANULADA' ? 'GENERAL' : estado, // DIARIA // GENERAL
          'status':
              estado == 'ANULADA' ? estado : 'ACTIVA', // ACTIVA // ANULADA
          'datos': busquedaCierreCaja.toJsonString(),
        },
      );
      final response = await dio.get(
        '/cajas',
        queryParameters: {
          'search': search,
          'cantidad': cantidad,
          'page': page,
          'input': input,
          'orden': orden,
          'estado':
              estado == 'ANULADA' ? 'GENERAL' : estado, // DIARIA // GENERAL
          'status':
              estado == 'ANULADA' ? estado : 'ACTIVA', // ACTIVA // ANULADA
          'datos': busquedaCierreCaja.toJsonString(),
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

  @override
  Future<ResponseSumaIEC> getSumaIEC(
      {required String fecha, required String search}) async {
    try {
      final response = await dio.get(
        '//cajas/saldo-total/ingreso-egreso-credito',
        queryParameters: {
          // 'search': search,
          'fecha': fecha,
        },
      );

      return ResponseSumaIEC(
        credito: Parse.parseDynamicToDouble(response.data?['Ingreso']),
        egreso: Parse.parseDynamicToDouble(response.data?['Egreso']),
        ingreso: Parse.parseDynamicToDouble(response.data?['Credito']),
        transferencia:
            Parse.parseDynamicToDouble(response.data?['Transferencia']),
        deposito: Parse.parseDynamicToDouble(response.data?['Deposito']),
        error: '',
      );
    } on DioException catch (e) {
      return ResponseSumaIEC(
          credito: 0,
          egreso: 0,
          ingreso: 0,
          transferencia: 0,
          deposito: 0,
          error: ErrorApi.getErrorMessage(e));
    }
  }
}
