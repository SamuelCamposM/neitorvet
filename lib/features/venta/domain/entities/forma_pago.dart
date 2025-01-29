class FormaPago {
  final int fpagoId;
  final String fpagoNombre;
  final String fpagoDescripcion;
  final String fpagoCodigo;
  final String fpagoPorcentaje;
  final String fpagoEmpresa;
  final String fpagoUser;
  final String fpagoFecReg;
  final String todos;

  FormaPago({
    required this.fpagoId,
    required this.fpagoNombre,
    required this.fpagoDescripcion,
    required this.fpagoCodigo,
    required this.fpagoPorcentaje,
    required this.fpagoEmpresa,
    required this.fpagoUser,
    required this.fpagoFecReg,
    required this.todos,
  });

  factory FormaPago.fromJson(Map<String, dynamic> json) => FormaPago(
        fpagoId: json["fpagoId"],
        fpagoNombre: json["fpagoNombre"],
        fpagoDescripcion: json["fpagoDescripcion"],
        fpagoCodigo: json["fpagoCodigo"],
        fpagoPorcentaje: json["fpagoPorcentaje"],
        fpagoEmpresa: json["fpagoEmpresa"],
        fpagoUser: json["fpagoUser"],
        fpagoFecReg: json["fpagoFecReg"],
        todos: json["Todos"],
      );

  Map<String, dynamic> toJson() => {
        "fpagoId": fpagoId,
        "fpagoNombre": fpagoNombre,
        "fpagoDescripcion": fpagoDescripcion,
        "fpagoCodigo": fpagoCodigo,
        "fpagoPorcentaje": fpagoPorcentaje,
        "fpagoEmpresa": fpagoEmpresa,
        "fpagoUser": fpagoUser,
        "fpagoFecReg": fpagoFecReg,
        "Todos": todos,
      };
}
