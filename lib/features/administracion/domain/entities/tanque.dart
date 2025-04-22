import 'package:neitorvet/features/shared/helpers/parse.dart';

class Tanque {
  final int tanque;
  final String productoCode;
  final String statusHex;
  final int statusInt;
  final bool deliveryInProgress;
  final bool leakTestInProgress;
  final bool invalidFuelHeightAlarm;
  final int numFields;
  final double volumen;
  final double tcVolumen;
  final double vacio;
  final double altura;
  final double agua;
  final double temperatura;
  final double volumenAgua;
  final String timestampDispositivo;

  Tanque({
    required this.tanque,
    required this.productoCode,
    required this.statusHex,
    required this.statusInt,
    required this.deliveryInProgress,
    required this.leakTestInProgress,
    required this.invalidFuelHeightAlarm,
    required this.numFields,
    required this.volumen,
    required this.tcVolumen,
    required this.vacio,
    required this.altura,
    required this.agua,
    required this.temperatura,
    required this.volumenAgua,
    required this.timestampDispositivo,
  });

  factory Tanque.fromJson(Map<String, dynamic> json) => Tanque(
        tanque: json["tanque"],
        productoCode: json["producto_code"],
        statusHex: json["status_hex"],
        statusInt: json["status_int"],
        deliveryInProgress: json["delivery_in_progress"],
        leakTestInProgress: json["leak_test_in_progress"],
        invalidFuelHeightAlarm: json["invalid_fuel_height_alarm"],
        numFields: json["num_fields"],
        volumen: Parse.parseDynamicToDouble(json["volumen"]),
        tcVolumen: Parse.parseDynamicToDouble(json["tc_volumen"]),
        vacio: Parse.parseDynamicToDouble(json["vacio"]),
        altura: Parse.parseDynamicToDouble(json["altura"]),
        agua: Parse.parseDynamicToDouble(json["agua"]),
        temperatura: Parse.parseDynamicToDouble(json["temperatura"]),
        volumenAgua: Parse.parseDynamicToDouble(json["volumen_agua"]),
        timestampDispositivo: json["timestamp_dispositivo"],
      );

  Map<String, dynamic> toJson() => {
        "tanque": tanque,
        "producto_code": productoCode,
        "status_hex": statusHex,
        "status_int": statusInt,
        "delivery_in_progress": deliveryInProgress,
        "leak_test_in_progress": leakTestInProgress,
        "invalid_fuel_height_alarm": invalidFuelHeightAlarm,
        "num_fields": numFields,
        "volumen": volumen,
        "tc_volumen": tcVolumen,
        "vacio": vacio,
        "altura": altura,
        "agua": agua,
        "temperatura": temperatura,
        "volumen_agua": volumenAgua,
        "timestamp_dispositivo": timestampDispositivo,
      };
}
