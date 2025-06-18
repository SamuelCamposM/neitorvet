import 'package:flutter/widgets.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/home/domain/entities/turno.dart';

class ResponseIniciarTurno {
  final String error;
  final String msg;
  final Turno? turno;
  ResponseIniciarTurno({
    required this.error,
    required this.msg,
    this.turno,
  });
}

class ResponseFinalizarTurno {
  final String error;
  final String msg;
  ResponseFinalizarTurno({
    required this.error,
    required this.msg,
  });
}

class ResponseVerificarTurnoActivo {
  final String error;
  final bool response;
  final Turno? turno;
  ResponseVerificarTurnoActivo({
    required this.error,
    required this.response,
    this.turno,
  });
}

class ResponseHorariosMes {
  final String error;
  final List<FechasIso> horarios;
  ResponseHorariosMes({
    required this.error,
    required this.horarios,
  });
}

abstract class TurnoDatasource {
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
