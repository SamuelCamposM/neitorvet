// To parse this JSON data, do
//
//     final inventario = inventarioFromJson(jsonString);

import 'package:neitorvet/features/shared/helpers/parse.dart';
import 'package:neitorvet/features/venta/domain/entities/bodega.dart';

class Inventario {
  final String invTipo;
  final String invNombre;
  final String invDescripcion;
  final String invCosto1;
  final String invCosto2;
  final String invCosto3;
  final int invStock;
  final String invIva;
  final String invIncluyeIva;
  final String invEstado;
  final List<Bodega> invBodegas;
  final List<int> invprecios;
  final String invProveedor;
  final String invCategoria;
  final String invSubCategoria;
  final String invUnidad;
  final String invMarca;
  final String invSubsidio;
  final String invPlanCuenta;
  final String invEmpresa;
  final String invUser;
  final int invId;
  final String invSerie;
  final int invNumVentas;
  final DateTime invFecReg;
  final DateTime invFecUpd;
  final List<dynamic> invFotos;

  Inventario({
    required this.invTipo,
    required this.invNombre,
    required this.invDescripcion,
    required this.invCosto1,
    required this.invCosto2,
    required this.invCosto3,
    required this.invStock,
    required this.invIva,
    required this.invIncluyeIva,
    required this.invEstado,
    required this.invBodegas,
    required this.invprecios,
    required this.invProveedor,
    required this.invCategoria,
    required this.invSubCategoria,
    required this.invUnidad,
    required this.invMarca,
    required this.invSubsidio,
    required this.invPlanCuenta,
    required this.invEmpresa,
    required this.invUser,
    required this.invId,
    required this.invSerie,
    required this.invNumVentas,
    required this.invFecReg,
    required this.invFecUpd,
    required this.invFotos,
  });

  factory Inventario.fromJson(Map<String, dynamic> json) => Inventario(
        invTipo: json["invTipo"],
        invNombre: json["invNombre"],
        invDescripcion: json["invDescripcion"],
        invCosto1: json["invCosto1"],
        invCosto2: json["invCosto2"],
        invCosto3: json["invCosto3"],
        invStock: Parse.parseDynamicToInt(json["invStock"]),
        invIva: json["invIva"],
        invIncluyeIva: json["invIncluyeIva"],
        invEstado: json["invEstado"],
        invBodegas: List<Bodega>.from(
            json["invBodegas"].map((x) => Bodega.fromJson(x))),
        invprecios: List<int>.from(
            Parse.parseDynamicToListInt(json["invprecios"]).map((x) => x)),
        invProveedor: json["invProveedor"],
        invCategoria: json["invCategoria"],
        invSubCategoria: json["invSubCategoria"],
        invUnidad: json["invUnidad"],
        invMarca: json["invMarca"],
        invSubsidio: json["invSubsidio"],
        invPlanCuenta: json["invPlanCuenta"],
        invEmpresa: json["invEmpresa"],
        invUser: json["invUser"],
        invId: json["invId"],
        invSerie: json["invSerie"],
        invNumVentas: json["inv_num_ventas"],
        invFecReg: DateTime.parse(json["invFecReg"]),
        invFecUpd: DateTime.parse(json["invFecUpd"]),
        invFotos: List<dynamic>.from(json["invFotos"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "invTipo": invTipo,
        "invNombre": invNombre,
        "invDescripcion": invDescripcion,
        "invCosto1": invCosto1,
        "invCosto2": invCosto2,
        "invCosto3": invCosto3,
        "invStock": invStock,
        "invIva": invIva,
        "invIncluyeIva": invIncluyeIva,
        "invEstado": invEstado,
        "invBodegas": List<dynamic>.from(invBodegas.map((x) => x.toJson())),
        "invprecios": List<dynamic>.from(invprecios.map((x) => x)),
        "invProveedor": invProveedor,
        "invCategoria": invCategoria,
        "invSubCategoria": invSubCategoria,
        "invUnidad": invUnidad,
        "invMarca": invMarca,
        "invSubsidio": invSubsidio,
        "invPlanCuenta": invPlanCuenta,
        "invEmpresa": invEmpresa,
        "invUser": invUser,
        "invId": invId,
        "invSerie": invSerie,
        "inv_num_ventas": invNumVentas,
        "invFecReg": invFecReg.toIso8601String(),
        "invFecUpd": invFecUpd.toIso8601String(),
        "invFotos": List<dynamic>.from(invFotos.map((x) => x)),
      };
}
