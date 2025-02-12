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
          ventaForm: VentaForm.fromVenta(venta),
          placasData: [venta.venOtrosDetalles],
        )) {
    setPorcentajeFormaPago(venta.venFormaPago);
  }

  void updateState(
      {String? nuevoEmail,
      String? productoSearch,
      Producto? nuevoProducto,
      String? monto,
      List<String>? placasData,
      VentaForm? ventaForm}) {
    state = state.copyWith(
      nuevoEmail:
          nuevoEmail != null ? Email.dirty(nuevoEmail) : state.nuevoEmail,
      nuevoProducto: nuevoProducto != null
          ? ProductoInput.dirty(nuevoProducto)
          : state.nuevoProducto,
      monto: monto == '' ? 0 : double.tryParse(monto ?? "") ?? state.monto,
      productoSearch: productoSearch ?? state.productoSearch,
      placasData: placasData ?? state.placasData,
      ventaForm: ventaForm ?? state.ventaForm,
    );
  }

  bool agregarEmail(TextEditingController controller) {
    if (state.nuevoEmail.isNotValid) {
      state = state.copyWith(nuevoEmail: Email.dirty(state.nuevoEmail.value));
      return false;
    }

    state = state.copyWith(
        nuevoEmail: const Email.pure(),
        ventaForm: state.ventaForm.copyWith(venEmailCliente: [
          state.nuevoEmail.value,
          ...state.ventaForm.venEmailCliente
        ]));
    controller.text = '';
    return true;
  }

  void eliminarEmail(String email) {
    final updatedEmails =
        state.ventaForm.venEmailCliente.where((e) => e != email).toList();

    state = state.copyWith(
        isFormValid:
            Formz.validate([GenericRequiredListStr.dirty(updatedEmails)]),
        ventaForm: state.ventaForm.copyWith(
          venEmailCliente: updatedEmails,
        ));
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
        ventaForm: state.ventaForm.copyWith(
      venProductosInput: Productos.dirty(newProductos),
      venCostoProduccion: resultTotales.venCostoProduccion,
      venDescuento: resultTotales.venDescuento,
      venSubTotal: resultTotales.venSubTotal,
      venSubTotal12: resultTotales.venSubTotal12,
      venSubtotal0: resultTotales.venSubtotal0,
      venTotal: resultTotales.venTotal,
      venTotalIva: resultTotales.venTotalIva,
    ));
  }

  void setPorcentajeFormaPago(String formaDePago) {
    final exist = formasPago.any((e) => e.fpagoNombre == formaDePago);
    if (exist) {
      final formaPagoF = formasPago.firstWhere(
        (venta) => venta.fpagoNombre == formaDePago,
      );
      _calcularTotales(state.ventaForm.venProductosInput.value,
          double.parse(formaPagoF.fpagoPorcentaje));

      state = state.copyWith(
          porcentajeFormaPago: double.parse(formaPagoF.fpagoPorcentaje));
    }
  }

  void agregarProducto(TextEditingController controller) {
    if (state.nuevoProducto.isNotValid) {
      state = state.copyWith(
          nuevoProducto: ProductoInput.dirty(const ProductoInput.pure().value));
      return;
    }
    final producto = state.nuevoProducto.value.copyWith(
        cantidad: state.monto / state.nuevoProducto.value.valorUnitario);

    final result = [producto, ...state.ventaForm.venProductosInput.value];
    _calcularTotales(result, state.porcentajeFormaPago);
    state = state.copyWith(
      monto: 0,
      nuevoProducto: const ProductoInput.pure(),
    );
    controller.text = '';
  }

  void eliminarProducto(String codigo) {
    final updatedProductos = state.ventaForm.venProductosInput.value
        .where((producto) => producto.codigo != codigo)
        .toList();
    _calcularTotales(updatedProductos, state.porcentajeFormaPago);

    state = state.copyWith(
        ventaForm: state.ventaForm.copyWith(
      venProductosInput: Productos.dirty(updatedProductos),
    ));
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
      ...state.ventaForm.toVenta().toJson(),
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
      GenericRequiredInput.dirty(state.ventaForm.venRucClienteInput.value),
      Productos.dirty(state.ventaForm.venProductosInput.value)
    ]));
  }
}

class VentaFormState {
  final bool isFormValid;
  final bool isPosted;
  final bool isPosting;
  final bool ocultarEmail;
  final double monto;
  final double porcentajeFormaPago;
  final Email nuevoEmail;
  final List<String> placasData;
  final ProductoInput nuevoProducto;
  final String productoSearch;
  final VentaForm ventaForm;

  VentaFormState({
    this.nuevoEmail = const Email.pure(),
    this.nuevoProducto = const ProductoInput.pure(),
    this.isFormValid = false,
    this.isPosted = false,
    this.isPosting = false,
    this.monto = 0,
    this.porcentajeFormaPago = 0,
    this.placasData = const [],
    this.ocultarEmail = true,
    this.productoSearch = '',
    VentaForm? ventaForm, // Make this parameter optional
  }) : ventaForm = ventaForm ?? VentaForm(); // Provide default value here

  VentaFormState copyWith(
      {Email? nuevoEmail,
      bool? isFormValid,
      bool? isPosted,
      bool? isPosting,
      double? monto,
      double? porcentajeFormaPago,
      List<String>? placasData,
      bool? ocultarEmail,
      String? productoSearch,
      ProductoInput? nuevoProducto,
      VentaForm? ventaForm}) {
    return VentaFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        isPosted: isPosted ?? this.isPosted,
        isPosting: isPosting ?? this.isPosting,
        monto: monto ?? this.monto,
        nuevoEmail: nuevoEmail ?? this.nuevoEmail,
        nuevoProducto: nuevoProducto ?? this.nuevoProducto,
        ocultarEmail: ocultarEmail ?? this.ocultarEmail,
        placasData: placasData ?? this.placasData,
        porcentajeFormaPago: porcentajeFormaPago ?? this.porcentajeFormaPago,
        productoSearch: productoSearch ?? this.productoSearch,
        ventaForm: ventaForm ?? this.ventaForm);
  }
}
