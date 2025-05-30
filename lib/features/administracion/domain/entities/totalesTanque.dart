import 'package:neitorvet/features/shared/helpers/parse.dart';

class Totalestanque {
  final List<Total> totalDiario;
  final List<Total> totalSemanal;
  final List<Total> totalMensual;
  final List<Total> totalAnual;

  Totalestanque({
    required this.totalDiario,
    required this.totalSemanal,
    required this.totalMensual,
    required this.totalAnual,
  });

  factory Totalestanque.fromJson(Map<String, dynamic> json) => Totalestanque(
        totalDiario: List<Total>.from(
            json["total_diario"].map((x) => Total.fromJson(x))),
        totalSemanal: List<Total>.from(
            json["total_semanal"].map((x) => Total.fromJson(x))),
        totalMensual: List<Total>.from(
            json["total_mensual"].map((x) => Total.fromJson(x))),
        totalAnual:
            List<Total>.from(json["total_anual"].map((x) => Total.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_diario": List<dynamic>.from(totalDiario.map((x) => x.toJson())),
        "total_semanal":
            List<dynamic>.from(totalSemanal.map((x) => x.toJson())),
        "total_mensual":
            List<dynamic>.from(totalMensual.map((x) => x.toJson())),
        "total_anual": List<dynamic>.from(totalAnual.map((x) => x.toJson())),
      };
}

class Total {
  final double valorTotal;
  final double volumenTotal;
  final String codigoCombustible;

  Total({
    required this.valorTotal,
    required this.volumenTotal,
    required this.codigoCombustible,
  });

  factory Total.fromJson(Map<String, dynamic> json) => Total(
        valorTotal: Parse.parseDynamicToDouble(json["valor_total"]),
        volumenTotal: Parse.parseDynamicToDouble(json["volumen_total"]),
        codigoCombustible: json["codigoCombustible"],
      );

  factory Total.defaultWithCodigo(String codigoCombustible) => Total(
        valorTotal: 0,
        volumenTotal: 0,
        codigoCombustible: codigoCombustible,
      );

  Map<String, dynamic> toJson() => {
        "valor_total": valorTotal,
        "volumen_total": volumenTotal,
        "codigoCombustible": codigoCombustible,
      };
}
