import 'package:neitorvet/features/shared/helpers/parse.dart';

class LiveVisualization {
  final int pico;
  final double valorActual;

  LiveVisualization({
    required this.pico,
    required this.valorActual,
  });

  factory LiveVisualization.fromJson(Map<String, dynamic> json) =>
      LiveVisualization(
        pico: json["pico"],
        valorActual: Parse.parseDynamicToDouble(json["valor_actual"]),
      );

  Map<String, dynamic> toJson() => {
        "pico": pico,
        "valor_actual": valorActual,
      };
}
