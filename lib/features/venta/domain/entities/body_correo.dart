class BodyCorreo {
  final String medioComunicacion;
  final String option;
  final int idRegistro;
  final List<String> contacto;
  final String contenidoMensaje;

  BodyCorreo({
    required this.medioComunicacion,
    required this.option,
    required this.idRegistro,
    required this.contacto,
    required this.contenidoMensaje,
  });

  Map<String, dynamic> toJson() {
    return {
      'medioComunicacion': medioComunicacion,
      'option': option,
      'idRegistro': idRegistro,
      'contacto': contacto,
      'contenidoMensaje': contenidoMensaje,
    };
  }
}
