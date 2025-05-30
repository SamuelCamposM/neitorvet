// To parse this JSON data, do
//
//     final venta = ventaFromJson(jsonString);

import 'dart:convert';

import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/venta/domain/entities/abastecimiento.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';
import 'package:neitorvet/features/venta/infrastructure/input/min_value_cliente.dart';
import 'package:neitorvet/features/venta/infrastructure/input/productos.dart';

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
  final double venDescPorcentaje;
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
  final String? venOtros;
  final String venOtrosDetalles;
  final String venRucCliente;
  final String venTelfCliente;
  final String venTipoDocuCliente;
  final String venTipoDocumento;
  final String optionDocumento;
  final String venTotalRetencion;
  final String venUser;
  final int? idAbastecimiento;
  final double? totInicio;
  final double? totFinal;
  final Abastecimiento? abastecimiento;
  final String manguera;
  Venta({
    this.venOtros,
    required this.venId,
    required this.venFecReg,
    required this.venOption,
    required this.venTipoDocumento,
    this.optionDocumento = '',
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
    this.idAbastecimiento,
    this.totInicio,
    this.totFinal,
    this.abastecimiento,
    required this.manguera,
  });
  static Venta defaultVenta() {
    return Venta(
      venId: 0,
      venIdCliente: 1,
      venCostoProduccion: 0,
      venDescPorcentaje: 0,
      venDescuento: 0,
      venEmpIva: 0,
      venSubTotal: 0,
      venSubtotal0: 0,
      venSubTotal12: 0,
      venTotal: 0,
      venTotalIva: 0,
      venUser: "",
      fechaSustentoFactura: "",
      venAbono: "0",
      venAutorizacion: "0",
      venDias: "0",
      venDirCliente: "s/n",
      venEmpAgenteRetencion: "",
      venEmpComercial: "",
      venEmpContribuyenteEspecial: '',
      venEmpDireccion: "",
      venEmpEmail: "",
      venEmpLeyenda: "",
      venEmpNombre: "",
      venEmpObligado: "",
      venEmpRegimen: "",
      venEmpresa: "",
      venEmpRuc: "",
      venEmpTelefono: "",
      venEnvio: "NO",
      venErrorAutorizacion: "NO",
      venEstado: "ACTIVA",
      venFacturaCredito: "NO",
      venFechaAutorizacion: "",
      venFechaFactura: DateTime.now().toLocal().toString().split(' ')[0],
      venFecReg: '',
      venFormaPago: "EFECTIVO",
      venNomCliente: "CONSUMIDOR FINAL",
      venNumero: "0",
      venNumFactura: '', //aplicar secuencia aca
      venNumFacturaAnterior: "",
      venObservacion: "",
      venOption: "1",
      venOtros: '',
      venOtrosDetalles: "",
      venRucCliente: "9999999999999",
      venTelfCliente: "0000000001",
      venTipoDocuCliente: "RUC",
      venTipoDocumento: "N",
      venTotalRetencion: "0.00",
      venCeluCliente: [],
      venEmailCliente: ["sin@sincorreo.com"],
      venProductos: [],
      manguera: '',
    );
  }

  factory Venta.fromJson(Map<String, dynamic> json) => Venta(
        venId: json["venId"],
        venOtros: json["venOtros"],
        venFecReg: json["venFecReg"],
        venOption: json["venOption"],
        venTipoDocumento: json["venTipoDocumento"],
        optionDocumento: json["optionDocumento"] ?? "",
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
        venDescPorcentaje:
            Parse.parseDynamicToDouble(json["venDescPorcentaje"]),
        venOtrosDetalles: json["venOtrosDetalles"].toString(),
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
        idAbastecimiento: Parse.parseDynamicToInt(json['idAbastecimiento']),
        totInicio: Parse.parseDynamicToDouble(json['totInicio']),
        totFinal: Parse.parseDynamicToDouble(json['totFinal']),
        abastecimiento: json['abastecimiento'],
        manguera: Parse.parseDynamicToString(json['manguera']),
      );

  Map<String, dynamic> toJson() => {
        "venId": venId,
        "venOtros": venOtros,
        "venFecReg": venFecReg,
        "venOption": venOption,
        "venTipoDocumento": venTipoDocumento,
        "optionDocumento": optionDocumento,
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
        "idAbastecimiento": idAbastecimiento,
        "totInicio": totInicio,
        "totFinal": totFinal,
        "abastecimiento": abastecimiento?.toJson(),
        "manguera": manguera,
      };
  static double cincoDecimales(double numero) {
    return double.parse(numero.toStringAsFixed(7));
  }

  static double dosDecimales(double numero) {
    return double.parse(numero.toStringAsFixed(3));
  }

  static Totales sumarCantidad(Totales acumulador, Producto valorActual) {
    var venSub0y12 = valorActual.llevaIva == "SI"
        ? Totales(
            venSubTotal12: cincoDecimales(
                acumulador.venSubTotal12 + valorActual.precioSubTotalProducto),
            venSubtotal0: acumulador.venSubtotal0,
            venDescuento: acumulador.venDescuento,
            venSubTotal: acumulador.venSubTotal,
            venTotalIva: acumulador.venTotalIva,
            venTotal: acumulador.venTotal,
            venCostoProduccion: acumulador.venCostoProduccion,
          )
        : Totales(
            venSubTotal12: acumulador.venSubTotal12,
            venSubtotal0: cincoDecimales(
                acumulador.venSubtotal0 + valorActual.precioSubTotalProducto),
            venDescuento: acumulador.venDescuento,
            venSubTotal: acumulador.venSubTotal,
            venTotalIva: acumulador.venTotalIva,
            venTotal: acumulador.venTotal,
            venCostoProduccion: acumulador.venCostoProduccion,
          );

    return Totales(
      venSubTotal12: venSub0y12.venSubTotal12,
      venSubtotal0: venSub0y12.venSubtotal0,
      venDescuento: cincoDecimales(acumulador.venDescuento +
          valorActual.descuento * valorActual.cantidad),
      venSubTotal: cincoDecimales(
          acumulador.venSubTotal + valorActual.precioSubTotalProducto),
      venTotalIva:
          cincoDecimales(acumulador.venTotalIva + valorActual.valorIva),
      venTotal: cincoDecimales(acumulador.venTotal +
          valorActual.precioSubTotalProducto +
          valorActual.valorIva),
      venCostoProduccion: cincoDecimales(
          acumulador.venCostoProduccion + valorActual.costoProduccion),
    );
  }

  static Totales calcularTotales(
      {required List<Producto> productos, required double iva}) {
    var inicial = Totales.inicial();
    var resultado = productos.fold<Totales>(inicial, sumarCantidad);

    // Calcular los valores finales con dos decimales
    double resvenSubTotal12 = dosDecimales(resultado.venSubTotal12);
    double resvenSubtotal0 = dosDecimales(resultado.venSubtotal0);
    double resvenDescuento = dosDecimales(resultado.venDescuento);
    double resvenSubTotal = dosDecimales(resultado.venSubTotal);
    double resvenTotalIva = dosDecimales(resultado.venTotalIva);
    double resvenTotal = dosDecimales(resultado.venTotal);
    double resvenCostoProduccion = dosDecimales(resultado.venCostoProduccion);
    // // Calcular los valores finales con dos decimales
    // double resvenSubTotal12 = dosDecimales(resultado.venSubTotal12);
    // double resvenSubtotal0 = dosDecimales(resultado.venSubtotal0);
    // double resvenDescuento = dosDecimales(resultado.venDescuento);
    // double resvenSubTotal = dosDecimales(resvenSubTotal12 + resvenSubtotal0);
    // double resvenTotalIva = dosDecimales(resvenSubTotal12 * (iva / 100));
    // double resvenTotal =
    //     dosDecimales(resvenSubTotal12 + resvenTotalIva + resvenSubtotal0);
    // double resvenCostoProduccion = dosDecimales(resultado.venCostoProduccion);

    // Retornar los totales calculados
    return Totales(
      venSubTotal12: resvenSubTotal12,
      venSubtotal0: resvenSubtotal0,
      venDescuento: resvenDescuento,
      venSubTotal: resvenSubTotal,
      venTotalIva: resvenTotalIva,
      venTotal: resvenTotal,
      venCostoProduccion: resvenCostoProduccion,
    );
  }
}

//* ES LA VENTA PERO CON VALIDACIONES PARA EL FORMULARIO
class VentaForm extends Venta {
  final GenericRequiredInput venRucClienteInput;
  final Productos venProductosInput;
  final MinValueCliente venTotalInput;
  VentaForm({
    //*VALIDACIONES
    required this.venRucClienteInput,
    required this.venProductosInput,
    required this.venTotalInput,
    //*CAMPOS NORMALES
    required super.venId,
    required super.fechaSustentoFactura,
    required super.venAbono,
    required super.venAutorizacion,
    required super.venCeluCliente,
    required super.venCostoProduccion,
    required super.venDescPorcentaje,
    required super.venDescuento,
    required super.venDias,
    required super.venDirCliente,
    required super.venEmailCliente,
    required super.venEmpAgenteRetencion,
    required super.venEmpComercial,
    required super.venEmpContribuyenteEspecial,
    required super.venEmpDireccion,
    required super.venEmpEmail,
    required super.venEmpIva,
    required super.venEmpLeyenda,
    required super.venEmpNombre,
    required super.venEmpObligado,
    required super.venEmpRegimen,
    required super.venEmpresa,
    required super.venEmpRuc,
    required super.venEmpTelefono,
    required super.venEnvio,
    required super.venErrorAutorizacion,
    required super.venEstado,
    required super.venFacturaCredito,
    required super.venFechaAutorizacion,
    required super.venFechaFactura,
    required super.venFecReg,
    required super.venFormaPago,
    required super.venIdCliente,
    required super.venNomCliente,
    required super.venNumero,
    required super.venNumFactura,
    required super.venNumFacturaAnterior,
    required super.venObservacion,
    required super.venOption,
    required super.venOtrosDetalles,
    required super.venProductos,
    required super.venRucCliente,
    required super.venSubTotal,
    required super.venSubtotal0,
    required super.venSubTotal12,
    required super.venTelfCliente,
    required super.venTipoDocuCliente,
    required super.venTipoDocumento,
    required super.optionDocumento,
    required super.venTotal,
    required super.venTotalIva,
    required super.venTotalRetencion,
    required super.venUser,
    required super.manguera,
    super.venOtros,
    super.idAbastecimiento,
    super.totInicio,
    super.totFinal,
    super.abastecimiento,
  });

  VentaForm copyWith({
    //* REQUERIDOS
    String? venRucCliente,
    List<Producto>? venProductos,
    double? venTotal,
    //* VENTA
    int? venId,
    double? venCostoProduccion,
    double? venDescuento,
    double? venSubTotal,
    double? venSubtotal0,
    double? venSubTotal12,
    double? venTotalIva,
    int? venIdCliente,
    int? venEmpIva,
    // List<Producto>? venProductos,
    List<String>? venCeluCliente,
    List<String>? venEmailCliente,
    String? fechaSustentoFactura,
    String? venAbono,
    String? venAutorizacion,
    double? venDescPorcentaje,
    String? venDias,
    String? venDirCliente,
    String? venEmpAgenteRetencion,
    String? venEmpComercial,
    String? venEmpContribuyenteEspecial,
    String? venEmpDireccion,
    String? venEmpEmail,
    String? venEmpLeyenda,
    String? venEmpNombre,
    String? venEmpObligado,
    String? venEmpRegimen,
    String? venEmpresa,
    String? venEmpRuc,
    String? venEmpTelefono,
    String? venEnvio,
    String? venErrorAutorizacion,
    String? venEstado,
    String? venFacturaCredito,
    String? venFechaAutorizacion,
    String? venFechaFactura,
    String? venFecReg,
    String? venFormaPago,
    String? venNomCliente,
    String? venNumero,
    String? venNumFactura,
    String? venNumFacturaAnterior,
    String? venObservacion,
    String? venOption,
    String? venOtrosDetalles,
    // String? venRucCliente,
    String? venTelfCliente,
    String? venTipoDocuCliente,
    String? venTipoDocumento,
    String? optionDocumento,
    String? venTotalRetencion,
    String? venUser,
    String? venOtros,
    int? idAbastecimiento,
    double? totInicio,
    double? totFinal,
    Abastecimiento? abastecimiento,
    String? manguera,
  }) {
    final venRucClienteInput = venRucCliente != null
        ? GenericRequiredInput.dirty(venRucCliente)
        : this.venRucClienteInput;

    return VentaForm(
      //*REQUERIDOS
      venRucClienteInput: venRucClienteInput,
      venProductosInput: venProductos != null
          ? Productos.dirty(venProductos)
          : venProductosInput,
      venTotalInput: venTotal != null
          ? MinValueCliente.dirty(venTotal,
              venRucCliente: venRucClienteInput.value)
          : venTotalInput,

      //*SUS EQUIVALENTES
      venRucCliente: venRucCliente ?? this.venRucCliente,
      venProductos: venProductos ?? this.venProductos,
      //* LO DEMAS
      venId: venId ?? this.venId,
      venNomCliente: venNomCliente ?? this.venNomCliente,
      venFecReg: venFecReg ?? this.venFecReg,
      venOption: venOption ?? this.venOption,
      venTipoDocumento: venTipoDocumento ?? this.venTipoDocumento,
      optionDocumento: optionDocumento ?? this.optionDocumento,
      venIdCliente: venIdCliente ?? this.venIdCliente,
      venTipoDocuCliente: venTipoDocuCliente ?? this.venTipoDocuCliente,
      venEmailCliente: venEmailCliente ?? this.venEmailCliente,
      venTelfCliente: venTelfCliente ?? this.venTelfCliente,
      venCeluCliente: venCeluCliente ?? this.venCeluCliente,
      venDirCliente: venDirCliente ?? this.venDirCliente,
      venEmpRuc: venEmpRuc ?? this.venEmpRuc,
      venEmpNombre: venEmpNombre ?? this.venEmpNombre,
      venEmpComercial: venEmpComercial ?? this.venEmpComercial,
      venEmpDireccion: venEmpDireccion ?? this.venEmpDireccion,
      venEmpTelefono: venEmpTelefono ?? this.venEmpTelefono,
      venEmpEmail: venEmpEmail ?? this.venEmpEmail,
      venEmpObligado: venEmpObligado ?? this.venEmpObligado,
      venEmpRegimen: venEmpRegimen ?? this.venEmpRegimen,
      venFormaPago: venFormaPago ?? this.venFormaPago,
      venNumero: venNumero ?? this.venNumero,
      venFacturaCredito: venFacturaCredito ?? this.venFacturaCredito,
      venDias: venDias ?? this.venDias,
      venAbono: venAbono ?? this.venAbono,
      venDescPorcentaje: venDescPorcentaje ?? this.venDescPorcentaje,
      venOtrosDetalles: venOtrosDetalles ?? this.venOtrosDetalles,
      venObservacion: venObservacion ?? this.venObservacion,
      venSubTotal12: venSubTotal12 ?? this.venSubTotal12,
      venSubtotal0: venSubtotal0 ?? this.venSubtotal0,
      venDescuento: venDescuento ?? this.venDescuento,
      venSubTotal: venSubTotal ?? this.venSubTotal,
      venTotalIva: venTotalIva ?? this.venTotalIva,
      venTotal: venTotal ?? this.venTotal,
      venCostoProduccion: venCostoProduccion ?? this.venCostoProduccion,
      venUser: venUser ?? this.venUser,
      venFechaFactura: venFechaFactura ?? this.venFechaFactura,
      venNumFactura: venNumFactura ?? this.venNumFactura,
      venNumFacturaAnterior:
          venNumFacturaAnterior ?? this.venNumFacturaAnterior,
      venAutorizacion: venAutorizacion ?? this.venAutorizacion,
      venFechaAutorizacion: venFechaAutorizacion ?? this.venFechaAutorizacion,
      venErrorAutorizacion: venErrorAutorizacion ?? this.venErrorAutorizacion,
      venEstado: venEstado ?? this.venEstado,
      venEnvio: venEnvio ?? this.venEnvio,
      fechaSustentoFactura: fechaSustentoFactura ?? this.fechaSustentoFactura,
      venTotalRetencion: venTotalRetencion ?? this.venTotalRetencion,
      venEmpresa: venEmpresa ?? this.venEmpresa,
      venEmpAgenteRetencion:
          venEmpAgenteRetencion ?? this.venEmpAgenteRetencion,
      venEmpContribuyenteEspecial:
          venEmpContribuyenteEspecial ?? this.venEmpContribuyenteEspecial,
      venEmpLeyenda: venEmpLeyenda ?? this.venEmpLeyenda,
      venEmpIva: venEmpIva ?? this.venEmpIva,
      manguera: manguera ?? this.manguera,

      //*POSIBLES NULOS
      venOtros: venOtros ?? this.venOtros,
      idAbastecimiento: idAbastecimiento ?? this.idAbastecimiento,
      totInicio: totInicio ?? this.totInicio,
      totFinal: totFinal ?? this.totFinal,
      abastecimiento: abastecimiento ?? this.abastecimiento,
    );
  }

  //CONVIERTE A VENTA
  Venta toVenta() => Venta(
        venId: venId,
        venFecReg: venFecReg,
        venOption: venOption,
        venTipoDocumento: venTipoDocumento,
        optionDocumento: optionDocumento,
        venIdCliente: venIdCliente,
        venRucCliente: venRucClienteInput.value,
        venProductos: venProductosInput.value,
        venTipoDocuCliente: venTipoDocuCliente,
        venNomCliente: venNomCliente,
        venEmailCliente: venEmailCliente,
        venTelfCliente: venTelfCliente,
        venCeluCliente: venCeluCliente,
        venDirCliente: venDirCliente,
        venEmpRuc: venEmpRuc,
        venEmpNombre: venEmpNombre,
        venEmpComercial: venEmpComercial,
        venEmpDireccion: venEmpDireccion,
        venEmpTelefono: venEmpTelefono,
        venEmpEmail: venEmpEmail,
        venEmpObligado: venEmpObligado,
        venEmpRegimen: venEmpRegimen,
        venFormaPago: venFormaPago,
        venNumero: venNumero,
        venFacturaCredito: venFacturaCredito,
        venDias: venDias,
        venAbono: venAbono,
        venDescPorcentaje: venDescPorcentaje,
        venOtrosDetalles: venOtrosDetalles,
        venObservacion: venObservacion,
        venSubTotal12: venSubTotal12,
        venSubtotal0: venSubtotal0,
        venDescuento: venDescuento,
        venSubTotal: venSubTotal,
        venTotalIva: venTotalIva,
        venTotal: venTotal,
        venCostoProduccion: venCostoProduccion,
        venUser: venUser,
        venFechaFactura: venFechaFactura,
        venNumFactura: venNumFactura,
        venNumFacturaAnterior: venNumFacturaAnterior,
        venAutorizacion: venAutorizacion,
        venFechaAutorizacion: venFechaAutorizacion,
        venErrorAutorizacion: venErrorAutorizacion,
        venEstado: venEstado,
        venEnvio: venEnvio,
        fechaSustentoFactura: fechaSustentoFactura,
        venTotalRetencion: venTotalRetencion,
        venEmpresa: venEmpresa,
        venEmpAgenteRetencion: venEmpAgenteRetencion,
        venEmpContribuyenteEspecial: venEmpContribuyenteEspecial,
        venEmpLeyenda: venEmpLeyenda,
        venEmpIva: venEmpIva,
        venOtros: venOtros,
        idAbastecimiento: idAbastecimiento,
        totInicio: totInicio,
        totFinal: totFinal,
        abastecimiento: abastecimiento,
        manguera: manguera,
      );

  factory VentaForm.fromVenta(Venta venta) {
    return venta.venId == 0
        ? VentaForm(
            venTotalInput: const MinValueCliente.pure(),
            venRucClienteInput: const GenericRequiredInput.pure(),
            venProductosInput: const Productos.pure(),
            venRucCliente: venta.venRucCliente,
            venId: venta.venId,
            venFecReg: venta.venFecReg,
            venOption: venta.venOption,
            venTipoDocumento: venta.venTipoDocumento,
            optionDocumento: venta.optionDocumento,
            venIdCliente: venta.venIdCliente,
            venTipoDocuCliente: venta.venTipoDocuCliente,
            venNomCliente: venta.venNomCliente,
            venEmailCliente: venta.venEmailCliente,
            venTelfCliente: venta.venTelfCliente,
            venCeluCliente: venta.venCeluCliente,
            venDirCliente: venta.venDirCliente,
            venEmpRuc: venta.venEmpRuc,
            venEmpNombre: venta.venEmpNombre,
            venEmpComercial: venta.venEmpComercial,
            venEmpDireccion: venta.venEmpDireccion,
            venEmpTelefono: venta.venEmpTelefono,
            venEmpEmail: venta.venEmpEmail,
            venEmpObligado: venta.venEmpObligado,
            venEmpRegimen: venta.venEmpRegimen,
            venFormaPago: venta.venFormaPago,
            venNumero: venta.venNumero,
            venFacturaCredito: venta.venFacturaCredito,
            venDias: venta.venDias,
            venAbono: venta.venAbono,
            venDescPorcentaje: venta.venDescPorcentaje,
            venOtrosDetalles: venta.venOtrosDetalles,
            venObservacion: venta.venObservacion,
            venSubTotal12: venta.venSubTotal12,
            venSubtotal0: venta.venSubtotal0,
            venDescuento: venta.venDescuento,
            venSubTotal: venta.venSubTotal,
            venTotalIva: venta.venTotalIva,
            venTotal: venta.venTotal,
            venCostoProduccion: venta.venCostoProduccion,
            venUser: venta.venUser,
            venFechaFactura: venta.venFechaFactura,
            venNumFactura: venta.venNumFactura,
            venNumFacturaAnterior: venta.venNumFacturaAnterior,
            venAutorizacion: venta.venAutorizacion,
            venFechaAutorizacion: venta.venFechaAutorizacion,
            venErrorAutorizacion: venta.venErrorAutorizacion,
            venEstado: venta.venEstado,
            venEnvio: venta.venEnvio,
            fechaSustentoFactura: venta.fechaSustentoFactura,
            venTotalRetencion: venta.venTotalRetencion,
            venEmpresa: venta.venEmpresa,
            venProductos: venta.venProductos,
            venEmpAgenteRetencion: venta.venEmpAgenteRetencion,
            venEmpContribuyenteEspecial: venta.venEmpContribuyenteEspecial,
            venEmpLeyenda: venta.venEmpLeyenda,
            venEmpIva: venta.venEmpIva,
            venOtros: venta.venOtros,
            idAbastecimiento: venta.idAbastecimiento,
            totInicio: venta.totInicio,
            totFinal: venta.totFinal,
            abastecimiento: venta.abastecimiento,
            manguera: venta.manguera,

          )
        : VentaForm(
            venTotalInput: MinValueCliente.dirty(venta.venTotal,
                venRucCliente: venta.venRucCliente),
            venRucClienteInput: GenericRequiredInput.dirty(venta.venRucCliente),
            venProductosInput: Productos.dirty(venta.venProductos),
            venRucCliente: venta.venRucCliente,
            venId: venta.venId,
            venFecReg: venta.venFecReg,
            venOption: venta.venOption,
            venTipoDocumento: venta.venTipoDocumento,
            optionDocumento: venta.optionDocumento,
            venIdCliente: venta.venIdCliente,
            venTipoDocuCliente: venta.venTipoDocuCliente,
            venNomCliente: venta.venNomCliente,
            venEmailCliente: venta.venEmailCliente,
            venTelfCliente: venta.venTelfCliente,
            venCeluCliente: venta.venCeluCliente,
            venDirCliente: venta.venDirCliente,
            venEmpRuc: venta.venEmpRuc,
            venEmpNombre: venta.venEmpNombre,
            venEmpComercial: venta.venEmpComercial,
            venEmpDireccion: venta.venEmpDireccion,
            venEmpTelefono: venta.venEmpTelefono,
            venEmpEmail: venta.venEmpEmail,
            venEmpObligado: venta.venEmpObligado,
            venEmpRegimen: venta.venEmpRegimen,
            venFormaPago: venta.venFormaPago,
            venNumero: venta.venNumero,
            venFacturaCredito: venta.venFacturaCredito,
            venDias: venta.venDias,
            venAbono: venta.venAbono,
            venDescPorcentaje: venta.venDescPorcentaje,
            venOtrosDetalles: venta.venOtrosDetalles,
            venObservacion: venta.venObservacion,
            venSubTotal12: venta.venSubTotal12,
            venSubtotal0: venta.venSubtotal0,
            venDescuento: venta.venDescuento,
            venSubTotal: venta.venSubTotal,
            venTotalIva: venta.venTotalIva,
            venTotal: venta.venTotal,
            venCostoProduccion: venta.venCostoProduccion,
            venUser: venta.venUser,
            venFechaFactura: venta.venFechaFactura,
            venNumFactura: venta.venNumFactura,
            venNumFacturaAnterior: venta.venNumFacturaAnterior,
            venAutorizacion: venta.venAutorizacion,
            venFechaAutorizacion: venta.venFechaAutorizacion,
            venErrorAutorizacion: venta.venErrorAutorizacion,
            venEstado: venta.venEstado,
            venEnvio: venta.venEnvio,
            fechaSustentoFactura: venta.fechaSustentoFactura,
            venTotalRetencion: venta.venTotalRetencion,
            venEmpresa: venta.venEmpresa,
            venProductos: venta.venProductos,
            venEmpAgenteRetencion: venta.venEmpAgenteRetencion,
            venEmpContribuyenteEspecial: venta.venEmpContribuyenteEspecial,
            venEmpLeyenda: venta.venEmpLeyenda,
            venEmpIva: venta.venEmpIva,
            venOtros: venta.venOtros,
            idAbastecimiento: venta.idAbastecimiento,
            totInicio: venta.totInicio,
            totFinal: venta.totFinal,
            abastecimiento: venta.abastecimiento,
            manguera: venta.manguera,
          );
  }
}

class Totales {
  double venSubTotal12;
  double venSubtotal0;
  double venDescuento;
  double venSubTotal;
  double venTotalIva;
  double venTotal;
  double venCostoProduccion;

  Totales({
    required this.venSubTotal12,
    required this.venSubtotal0,
    required this.venDescuento,
    required this.venSubTotal,
    required this.venTotalIva,
    required this.venTotal,
    required this.venCostoProduccion,
  });

  factory Totales.inicial() {
    return Totales(
      venSubTotal12: 0.0,
      venSubtotal0: 0.0,
      venDescuento: 0.0,
      venSubTotal: 0.0,
      venTotalIva: 0.0,
      venTotal: 0.0,
      venCostoProduccion: 0.0,
    );
  }
}

class BusquedaVenta {
  final String venFechaFactura1;
  final String venFechaFactura2;

  const BusquedaVenta({
    this.venFechaFactura1 = '',
    this.venFechaFactura2 = '',
  });

  factory BusquedaVenta.fromJson(Map<String, dynamic> json) => BusquedaVenta(
        venFechaFactura1: json["venFechaFactura1"],
        venFechaFactura2: json["venFechaFactura2"],
      );

  Map<String, dynamic> toJson() => {
        "venFechaFactura1": venFechaFactura1,
        "venFechaFactura2": venFechaFactura2,
      };

  BusquedaVenta copyWith({
    String? venFechaFactura1,
    String? venFechaFactura2,
  }) {
    return BusquedaVenta(
      venFechaFactura1: venFechaFactura1 ?? this.venFechaFactura1,
      venFechaFactura2: venFechaFactura2 ?? this.venFechaFactura2,
    );
  }

  bool isSearching() {
    return venFechaFactura1.isNotEmpty || venFechaFactura2.isNotEmpty;
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}
