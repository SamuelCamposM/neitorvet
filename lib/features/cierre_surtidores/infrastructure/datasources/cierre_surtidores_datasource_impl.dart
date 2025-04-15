import 'package:dio/dio.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/datasources/cierre_surtidores_datasource.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/cierre_surtidor.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/surtidor.dart';
import 'package:neitorvet/features/shared/errors/error_api.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:neitorvet/features/shared/utils/dio_zaracay.dart';

class CierreSurtidoresDatasourceImpl extends CierreSurtidoresDatasource {
  final Dio dio;
  final String rucempresa;
  CierreSurtidoresDatasourceImpl({required this.dio, required this.rucempresa});

  @override
  Future<ResponseCierreSurtidores> getCierreSurtidoresByPage(
      {required int cantidad,
      required int page,
      required String input,
      required bool orden,
      required String search,
      required BusquedaCierreSurtidor busquedaCierreSurtidor}) async {
    try {
      final queryParameters = {
        'page': page,
        'cantidad': cantidad,
        'search': search,
        'input': input,
        'orden': orden,
        'datos': busquedaCierreSurtidor.toJsonString(), // Con
      };
      final response = await dio.get('/cierre_surtidores/',
          queryParameters: queryParameters);
      final List<CierreSurtidor> newCierreSurtidores = response.data['data']
              ['results']
          .map<CierreSurtidor>((e) => CierreSurtidor.fromJson(e))
          .toList();

      return ResponseCierreSurtidores(
          resultado: newCierreSurtidores,
          error: '',
          total: response.data['data']['pagination']['numRows'] ?? 0);
    } on DioException catch (e) {
      return ResponseCierreSurtidores(
          resultado: [],
          error: ErrorApi.getErrorMessage(e, 'getCierreSurtidoresByPage'));
    }
  }

  @override
  Future<ResponseSurtidores> getSurtidores() async {
    try {
      // final queryParameters = {
      //   'cantidad': 20,
      //   'page': 0,
      //   'search': '',
      //   'input': 'id_surtidor',
      //   'orden': false,
      //   'datos': {},
      //   'rucempresa': rucempresa,
      // };
      final response = await dio.get('/surtidores/todo');

      final List<Surtidor> surtidoresData =
          (response.data as List).map((e) => Surtidor.fromJson(e)).toList();
      return ResponseSurtidores(resultado: surtidoresData, error: '');
    } on DioException catch (e) {
      return ResponseSurtidores(
          resultado: [], error: ErrorApi.getErrorMessage(e, 'getSurtidores'));
    }
  }

  @override
  Future<ResponseCierreSurtidores> getCierreSurtidoresUuid(
      {required String uuid}) async {
    try {
      final queryParameters = {
        'uuid': uuid,
      };
      final response =
          await dio.post('/cierre_surtidores/byuuid', data: queryParameters);

      // Asegúrate de que response.data es una lista antes de mapear
      final List<CierreSurtidor> cierreSurtidores = response.data
          .map<CierreSurtidor>((e) => CierreSurtidor.fromJson(e))
          .toList();

      return ResponseCierreSurtidores(
        resultado: cierreSurtidores,
        error: '',
        total: cierreSurtidores.length,
      );
    } catch (e) {
      // print(e);
      return ResponseCierreSurtidores(
        resultado: [],
        error: ErrorApi.getErrorMessage(e, 'getCierreSurtidoresUuid'),
      );
    }
  }

  @override
  Future<ResponseGenerarCierre> generarCierre({
    required List<String> codCombustible,
    required List<String> pistolas,
  }) async {
    try {
      final queryParameters = {
        'cod_combustible': codCombustible,
        'pistolas': pistolas,
      };
      final response = await dio.post('/cierre_surtidores/generar/cierre',
          data: queryParameters);
      response;
      return ResponseGenerarCierre(
        uuid: 'cierreSurtidores',
        error: '',
      );
    } catch (e) {
      // print(e);
      return ResponseGenerarCierre(
        uuid: '',
        error: ErrorApi.getErrorMessage(e, 'generarCierre'),
      );
    }
  }

  @override
  Future<ResponseStatusPicos> getStatusPicos({required String manguera}) async {
    try {
      final response = await dioZaracay.get(
        '/status/picos',
      );
      return ResponseStatusPicos(
          error: '', success: response.data[manguera] == 'B');
    } catch (e) {
      return ResponseStatusPicos(
          error: ErrorApi.getErrorMessage(e, 'getStatusPicos'), success: false);
    }
  }

  @override
  Future<ResponsePresetExtendido> presetExtendido({
    required String manguera,
    required String valorPreset, // valor_preset
    required String tipoPreset, // tipo_preset
    required String nivelPrecio, // nivel_precio
  }) async {
    try {
      final data = {
        'valor_preset': Format.formatValorPreset(valorPreset),
        'tipo_preset': tipoPreset,
        'nivel_precio': nivelPrecio,
      };
      print(data);
      final response = await dioZaracay.post(
        '/picos/$manguera/preset_extendido',
        data: data,
      );
      return ResponsePresetExtendido(error: '');
    } catch (e) {
      return ResponsePresetExtendido(
        error: ErrorApi.getErrorMessage(e, 'getStatusPicos'),
      );
    }
  }
}
