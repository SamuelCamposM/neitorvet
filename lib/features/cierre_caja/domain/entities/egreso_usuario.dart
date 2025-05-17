class EgresoUsuario {
  final String numero;
  final String egreso;
  final String cajaFecReg;
  final String users;

  EgresoUsuario({
    required this.numero,
    required this.egreso,
    required this.cajaFecReg,
    required this.users,
  });

  factory EgresoUsuario.fromJson(Map<String, dynamic> json) => EgresoUsuario(
        numero: json["Numero"],
        egreso: json["Egreso"],
        cajaFecReg: json["cajaFecReg"],
        users: json["Users"],
      );

  Map<String, dynamic> toJson() => {
        "Numero": numero,
        "Egreso": egreso,
        "cajaFecReg": cajaFecReg,
        "Users": users,
      };
}
