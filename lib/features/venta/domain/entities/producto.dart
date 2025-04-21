import 'package:neitorvet/features/shared/helpers/parse.dart';

class Producto {
  final double cantidad;
  final String codigo;
  final String descripcion;
  final double valUnitarioInterno;
  final double valorUnitario;
  final double recargoPorcentaje;
  final double recargo;
  final double descPorcentaje;
  final double descuento;
  final double precioSubTotalProducto;
  final double valorIva;
  final double costoProduccion;
  final String llevaIva;
  final String incluyeIva;

  const Producto({
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
  Producto copyWith({
    double? cantidad,
    String? codigo,
    String? descripcion,
    double? valUnitarioInterno,
    double? valorUnitario,
    double? recargoPorcentaje,
    double? recargo,
    double? descPorcentaje,
    double? descuento,
    double? precioSubTotalProducto,
    double? valorIva,
    double? costoProduccion,
    String? llevaIva,
    String? incluyeIva,
  }) {
    return Producto(
      cantidad: cantidad ?? this.cantidad,
      codigo: codigo ?? this.codigo,
      descripcion: descripcion ?? this.descripcion,
      valUnitarioInterno: valUnitarioInterno ?? this.valUnitarioInterno,
      valorUnitario: valorUnitario ?? this.valorUnitario,
      recargoPorcentaje: recargoPorcentaje ?? this.recargoPorcentaje,
      recargo: recargo ?? this.recargo,
      descPorcentaje: descPorcentaje ?? this.descPorcentaje,
      descuento: descuento ?? this.descuento,
      precioSubTotalProducto:
          precioSubTotalProducto ?? this.precioSubTotalProducto,
      valorIva: valorIva ?? this.valorIva,
      costoProduccion: costoProduccion ?? this.costoProduccion,
      llevaIva: llevaIva ?? this.llevaIva,
      incluyeIva: incluyeIva ?? this.incluyeIva,
    );
  }

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        cantidad: Parse.parseDynamicToDouble(json["cantidad"]),
        codigo: json["codigo"],
        descripcion: json["descripcion"],
        valUnitarioInterno:
            Parse.parseDynamicToDouble(json["valUnitarioInterno"]),
        valorUnitario: Parse.parseDynamicToDouble(json["valorUnitario"]),
        recargoPorcentaje:
            Parse.parseDynamicToDouble(json["recargoPorcentaje"]),
        recargo: Parse.parseDynamicToDouble(json["recargo"]),
        descPorcentaje: Parse.parseDynamicToDouble(json["descPorcentaje"]),
        descuento: Parse.parseDynamicToDouble(json["descuento"]),
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

  double cincoDecimales(double numero) {
    return double.parse(numero.toStringAsFixed(7));
  }

  double tresDecimales(double numero) {
    return double.parse(numero.toStringAsFixed(2));
  }

  Producto calcularProducto({
    required double formPorcentaje,
    required double iva,
  }) {
    try {
      double resvalorUnitario = 0;

      if (llevaIva == "SI" && incluyeIva == "SI") {
        resvalorUnitario = (valUnitarioInterno / (1 + iva / 100));
      } else {
        resvalorUnitario = valUnitarioInterno;
      }

      double resdescuento = (resvalorUnitario * (descPorcentaje / 100));

      double resprecioUnitarioConDescuento = (resvalorUnitario - resdescuento);

      double resprecioSubTotalProducto =
          (resprecioUnitarioConDescuento * cantidad);

      double resrecargo = (resprecioSubTotalProducto * (formPorcentaje / 100));

      resprecioSubTotalProducto = (resprecioSubTotalProducto + resrecargo);

      double resvalorIva = 0;
      if (llevaIva == "SI") {
        resvalorIva = (resprecioSubTotalProducto * (iva / 100));
      }
      // print({
      //   'valorUnitario': dosDecimales(resvalorUnitario),
      //   'descuento': dosDecimales(resdescuento),
      //   'precioSubTotalProducto': dosDecimales(resprecioSubTotalProducto),
      //   'valorIva': dosDecimales(resvalorIva),
      //   'recargoPorcentaje': dosDecimales(formPorcentaje),
      //   'costoProduccion': dosDecimales(resvalorUnitario),
      //   'recargo': dosDecimales(resrecargo),
      // });

      return Producto(
        cantidad: double.parse(cantidad.toStringAsFixed(3)),
        codigo: codigo,
        descripcion: descripcion,
        valUnitarioInterno: valUnitarioInterno,
        valorUnitario: tresDecimales(resvalorUnitario),
        recargoPorcentaje: tresDecimales(formPorcentaje),
        recargo: tresDecimales(resrecargo),
        descPorcentaje: descPorcentaje,
        descuento: tresDecimales(resdescuento),
        precioSubTotalProducto: tresDecimales(resprecioSubTotalProducto),
        valorIva: tresDecimales(resvalorIva),
        costoProduccion: tresDecimales(resvalorUnitario),
        llevaIva: llevaIva,
        incluyeIva: incluyeIva,
      );
    } catch (error) {
      return this;
    }
  }
}
