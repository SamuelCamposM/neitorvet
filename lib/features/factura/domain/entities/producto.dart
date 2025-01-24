// To parse this JSON data, do
//
//     final producto = productoFromJson(jsonString);

import 'package:neitorvet/features/shared/helpers/parse.dart';

class Producto {
  final String cantidad;
  final String codigo;
  final String descripcion;
  final String valUnitarioInterno;
  final double valorUnitario;
  final int recargoPorcentaje;
  final int recargo;
  final String descPorcentaje;
  final int descuento;
  final double precioSubTotalProducto;
  final double valorIva;
  final double costoProduccion;
  final String llevaIva;
  final String incluyeIva;

  Producto({
    required this.cantidad,
    required this.codigo,
    required this.descripcion,
    required this.valUnitarioInterno,
    required this.valorUnitario,
    required this.recargoPorcentaje,
    required this.recargo,
    required this.descPorcentaje,
    required this.descuento,
    required this.precioSubTotalProducto,
    required this.valorIva,
    required this.costoProduccion,
    required this.llevaIva,
    required this.incluyeIva,
  });

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        cantidad: json["cantidad"],
        codigo: json["codigo"],
        descripcion: json["descripcion"],
        valUnitarioInterno: json["valUnitarioInterno"],
        valorUnitario: Parse.parseDynamicToDouble(json["valorUnitario"]),
        recargoPorcentaje: Parse.parseDynamicToInt(json["recargoPorcentaje"]),
        recargo: Parse.parseDynamicToInt(json["recargo"]),
        descPorcentaje: json["descPorcentaje"],
        descuento: Parse.parseDynamicToInt(json["descuento"]),
        precioSubTotalProducto:
            Parse.parseDynamicToDouble(json["precioSubTotalProducto"]),
        valorIva: Parse.parseDynamicToDouble(json["valorIva"]),
        costoProduccion: Parse.parseDynamicToDouble(json["costoProduccion"]),
        llevaIva: json["llevaIva"],
        incluyeIva: json["incluyeIva"],
      );

  Map<String, dynamic> toJson() => {
        "cantidad": cantidad,
        "codigo": codigo,
        "descripcion": descripcion,
        "valUnitarioInterno": valUnitarioInterno,
        "valorUnitario": valorUnitario,
        "recargoPorcentaje": recargoPorcentaje,
        "recargo": recargo,
        "descPorcentaje": descPorcentaje,
        "descuento": descuento,
        "precioSubTotalProducto": precioSubTotalProducto,
        "valorIva": valorIva,
        "costoProduccion": costoProduccion,
        "llevaIva": llevaIva,
        "incluyeIva": incluyeIva,
      };
}
