import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/venta/domain/entities/forma_pago.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';

import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/venta/infrastructure/input/producto_input.dart';
import 'package:neitorvet/features/venta/infrastructure/input/productos.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_provider.dart';

import 'package:neitorvet/features/shared/shared.dart';

final ventaFormProvider = StateNotifierProvider.family
    .autoDispose<VentaFormNotifier, VentaFormState, Venta>((ref, venta) {
  final createUpdateVenta =
      ref.watch(ventasProvider.notifier).createUpdateVenta;
  final formasPago = ref.watch(ventasProvider).formasPago;
  final iva = ref.watch(authProvider).user?.iva ?? 15;
  final rol = ref.watch(authProvider).user!.rol;
  final rucempresa = ref.watch(authProvider).user!.rucempresa;
  final usuario = ref.watch(authProvider).user!.usuario;
  return VentaFormNotifier(
    venta: venta,
    createUpdateVenta: createUpdateVenta,
    iva: iva,
    formasPago: formasPago,
    rol: rol,
    rucempresa: rucempresa,
    usuario: usuario,
  );
});

class VentaFormNotifier extends StateNotifier<VentaFormState> {
  final Future<void> Function(Map<String, dynamic> ventaMap) createUpdateVenta;
  final int iva;
  final List<FormaPago> formasPago;
  final List<String> rol;
  final String rucempresa;
  final String usuario;
  VentaFormNotifier({
    required Venta venta,
    required this.createUpdateVenta,
    required this.formasPago,
    required this.iva,
    required this.rol,
    required this.rucempresa,
    required this.usuario,
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
          venOtros: venta.venOtros ?? '',
          venOtrosDetalles: venta.venOtrosDetalles,
          venTelfCliente: venta.venTelfCliente,
          venTipoDocuCliente: venta.venTipoDocuCliente,
          venTipoDocumento: venta.venTipoDocumento,
          venTotalRetencion: venta.venTotalRetencion,
          venUser: venta.venUser,
          placasData: [venta.venOtrosDetalles],
        )) {
    setPorcentajeFormaPago(venta.venFormaPago);
  }

  void updateState({
    String? nuevoEmail,
    String? productoSearch,
    Producto? nuevoProducto,
    String? monto,
    double? venCostoProduccion,
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
    String? venOtros,
    String? venOtrosDetalles,
    String? venTelfCliente,
    String? venTipoDocuCliente,
    String? venTipoDocumento,
    String? venTotalRetencion,
    String? venUser,
    List<String>? placasData,
  }) {
    state = state.copyWith(
      venRucCliente: GenericRequiredInput.dirty(
          venRucCliente ?? state.venRucCliente.value),
      nuevoEmail:
          nuevoEmail != null ? Email.dirty(nuevoEmail) : state.nuevoEmail,
      nuevoProducto: nuevoProducto != null
          ? ProductoInput.dirty(nuevoProducto)
          : state.nuevoProducto,
      monto: monto == '' ? 0 : double.tryParse(monto ?? "") ?? state.monto,
      productoSearch: productoSearch ?? state.productoSearch,
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
      placasData: placasData ?? state.placasData,
      isFormValid: Formz.validate([
        GenericRequiredInput.dirty(venRucCliente ?? state.venRucCliente.value),
        Productos.dirty(venProductos ?? state.venProductos.value),
      ]),
    );
  }

  //* TODO: CREAR UNA FUNCION PARA AGREGAR EMAIL GLOBAL
  bool agregarEmail(TextEditingController controller) {
    if (state.nuevoEmail.isNotValid) {
      state = state.copyWith(nuevoEmail: Email.dirty(state.nuevoEmail.value));
      return false;
    }
    state = state.copyWith(
        venEmailCliente: [state.nuevoEmail.value, ...state.venEmailCliente],
        nuevoEmail: const Email.pure());
    controller.text = '';
    return true;
  }

  void eliminarEmail(String email) {
    final updatedEmails =
        state.venEmailCliente.where((e) => e != email).toList();
    state = state.copyWith(
      venEmailCliente: updatedEmails,
      isFormValid:
          Formz.validate([GenericRequiredListStr.dirty(updatedEmails)]),
    );
  }

  void handleOcultarEmail() {
    state = state.copyWith(ocultarEmail: !state.ocultarEmail);
  }

  void _calcularTotales(List<Producto> productos, double formPorcentaje) {
    final newProductos = productos.map(
      (e) {
        return e.calcularProducto(
            formPorcentaje: formPorcentaje, iva: iva.toDouble());
      },
    ).toList();

    final resultTotales = Venta.calcularTotales(newProductos);

    state = state.copyWith(
      venProductos: Productos.dirty(newProductos),
      venCostoProduccion: resultTotales.venCostoProduccion,
      venDescuento: resultTotales.venDescuento,
      venSubTotal: resultTotales.venSubTotal,
      venSubTotal12: resultTotales.venSubTotal12,
      venSubtotal0: resultTotales.venSubtotal0,
      venTotal: resultTotales.venTotal,
      venTotalIva: resultTotales.venTotalIva,
    );
  }

  void setPorcentajeFormaPago(String formaDePago) {
    final exist = formasPago.any((e) => e.fpagoNombre == formaDePago);
    if (exist) {
      final formaPagoF = formasPago.firstWhere(
        (venta) => venta.fpagoNombre == formaDePago,
      );
      _calcularTotales(
          state.venProductos.value, double.parse(formaPagoF.fpagoPorcentaje));
      state = state.copyWith(
          porcentajeFormaPago: double.parse(formaPagoF.fpagoPorcentaje));
    }
  }

  void agregarProducto(TextEditingController controller) {
    if (state.nuevoProducto.isNotValid) {
      print(state.nuevoProducto.errorMessage);
      state = state.copyWith(
          nuevoProducto: ProductoInput.dirty(const ProductoInput.pure().value));
      return;
    }
    final producto = state.nuevoProducto.value.copyWith(
        cantidad: state.monto / state.nuevoProducto.value.valorUnitario);

    final result = [producto, ...state.venProductos.value];
    _calcularTotales(result, state.porcentajeFormaPago);
    state = state.copyWith(
      monto: 0,
      nuevoProducto: const ProductoInput.pure(),
    );
    controller.text = '';
  }

  void eliminarProducto(String codigo) {
    final updatedProductos = state.venProductos.value
        .where((producto) => producto.codigo != codigo)
        .toList();
    _calcularTotales(updatedProductos, state.porcentajeFormaPago);
    state = state.copyWith(
      venProductos: Productos.dirty(updatedProductos),
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
    final ventaMap = {
      ...Venta(
              venId: state.venId,
              venOtros: state.venOtros,
              venFecReg: state.venFecReg,
              venOption: state.venOption,
              venTipoDocumento: state.venTipoDocumento,
              venIdCliente: state.venIdCliente,
              venRucCliente: state.venRucCliente.value,
              venTipoDocuCliente: state.venTipoDocuCliente,
              venNomCliente: state.venNomCliente,
              venEmailCliente: state.venEmailCliente,
              venTelfCliente: state.venTelfCliente,
              venCeluCliente: state.venCeluCliente,
              venDirCliente: state.venDirCliente,
              venEmpRuc: state.venEmpRuc,
              venEmpNombre: state.venEmpNombre,
              venEmpComercial: state.venEmpComercial,
              venEmpDireccion: state.venEmpDireccion,
              venEmpTelefono: state.venEmpTelefono,
              venEmpEmail: state.venEmpEmail,
              venEmpObligado: state.venEmpObligado,
              venEmpRegimen: state.venEmpRegimen,
              venFormaPago: state.venFormaPago,
              venNumero: state.venNumero,
              venFacturaCredito: state.venFacturaCredito,
              venDias: state.venDias,
              venAbono: state.venAbono,
              venDescPorcentaje: state.venDescPorcentaje,
              venOtrosDetalles: state.venOtrosDetalles,
              venObservacion: state.venObservacion,
              venSubTotal12: state.venSubTotal12,
              venSubtotal0: state.venSubtotal0,
              venDescuento: state.venDescuento,
              venSubTotal: state.venSubTotal,
              venTotalIva: state.venTotalIva,
              venTotal: state.venTotal,
              venCostoProduccion: state.venCostoProduccion,
              venUser: state.venUser,
              venFechaFactura: state.venFechaFactura,
              venNumFactura: state.venNumFactura,
              venNumFacturaAnterior: state.venNumFacturaAnterior,
              venAutorizacion: state.venAutorizacion,
              venFechaAutorizacion: state.venFechaAutorizacion,
              venErrorAutorizacion: state.venErrorAutorizacion,
              venEstado: state.venEstado,
              venEnvio: state.venEnvio,
              fechaSustentoFactura: state.fechaSustentoFactura,
              venTotalRetencion: state.venTotalRetencion,
              venEmpresa: state.venEmpresa,
              venProductos: state.venProductos.value,
              venEmpAgenteRetencion: state.venEmpAgenteRetencion,
              venEmpContribuyenteEspecial: state.venEmpContribuyenteEspecial,
              venEmpLeyenda: state.venEmpLeyenda,
              venEmpIva: state.venEmpIva)
          .toJson(),
      "optionDocumento": 'F',
      "venTipoDocumento": "F",
      "venOption": "1",
      "rucempresa": rucempresa,
      "rol": rol,
      "venUser": usuario,
      "venEmpresa": rucempresa,
      "tabla": "venta",
    };

    try {
      // socket.emit('editar-registro', ventaMap);
      const result = true;
      await createUpdateVenta(ventaMap);
      // String jsonString = jsonEncode(ventaMap);

      // const int chunkSize = 800; // Tamaño de cada parte
      // for (int i = 0; i < jsonString.length; i += chunkSize) {
      //   // print(jsonString.substring(
      //   //     i,
      //   //     i + chunkSize > jsonString.length
      //   //         ? jsonString.length
      //   //         : i + chunkSize));
      // }

      // Actualizar el estado para indicar que ya no se está posteando
      state = state.copyWith(isPosting: false);
      return result;
    } catch (e) {
      // Actualizar el estado para indicar que ya no se está posteando
      state = state.copyWith(isPosting: false);

      return false;
    }
  }

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
  final ProductoInput nuevoProducto;
  final String productoSearch;
  final List<String> placasData;
  final Email nuevoEmail;
  final bool ocultarEmail;
  final double monto;
  final double porcentajeFormaPago;
// venRucCliente
  //*REGISTRO
  final GenericRequiredInput venRucCliente;
  final Productos venProductos;
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
  final String venOtros;
  final String venOtrosDetalles;
  final String venTelfCliente;
  final String venTipoDocuCliente;
  final String venTipoDocumento;
  final String venTotalRetencion;
  final String venUser;

  VentaFormState(
      {this.nuevoEmail = const Email.pure(),
      this.nuevoProducto = const ProductoInput.pure(),
      this.isFormValid = false,
      this.isPosted = false,
      this.isPosting = false,
      this.monto = 0,
      this.porcentajeFormaPago = 0,
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
      this.venDescPorcentaje = 0,
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
      this.placasData = const [],
      this.ocultarEmail = true,
      this.productoSearch = ''});
  VentaFormState copyWith(
      {Email? nuevoEmail,
      bool? isFormValid,
      bool? isPosted,
      bool? isPosting,
      double? monto,
      double? porcentajeFormaPago,
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
      String? venOtros,
      String? venOtrosDetalles,
      String? venTelfCliente,
      String? venTipoDocuCliente,
      String? venTipoDocumento,
      String? venTotalRetencion,
      String? venUser,
      List<String>? placasData,
      bool? ocultarEmail,
      String? productoSearch,
      ProductoInput? nuevoProducto}) {
    return VentaFormState(
      nuevoEmail: nuevoEmail ?? this.nuevoEmail,
      isFormValid: isFormValid ?? this.isFormValid,
      isPosted: isPosted ?? this.isPosted,
      isPosting: isPosting ?? this.isPosting,
      monto: monto ?? this.monto,
      porcentajeFormaPago: porcentajeFormaPago ?? this.porcentajeFormaPago,
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
      placasData: placasData ?? this.placasData,
      ocultarEmail: ocultarEmail ?? this.ocultarEmail,
      productoSearch: productoSearch ?? this.productoSearch,
      nuevoProducto: nuevoProducto ?? this.nuevoProducto,
    );
  }
}
