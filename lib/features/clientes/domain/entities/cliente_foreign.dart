class ClienteForeign {
  final int perId;
  final String perNombre;
  final String perDocNumero;
  final String perDocTipo;
  final String perTelefono;
  final String perDireccion;
  final List<String> perEmail;
  final List<String> perCelular;
  final List<String> perOtros;
  final String perCredito;
  final String perFlota;
  ClienteForeign({
    required this.perId,
    required this.perNombre,
    required this.perCredito,
    required this.perDocNumero,
    required this.perDocTipo,
    required this.perTelefono,
    required this.perDireccion,
    required this.perEmail,
    required this.perCelular,
    required this.perOtros,
    required this.perFlota,
  });

  factory ClienteForeign.fromJson(Map<String, dynamic> json) => ClienteForeign(
        perId: json["perId"] == "" ? 0 : json["perId"],
        perNombre: json["perNombre"],
        perCredito: json["perCredito"] ?? "NO",
        perDocNumero: json["perDocNumero"],
        perDocTipo: json["perDocTipo"],
        perTelefono: json["perTelefono"],
        perDireccion: json["perDireccion"],
        perFlota: json["perFlota"] ?? '',
        perEmail: List<String>.from(json["perEmail"].map((x) => x)),
        perCelular: List<String>.from(json["perCelular"].map((x) => x)),
        perOtros: List<String>.from(json["perOtros"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "perId": perId,
        "perNombre": perNombre,
        "perCredito": perCredito,
        "perDocNumero": perDocNumero,
        "perDocTipo": perDocTipo,
        "perTelefono": perTelefono,
        "perDireccion": perDireccion,
        "perFlota": perFlota,
        "perEmail": List<dynamic>.from(perEmail.map((x) => x)),
        "perCelular": List<dynamic>.from(perCelular.map((x) => x)),
        "perOtros": List<dynamic>.from(perOtros.map((x) => x)),
      };
}
