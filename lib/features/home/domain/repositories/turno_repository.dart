import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/home/domain/datasources/turno_datasource.dart';

abstract class TurnoRepository {
  Future<ResponseIniciarTurno> iniciarTurno({
    required String qrUbicacion,
    required PerUbicacion regCoordenadas,
    required String regDispositivo,
  });
  Future<ResponseFinalizarTurno> finalizarTurno({
    required String qrUbicacion,
    required PerUbicacion coordenadasFinalizar,
    required int regId,
  });

  Future<ResponseVerificarTurnoActivo> verificarTurnoActivo();
  Future<ResponseHorariosMes> getHorariosMes({
    required int perId,
  });
}
