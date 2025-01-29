// To parse this JSON data, do
//
//     final bodega = bodegaFromJson(jsonString);

class Bodega {
  final String estado;
  final String nomBodega;
  final String stock;
  final String maximo;
  final String minimo;
  final int bodId;

  Bodega({
    required this.estado,
    required this.nomBodega,
    required this.stock,
    required this.maximo,
    required this.minimo,
    required this.bodId,
  });

  factory Bodega.fromJson(Map<String, dynamic> json) => Bodega(
        estado: json["estado"],
        nomBodega: json["nomBodega"],
        stock: json["stock"],
        maximo: json["maximo"],
        minimo: json["minimo"],
        bodId: json["bodId"],
      );

  Map<String, dynamic> toJson() => {
        "estado": estado,
        "nomBodega": nomBodega,
        "stock": stock,
        "maximo": maximo,
        "minimo": minimo,
        "bodId": bodId,
      };
}
