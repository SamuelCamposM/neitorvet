import 'package:neitorvet/features/shared/helpers/parse.dart';

class Turno {
  final int regId;
  final int idPersona;
  final String regDispositivo;
  final String regEmpresa;
  final String regHoraRegistroIngreso;
  final String regTiempoIngreso;
  final String regStatusIngreso;
  final String regHoraRegistroSalida;
  final String regTiempoSalida;
  final String regStatusSalida;
  final String regFecReg;
  final String regDocumento;
  final String regNombres;
  final String regDia;
  final String regHoraIngreso;
  final String regHoraSalida;
  final RegCoordenadas regCoordenadas;
  final List<RegDatosTurno> regDatosTurno;

  Turno({
    required this.regId,
    required this.idPersona,
    required this.regDispositivo,
    required this.regEmpresa,
    required this.regHoraRegistroIngreso,
    required this.regTiempoIngreso,
    required this.regStatusIngreso,
    required this.regHoraRegistroSalida,
    required this.regTiempoSalida,
    required this.regStatusSalida,
    required this.regFecReg,
    required this.regDocumento,
    required this.regNombres,
    required this.regDia,
    required this.regHoraIngreso,
    required this.regHoraSalida,
    required this.regCoordenadas,
    required this.regDatosTurno,
  });

  factory Turno.fromJson(Map<String, dynamic> json) => Turno(
        regId: json["regId"],
        idPersona: json["id_persona"],
        regDispositivo: json["regDispositivo"],
        regEmpresa: json["regEmpresa"],
        regHoraRegistroIngreso: json["regHoraRegistroIngreso"],
        regTiempoIngreso: json["regTiempoIngreso"],
        regStatusIngreso: json["regStatusIngreso"],
        regHoraRegistroSalida: json["regHoraRegistroSalida"] ?? "",
        regTiempoSalida: json["regTiempoSalida"],
        regStatusSalida: json["regStatusSalida"],
        regFecReg: json["regFecReg"],
        regDocumento: json["regDocumento"],
        regNombres: json["regNombres"],
        regDia: json["regDia"],
        regHoraIngreso: json["regHoraIngreso"],
        regHoraSalida: json["regHoraSalida"] ?? '',
        regCoordenadas: RegCoordenadas.fromJson(json["regCoordenadas"]),
        regDatosTurno: List<RegDatosTurno>.from(
            json["regDatosTurno"].map((x) => RegDatosTurno.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "regId": regId,
        "id_persona": idPersona,
        "regDispositivo": regDispositivo,
        "regEmpresa": regEmpresa,
        "regHoraRegistroIngreso": regHoraRegistroIngreso,
        "regTiempoIngreso": regTiempoIngreso,
        "regStatusIngreso": regStatusIngreso,
        "regHoraRegistroSalida": regHoraRegistroSalida,
        "regTiempoSalida": regTiempoSalida,
        "regStatusSalida": regStatusSalida,
        "regFecReg": regFecReg,
        "regDocumento": regDocumento,
        "regNombres": regNombres,
        "regDia": regDia,
        "regHoraIngreso": regHoraIngreso,
        "regHoraSalida": regHoraSalida,
        "regCoordenadas": regCoordenadas.toJson(),
        "regDatosTurno":
            List<dynamic>.from(regDatosTurno.map((x) => x.toJson())),
      };
}

class RegCoordenadas {
  final double latitud;
  final double longitud;

  RegCoordenadas({
    required this.latitud,
    required this.longitud,
  });

  factory RegCoordenadas.fromJson(Map<String, dynamic> json) => RegCoordenadas(
        latitud: Parse.parseDynamicToDouble(json["latitud"]),
        longitud: Parse.parseDynamicToDouble(json["longitud"]),
      );

  Map<String, dynamic> toJson() => {
        "latitud": latitud,
        "longitud": longitud,
      };
}

class RegDatosTurno {
  final String ubicacion;
  final String puesto;
  final String id;
  final List<FechasIso> fechasIso;

  RegDatosTurno({
    required this.ubicacion,
    required this.puesto,
    required this.id,
    required this.fechasIso,
  });

  factory RegDatosTurno.fromJson(Map<String, dynamic> json) => RegDatosTurno(
        ubicacion: json["ubicacion"],
        puesto: json["puesto"],
        id: json["id"],
        fechasIso: List<FechasIso>.from(
            json["fechas_iso"].map((x) => FechasIso.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ubicacion": ubicacion,
        "puesto": puesto,
        "id": id,
        "fechas_iso": List<dynamic>.from(fechasIso.map((x) => x.toJson())),
      };
}

class FechasIso {
  final String desde;
  final String hasta;
  final int id;

  FechasIso({
    required this.desde,
    required this.hasta,
    required this.id,
  });

  factory FechasIso.fromJson(Map<String, dynamic> json) => FechasIso(
        desde: json["desde"],
        hasta: json["hasta"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "desde": desde,
        "hasta": hasta,
        "id": id,
      };
}
