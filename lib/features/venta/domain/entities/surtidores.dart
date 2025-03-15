// To parse this JSON data, do
//
//     final surtidores = surtidoresFromJson(jsonString);

import 'dart:convert';

Surtidores surtidoresFromJson(String str) =>
    Surtidores.fromJson(json.decode(str));

String surtidoresToJson(Surtidores data) => json.encode(data.toJson());

class Surtidores {
  int? id;
  String? nombre;
  String? imagen;
  List<String>? lado;

  Surtidores({
    this.id,
    this.nombre,
    this.imagen,
    this.lado,
  });

  Surtidores copyWith({
    int? id,
    String? nombre,
    String? imagen,
    List<String>? lado,
  }) =>
      Surtidores(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        imagen: imagen ?? this.imagen,
        lado: lado ?? this.lado,
      );

  factory Surtidores.fromJson(Map<String, dynamic> json) => Surtidores(
        id: json["id"],
        nombre: json["nombre"],
        imagen: json["imagen"],
        lado: json["lado"] == null
            ? []
            : List<String>.from(json["lado"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "imagen": imagen,
        "lado": lado == null ? [] : List<dynamic>.from(lado!.map((x) => x)),
      };
}
