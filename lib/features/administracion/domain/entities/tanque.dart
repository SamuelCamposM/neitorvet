//====================== MODELO DE TANQUE ==========================//

class Tanque {
  int idTanque;
  String numeroTanque;
  int volumenTotal;
  String codigoCombustible;
  DateTime fechaHora;
  String estado;
  double volumen;
  double volumenTemperatura;
  double vacio;
  double altura;
  int agua;
  double temperatura;
  int volumenAgua;
  String columnaExtra;

  Tanque({
    required this.idTanque,
    required this.numeroTanque,
    required this.volumenTotal,
    required this.codigoCombustible,
    required this.fechaHora,
    required this.estado,
    required this.volumen,
    required this.volumenTemperatura,
    required this.vacio,
    required this.altura,
    required this.agua,
    required this.temperatura,
    required this.volumenAgua,
    required this.columnaExtra,
  });

  factory Tanque.fromJson(Map<String, dynamic> json) => Tanque(
        idTanque: json["idTanque"],
        numeroTanque: json["numeroTanque"],
        volumenTotal: json["volumenTotal"],
        codigoCombustible: json["codigoCombustible"],
        fechaHora: DateTime.parse(json["fechaHora"]),
        estado: json["estado"],
        volumen: json["volumen"]?.toDouble(),
        volumenTemperatura: json["volumenTemperatura"]?.toDouble(),
        vacio: json["vacio"]?.toDouble(),
        altura: json["altura"]?.toDouble(),
        agua: json["agua"].toInt(),
        temperatura: json["temperatura"]?.toDouble(),
        volumenAgua: json["volumenAgua"].toInt(),
        columnaExtra: json["columnaExtra"],
      );

  Map<String, dynamic> toJson() => {
        "idTanque": idTanque,
        "numeroTanque": numeroTanque,
        "volumenTotal": volumenTotal,
        "codigoCombustible": codigoCombustible,
        "fechaHora": fechaHora.toIso8601String(),
        "estado": estado,
        "volumen": volumen,
        "volumenTemperatura": volumenTemperatura,
        "vacio": vacio,
        "altura": altura,
        "agua": agua,
        "temperatura": temperatura,
        "volumenAgua": volumenAgua,
        "columnaExtra": columnaExtra,
      };
}
