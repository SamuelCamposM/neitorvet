import 'package:neitorvet/features/shared/helpers/parse.dart';

class Abastecimiento {
  final String registro;
  final int pistola;
  final int numeroTanque;
  final int codigoCombustible;
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
  final int facturado;
  final String nombreCombustible;
  final String usuario;
  final String cedulaCliente;
  final String nombreCliente;

  Abastecimiento({
    required this.registro,
    required this.pistola,
    required this.numeroTanque,
    required this.codigoCombustible,
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
    required this.facturado,
    required this.nombreCombustible,
    required this.usuario,
    required this.cedulaCliente,
    required this.nombreCliente,
  });

  factory Abastecimiento.fromJson(Map<String, dynamic> json) => Abastecimiento(
        registro: json["registro"],
        pistola: json["pistola"],
        numeroTanque: json["numeroTanque"],
        codigoCombustible: json["codigo_combustible"],
        valorTotal: Parse.parseDynamicToDouble(json["valorTotal"]),
        volTotal: Parse.parseDynamicToDouble(json["volTotal"]),
        precioUnitario: Parse.parseDynamicToDouble(json["precioUnitario"]),
        tiempo: json["tiempo"],
        fechaHora: json["fechaHora"],
        totInicio: Parse.parseDynamicToDouble(json["totInicio"]),
        totFinal: Parse.parseDynamicToDouble(json["totFinal"]),
        iDoperador: json["IDoperador"],
        iDcliente: json["IDcliente"],
        volTanque: json["volTanque"],
        facturado: json["facturado"],
        nombreCombustible: json["nombreCombustible"],
        usuario: json["usuario"],
        cedulaCliente: json["cedulaCliente"],
        nombreCliente: json["nombreCliente"],
      );

  Map<String, dynamic> toJson() => {
        "registro": registro,
        "pistola": pistola,
        "numeroTanque": numeroTanque,
        "codigoCombustible": codigoCombustible,
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
        "facturado": facturado,
        "nombreCombustible": nombreCombustible,
        "usuario": usuario,
        "cedulaCliente": cedulaCliente,
        "nombreCliente": nombreCliente,
      };
}
