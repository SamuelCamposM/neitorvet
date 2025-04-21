import 'package:neitorvet/features/shared/helpers/parse.dart';

class NoFacturado {
  final int idRegistro;
  final int registro;
  final int pistola;
  final String codigoCombustible;
  final int numeroTanque;
  final double valorTotal;
  final double volTotal;
  final double precioUnitario;
  final int tiempo;
  final String fechaHora;
  final double totInicio;
  final double totFinal;
  final String iDoperador;
  final String iDcliente;
  final int volTanque;
  final String fecReg;
  final int facturado;
  final String? nombreCombustible;
  final String? usuario;
  final String? cedulaCliente;
  final String? nombreCliente;
  final List<String> tipoCombustible;
  NoFacturado({
    required this.idRegistro,
    required this.registro,
    required this.pistola,
    required this.codigoCombustible,
    required this.numeroTanque,
    required this.valorTotal,
    required this.volTotal,
    required this.precioUnitario,
    required this.tiempo,
    required this.fechaHora,
    required this.totInicio,
    required this.totFinal,
    required this.iDoperador,
    required this.iDcliente,
    required this.volTanque,
    required this.fecReg,
    required this.facturado,
    required this.nombreCombustible,
    required this.usuario,
    required this.cedulaCliente,
    required this.nombreCliente,
    required this.tipoCombustible,
  });

  factory NoFacturado.fromJson(Map<String, dynamic> json) => NoFacturado(
        idRegistro: json["idRegistro"],
        registro: Parse.parseDynamicToInt(json["registro"]),
        pistola: json["pistola"],
        codigoCombustible: json["codigoCombustible"],
        numeroTanque: json["numeroTanque"],
        valorTotal: Parse.parseDynamicToDouble(json["valorTotal"]),
        volTotal: Parse.parseDynamicToDouble(json["volTotal"]),
        precioUnitario: Parse.parseDynamicToDouble(json["precioUnitario"]),
        tiempo: json["tiempo"],
        fechaHora: json["fechaHora"],
        totInicio: Parse.parseDynamicToDouble(json["totInicio"]),
        totFinal: Parse.parseDynamicToDouble(json["totFinal"]),
        iDoperador: json["IDoperador"] ?? '',
        iDcliente: json["IDcliente"] ?? '',
        volTanque: json["volTanque"] ?? 0,
        fecReg: json["fecReg"],
        facturado: json["facturado"],
        nombreCombustible: json["nombreCombustible"],
        usuario: json["usuario"],
        cedulaCliente: json["cedulaCliente"],
        nombreCliente: json["nombreCliente"],
        tipoCombustible:
            List<String>.from(json["tipoCombustible"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "idRegistro": idRegistro,
        "registro": registro,
        "pistola": pistola,
        "codigoCombustible": codigoCombustible,
        "numeroTanque": numeroTanque,
        "valorTotal": valorTotal,
        "volTotal": volTotal,
        "precioUnitario": precioUnitario,
        "tiempo": tiempo,
        "fechaHora": fechaHora,
        "totInicio": totInicio,
        "totFinal": totFinal,
        "IDoperador": iDoperador,
        "IDcliente": iDcliente,
        "volTanque": volTanque,
        "fecReg": fecReg,
        "facturado": facturado,
        "nombreCombustible": nombreCombustible,
        "usuario": usuario,
        "cedulaCliente": cedulaCliente,
        "nombreCliente": nombreCliente,
        "tipoCombustible": List<dynamic>.from(tipoCombustible.map((x) => x)),
      };
}
