import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';

import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/venta/infrastructure/input/productos.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_provider.dart';

import 'package:neitorvet/features/shared/shared.dart';

final ventaFormProvider = StateNotifierProvider.family
    .autoDispose<VentaFormNotifier, VentaFormState, Venta>((ref, venta) {
  final createUpdateVenta =
      ref.watch(ventasProvider.notifier).createUpdateVenta;
  return VentaFormNotifier(venta: venta, createUpdateVenta: createUpdateVenta);
});

class VentaFormNotifier extends StateNotifier<VentaFormState> {
  final Future<void> Function(Map<String, dynamic> ventaMap) createUpdateVenta;
  VentaFormNotifier({
    required Venta venta,
    required this.createUpdateVenta,
  }) : super(VentaFormState(
          venId: venta.venId,
          venRucCliente: GenericRequiredInput.dirty(venta.venRucCliente),
          venCostoProduccion: venta.venCostoProduccion,
          venDescuento: venta.venDescuento,
          venSubTotal: venta.venSubTotal,
          venSubtotal0: venta.venSubtotal0,
          venSubTotal12: venta.venSubTotal12,
          venTotal: venta.venTotal,
          venTotalIva: venta.venTotalIva,
          venIdCliente: venta.venIdCliente,
          venEmpIva: venta.venEmpIva,
          venCeluCliente: venta.venCeluCliente,
          venEmailCliente: venta.venEmailCliente,
          venProductos: Productos.dirty(venta.venProductos),
          fechaSustentoFactura: venta.fechaSustentoFactura,
          venAbono: venta.venAbono,
          venAutorizacion: venta.venAutorizacion,
          venDescPorcentaje: venta.venDescPorcentaje,
          venDias: venta.venDias,
          venDirCliente: venta.venDirCliente,
          venEmpAgenteRetencion: venta.venEmpAgenteRetencion,
          venEmpComercial: venta.venEmpComercial,
          venEmpContribuyenteEspecial: venta.venEmpContribuyenteEspecial,
          venEmpDireccion: venta.venEmpDireccion,
          venEmpEmail: venta.venEmpEmail,
          venEmpLeyenda: venta.venEmpLeyenda,
          venEmpNombre: venta.venEmpNombre,
          venEmpObligado: venta.venEmpObligado,
          venEmpRegimen: venta.venEmpRegimen,
          venEmpresa: venta.venEmpresa,
          venEmpRuc: venta.venEmpRuc,
          venEmpTelefono: venta.venEmpTelefono,
          venEnvio: venta.venEnvio,
          venErrorAutorizacion: venta.venErrorAutorizacion,
          venEstado: venta.venEstado,
          venFacturaCredito: venta.venFacturaCredito,
          venFechaAutorizacion: venta.venFechaAutorizacion,
          venFechaFactura: venta.venFechaFactura,
          venFecReg: venta.venFecReg,
          venFormaPago: venta.venFormaPago,
          venNomCliente: venta.venNomCliente,
          venNumero: venta.venNumero,
          venNumFactura: venta.venNumFactura,
          venNumFacturaAnterior: venta.venNumFacturaAnterior,
          venObservacion: venta.venObservacion,
          venOption: venta.venOption,
          venOtros: venta.venOtros,
          venOtrosDetalles: venta.venOtrosDetalles,
          venTelfCliente: venta.venTelfCliente,
          venTipoDocuCliente: venta.venTipoDocuCliente,
          venTipoDocumento: venta.venTipoDocumento,
          venTotalRetencion: venta.venTotalRetencion,
          venUser: venta.venUser,
        ));

  void updateState(
      {double? venCostoProduccion,
      double? venDescuento,
      double? venSubTotal,
      double? venSubtotal0,
      double? venSubTotal12,
      double? venTotal,
      double? venTotalIva,
      String? venRucCliente,
      int? venIdCliente,
      int? venEmpIva,
      List<String>? venCeluCliente,
      List<String>? venEmailCliente,
      List<Producto>? venProductos,
      String? fechaSustentoFactura,
      String? venAbono,
      String? venAutorizacion,
      String? venDescPorcentaje,
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
      String? venOtros,
      String? venOtrosDetalles,
      String? venTelfCliente,
      String? venTipoDocuCliente,
      String? venTipoDocumento,
      String? venTotalRetencion,
      String? venUser,
      List<String>? placasData,
      String? secuencia}) {
    state = state.copyWith(
      venRucCliente: GenericRequiredInput.dirty(
          venRucCliente ?? state.venRucCliente.value),
      venProductos: Productos.dirty(venProductos ?? state.venProductos.value),
      venCostoProduccion: venCostoProduccion ?? state.venCostoProduccion,
      venDescuento: venDescuento ?? state.venDescuento,
      venSubTotal: venSubTotal ?? state.venSubTotal,
      venSubtotal0: venSubtotal0 ?? state.venSubtotal0,
      venSubTotal12: venSubTotal12 ?? state.venSubTotal12,
      venTotal: venTotal ?? state.venTotal,
      venTotalIva: venTotalIva ?? state.venTotalIva,
      venIdCliente: venIdCliente ?? state.venIdCliente,
      venEmpIva: venEmpIva ?? state.venEmpIva,
      venCeluCliente: venCeluCliente ?? state.venCeluCliente,
      venEmailCliente: venEmailCliente ?? state.venEmailCliente,
      fechaSustentoFactura: fechaSustentoFactura ?? state.fechaSustentoFactura,
      venAbono: venAbono ?? state.venAbono,
      venAutorizacion: venAutorizacion ?? state.venAutorizacion,
      venDescPorcentaje: venDescPorcentaje ?? state.venDescPorcentaje,
      venDias: venDias ?? state.venDias,
      venDirCliente: venDirCliente ?? state.venDirCliente,
      venEmpAgenteRetencion:
          venEmpAgenteRetencion ?? state.venEmpAgenteRetencion,
      venEmpComercial: venEmpComercial ?? state.venEmpComercial,
      venEmpContribuyenteEspecial:
          venEmpContribuyenteEspecial ?? state.venEmpContribuyenteEspecial,
      venEmpDireccion: venEmpDireccion ?? state.venEmpDireccion,
      venEmpEmail: venEmpEmail ?? state.venEmpEmail,
      venEmpLeyenda: venEmpLeyenda ?? state.venEmpLeyenda,
      venEmpNombre: venEmpNombre ?? state.venEmpNombre,
      venEmpObligado: venEmpObligado ?? state.venEmpObligado,
      venEmpRegimen: venEmpRegimen ?? state.venEmpRegimen,
      venEmpresa: venEmpresa ?? state.venEmpresa,
      venEmpRuc: venEmpRuc ?? state.venEmpRuc,
      venEmpTelefono: venEmpTelefono ?? state.venEmpTelefono,
      venEnvio: venEnvio ?? state.venEnvio,
      venErrorAutorizacion: venErrorAutorizacion ?? state.venErrorAutorizacion,
      venEstado: venEstado ?? state.venEstado,
      venFacturaCredito: venFacturaCredito ?? state.venFacturaCredito,
      venFechaAutorizacion: venFechaAutorizacion ?? state.venFechaAutorizacion,
      venFechaFactura: venFechaFactura ?? state.venFechaFactura,
      venFecReg: venFecReg ?? state.venFecReg,
      venFormaPago: venFormaPago ?? state.venFormaPago,
      venNomCliente: venNomCliente ?? state.venNomCliente,
      venNumero: venNumero ?? state.venNumero,
      venNumFactura: venNumFactura ?? state.venNumFactura,
      venNumFacturaAnterior:
          venNumFacturaAnterior ?? state.venNumFacturaAnterior,
      venObservacion: venObservacion ?? state.venObservacion,
      venOption: venOption ?? state.venOption,
      venOtros: venOtros ?? state.venOtros,
      venOtrosDetalles: venOtrosDetalles ?? state.venOtrosDetalles,
      venTelfCliente: venTelfCliente ?? state.venTelfCliente,
      venTipoDocuCliente: venTipoDocuCliente ?? state.venTipoDocuCliente,
      venTipoDocumento: venTipoDocumento ?? state.venTipoDocumento,
      venTotalRetencion: venTotalRetencion ?? state.venTotalRetencion,
      venUser: venUser ?? state.venUser,
      secuencia: secuencia ?? state.secuencia,
      placasData: placasData ?? state.placasData,
      isFormValid: Formz.validate([
        GenericRequiredInput.dirty(venRucCliente ?? state.venRucCliente.value),
        Productos.dirty(venProductos ?? state.venProductos.value),
      ]),
    );
  }

  Future<bool> onFormSubmit() async {
    // Marcar todos los campos como tocados
    _touchedEverything();

    // Esperar un breve momento para asegurar que el estado se actualice

    // Verificar si el formulario es válido y si ya se está posteando
    if (!state.isFormValid) {
      return false;
    }
    if (state.isPosting) {
      return false;
    }
    // Actualizar el estado para indicar que se está posteando
    state = state.copyWith(isPosting: true);
    final ventaMap = {"A": 'A'};

    try {
      // socket.emit('editar-registro', ventaMap);
      const result = true;
      //  await onSubmitCallback(productMap);
      await createUpdateVenta(ventaMap);
      // Actualizar el estado para indicar que ya no se está posteando
      state = state.copyWith(isPosting: false);

      return result;
    } catch (e) {
      // Actualizar el estado para indicar que ya no se está posteando
      state = state.copyWith(isPosting: false);

      return false;
    }
  }

  void cargarSecuencia() async {}
  void _touchedEverything() {
    state = state.copyWith(
        isFormValid: Formz.validate([
      GenericRequiredInput.dirty(state.venRucCliente.value),
      Productos.dirty(state.venProductos.value)
    ]));
  }
}

class VentaFormState {
  final bool isFormValid;
  final bool isPosted;
  final bool isPosting;
// venRucCliente
  //*REGISTRO
  final int venId;
  final double venCostoProduccion;
  final double venDescuento;
  final double venSubTotal;
  final double venSubtotal0;
  final double venSubTotal12;
  final double venTotal;
  final double venTotalIva;
  final GenericRequiredInput venRucCliente;
  final int venIdCliente;
  final int? venEmpIva;
  final List<String> venCeluCliente;
  final List<String> venEmailCliente;
  final Productos venProductos;
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
  final String venTelfCliente;
  final String venTipoDocuCliente;
  final String venTipoDocumento;
  final String venTotalRetencion;
  final String venUser;

  final List<String> placasData;
  final String secuencia;

  VentaFormState({
    this.isFormValid = false,
    this.isPosted = false,
    this.isPosting = false,
    this.venId = 0,
    this.venCostoProduccion = 0,
    this.venDescuento = 0,
    this.venSubTotal = 0,
    this.venSubtotal0 = 0,
    this.venSubTotal12 = 0,
    this.venTotal = 0,
    this.venTotalIva = 0,
    this.venRucCliente = const GenericRequiredInput.dirty(''),
    this.venIdCliente = 0,
    this.venEmpIva = 0,
    this.venCeluCliente = const [],
    this.venEmailCliente = const [],
    this.venProductos = const Productos.dirty([]),
    this.fechaSustentoFactura = '',
    this.venAbono = '',
    this.venAutorizacion = '',
    this.venDescPorcentaje = '',
    this.venDias = '',
    this.venDirCliente = '',
    this.venEmpAgenteRetencion = '',
    this.venEmpComercial = '',
    this.venEmpContribuyenteEspecial = '',
    this.venEmpDireccion = '',
    this.venEmpEmail = '',
    this.venEmpLeyenda = '',
    this.venEmpNombre = '',
    this.venEmpObligado = '',
    this.venEmpRegimen = '',
    this.venEmpresa = '',
    this.venEmpRuc = '',
    this.venEmpTelefono = '',
    this.venEnvio = '',
    this.venErrorAutorizacion = '',
    this.venEstado = '',
    this.venFacturaCredito = '',
    this.venFechaAutorizacion = '',
    this.venFechaFactura = '',
    this.venFecReg = '',
    this.venFormaPago = '',
    this.venNomCliente = '',
    this.venNumero = '',
    this.venNumFactura = '',
    this.venNumFacturaAnterior = '',
    this.venObservacion = '',
    this.venOption = '',
    this.venOtros = '',
    this.venOtrosDetalles = '',
    this.venTelfCliente = '',
    this.venTipoDocuCliente = '',
    this.venTipoDocumento = '',
    this.venTotalRetencion = '',
    this.venUser = '',
    this.secuencia = '',
    this.placasData = const [],
  });
  VentaFormState copyWith({
    bool? isFormValid,
    bool? isPosted,
    bool? isPosting,
    int? venId,
    double? venCostoProduccion,
    double? venDescuento,
    double? venSubTotal,
    double? venSubtotal0,
    double? venSubTotal12,
    double? venTotal,
    double? venTotalIva,
    GenericRequiredInput? venRucCliente,
    int? venIdCliente,
    int? venEmpIva,
    List<String>? venCeluCliente,
    List<String>? venEmailCliente,
    Productos? venProductos,
    String? fechaSustentoFactura,
    String? venAbono,
    String? venAutorizacion,
    String? venDescPorcentaje,
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
    String? venOtros,
    String? venOtrosDetalles,
    String? venTelfCliente,
    String? venTipoDocuCliente,
    String? venTipoDocumento,
    String? venTotalRetencion,
    String? venUser, 
    
    String? secuencia,
    List<String>? placasData,
  }) {
    return VentaFormState(
      isFormValid: isFormValid ?? this.isFormValid,
      isPosted: isPosted ?? this.isPosted,
      isPosting: isPosting ?? this.isPosting,
      venId: venId ?? this.venId,
      venCostoProduccion: venCostoProduccion ?? this.venCostoProduccion,
      venDescuento: venDescuento ?? this.venDescuento,
      venSubTotal: venSubTotal ?? this.venSubTotal,
      venSubtotal0: venSubtotal0 ?? this.venSubtotal0,
      venSubTotal12: venSubTotal12 ?? this.venSubTotal12,
      venTotal: venTotal ?? this.venTotal,
      venTotalIva: venTotalIva ?? this.venTotalIva,
      venRucCliente: venRucCliente ?? this.venRucCliente,
      venIdCliente: venIdCliente ?? this.venIdCliente,
      venEmpIva: venEmpIva ?? this.venEmpIva,
      venCeluCliente: venCeluCliente ?? this.venCeluCliente,
      venEmailCliente: venEmailCliente ?? this.venEmailCliente,
      venProductos: venProductos ?? this.venProductos,
      fechaSustentoFactura: fechaSustentoFactura ?? this.fechaSustentoFactura,
      venAbono: venAbono ?? this.venAbono,
      venAutorizacion: venAutorizacion ?? this.venAutorizacion,
      venDescPorcentaje: venDescPorcentaje ?? this.venDescPorcentaje,
      venDias: venDias ?? this.venDias,
      venDirCliente: venDirCliente ?? this.venDirCliente,
      venEmpAgenteRetencion:
          venEmpAgenteRetencion ?? this.venEmpAgenteRetencion,
      venEmpComercial: venEmpComercial ?? this.venEmpComercial,
      venEmpContribuyenteEspecial:
          venEmpContribuyenteEspecial ?? this.venEmpContribuyenteEspecial,
      venEmpDireccion: venEmpDireccion ?? this.venEmpDireccion,
      venEmpEmail: venEmpEmail ?? this.venEmpEmail,
      venEmpLeyenda: venEmpLeyenda ?? this.venEmpLeyenda,
      venEmpNombre: venEmpNombre ?? this.venEmpNombre,
      venEmpObligado: venEmpObligado ?? this.venEmpObligado,
      venEmpRegimen: venEmpRegimen ?? this.venEmpRegimen,
      venEmpresa: venEmpresa ?? this.venEmpresa,
      venEmpRuc: venEmpRuc ?? this.venEmpRuc,
      venEmpTelefono: venEmpTelefono ?? this.venEmpTelefono,
      venEnvio: venEnvio ?? this.venEnvio,
      venErrorAutorizacion: venErrorAutorizacion ?? this.venErrorAutorizacion,
      venEstado: venEstado ?? this.venEstado,
      venFacturaCredito: venFacturaCredito ?? this.venFacturaCredito,
      venFechaAutorizacion: venFechaAutorizacion ?? this.venFechaAutorizacion,
      venFechaFactura: venFechaFactura ?? this.venFechaFactura,
      venFecReg: venFecReg ?? this.venFecReg,
      venFormaPago: venFormaPago ?? this.venFormaPago,
      venNomCliente: venNomCliente ?? this.venNomCliente,
      venNumero: venNumero ?? this.venNumero,
      venNumFactura: venNumFactura ?? this.venNumFactura,
      venNumFacturaAnterior:
          venNumFacturaAnterior ?? this.venNumFacturaAnterior,
      venObservacion: venObservacion ?? this.venObservacion,
      venOption: venOption ?? this.venOption,
      venOtros: venOtros ?? this.venOtros,
      venOtrosDetalles: venOtrosDetalles ?? this.venOtrosDetalles,
      venTelfCliente: venTelfCliente ?? this.venTelfCliente,
      venTipoDocuCliente: venTipoDocuCliente ?? this.venTipoDocuCliente,
      venTipoDocumento: venTipoDocumento ?? this.venTipoDocumento,
      venTotalRetencion: venTotalRetencion ?? this.venTotalRetencion,
      venUser: venUser ?? this.venUser,
      secuencia: secuencia ?? this.secuencia,
      placasData: placasData ?? this.placasData,
    );
  }
}
