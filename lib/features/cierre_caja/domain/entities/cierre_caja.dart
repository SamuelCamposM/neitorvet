import 'dart:convert';

import 'package:neitorvet/features/shared/helpers/parse.dart';
import 'package:neitorvet/features/shared/infrastructure/inputs/generic_required_input_number.dart';
import 'package:neitorvet/features/shared/shared.dart';

class CierreCaja {
  final int cajaId;
  final double cajaMonto;
  final String cajaAutorizacion;
  final String cajaCredito;
  final String cajaDetalle;
  final String cajaEgreso;
  final String cajaEmpresa;
  final String cajaEstado;
  final String cajaFecha;
  final String cajaFecReg;
  final String cajaIdVenta;
  final String cajaIngreso;
  final String cajaNumero;
  final String cajaProcedencia;
  final String cajaTipoCaja;
  final String cajaTipoDocumento;
  final String cajaUser;
  final String todos;

  CierreCaja({
    required this.cajaId,
    required this.cajaIdVenta,
    required this.cajaNumero,
    required this.cajaFecha,
    required this.cajaDetalle,
    required this.cajaIngreso,
    required this.cajaEgreso,
    required this.cajaCredito,
    required this.cajaMonto,
    required this.cajaTipoCaja,
    required this.cajaTipoDocumento,
    required this.cajaEstado,
    required this.cajaProcedencia,
    required this.cajaAutorizacion,
    required this.cajaEmpresa,
    required this.cajaUser,
    required this.cajaFecReg,
    required this.todos,
  });

  factory CierreCaja.fromJson(Map<String, dynamic> json) => CierreCaja(
        cajaId: json["cajaId"],
        cajaIdVenta: json["cajaIdVenta"],
        cajaNumero: json["cajaNumero"],
        cajaFecha: json["cajaFecha"],
        cajaDetalle: json["cajaDetalle"],
        cajaIngreso: json["cajaIngreso"],
        cajaEgreso: json["cajaEgreso"],
        cajaCredito: json["cajaCredito"],
        cajaMonto: Parse.parseDynamicToDouble(json["cajaMonto"]),
        cajaTipoCaja: json["cajaTipoCaja"],
        cajaTipoDocumento: json["cajaTipoDocumento"],
        cajaEstado: json["cajaEstado"],
        cajaProcedencia: json["cajaProcedencia"],
        cajaAutorizacion: json["cajaAutorizacion"],
        cajaEmpresa: json["cajaEmpresa"],
        cajaUser: json["cajaUser"],
        cajaFecReg: json["cajaFecReg"],
        todos: json["Todos"],
      );

  Map<String, dynamic> toJson() => {
        "cajaId": cajaId,
        "cajaIdVenta": cajaIdVenta,
        "cajaNumero": cajaNumero,
        "cajaFecha": cajaFecha,
        "cajaDetalle": cajaDetalle,
        "cajaIngreso": cajaIngreso,
        "cajaEgreso": cajaEgreso,
        "cajaCredito": cajaCredito,
        "cajaMonto": cajaMonto,
        "cajaTipoCaja": cajaTipoCaja,
        "cajaTipoDocumento": cajaTipoDocumento,
        "cajaEstado": cajaEstado,
        "cajaProcedencia": cajaProcedencia,
        "cajaAutorizacion": cajaAutorizacion,
        "cajaEmpresa": cajaEmpresa,
        "cajaUser": cajaUser,
        "cajaFecReg": cajaFecReg,
        "Todos": todos,
      };
}

class CierreCajaForm extends CierreCaja {
  // final GenericRequiredInput perDocTipoInput;
  // final NumDoc perDocNumeroInput;
  // final GenericRequiredInput perNombreInput;
  // final GenericRequiredInput perDireccionInput;
  // final GenericRequiredListStr perEmailInput;
  // final GenericRequiredListStr perOtrosInput;
  final GenericRequiredInput cajaTipoCajaInput;
  final GenericRequiredInput cajaTipoDocumentoInput;
  final GenericRequiredInputNumber cajaMontoInput;
  final GenericRequiredInput cajaDetalleInput;
  CierreCajaForm({
    required this.cajaDetalleInput,
    required this.cajaMontoInput,
    required this.cajaTipoCajaInput,
    required this.cajaTipoDocumentoInput,
    //* REQUIRED
    required super.cajaDetalle,
    required super.cajaMonto,
    required super.cajaTipoCaja,
    required super.cajaTipoDocumento,
    required super.cajaId,
    required super.cajaIdVenta,
    required super.cajaNumero,
    required super.cajaFecha,
    required super.cajaIngreso,
    required super.cajaEgreso,
    required super.cajaCredito,
    required super.cajaEstado,
    required super.cajaProcedencia,
    required super.cajaAutorizacion,
    required super.cajaEmpresa,
    required super.cajaUser,
    required super.cajaFecReg,
    required super.todos,
  });

  CierreCajaForm copyWith({
    //* REQUERIDOS
    String? cajaDetalle,
    double? cajaMonto,
    String? cajaTipoCaja,
    String? cajaTipoDocumento,
    //* CLIENTE
    int? cajaId,
    String? cajaIdVenta,
    String? cajaNumero,
    String? cajaFecha,
    String? cajaIngreso,
    String? cajaEgreso,
    String? cajaCredito,
    String? cajaEstado,
    String? cajaProcedencia,
    String? cajaAutorizacion,
    String? cajaEmpresa,
    String? cajaUser,
    String? cajaFecReg,
    String? todos,
  }) {
    return CierreCajaForm(
      //*REQUERIDOS
      cajaDetalleInput: cajaDetalle != null
          ? GenericRequiredInput.dirty(cajaDetalle)
          : cajaDetalleInput,
      cajaMontoInput: cajaMonto != null
          ? GenericRequiredInputNumber.dirty(cajaMonto)
          : cajaMontoInput,
      cajaTipoCajaInput: cajaTipoCaja != null
          ? GenericRequiredInput.dirty(cajaTipoCaja)
          : cajaTipoCajaInput,
      cajaTipoDocumentoInput: cajaTipoDocumento != null
          ? GenericRequiredInput.dirty(cajaTipoDocumento)
          : cajaTipoDocumentoInput,

      //*SUS EQUIVALENTES
      cajaDetalle: cajaDetalle ?? this.cajaDetalle,
      cajaMonto: cajaMonto ?? this.cajaMonto,
      cajaTipoCaja: cajaTipoCaja ?? this.cajaTipoCaja,
      cajaTipoDocumento: cajaTipoDocumento ?? this.cajaTipoDocumento,
      //* LO DEMAS
      cajaId: cajaId ?? this.cajaId,
      cajaIdVenta: cajaIdVenta ?? this.cajaIdVenta,
      cajaNumero: cajaNumero ?? this.cajaNumero,
      cajaFecha: cajaFecha ?? this.cajaFecha,
      cajaIngreso: cajaIngreso ?? this.cajaIngreso,
      cajaEgreso: cajaEgreso ?? this.cajaEgreso,
      cajaCredito: cajaCredito ?? this.cajaCredito,
      cajaEstado: cajaEstado ?? this.cajaEstado,
      cajaProcedencia: cajaProcedencia ?? this.cajaProcedencia,
      cajaAutorizacion: cajaAutorizacion ?? this.cajaAutorizacion,
      cajaEmpresa: cajaEmpresa ?? this.cajaEmpresa,
      cajaUser: cajaUser ?? this.cajaUser,
      cajaFecReg: cajaFecReg ?? this.cajaFecReg,
      todos: todos ?? this.todos,
    );
  }

  //CONVIERTE A CIERRE CAJA
  CierreCaja toCierreCaja() => CierreCaja(
        cajaId: cajaId,
        cajaIdVenta: cajaIdVenta,
        cajaNumero: cajaNumero,
        cajaFecha: cajaFecha,
        cajaDetalle: cajaDetalle,
        cajaIngreso: cajaIngreso,
        cajaEgreso: cajaEgreso,
        cajaCredito: cajaCredito,
        cajaMonto: cajaMonto,
        cajaTipoCaja: cajaTipoCaja,
        cajaTipoDocumento: cajaTipoDocumento,
        cajaEstado: cajaEstado,
        cajaProcedencia: cajaProcedencia,
        cajaAutorizacion: cajaAutorizacion,
        cajaEmpresa: cajaEmpresa,
        cajaUser: cajaUser,
        cajaFecReg: cajaFecReg,
        todos: todos,
      );

  factory CierreCajaForm.fromCierreCaja(CierreCaja cierreCaja) {
    return cierreCaja.cajaId == 0
        ? CierreCajaForm(
            cajaDetalleInput: const GenericRequiredInput.pure(),
            cajaMontoInput: const GenericRequiredInputNumber.pure(),
            cajaTipoCajaInput: const GenericRequiredInput.pure(),
            cajaTipoDocumentoInput: const GenericRequiredInput.pure(),
            cajaDetalle: cierreCaja.cajaDetalle,
            cajaMonto: cierreCaja.cajaMonto,
            cajaTipoCaja: cierreCaja.cajaTipoCaja,
            cajaTipoDocumento: cierreCaja.cajaTipoDocumento,
            cajaId: cierreCaja.cajaId,
            cajaIdVenta: cierreCaja.cajaIdVenta,
            cajaNumero: cierreCaja.cajaNumero,
            cajaFecha: cierreCaja.cajaFecha,
            cajaIngreso: cierreCaja.cajaIngreso,
            cajaEgreso: cierreCaja.cajaEgreso,
            cajaCredito: cierreCaja.cajaCredito,
            cajaEstado: cierreCaja.cajaEstado,
            cajaProcedencia: cierreCaja.cajaProcedencia,
            cajaAutorizacion: cierreCaja.cajaAutorizacion,
            cajaEmpresa: cierreCaja.cajaEmpresa,
            cajaUser: cierreCaja.cajaUser,
            cajaFecReg: cierreCaja.cajaFecReg,
            todos: cierreCaja.todos,
          )
        : CierreCajaForm(
            cajaDetalleInput:
                GenericRequiredInput.dirty(cierreCaja.cajaDetalle),
            cajaMontoInput:
                GenericRequiredInputNumber.dirty(cierreCaja.cajaMonto),
            cajaTipoCajaInput:
                GenericRequiredInput.dirty(cierreCaja.cajaTipoCaja),
            cajaTipoDocumentoInput:
                GenericRequiredInput.dirty(cierreCaja.cajaTipoDocumento),
            cajaDetalle: cierreCaja.cajaDetalle,
            cajaMonto: cierreCaja.cajaMonto,
            cajaTipoCaja: cierreCaja.cajaTipoCaja,
            cajaTipoDocumento: cierreCaja.cajaTipoDocumento,
            cajaId: cierreCaja.cajaId,
            cajaIdVenta: cierreCaja.cajaIdVenta,
            cajaNumero: cierreCaja.cajaNumero,
            cajaFecha: cierreCaja.cajaFecha,
            cajaIngreso: cierreCaja.cajaIngreso,
            cajaEgreso: cierreCaja.cajaEgreso,
            cajaCredito: cierreCaja.cajaCredito,
            cajaEstado: cierreCaja.cajaEstado,
            cajaProcedencia: cierreCaja.cajaProcedencia,
            cajaAutorizacion: cierreCaja.cajaAutorizacion,
            cajaEmpresa: cierreCaja.cajaEmpresa,
            cajaUser: cierreCaja.cajaUser,
            cajaFecReg: cierreCaja.cajaFecReg,
            todos: cierreCaja.todos,
          );
  }
}

class BusquedaCierreCaja {
  final String cajaFecha1;
  final String cajaFecha2;

  const BusquedaCierreCaja({
    this.cajaFecha1 = '',
    this.cajaFecha2 = '',
  });

  factory BusquedaCierreCaja.fromJson(Map<String, dynamic> json) =>
      BusquedaCierreCaja(
        cajaFecha1: json["cajaFecha1"],
        cajaFecha2: json["cajaFecha2"],
      );

  Map<String, dynamic> toJson() => {
        "cajaFecha1": cajaFecha1,
        "cajaFecha2": cajaFecha2,
      };

  BusquedaCierreCaja copyWith({
    String? cajaFecha1,
    String? cajaFecha2,
  }) {
    return BusquedaCierreCaja(
      cajaFecha1: cajaFecha1 ?? this.cajaFecha1,
      cajaFecha2: cajaFecha2 ?? this.cajaFecha2,
    );
  }

  bool isSearching() {
    return cajaFecha1.isNotEmpty || cajaFecha2.isNotEmpty;
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
