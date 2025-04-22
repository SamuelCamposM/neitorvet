import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/shared/provider/socket.dart';
import 'package:neitorvet/features/venta/domain/entities/forma_pago.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/venta/infrastructure/input/min_value_cliente.dart';
import 'package:neitorvet/features/venta/infrastructure/input/producto_input.dart';
import 'package:neitorvet/features/venta/infrastructure/input/productos.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_provider.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

final ventaFormProvider = StateNotifierProvider.family
    .autoDispose<VentaFormNotifier, VentaFormState, Venta>((ref, venta) {
  final createUpdateVenta =
      ref.watch(ventasProvider.notifier).createUpdateVenta;
  final formasPago = ref.watch(ventasProvider).formasPago;
  final iva = ref.watch(authProvider).user?.iva ?? 15;
  final rol = ref.watch(authProvider).user!.rol;
  final rucempresa = ref.watch(authProvider).user!.rucempresa;
  final usuario = ref.watch(authProvider).user!.usuario;

  final socket = ref.watch(socketProvider);
  return VentaFormNotifier(
    socket: socket,
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
  final io.Socket socket;
  VentaFormNotifier({
    required Venta venta,
    required this.createUpdateVenta,
    required this.formasPago,
    required this.socket,
    required this.iva,
    required this.rol,
    required this.rucempresa,
    required this.usuario,
  }) : super(VentaFormState(
          ventaForm: VentaForm.fromVenta(venta),
          placasData: [venta.venOtrosDetalles],
        )) {
    _initializeSocketListeners();
    setPorcentajeFormaPago(venta.venFormaPago);
  }
  void _initializeSocketListeners() {
    socket.on('connect', _onConnect);
    socket.on('disconnect', _onDisconnect);
    socket.on("server:actualizadoExitoso", _onActualizadoExitoso);
    socket.on("server:guardadoExitoso", _onGuardadoExitoso);
  }

  void _onConnect(dynamic data) {
    // Handle socket connection
  }

  void _onDisconnect(dynamic data) {
    // Handle socket disconnection
  }

  void _onActualizadoExitoso(dynamic data) {
    if (mounted) {
      try {
        if (data['tabla'] == 'proveedor') {
          // Edita de la lista de clientes
          final updatedCliente = Cliente.fromJson(data);
          if (updatedCliente.perUser == usuario) {
            updateState(
                permitirCredito: updatedCliente.perCredito == 'SI',
                placasData: updatedCliente.perOtros,
                ventaForm: state.ventaForm.copyWith(
                  venRucCliente: updatedCliente.perDocNumero,
                  venNomCliente: updatedCliente.perNombre,
                  venIdCliente: updatedCliente.perId,
                  venTipoDocuCliente: updatedCliente.perDocTipo,
                  venEmailCliente: updatedCliente.perEmail,
                  venTelfCliente: updatedCliente.perTelefono,
                  venCeluCliente: updatedCliente.perCelular,
                  venDirCliente: updatedCliente.perDireccion,
                  venOtrosDetalles: updatedCliente.perOtros.isEmpty
                      ? ""
                      : updatedCliente.perOtros[0],
                ));
          }
        }
      } catch (e) {
        print('hola');
        // print('Error handling server:actualizadoExitoso: $e');
      }
    }
  }

  void _onGuardadoExitoso(dynamic data) {
    print('LLEGANDO');
    if (mounted) {
      try {
        if (data['tabla'] == 'proveedor') {
          // Agrega a la lista de clientes
          final newCliente = Cliente.fromJson(data);
          if (newCliente.perUser == usuario) {
            updateState(
                permitirCredito: newCliente.perCredito == 'SI',
                placasData: newCliente.perOtros,
                ventaForm: state.ventaForm.copyWith(
                  venRucCliente: newCliente.perDocNumero,
                  venNomCliente: newCliente.perNombre,
                  venIdCliente: newCliente.perId,
                  venTipoDocuCliente: newCliente.perDocTipo,
                  venEmailCliente: newCliente.perEmail,
                  venTelfCliente: newCliente.perTelefono,
                  venCeluCliente: newCliente.perCelular,
                  venDirCliente: newCliente.perDireccion,
                  venOtrosDetalles:
                      newCliente.perOtros.isEmpty ? "" : newCliente.perOtros[0],
                ));
          }
        }
      } catch (e) {
        // print('Error handling server:actualizadoExitoso: $e');
      }
    }
  }

  void updateState(
      {String? nuevoEmail,
      String? productoSearch,
      Producto? nuevoProducto,
      String? monto,
      bool? permitirCredito,
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
      permitirCredito: permitirCredito ?? state.permitirCredito,
      placasData: placasData ?? state.placasData,
      ventaForm: ventaForm ?? state.ventaForm,
    );
    _touchedEverything(false);
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

    final resultTotales =
        Venta.calcularTotales(productos: newProductos, iva: iva.toDouble());

    state = state.copyWith(
        ventaForm: state.ventaForm.copyWith(
      venProductos: newProductos,
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

  bool agregarProducto(TextEditingController? controller) {
    const restrictedCodes = ['0101', '0185', '0121'];

    if (state.nuevoProducto.isNotValid) {
      state = state.copyWith(
          nuevoProducto: ProductoInput.dirty(const ProductoInput.pure().value));
      return true; // Devuelve true si hay un error
    }

    // Validar si el producto ya existe en la lista
    final productoExistente = state.ventaForm.venProductos
        .any((producto) => producto.codigo == state.nuevoProducto.value.codigo);

    if (productoExistente) {
      // Mostrar un mensaje o manejar el caso donde el producto ya existe
      state = state.copyWith(
        error: 'El producto ya existe en la lista',
      );
      _resetError();
      return true; // Devuelve true si hay un error
    }

// Validar si el nuevo producto tiene un código restringido
    final nuevoCodigo = state.nuevoProducto.value.codigo;
    if (restrictedCodes.contains(nuevoCodigo)) {
      // Verificar si ya hay un producto registrado con un código restringido
      final existeCodigoRestringido = state.ventaForm.venProductos
          .any((producto) => restrictedCodes.contains(producto.codigo));

      if (existeCodigoRestringido) {
        state = state.copyWith(
          error:
              'Solo puede haber un producto con los códigos: 0101, 0185, 0121',
        );
        _resetError();
        return true; // Devuelve true si hay un error
      }
    }
    final cantidad = state.monto / state.nuevoProducto.value.valorUnitario;
    print(cantidad);
    final producto = state.nuevoProducto.value.copyWith(
      cantidad: cantidad,
    );
    final result = [producto, ...state.ventaForm.venProductos];
    _calcularTotales(result, state.porcentajeFormaPago);
    state = state.copyWith(
      monto: 0,
      nuevoProducto: const ProductoInput.pure(),
    );
    controller?.text = '';
    return false; // Devuelve false si no hay error
  }

  void eliminarProducto(String codigo) {
    final updatedProductos = state.ventaForm.venProductosInput.value
        .where((producto) => producto.codigo != codigo)
        .toList();
    _calcularTotales(updatedProductos, state.porcentajeFormaPago);

    state = state.copyWith(
        ventaForm: state.ventaForm.copyWith(
      venProductos: updatedProductos,
    ));
  }

  // void printLargeMap(Map<String, dynamic> map, {int chunkSize = 20}) {
  //   final entries = map.entries.toList();
  //   final totalChunks = (entries.length / chunkSize).ceil();

  //   for (int i = 0; i < totalChunks; i++) {
  //     final start = i * chunkSize;
  //     final end = start + chunkSize;
  //     final chunk =
  //         entries.sublist(start, end > entries.length ? entries.length : end);

  //     final chunkMap =
  //         Map.fromEntries(chunk); // Convertir el fragmento en un mapa
  //     print('Parte ${i + 1} de $totalChunks: ${jsonEncode(chunkMap)}');
  //   }
  // }

  Future<bool> onFormSubmit() async {
    // Marcar todos los campos como tocados
    _touchedEverything(true);

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

    try {
      final ventaMap = {
        ...state.ventaForm
            .copyWith(
              optionDocumento:
                  state.ventaForm.venFormaPago == "CALIBRACIÓN" ? 'N' : 'F',
              venTipoDocumento:
                  state.ventaForm.venFormaPago == "CALIBRACIÓN" ? 'N' : "F",
            )
            .toVenta()
            .toJson(),
        "venOption": "1",
        "rucempresa": rucempresa,
        "rol": rol,
        "venUser": usuario,
        "venEmpresa": rucempresa,
        "tabla": "venta",
      };

      // print(ventaMap);
      // printLargeMap(ventaMap);
      const result = true;
      createUpdateVenta(ventaMap);

      // Actualizar el estado para indicar que ya no se está posteando
      state = state.copyWith(isPosting: false);
      return result;
    } catch (e) {
      // Actualizar el estado para indicar que ya no se está posteando
      state = state.copyWith(isPosting: false);

      return false;
    }
  }

  void _touchedEverything(bool submit) {
    if (submit) {
      state = state.copyWith(
          ventaForm: state.ventaForm.copyWith(
            venRucCliente: state.ventaForm.venRucCliente,
            venProductos: state.ventaForm.venProductos,
            venTotal: state.ventaForm.venTotal,
          ),
          isFormValid: Formz.validate([
            MinValueCliente.dirty(state.ventaForm.venTotal,
                venRucCliente: state.ventaForm.venRucCliente),
            GenericRequiredInput.dirty(state.ventaForm.venRucCliente),
            Productos.dirty(state.ventaForm.venProductos)
          ]));
    } else {
      state = state.copyWith(
          isFormValid: Formz.validate([
        MinValueCliente.dirty(state.ventaForm.venTotal,
            venRucCliente: state.ventaForm.venRucCliente),
        GenericRequiredInput.dirty(state.ventaForm.venRucCliente),
        Productos.dirty(state.ventaForm.venProductos)
      ]));
    }
  }

  void _resetError() {
    state = state.copyWith(error: '');
  }

  @override
  void dispose() {
    socket.off('connect', _onConnect);
    socket.off('disconnect', _onDisconnect);
    socket.off('server:actualizadoExitoso', _onActualizadoExitoso);
    socket.off('server:guardadoExitoso', _onGuardadoExitoso);

    // Log for debugging
    debugPrint('VentaFormNotifier disposed');
    super.dispose();
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
  final bool permitirCredito;
  final String error;
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
    this.permitirCredito = false,
    this.error = '',
    required this.ventaForm,
    // Make this parameter optional
  }); // Provide default value here

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
      VentaForm? ventaForm,
      bool? permitirCredito,
      String? error}) {
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
      ventaForm: ventaForm ?? this.ventaForm,
      permitirCredito: permitirCredito ?? this.permitirCredito,
      error: error ?? this.error,
    );
  }
}
