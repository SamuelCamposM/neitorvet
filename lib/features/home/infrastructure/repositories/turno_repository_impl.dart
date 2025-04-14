import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/home/domain/datasources/turno_datasource.dart';
import 'package:neitorvet/features/home/domain/repositories/turno_repository.dart';

class TurnoRepositoryImpl extends TurnoRepository {
  final TurnoDatasource datasource;

  TurnoRepositoryImpl({required this.datasource});

  @override
  Future<ResponseVerificarTurnoActivo> verificarTurnoActivo() {
    return datasource.verificarTurnoActivo();
  }

  @override
  Future<ResponseIniciarTurno> iniciarTurno(
      {required String qrUbicacion,
      required PerUbicacion regCoordenadas,
      required String regDispositivo}) {
    return datasource.iniciarTurno(
        qrUbicacion: qrUbicacion,
        regCoordenadas: regCoordenadas,
        regDispositivo: regDispositivo);
  }

  @override
  Future<ResponseFinalizarTurno> finalizarTurno(
      {required String qrUbicacion,
      required PerUbicacion coordenadasFinalizar,
      required int regId}) {
    return datasource.finalizarTurno(
        qrUbicacion: qrUbicacion,
        coordenadasFinalizar: coordenadasFinalizar,
        regId: regId);
  }
  // @override
  // Future<ResponseTurno> getTurnoByPage(
  //     {required int cantidad,
  //     required int page,
  //     required String input,
  //     required bool orden,
  //     required String search,
  //     required BusquedaTurno busquedaTurno}) {
  //   return datasource.getTurnoByPage(
  //       cantidad: cantidad,
  //       page: page,
  //       input: input,
  //       orden: orden,
  //       search: search,
  //       busquedaTurno: busquedaTurno);
  // }

  // @override
  // Future<ResponseTurno> getTurnoUuid({
  //   required String uuid,
  // }) {
  //   return datasource.getTurnoUuid(
  //     uuid: uuid,
  //   );
  // }
}
