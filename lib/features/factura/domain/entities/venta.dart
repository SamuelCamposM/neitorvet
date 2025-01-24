// To parse this JSON data, do
//
//     final venta = ventaFromJson(jsonString);

import 'package:neitorvet/features/factura/domain/entities/producto.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';

class Venta {
  final int venId;
  final double venCostoProduccion;
  final double venDescuento;
  final double venSubTotal;
  final double venSubtotal0;
  final double venSubTotal12;
  final double venTotal;
  final double venTotalIva;
  final int venIdCliente;
  final int? venEmpIva;
  final List<Producto> venProductos;
  final List<String> venCeluCliente;
  final List<String> venEmailCliente;
  final String fechaSustentoFactura;
  final String venAbono;
  final String venAutorizacion;
  final String venDescPorcentaje;
  final String venDias;
  final String venDirCliente;
  final String venEmpAgenteRetencion;
  final String venEmpComercial;
  final String venEmpContribuyenteEspecial;
  final String venEmpDireccion;
  final String venEmpEmail;
  final String venEmpLeyenda;
  final String venEmpNombre;
  final String venEmpObligado;
  final String venEmpRegimen;
  final String venEmpresa;
  final String venEmpRuc;
  final String venEmpTelefono;
  final String venEnvio;
  final String venErrorAutorizacion;
  final String venEstado;
  final String venFacturaCredito;
  final String venFechaAutorizacion;
  final String venFechaFactura;
  final String venFecReg;
  final String venFormaPago;
  final String venNomCliente;
  final String venNumero;
  final String venNumFactura;
  final String venNumFacturaAnterior;
  final String venObservacion;
  final String venOption;
  final String venOtros;
  final String venOtrosDetalles;
  final String venRucCliente;
  final String venTelfCliente;
  final String venTipoDocuCliente;
  final String venTipoDocumento;
  final String venTotalRetencion;
  final String venUser;

  Venta({
    required this.venId,
    required this.venOtros,
    required this.venFecReg,
    required this.venOption,
    required this.venTipoDocumento,
    required this.venIdCliente,
    required this.venRucCliente,
    required this.venTipoDocuCliente,
    required this.venNomCliente,
    required this.venEmailCliente,
    required this.venTelfCliente,
    required this.venCeluCliente,
    required this.venDirCliente,
    required this.venEmpRuc,
    required this.venEmpNombre,
    required this.venEmpComercial,
    required this.venEmpDireccion,
    required this.venEmpTelefono,
    required this.venEmpEmail,
    required this.venEmpObligado,
    required this.venEmpRegimen,
    required this.venFormaPago,
    required this.venNumero,
    required this.venFacturaCredito,
    required this.venDias,
    required this.venAbono,
    required this.venDescPorcentaje,
    required this.venOtrosDetalles,
    required this.venObservacion,
    required this.venSubTotal12,
    required this.venSubtotal0,
    required this.venDescuento,
    required this.venSubTotal,
    required this.venTotalIva,
    required this.venTotal,
    required this.venCostoProduccion,
    required this.venUser,
    required this.venFechaFactura,
    required this.venNumFactura,
    required this.venNumFacturaAnterior,
    required this.venAutorizacion,
    required this.venFechaAutorizacion,
    required this.venErrorAutorizacion,
    required this.venEstado,
    required this.venEnvio,
    required this.fechaSustentoFactura,
    required this.venTotalRetencion,
    required this.venEmpresa,
    required this.venProductos,
    required this.venEmpAgenteRetencion,
    required this.venEmpContribuyenteEspecial,
    required this.venEmpLeyenda,
    required this.venEmpIva,
  });

  factory Venta.fromJson(Map<String, dynamic> json) => Venta(
        venId: json["venId"],
        venOtros: json["venOtros"],
        venFecReg: json["venFecReg"],
        venOption: json["venOption"],
        venTipoDocumento: json["venTipoDocumento"],
        venIdCliente: Parse.parseDynamicToInt(json["venIdCliente"]),
        venRucCliente: json["venRucCliente"],
        venTipoDocuCliente: json["venTipoDocuCliente"],
        venNomCliente: json["venNomCliente"],
        venEmailCliente:
            List<String>.from(json["venEmailCliente"].map((x) => x)),
        venTelfCliente: json["venTelfCliente"],
        venCeluCliente: List<String>.from(
            Parse.parseDynamicToListString(json["venCeluCliente"])
                .map((x) => x)),
        venDirCliente: json["venDirCliente"],
        venEmpRuc: json["venEmpRuc"],
        venEmpNombre: json["venEmpNombre"],
        venEmpComercial: json["venEmpComercial"],
        venEmpDireccion: json["venEmpDireccion"],
        venEmpTelefono: json["venEmpTelefono"],
        venEmpEmail: json["venEmpEmail"],
        venEmpObligado: json["venEmpObligado"],
        venEmpRegimen: json["venEmpRegimen"],
        venFormaPago: json["venFormaPago"],
        venNumero: json["venNumero"],
        venFacturaCredito: json["venFacturaCredito"],
        venDias: json["venDias"],
        venAbono: json["venAbono"],
        venDescPorcentaje: json["venDescPorcentaje"],
        venOtrosDetalles: json["venOtrosDetalles"],
        venObservacion: json["venObservacion"],
        venSubTotal12: Parse.parseDynamicToDouble(json["venSubTotal12"]),
        venSubtotal0: Parse.parseDynamicToDouble(json["venSubtotal0"]),
        venDescuento: Parse.parseDynamicToDouble(json["venDescuento"]),
        venSubTotal: Parse.parseDynamicToDouble(json["venSubTotal"]),
        venTotalIva: Parse.parseDynamicToDouble(json["venTotalIva"]),
        venTotal: Parse.parseDynamicToDouble(json["venTotal"]),
        venCostoProduccion:
            Parse.parseDynamicToDouble(json["venCostoProduccion"]),
        venUser: json["venUser"],
        venFechaFactura: json["venFechaFactura"],
        venNumFactura: json["venNumFactura"],
        venNumFacturaAnterior: json["venNumFacturaAnterior"],
        venAutorizacion: json["venAutorizacion"],
        venFechaAutorizacion: json["venFechaAutorizacion"],
        venErrorAutorizacion: json["venErrorAutorizacion"],
        venEstado: json["venEstado"],
        venEnvio: json["venEnvio"],
        fechaSustentoFactura: json["fechaSustentoFactura"],
        venTotalRetencion: json["venTotalRetencion"],
        venEmpresa: json["venEmpresa"],
        venProductos: List<Producto>.from(
            json["venProductos"].map((x) => Producto.fromJson(x))),
        venEmpAgenteRetencion: json["venEmpAgenteRetencion"],
        venEmpContribuyenteEspecial: json["venEmpContribuyenteEspecial"],
        venEmpLeyenda: json["venEmpLeyenda"],
        venEmpIva: json["venEmpIva"],
      );

  Map<String, dynamic> toJson() => {
        "venId": venId,
        "venOtros": venOtros,
        "venFecReg": venFecReg,
        "venOption": venOption,
        "venTipoDocumento": venTipoDocumento,
        "venIdCliente": venIdCliente,
        "venRucCliente": venRucCliente,
        "venTipoDocuCliente": venTipoDocuCliente,
        "venNomCliente": venNomCliente,
        "venEmailCliente": List<dynamic>.from(venEmailCliente.map((x) => x)),
        "venTelfCliente": venTelfCliente,
        "venCeluCliente": List<dynamic>.from(venCeluCliente.map((x) => x)),
        "venDirCliente": venDirCliente,
        "venEmpRuc": venEmpRuc,
        "venEmpNombre": venEmpNombre,
        "venEmpComercial": venEmpComercial,
        "venEmpDireccion": venEmpDireccion,
        "venEmpTelefono": venEmpTelefono,
        "venEmpEmail": venEmpEmail,
        "venEmpObligado": venEmpObligado,
        "venEmpRegimen": venEmpRegimen,
        "venFormaPago": venFormaPago,
        "venNumero": venNumero,
        "venFacturaCredito": venFacturaCredito,
        "venDias": venDias,
        "venAbono": venAbono,
        "venDescPorcentaje": venDescPorcentaje,
        "venOtrosDetalles": venOtrosDetalles,
        "venObservacion": venObservacion,
        "venSubTotal12": venSubTotal12,
        "venSubtotal0": venSubtotal0,
        "venDescuento": venDescuento,
        "venSubTotal": venSubTotal,
        "venTotalIva": venTotalIva,
        "venTotal": venTotal,
        "venCostoProduccion": venCostoProduccion,
        "venUser": venUser,
        "venFechaFactura": venFechaFactura,
        "venNumFactura": venNumFactura,
        "venNumFacturaAnterior": venNumFacturaAnterior,
        "venAutorizacion": venAutorizacion,
        "venFechaAutorizacion": venFechaAutorizacion,
        "venErrorAutorizacion": venErrorAutorizacion,
        "venEstado": venEstado,
        "venEnvio": venEnvio,
        "fechaSustentoFactura": fechaSustentoFactura,
        "venTotalRetencion": venTotalRetencion,
        "venEmpresa": venEmpresa,
        "venProductos": List<dynamic>.from(venProductos.map((x) => x.toJson())),
        "venEmpAgenteRetencion": venEmpAgenteRetencion,
        "venEmpContribuyenteEspecial": venEmpContribuyenteEspecial,
        "venEmpLeyenda": venEmpLeyenda,
        "venEmpIva": venEmpIva,
      };
}
