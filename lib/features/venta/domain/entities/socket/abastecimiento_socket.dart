import 'package:neitorvet/features/shared/helpers/parse.dart';

class AbastecimientoSocket {
  final String status;
  final String type;
  final String parametroRespuesta;
  final String indiceMemoria;
  final int pico;
  final int codigoCombustible;
  final int tanque;
  final double total;
  final double volumen;
  final double precioUnitario;
  final int duracionSegundos;
  final String fecha;
  final String hora;
  final double totalizadorInicial;
  final double totalizadorFinal;
  final String idFrentista;
  final String idCliente;
  final double odometroOVolTanque;
  final String rawData;
  final String codEmp;
  AbastecimientoSocket({
    required this.status,
    required this.type,
    required this.parametroRespuesta,
    required this.indiceMemoria,
    required this.pico,
    required this.codigoCombustible,
    required this.tanque,
    required this.total,
    required this.volumen,
    required this.precioUnitario,
    required this.duracionSegundos,
    required this.fecha,
    required this.hora,
    required this.totalizadorInicial,
    required this.totalizadorFinal,
    required this.idFrentista,
    required this.idCliente,
    required this.odometroOVolTanque,
    required this.rawData,
    required this.codEmp,
  });

  factory AbastecimientoSocket.fromJson(Map<String, dynamic> json) =>
      AbastecimientoSocket(
        status: json["status"],
        type: json["type"],
        parametroRespuesta: json["parametro_respuesta"],
        indiceMemoria: json["indice_memoria"],
        pico: json["pico"],
        codigoCombustible: json["codigo_combustible"],
        tanque: json["tanque"],
        total: Parse.parseDynamicToDouble(json["total"]),
        volumen: Parse.parseDynamicToDouble(json["volumen"]),
        precioUnitario: Parse.parseDynamicToDouble(json["precio_unitario"]),
        duracionSegundos: json["duracion_segundos"],
        fecha: json["fecha"],
        hora: json["hora"],
        totalizadorInicial:
            Parse.parseDynamicToDouble(json["totalizador_inicial"]),
        totalizadorFinal: Parse.parseDynamicToDouble(json["totalizador_final"]),
        idFrentista: json["id_frentista"],
        idCliente: json["id_cliente"],
        odometroOVolTanque: json["odometro_o_vol_tanque"],
        rawData: json["raw_data"],
        codEmp: json["codEmp"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "type": type,
        "parametro_respuesta": parametroRespuesta,
        "indice_memoria": indiceMemoria,
        "pico": pico,
        "codigo_combustible": codigoCombustible,
        "tanque": tanque,
        "total": total,
        "volumen": volumen,
        "precio_unitario": precioUnitario,
        "duracion_segundos": duracionSegundos,
        "fecha": fecha,
        "hora": hora,
        "totalizador_inicial": totalizadorInicial,
        "totalizador_final": totalizadorFinal,
        "id_frentista": idFrentista,
        "id_cliente": idCliente,
        "odometro_o_vol_tanque": odometroOVolTanque,
        "raw_data": rawData,
        "codEmp": codEmp,
      };
}
