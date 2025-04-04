class Usuario {
  final String perFoto;
  final String perApellidos;
  final String perNombres;
  final String perDocNumero;
  final int perId;

  Usuario({
    required this.perFoto,
    required this.perApellidos,
    required this.perNombres,
    required this.perDocNumero,
    required this.perId,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        perFoto: json["perFoto"],
        perApellidos: json["perApellidos"],
        perNombres: json["perNombres"],
        perDocNumero: json["perDocNumero"],
        perId: json["perId"],
      );

  Map<String, dynamic> toJson() => {
        "perFoto": perFoto,
        "perApellidos": perApellidos,
        "perNombres": perNombres,
        "perDocNumero": perDocNumero,
        "perId": perId,
      };
}
