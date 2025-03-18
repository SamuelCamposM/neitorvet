import 'package:neitorvet/features/shared/helpers/parse.dart';

class Estacion {
  int? numeroPistola;
  String? codigoProducto;
  String? nombreProducto;

  Estacion({
    this.numeroPistola,
    this.codigoProducto,
    this.nombreProducto,
  });

  factory Estacion.fromJson(Map<String, dynamic> json) {
    return Estacion(
      numeroPistola: Parse.parseDynamicToInt(json['numero_pistola']),
      codigoProducto: json['codigo_producto'],
      nombreProducto: json['nombre_producto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numero_pistola': numeroPistola,
      'codigo_producto': codigoProducto,
      'nombre_producto': nombreProducto,
    };
  }
}

class Surtidor {
  int idSurtidor;
  String nombreSurtidor;
  String lado;
  String user;
  String fecreg;
  Estacion estacion1;
  Estacion estacion2;
  Estacion estacion3;

  Surtidor({
    required this.idSurtidor,
    required this.nombreSurtidor,
    required this.lado,
    required this.user,
    required this.fecreg,
    required this.estacion1,
    required this.estacion2,
    required this.estacion3,
  });

  factory Surtidor.fromJson(Map<String, dynamic> json) {
    return Surtidor(
      idSurtidor: json['id_surtidor'],
      nombreSurtidor: json['nombre_surtidor'],
      lado: json['lado'],
      user: json['user'],
      fecreg: json['fecreg'],
      estacion1: Estacion.fromJson(json['estacion1']),
      estacion2: Estacion.fromJson(json['estacion2']),
      estacion3: Estacion.fromJson(json['estacion3']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_surtidor': idSurtidor,
      'nombre_surtidor': nombreSurtidor,
      'lado': lado,
      'user': user,
      'fecreg': fecreg,
      'estacion1': estacion1.toJson(),
      'estacion2': estacion2.toJson(),
      'estacion3': estacion3.toJson(),
    };
  }
}
