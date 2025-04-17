import 'package:neitorvet/features/shared/helpers/parse.dart'; 

class AbastecimientoP {
  final int idAbastecimiento;
  final int pistola;
  final String iDoperador;

  AbastecimientoP({
    required this.idAbastecimiento,
    required this.pistola,
    required this.iDoperador,
  });

  factory AbastecimientoP.fromJson(Map<String, dynamic> json) =>
      AbastecimientoP(
        idAbastecimiento: json["idAbastecimiento"],
        pistola: json["pistola"],
        iDoperador: json["IDoperador"],
      );

  Map<String, dynamic> toJson() => {
        "idAbastecimiento": idAbastecimiento,
        "pistola": pistola,
        "IDoperador": iDoperador,
      };
}

class InventarioSocket {
  final String invTipo;
  final String invCosto2;
  final String invEmpresa;
  final String invUser;
  final String userUpd;
  final String invNombre;
  final String invCosto1;
  final List<double> invprecios;
  final String invSubsidio;
  final int invId;
  final String invSerie;

  InventarioSocket({
    required this.invTipo,
    required this.invCosto2,
    required this.invEmpresa,
    required this.invUser,
    required this.userUpd,
    required this.invNombre,
    required this.invCosto1,
    required this.invprecios,
    required this.invSubsidio,
    required this.invId,
    required this.invSerie,
  });

  factory InventarioSocket.fromJson(Map<String, dynamic> json) =>
      InventarioSocket(
        invTipo: json["invTipo"],
        invCosto2: json["invCosto2"],
        invEmpresa: json["invEmpresa"],
        invUser: json["invUser"],
        userUpd: json["user_upd"],
        invNombre: json["invNombre"],
        invCosto1: json["invCosto1"],
        invprecios: List<double>.from(
            Parse.parseDynamicToListDouble(json["invprecios"]).map((x) => x)),
        invSubsidio: json["invSubsidio"],
        invId: json["invId"],
        invSerie: json["invSerie"],
      );

  Map<String, dynamic> toJson() => {
        "invTipo": invTipo,
        "invCosto2": invCosto2,
        "invEmpresa": invEmpresa,
        "invUser": invUser,
        "user_upd": userUpd,
        "invNombre": invNombre,
        "invCosto1": invCosto1,
        "invprecios": List<dynamic>.from(invprecios.map((x) => x)),
        "invSubsidio": invSubsidio,
        "invId": invId,
        "invSerie": invSerie,
      };
}

class ProcessedDispatch {
  final String type;
  final InventarioSocket producto;
  final AbastecimientoP abastecimiento;

  ProcessedDispatch({
    required this.type,
    required this.producto,
    required this.abastecimiento,
  });

  factory ProcessedDispatch.fromJson(Map<String, dynamic> json) =>
      ProcessedDispatch(
        type: json["type"],
        producto: InventarioSocket.fromJson(json["producto"]),
        abastecimiento: AbastecimientoP.fromJson(json["abastecimiento"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "producto": producto.toJson(),
        "abastecimiento": abastecimiento.toJson(),
      };
}
