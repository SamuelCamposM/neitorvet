class Parse {
  static double parseDynamicToDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      return value.toDouble();
    } else {
      return 0.0;
    }
  }

  static int parseDynamicToInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else {
      return 0;
    }
  }

  static List<String> parseDynamicToListString(dynamic value) {
    if (value is String) {
      return [value];
    } else if (value is List) {
      return value.cast<String>();
    } else {
      return [];
    }
  }

  static List<int> parseDynamicToListInt(dynamic value) {
    if (value is int) {
      return [value];
    } else if (value is List) {
      return value.map((e) {
        if (e is int) {
          return e;
        } else if (e is String) {
          return int.tryParse(e) ?? 0;
        } else {
          return 0;
        }
      }).toList();
    } else {
      return [];
    }
  }
}
