import 'package:neitorvet/features/clientes/domain/entities/usuario.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';

// class Surtidor {
//   int idSurtidor;
//   String nombreSurtidor;
//   String lado;
//   String user;
//   String fecreg;
//   Estacion? estacion1;
//   Estacion? estacion2;
//   Estacion? estacion3;

//   Surtidor({
//     required this.idSurtidor,
//     required this.nombreSurtidor,
//     required this.lado,
//     required this.user,
//     required this.fecreg,
//     required this.estacion1,
//     required this.estacion2,
//     required this.estacion3,
//   });

//   factory Surtidor.fromJson(Map<String, dynamic> json) {
//     return Surtidor(
//       idSurtidor: json['id_surtidor'],
//       nombreSurtidor: json['nombre_surtidor'],
//       lado: json['lado'],
//       user: json['user'],
//       fecreg: json['fecreg'],
//       estacion1: json['estacion1'] != null
//           ? Estacion.fromJson(json['estacion1'])
//           : null,
//       estacion2: json['estacion2'] != null
//           ? Estacion.fromJson(json['estacion2'])
//           : null,
//       estacion3: json['estacion3'] != null
//           ? Estacion.fromJson(json['estacion3'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id_surtidor': idSurtidor,
//       'nombre_surtidor': nombreSurtidor,
//       'lado': lado,
//       'user': user,
//       'fecreg': fecreg,
//       'estacion1': estacion1?.toJson(),
//       'estacion2': estacion2?.toJson(),
//       'estacion3': estacion3?.toJson(),
//     };
//   }
// }

class Surtidor {
  final int idSurtidor;
  final String nombreSurtidor;
  final String lado;
  final String user;
  final String fecreg;
  final Estacion? estacion1;
  final Estacion? estacion2;
  final Estacion? estacion3;
  final List<Usuario> usuarios;

  Surtidor({
    required this.idSurtidor,
    required this.nombreSurtidor,
    required this.lado,
    required this.user,
    required this.fecreg,
    required this.estacion1,
    required this.estacion2,
    required this.estacion3,
    required this.usuarios,
  });

  factory Surtidor.fromJson(Map<String, dynamic> json) => Surtidor(
        idSurtidor: json['id_surtidor'],
        nombreSurtidor: json['nombre_surtidor'],
        lado: json['lado'],
        user: json['user'],
        fecreg: json['fecreg'],
        estacion1: json['estacion1'] != null
            ? Estacion.fromJson(json['estacion1'])
            : null,
        estacion2: json['estacion2'] != null
            ? Estacion.fromJson(json['estacion2'])
            : null,
        estacion3: json['estacion3'] != null
            ? Estacion.fromJson(json['estacion3'])
            : null,
        usuarios: List<Usuario>.from(
            json["usuarios"].map((x) => Usuario.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id_surtidor": idSurtidor,
        "nombre_surtidor": nombreSurtidor,
        "lado": lado,
        "user": user,
        "fecreg": fecreg,
        "estacion1": estacion1?.toJson(),
        "estacion2": estacion2?.toJson(),
        "estacion3": estacion3?.toJson(),
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
      };
}

class Estacion {
  int? numeroPistola;
  String? codigoProducto;
  String? nombreProducto;
  String? numeroTanque;

  Estacion({
    this.numeroPistola,
    this.codigoProducto,
    this.nombreProducto,
    this.numeroTanque,
  });

  factory Estacion.fromJson(Map<String, dynamic> json) {
    return Estacion(
      numeroPistola: Parse.parseDynamicToInt(json['numero_pistola']),
      codigoProducto: json['codigo_producto'],
      nombreProducto: json['nombre_producto'],
      numeroTanque: json['numero_tanque'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numero_pistola': numeroPistola,
      'codigo_producto': codigoProducto,
      'nombre_producto': nombreProducto,
      'numero_tanque': numeroTanque,
    };
  }
}

