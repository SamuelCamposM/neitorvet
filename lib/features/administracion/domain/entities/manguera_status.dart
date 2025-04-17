/// Representa los diferentes estados de una manguera.
enum Datum {
  /// Libre
  L,

  /// Bloqueado
  B,

  /// Abasteciendo
  A,

  /// En Espera
  E,

  /// Pronto para abastecer
  P,

  /// En Falla
  F,

  /// FINALIZAR EL SERVICIO
  C,

  /// Ocupado (otro pico del surtidor activo)
  hash, // Representa el símbolo `#`

  /// Error genérico
  exclamation // Representa el símbolo `!`
}

final datumValues = EnumValues({
  "L": Datum.L,
  "B": Datum.B,
  "A": Datum.A,
  "E": Datum.E,
  "P": Datum.P,
  "F": Datum.F,
  "C": Datum.C,
  "#": Datum.hash,
  "!": Datum.exclamation,
});

class MangueraStatus {
  final Map<String, Datum> data;

  MangueraStatus({
    required this.data,
  });

  factory MangueraStatus.fromJson(Map<String, dynamic> json) => MangueraStatus(
        data: Map.from(json["data"])
            .map((k, v) => MapEntry<String, Datum>(k, datumValues.map[v]!)),
      );

  Map<String, dynamic> toJson() => {
        "data": Map.from(data).map(
            (k, v) => MapEntry<String, dynamic>(k, datumValues.reverse[v])),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}