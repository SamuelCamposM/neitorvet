import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:neitorvet/features/administracion/domain/entities/manguera_status.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/datasources/cierre_surtidores_datasource.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/provider/cierre_surtidores_repository_provider.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/screens/menu_despacho.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';
import 'package:neitorvet/features/shared/provider/socket.dart';
import 'package:neitorvet/features/venta/domain/datasources/ventas_datasource.dart';
import 'package:neitorvet/features/venta/domain/entities/abastecimiento.dart';
import 'package:neitorvet/features/venta/domain/entities/forma_pago.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/venta/infrastructure/input/min_value_cliente.dart';
import 'package:neitorvet/features/venta/infrastructure/input/producto_input.dart';
import 'package:neitorvet/features/venta/infrastructure/input/productos.dart';
import 'package:neitorvet/features/venta/presentation/provider/tabs_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_provider.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class VentaFormProviderParams {
  final bool editar;
  final int id;
  final String manguera;
  VentaFormProviderParams(
      {required this.editar, required this.id, this.manguera = ''});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VentaFormProviderParams &&
        other.editar == editar &&
        other.id == id;
  }

  @override
  int get hashCode => editar.hashCode ^ id.hashCode;
}

final ventaFormProvider = StateNotifierProvider.family
    .autoDispose<VentaFormNotifier, VentaFormState, VentaFormProviderParams>(
        (ref, params) {
  final ventasProviderNotifier = ref.read(ventasProvider.notifier);
  final removeTabById = ref.watch(tabsProvider.notifier).removeTabById;
  final surtidoresProvider = ref.read(cierreSurtidoresRepositoryProvider);
  final formasPago = ref.read(ventasProvider).formasPago;
  final user = ref.read(authProvider).user!;
  final iva = user.iva;
  final rol = user.rol;
  final rucempresa = user.rucempresa;
  final usuario = user.usuario;
  final socket = ref.watch(socketProvider);
  return VentaFormNotifier(
    socket: socket,
    createUpdateVenta: ventasProviderNotifier.createUpdateVenta,
    setModoManguera: surtidoresProvider.setModoManguera,
    getLastDispatch: surtidoresProvider.getLastDispatch,
    ventaFormProviderParams: params,
    removeTabById: removeTabById,
    getSecuencia: ventasProviderNotifier.getSecuencia,
    getVentaById: ventasProviderNotifier.getVentaById,
    iva: iva,
    formasPago: formasPago,
    rol: rol,
    rucempresa: rucempresa,
    usuario: usuario,
  );
});

class VentaFormNotifier extends StateNotifier<VentaFormState> {
  final Future<void> Function(Map<String, dynamic> ventaMap) createUpdateVenta;
  Future<ResponseModoManguera> Function(
      {required String manguera, required String modo}) setModoManguera;
  final Function(int id) removeTabById;
  final int iva;
  final List<FormaPago> formasPago;
  final List<String> rol;
  final String rucempresa;
  final String usuario;
  final io.Socket socket;
  final Future<ResponseSecuencia> Function() getSecuencia;
  final Future<GetVentaResponse> Function(int venId) getVentaById;
  final Future<ResponseLastDispatch> Function({required String manguera})
      getLastDispatch;

  VentaFormNotifier({
    required this.getSecuencia,
    required this.setModoManguera,
    required this.removeTabById,
    required this.getVentaById,
    required ventaFormProviderParams,
    required this.createUpdateVenta,
    required this.formasPago,
    required this.socket,
    required this.iva,
    required this.rol,
    required this.rucempresa,
    required this.usuario,
    required this.getLastDispatch,
  }) : super(VentaFormState(
            ventaForm: VentaForm.fromVenta(Venta.defaultVenta()),
            ventaFormProviderParams: ventaFormProviderParams
            // placasData: [venta.venOtrosDetalles],
            )) {
    _initializeSocketListeners();
    loadVenta();
  }

  void loadVenta() async {
    if (!state.ventaFormProviderParams.editar) {
      getSecuencia().then((value) {
        if (value.error.isNotEmpty) {
          state = state.copyWith(error: value.error);
          return;
        }
        state = state.copyWith(
            isLoading: false,
            secuencia: value.resultado,
            ventaForm: state.ventaForm.copyWith(
              venNumFactura: value.resultado,
            ));
      });
    }
    state = state.copyWith(
      isLoading: false,
    );
  }

  void _initializeSocketListeners() {
    print("server:guardadoExitoso.${state.ventaFormProviderParams.id}");
    socket.on('connect', _onConnect);
    socket.on('disconnect', _onDisconnect);
    socket.on("server:actualizado_exitoso.${state.ventaFormProviderParams.id}",
        _onActualizadoExitoso);
    socket.on("server:guardado_exitoso.${state.ventaFormProviderParams.id}",
        _onGuardadoExitoso);
  }

  void _onConnect(dynamic data) {
    // Handle socket connection
  }

  void _onDisconnect(dynamic data) {
    // Handle socket disconnection
  }

  void _onActualizadoExitoso(dynamic data) {
    try {
      if (data['tabla'] == 'proveedor') {
        // Edita de la lista de clientes
        final updatedCliente = Cliente.fromJson(data);
        if (updatedCliente.perUser == usuario &&
            updatedCliente.ventaTab == state.ventaFormProviderParams.id) {
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
                venFlota: updatedCliente.perFlota,
                venOtrosDetalles: updatedCliente.perOtros.isEmpty
                    ? ""
                    : updatedCliente.perOtros[0],
              ));
        }
      }
    } catch (e) {
      e;
    }
  }

  void _onGuardadoExitoso(dynamic data) {
    try {
      if (data['tabla'] == 'proveedor') {
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
                venFlota: newCliente.perFlota,
                venOtrosDetalles:
                    newCliente.perOtros.isEmpty ? "" : newCliente.perOtros[0],
              ));
        }
      }
    } catch (e) {
      e;
    }
  }

  void updateState({
    String? nuevoEmail,
    String? productoSearch,
    Producto? nuevoProducto,
    String? monto,
    String? cantidad,
    bool? permitirCredito,
    List<String>? placasData,
    VentaForm? ventaForm,
  }) {
    state = state.copyWith(
      nuevoEmail:
          nuevoEmail != null ? Email.dirty(nuevoEmail) : state.nuevoEmail,
      nuevoProducto: nuevoProducto != null
          ? ProductoInput.dirty(nuevoProducto)
          : state.nuevoProducto,
      monto: monto == '' ? 0 : double.tryParse(monto ?? "") ?? state.monto,
      cantidad: cantidad == ''
          ? 0
          : double.tryParse(cantidad ?? "") ?? state.cantidad,
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

  bool agregarProducto(
      TextEditingController? controller, TextEditingController? controller2,
      {bool sinAlerta = false, bool conCantidad = false}) {
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
        error: sinAlerta ? "" : 'El producto ya existe en la lista',
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
    if (conCantidad && state.cantidad <= 0) {
      state = state.copyWith(
        error: 'La cantidad debe ser mayor a cero',
      );
      _resetError();
      return true; // Devuelve true si hay un error
    }
    if ((state.ventaForm.abastecimiento?.valorTotal ?? state.monto) == 0 &&
        !conCantidad) {
      state = state.copyWith(
        error: 'El valor no puede ser cero',
      );
      _resetError();
      return true; // Devuelve true si hay un error
    }

    final cantidad = conCantidad
        ? state.cantidad
        : (state.ventaForm.abastecimiento?.valorTotal ?? state.monto) /
            state.nuevoProducto.value.valorUnitario;
    final producto = state.nuevoProducto.value.copyWith(
      cantidad: cantidad,
    );
    final result = [producto, ...state.ventaForm.venProductos];
    _calcularTotales(result, state.porcentajeFormaPago);
    state = state.copyWith(
      monto: 0,
      cantidad: 0,
      nuevoProducto: const ProductoInput.pure(),
    );
    controller?.text = '';
    controller2?.text = '';
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

  void printLargeMap(Map<String, dynamic> map, {int chunkSize = 20}) {
    final entries = map.entries.toList();
    final totalChunks = (entries.length / chunkSize).ceil();

    for (int i = 0; i < totalChunks; i++) {
      final start = i * chunkSize;
      final end = start + chunkSize;
      final chunk =
          entries.sublist(start, end > entries.length ? entries.length : end);

      final chunkMap = Map.fromEntries(chunk);
      // Convertir el fragmento en un mapa
      print('Parte ${i + 1} de $totalChunks: ${jsonEncode(chunkMap)}');
    }
  }

  Future<bool> onFormSubmit() async {
    // Marcar todos los campos como tocados
    _touchedEverything(true);

    // Esperar un breve momento para asegurar que el estado se actualice
    if (state.ventaForm.venTotal == 0) {
      state = state.copyWith(error: 'El total no puede ser cero');
      // Si el formulario está en modo edición, no se permite volver a enviar

      _resetError();
      return false;
    }
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
              venFlota: Format.limpiarComillas(state.ventaForm.venFlota),
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
      printLargeMap(ventaMap);
      createUpdateVenta(ventaMap);
      setModoManguera(manguera: state.manguera, modo: '03');
      final volver = removeTabById(state.ventaFormProviderParams.id);

      // Actualizar el estado para indicar que ya no se está posteando
      state = state.copyWith(isPosting: false, saved: true);
      return volver;
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

  void setValor(double? valor) {
    state = state.copyWith(valor: valor);
  }

  void setValoresEstacion(ResponseModalEstacion response) async {
    final res = await getLastDispatch(
      manguera: response.estacion.numeroPistola.toString(),
    );
    state = state.copyWith(
      manguera: response.estacion.numeroPistola.toString(),
      nombreCombustible: response.estacion.nombreProducto.toString(),
      indiceMemoria: res.abastecimientoSocket?.indiceMemoria.toString(),
    );
  }

  void setEstadoManguera(Datum? estadoManguera) {
    state = state.copyWith(estadoManguera: estadoManguera);
  }

  void setAbastecimiento() async {
    final res = await getLastDispatch(
      manguera: state.manguera,
    );

    if (res.error.isNotEmpty) {
      state = state.copyWith(error: res.error);

      _resetError();
      return;
    }
    final abastecimientoSocket = res.abastecimientoSocket;

    if (abastecimientoSocket != null) {
      if (
          abastecimientoSocket.indiceMemoria == state.indiceMemoria
           &&
          Parse.parseDynamicToString(abastecimientoSocket.pico) !=
              state.manguera) {
        state = state.copyWith(
          error: 'No hay abastecimiento nuevo',
        );
        _resetError();
        // Si el índice de memoria es el mismo, no hacer nada
        return;
      }
      if (state.manguera.isNotEmpty) {
        // Variables para descripción y código según el códigoCombustible

        // Asignar valores según el códigoCombustible
        final info =
            Format.getCombustibleInfo(abastecimientoSocket.codigoCombustible);
        final descripcion = info.descripcion;
        final codigo = info.codigo;

        setValor(abastecimientoSocket.total);
        updateState(
          ventaForm: state.ventaForm.copyWith(
            manguera: abastecimientoSocket.pico.toString(),
            // idAbastecimiento: Parse.parseDynamicToInt(
            //     abastecimientoSocket.indiceMemoria),
            totInicio: abastecimientoSocket.totalizadorInicial,
            totFinal: abastecimientoSocket.totalizadorFinal,
            abastecimiento: Abastecimiento(
              registro: abastecimientoSocket.indiceMemoria, //indice_memoria
              pistola: abastecimientoSocket.pico, //pico
              numeroTanque: abastecimientoSocket.tanque, //tanque
              codigoCombustible:
                  abastecimientoSocket.codigoCombustible, //tanque
              valorTotal: abastecimientoSocket.total, //total
              volTotal: abastecimientoSocket.volumen, //volumen
              precioUnitario: abastecimientoSocket.precioUnitario,
              tiempo:
                  abastecimientoSocket.duracionSegundos, // duracion_segundos
              fechaHora:
                  '${abastecimientoSocket.fecha} ${abastecimientoSocket.hora}', // fecha
              // "": "08:50:09",
              totInicio: abastecimientoSocket.totalizadorInicial,
              totFinal: abastecimientoSocket.totalizadorFinal,
              iDoperador: abastecimientoSocket.idFrentista, //id_frentista
              iDcliente: abastecimientoSocket.idCliente, //id_cliente
              volTanque: Parse.parseDynamicToInt(abastecimientoSocket
                  .odometroOVolTanque), //odometro_o_vol_tanque
              facturado: 1,
              nombreCombustible: descripcion, //descripcion
              usuario: usuario,
              cedulaCliente: state.ventaForm.venRucCliente,
              nombreCliente: state.ventaForm.venNomCliente,
            ),
          ),
          nuevoProducto: Producto(
            cantidad: 0,
            codigo: codigo,
            descripcion: descripcion,
            valUnitarioInterno:
                Parse.parseDynamicToDouble(abastecimientoSocket.precioUnitario),
            valorUnitario:
                Parse.parseDynamicToDouble(abastecimientoSocket.precioUnitario),
            llevaIva: 'SI',
            incluyeIva: 'SI',
            recargoPorcentaje: 0,
            recargo: 0,
            descPorcentaje: state.ventaForm.venDescPorcentaje,
            descuento: 0,
            precioSubTotalProducto: 0,
            valorIva: 0,
            costoProduccion: 0,
          ),
          monto: abastecimientoSocket.total.toString(),
        );
        agregarProducto(null, null, sinAlerta: true);
        state = state.copyWith(puedeGuardar: true);
      }
    } else {
      state = state.copyWith(
        error: 'No hay abastecimiento',
      );
      _resetError();
      // Si el índice de memoria es el mismo, no hacer nada
      return;
    }
  }

  @override
  void dispose() {
    socket.off('connect', _onConnect);
    socket.off('disconnect', _onDisconnect);
    socket.off("server:actualizado_exitoso.${state.ventaFormProviderParams.id}",
        _onActualizadoExitoso);
    socket.off("server:guardado_exitoso.${state.ventaFormProviderParams.id}",
        _onGuardadoExitoso);
    // Log for debugging

    print('Dispose VENTA FORM');
    super.dispose();
  }
}

class VentaFormState {
  // final Venta venta;
  final VentaFormProviderParams ventaFormProviderParams;
  final bool isLoading;
  final String error;
  final String secuencia;

  //* FORMULARIO
  final bool isFormValid;
  final bool isPosted;
  final bool isPosting;
  final bool ocultarEmail;
  final double monto;
  final double cantidad;
  final double porcentajeFormaPago;
  final Email nuevoEmail;
  final List<String> placasData;
  final ProductoInput nuevoProducto;
  final String productoSearch;
  final VentaForm ventaForm;
  final bool permitirCredito;
  //* MANGUERA
  final String nombreCombustible;
  final String manguera;
  final double? valor;
  final Datum estadoManguera;
  final bool saved;
  final bool puedeGuardar;
  //*indice
  final String indiceMemoria;
  VentaFormState({
// //* VENTA
    required this.ventaFormProviderParams,

    // required this.venta,
    this.isLoading = true,
    this.error = '',
    this.secuencia = '',
//* VENTA-FORM
    required this.ventaForm,
    this.nuevoEmail = const Email.pure(),
    this.nuevoProducto = const ProductoInput.pure(),
    this.isFormValid = false,
    this.isPosted = false,
    this.isPosting = false,
    this.monto = 0,
    this.cantidad = 0,
    this.porcentajeFormaPago = 0,
    this.placasData = const [],
    this.ocultarEmail = true,
    this.productoSearch = '',
    this.permitirCredito = false,
    // Make this parameter optional
    this.manguera = '', // Provide default value here
    this.nombreCombustible = '', // Provide default value here
    this.valor,
    this.estadoManguera = Datum.L, // Provide default value here
    this.saved = false,
    this.indiceMemoria = '', // Provide default value here
    this.puedeGuardar = false, // Provide default value here
  }); // Provide default value here

  VentaFormState copyWith({
    VentaFormProviderParams? ventaFormProviderParams,
    bool? isLoading,
    String? secuencia,
    Email? nuevoEmail,
    bool? isFormValid,
    bool? isPosted,
    bool? isPosting,
    double? monto,
    double? cantidad,
    double? porcentajeFormaPago,
    List<String>? placasData,
    bool? ocultarEmail,
    String? productoSearch,
    ProductoInput? nuevoProducto,
    VentaForm? ventaForm,
    bool? permitirCredito,
    String? error,
    String? manguera,
    String? nombreCombustible,
    double? valor,
    Datum? estadoManguera,
    bool? saved,
    String? indiceMemoria,
    bool? puedeGuardar,
  }) {
    return VentaFormState(
      ventaFormProviderParams:
          ventaFormProviderParams ?? this.ventaFormProviderParams,
      isLoading: isLoading ?? this.isLoading,
      secuencia: secuencia ?? this.secuencia,
      isFormValid: isFormValid ?? this.isFormValid,
      isPosted: isPosted ?? this.isPosted,
      isPosting: isPosting ?? this.isPosting,
      monto: monto ?? this.monto,
      cantidad: cantidad ?? this.cantidad,
      nuevoEmail: nuevoEmail ?? this.nuevoEmail,
      nuevoProducto: nuevoProducto ?? this.nuevoProducto,
      ocultarEmail: ocultarEmail ?? this.ocultarEmail,
      placasData: placasData ?? this.placasData,
      porcentajeFormaPago: porcentajeFormaPago ?? this.porcentajeFormaPago,
      productoSearch: productoSearch ?? this.productoSearch,
      ventaForm: ventaForm ?? this.ventaForm,
      permitirCredito: permitirCredito ?? this.permitirCredito,
      error: error ?? this.error,
      manguera: manguera ?? this.manguera,
      nombreCombustible: nombreCombustible ?? this.nombreCombustible,
      valor: valor ?? this.valor,
      estadoManguera: estadoManguera ?? this.estadoManguera,
      saved: saved ?? this.saved,
      indiceMemoria: indiceMemoria ?? this.indiceMemoria,
      puedeGuardar: puedeGuardar ?? this.puedeGuardar,
    );
  }
}
