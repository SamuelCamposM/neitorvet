import 'dart:convert';

import 'package:neitorvet/features/shared/helpers/parse.dart';

class CierreSurtidor {
  final int idcierre;
  final int contadorCierre;
  final int combustibleCierre;
  final int codigoCombustible;
  final String? nombreCombustible;
  final int pistolaCierre;
  final double valorCierre;
  final double tGalonesCierre;
  final String fechaCierre;
  final double totInicioCierre;
  final double totFinalCierre;
  final double totalDiaValorCierre;
  final double totalDiaGalonesCierre;
  final String userCierre;
  final String uuid;
  final String fecReg;

  CierreSurtidor({
    required this.idcierre,
    required this.contadorCierre,
    required this.combustibleCierre,
    required this.codigoCombustible,
    required this.nombreCombustible,
    required this.pistolaCierre,
    required this.valorCierre,
    required this.tGalonesCierre,
    required this.fechaCierre,
    required this.totInicioCierre,
    required this.totFinalCierre,
    required this.totalDiaValorCierre,
    required this.totalDiaGalonesCierre,
    required this.userCierre,
    required this.uuid,
    required this.fecReg,
  });

  factory CierreSurtidor.fromJson(Map<String, dynamic> json) => CierreSurtidor(
        idcierre: json["idcierre"],
        contadorCierre: Parse.parseDynamicToInt(json["contadorCierre"]),
        combustibleCierre: Parse.parseDynamicToInt(json["combustibleCierre"]),
        codigoCombustible: Parse.parseDynamicToInt(json["codigoCombustible"]),
        nombreCombustible: json["nombreCombustible"],
        pistolaCierre: Parse.parseDynamicToInt(json["pistolaCierre"]),
        valorCierre: Parse.parseDynamicToDouble(json["valorCierre"]),
        tGalonesCierre: Parse.parseDynamicToDouble(json["tGalonesCierre"]),
        fechaCierre: json["fechaCierre"],
        totInicioCierre: Parse.parseDynamicToDouble(json["totInicioCierre"]),
        totFinalCierre: Parse.parseDynamicToDouble(json["totFinalCierre"]),
        totalDiaValorCierre:
            Parse.parseDynamicToDouble(json["totalDiaValorCierre"]),
        totalDiaGalonesCierre:
            Parse.parseDynamicToDouble(json["totalDiaGalonesCierre"]),
        userCierre: json["userCierre"],
        uuid: json["uuid"],
        fecReg: json["fecReg"],
      );

  Map<String, dynamic> toJson() => {
        "idcierre": idcierre,
        "contadorCierre": contadorCierre,
        "combustibleCierre": combustibleCierre,
        "codigoCombustible": codigoCombustible,
        "nombreCombustible": nombreCombustible,
        "pistolaCierre": pistolaCierre,
        "valorCierre": valorCierre,
        "tGalonesCierre": tGalonesCierre,
        "fechaCierre": fechaCierre,
        "totInicioCierre": totInicioCierre,
        "totFinalCierre": totFinalCierre,
        "totalDiaValorCierre": totalDiaValorCierre,
        "totalDiaGalonesCierre": totalDiaGalonesCierre,
        "userCierre": userCierre,
        "uuid": uuid,
        "fecReg": fecReg,
      };
}

class BusquedaCierreSurtidor {
  final String fechaCierre1;
  final String fechaCierre2;

  const BusquedaCierreSurtidor({
    this.fechaCierre1 = '',
    this.fechaCierre2 = '',
  });

  factory BusquedaCierreSurtidor.fromJson(Map<String, dynamic> json) =>
      BusquedaCierreSurtidor(
        fechaCierre1: json["fechaCierre1"],
        fechaCierre2: json["fechaCierre2"],
      );

  Map<String, dynamic> toJson() => {
        "fechaCierre1": fechaCierre1,
        "fechaCierre2": fechaCierre2,
      };

  BusquedaCierreSurtidor copyWith({
    String? fechaCierre1,
    String? fechaCierre2,
  }) {
    return BusquedaCierreSurtidor(
      fechaCierre1: fechaCierre1 ?? this.fechaCierre1,
      fechaCierre2: fechaCierre2 ?? this.fechaCierre2,
    );
  }

  bool isSearching() {
    return fechaCierre1.isNotEmpty || fechaCierre2.isNotEmpty;
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
