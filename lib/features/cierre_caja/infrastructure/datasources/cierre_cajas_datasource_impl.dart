import 'package:dio/dio.dart';
import 'package:neitorvet/features/cierre_caja/domain/datasources/cierre_cajas_datasource.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/egreso_usuario.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/no_facturado.dart';
import 'package:neitorvet/features/shared/errors/error_api.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';

class CierreCajasDatasourceImpl extends CierreCajasDatasource {
  final Dio dio;
  final String rucempresa;
  CierreCajasDatasourceImpl({required this.dio, required this.rucempresa});
  @override
  Future<ResponseCierreCajasPaginacion> getCierreCajasByPage({
    required int cantidad,
    required int page,
    required String search,
    required String input,
    required bool orden,
    required BusquedaCierreCaja busquedaCierreCaja,
    required String estado,
  }) async {
    try {
      final queryParams = {
        'search': search,
        'cantidad': cantidad,
        'page': page,
        'input': input,
        'orden': orden,
        'estado': estado == 'ANULADA' ? 'GENERAL' : estado,
        'status': estado == 'ANULADA' ? estado : 'ACTIVA',
        'datos': busquedaCierreCaja.toJsonString(),
      };

      final endpoint =
          estado == 'DIARIA' ? '/cajas/lista/diaria_gasolineraApp' : '/cajas';

      final response = await dio.get(endpoint, queryParameters: queryParams);

      final data =
          estado == 'DIARIA' ? response.data : response.data['data']['results'];

      final List<CierreCaja> newCierreCajas =
          data.map<CierreCaja>((e) => CierreCaja.fromJson(e)).toList();

      final total = estado == 'DIARIA'
          ? data.length
          : response.data['data']['pagination']['numRows'] ?? 0;

      return ResponseCierreCajasPaginacion(
        resultado: newCierreCajas,
        error: '',
        total: total,
      );
    } on DioException catch (e) {
      return ResponseCierreCajasPaginacion(
        resultado: [],
        error: ErrorApi.getErrorMessage(e, 'getCierreCajasByPage'),
      );
    }
  }

  @override
  Future<ResponseSumaIEC> getSumaIEC(
      {required String fecha, required String search}) async {
    try {
      final response = await dio.get(
        '/cajas/saldo-total/ingreso-egreso-credito_gasolineraApp',
        queryParameters: {
          'search': search,
          'fecha': fecha,
        },
      );

      return ResponseSumaIEC(
        ingreso: Parse.parseDynamicToDouble(response.data?['Ingreso']),
        egreso: Parse.parseDynamicToDouble(response.data?['Egreso']),
        credito: Parse.parseDynamicToDouble(response.data?['Credito']),
        transferencia:
            Parse.parseDynamicToDouble(response.data?['Transferencia']),
        deposito: Parse.parseDynamicToDouble(response.data?['DEPOSITO']),
        tarjetaCredito:
            Parse.parseDynamicToDouble(response.data?['TARJETA_DE_CREDITO']),
        tarjetaDebito:
            Parse.parseDynamicToDouble(response.data?['TARJETA_DE_DEBITO']),
        tarjetaPrepago:
            Parse.parseDynamicToDouble(response.data?['TARJETA_PREPAGO']),
        error: '',
      );
    } on DioException catch (e) {
      return ResponseSumaIEC(
          credito: 0,
          egreso: 0,
          ingreso: 0,
          transferencia: 0,
          deposito: 0,
          tarjetaCredito: 0,
          tarjetaDebito: 0,
          tarjetaPrepago: 0,
          error: ErrorApi.getErrorMessage(e, 'getSumaIEC'));
    }
  }

  @override
  Future<ResponseNoFacturados> getNoFacturados() async {
    try {
      final response = await dio.post(
        '/abastecimientos/no_facturados',
      );
      final List<NoFacturado> resultado = response.data.map<NoFacturado>((e) {
        return NoFacturado.fromJson(e);
      }).toList();
      return ResponseNoFacturados(
        resultado: resultado,
        error: '',
      );
    } catch (e) {
      return ResponseNoFacturados(
          resultado: [], error: ErrorApi.getErrorMessage(e, 'getNoFacturados'));
    }
  }

  @override
  Future<ResponseEgresos> getEgresos({required String documento}) async {
    try {
      final response = await dio.get(
        '/cajas/egresos/del/dia/por/usuario',
        queryParameters: {
          'documento': documento,
        },
      );

      final List<EgresoUsuario> resultado =
          response.data.map<EgresoUsuario>((e) {
        return EgresoUsuario.fromJson(e);
      }).toList();
      return ResponseEgresos(
        error: '',
        resultado: resultado,
      );
    } on DioException catch (e) {
      return ResponseEgresos(
          error: ErrorApi.getErrorMessage(e, 'getEgresos'), resultado: []);
    }
  }
}
