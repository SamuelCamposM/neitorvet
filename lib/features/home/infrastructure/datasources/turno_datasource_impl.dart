import 'package:dio/dio.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/home/domain/datasources/turno_datasource.dart';
import 'package:neitorvet/features/home/domain/entities/turno.dart';
import 'package:neitorvet/features/shared/errors/error_api.dart';

class TurnoDatasourceImpl extends TurnoDatasource {
  final Dio dio;
  final String rucempresa;
  TurnoDatasourceImpl({required this.dio, required this.rucempresa});
  @override
  Future<ResponseIniciarTurno> iniciarTurno(
      {required String qrUbicacion,
      required PerUbicacion regCoordenadas,
      required String regDispositivo}) async {
    try {
      final queryParameters = {
        'qrUbicacion': qrUbicacion,
        'regCoordenadas': regCoordenadas.toJson(),
        'regDispositivo': regDispositivo,
      };
      final response = await dio.post('/registro_asistencias/iniciar_turno',
          data: queryParameters);
      final Turno turno = Turno.fromJson(response.data['informacion']);
      return ResponseIniciarTurno(
          error: '', turno: turno, msg: response.data['msg']);
    } on DioException catch (e) {
      return ResponseIniciarTurno(
          error: ErrorApi.getErrorMessage(e, 'iniciarTurno'),
          msg: '',
          turno: null);
    }
  }

  @override
  Future<ResponseFinalizarTurno> finalizarTurno(
      {required String qrUbicacion,
      required PerUbicacion coordenadasFinalizar,
      required int regId}) async {
    try {
      final queryParameters = {
        'qrUbicacion': qrUbicacion,
        'coordenadasFinalizar': coordenadasFinalizar.toJson(),
        'regId': regId,
      };
      final response = await dio.put('/registro_asistencias/finalizar_turno',
          data: queryParameters);
      return ResponseFinalizarTurno(
        error: '',
        msg: response.data['msg'],
      );
    } on DioException catch (e) {
      return ResponseFinalizarTurno(
          error: ErrorApi.getErrorMessage(e, 'finalizarTurno'), msg: '');
    }
  }

  @override
  Future<ResponseVerificarTurnoActivo> verificarTurnoActivo() async {
    try {
      final response = await dio.get(
        '/registro_asistencias/obtener_asistencia',
      );
      final List<Turno> turnos =
          response.data.map((e) => Turno.fromJson(e)).toList().cast<Turno>();
      return ResponseVerificarTurnoActivo(
        error: '',
        response: turnos.isNotEmpty,
        turno: turnos.isNotEmpty ? turnos.first : null,
      );
    } on DioException catch (e) {
      return ResponseVerificarTurnoActivo(
          error: ErrorApi.getErrorMessage(e, 'verificarTurnoActivo'),
          response: false);
    }
  }

  @override
  Future<ResponseHorariosMes> getHorariosMes({required int perId}) async {
    try {
      final response = await dio.get(
        '/horarios/$perId/mes_actual',
      );
      final List<FechasIso> horarios = response.data
          .map((e) => FechasIso.fromJson(e))
          .toList()
          .cast<FechasIso>();
      return ResponseHorariosMes(
        error: '',
        horarios: horarios,
      );
    } on DioException catch (e) {
      return ResponseHorariosMes(
          error: ErrorApi.getErrorMessage(e, 'verificarTurnoActivo'),
          horarios: []);
    }
  }

  // @override
  // Future<ResponseTurno> getTurnoByPage(
  //     {required int cantidad,
  //     required int page,
  //     required String input,
  //     required bool orden,
  //     required String search,
  //     required BusquedaTurno busquedaTurno}) async {
  //   try {
  //     final queryParameters = {
  //       'page': page,
  //       'cantidad': cantidad,
  //       'search': search,
  //       'input': input,
  //       'orden': orden,
  //       'datos': busquedaTurno.toJsonString(), // Con
  //     };
  //     final response = await dio.get('/cierre_surtidores/',
  //         queryParameters: queryParameters);
  //     final List<Turno> newTurno = response.data['data']
  //             ['results']
  //         .map<Turno>((e) => Turno.fromJson(e))
  //         .toList();

  //     return ResponseTurno(
  //         resultado: newTurno,
  //         error: '',
  //         total: response.data['data']['pagination']['numRows'] ?? 0);
  //   } on DioException catch (e) {
  //     return ResponseTurno(
  //         resultado: [], error: ErrorApi.getErrorMessage(e));
  //   }
  // }
}
