import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/domain/domain.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/repositories/cierre_surtidores_repository.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/provider/cierre_surtidores_repository_provider.dart';
import 'package:neitorvet/features/shared/provider/download_pdf.dart';
import 'package:neitorvet/features/shared/widgets/modal/dialog_alert.dart';
import 'package:neitorvet/features/venta/domain/datasources/ventas_datasource.dart';
import 'package:neitorvet/features/venta/domain/entities/forma_pago.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/surtidor.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/venta/domain/repositories/ventas_repository.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_repository_provider.dart';

import 'package:neitorvet/features/shared/provider/socket.dart';
import 'package:neitorvet/features/venta/presentation/widgets/prit_Sunmi.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum VentaEstado {
  facturas("FACTURAS"),
  sinAutorizar("SIN AUTORIZAR");
  // notaVentas("NOTA VENTAS"),
  // proformas("PROFORMAS"),
  // notaCreditos("NOTA CREDITOS");

  final String value;
  const VentaEstado(this.value);
}

class GetVentaResponse {
  final Venta? venta;
  final String error;

  GetVentaResponse({required this.venta, required this.error});
}

final ventasProvider =
    StateNotifierProvider.autoDispose<VentasNotifier, VentasState>(
  (ref) {
    final authState = ref.watch(authProvider);
    final getUsuarioNombre = ref.watch(authProvider.notifier).getUsuarioNombre;
    final ventasRepository = ref.watch(ventasRepositoryProvider);
    final cierreSurtidoresRepository =
        ref.watch(cierreSurtidoresRepositoryProvider);
    final socket = ref.watch(socketProvider);
    final downloadPDF = ref.watch(downloadPdfProvider.notifier).downloadPDF;
    return VentasNotifier(
      socket: socket,
      ventasRepository: ventasRepository,
      downloadPDF: downloadPDF,
      user: authState.user!,
      isAdmin: authState.isAdmin,
      cierreSurtidoresRepository: cierreSurtidoresRepository,
      getUsuarioNombre: getUsuarioNombre,
    );
  },
);

class VentasNotifier extends StateNotifier<VentasState> {
  final VentasRepository ventasRepository;
  final CierreSurtidoresRepository cierreSurtidoresRepository;
  final io.Socket socket;
  final User user;
  final bool isAdmin;
  final Future<void> Function(BuildContext? context, String infoPdf)
      downloadPDF;
  final Future<UsuarioNombreResponse> Function(String) getUsuarioNombre;
  VentasNotifier({
    required this.ventasRepository,
    required this.socket,
    required this.user,
    required this.downloadPDF,
    required this.cierreSurtidoresRepository,
    required this.isAdmin,
    required this.getUsuarioNombre,
  }) : super(VentasState()) {
    print('INIT VENTAS PROVIDER');
    _initializeSocketListeners();
    loadNextPage();
    _setFormasPago();
    _setSurtidores();
  }

  void resetImprimirFactura() {
    state = state.copyWith(
      mostrarImprimirFactura: false,
    );
  }

  Future loadNextPage() async {
    if (!isAdmin && state.page == 1) {
      return;
    }
    if (state.isLastPage || state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true);

    final ventas = await ventasRepository.getVentasByPage(
        cantidad: state.cantidad,
        page: state.page,
        search: state.search,
        estado: state.estado.value,
        input: state.input,
        orden: state.orden,
        busquedaVenta: state.busquedaVenta);

    if (ventas.error.isNotEmpty) {
      state = state.copyWith(isLoading: false, error: ventas.error);
      return;
    }
    if (ventas.resultado.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
        error: '',
        isLoading: false,
        page: state.page + 1,
        total: ventas.total,
        ventas: [...state.ventas, ...ventas.resultado]);
  }

  Future<List<Venta>> searchVentasByQueryWhileWasLoading() async {
    state = state.copyWith(isLoading: true);
    final ventas = await ventasRepository.getVentasByPage(
        search: state.search,
        cantidad: state.cantidad,
        input: state.input,
        orden: state.orden,
        page: 0,
        estado: state.estado.value,
        busquedaVenta: state.busquedaVenta);
    // ref.read(searchQueryProvider.notifier).update((state) => search);
    if (ventas.error.isNotEmpty) {
      state = state.copyWith(error: ventas.error, isLoading: false);
      return [];
    }

    state = state.copyWith(
        searchedVentas: ventas.resultado,
        totalSearched: ventas.total,
        total: ventas.total,
        ventas: ventas.resultado,
        isLastPage: false,
        isLoading: false,
        isSearching:
            state.search.isNotEmpty || state.busquedaVenta.isSearching());
    return ventas.resultado;
  }

  Future<List<Venta>> searchVentasByQuery({String search = ''}) async {
    final ventas = await ventasRepository.getVentasByPage(
      search: search,
      cantidad: state.cantidad,
      input: state.input,
      orden: state.orden,
      page: 0,
      estado: state.estado.value,
      busquedaVenta: state.busquedaVenta,
    );
    // ref.read(searchQueryProvider.notifier).update((state) => search);
    if (ventas.error.isNotEmpty) {
      state = state.copyWith(error: ventas.error, search: search);
      return [];
    }

    state = state.copyWith(
        search: search,
        searchedVentas: ventas.resultado,
        totalSearched: ventas.total,
        isLastPage: false,
        isSearching: search.isNotEmpty || state.busquedaVenta.isSearching());
    return ventas.resultado;
  }

  void setSearch(String search) {
    state = state.copyWith(search: search);
  }

  Future<GetVentaResponse> getVentaById(int venId) async {
    try {
      final exist = [...state.ventas, ...state.searchedVentas]
          .any((e) => e.venId == venId);
      if (!exist) {
        return GetVentaResponse(venta: null, error: 'No se encontró el venta');
      }
      return GetVentaResponse(
          venta: [...state.ventas, ...state.searchedVentas].firstWhere(
            (venta) => venta.venId == venId,
          ),
          error: '');
    } catch (e) {
      return GetVentaResponse(
          venta: null, error: 'Hubo un error al consultar el clinete');
    }
  }

  Future<void> resetQuery({
    String? search,
    VentaEstado? estado,
    String? input,
    bool? orden,
    BusquedaVenta? busquedaVenta,
  }) async {
    if (state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true);

    final ventas = await ventasRepository.getVentasByPage(
      cantidad: state.cantidad,
      page: 0,
      search: search ?? state.search,
      estado: estado?.value ?? state.estado.value,
      input: input ?? state.input,
      orden: orden ?? state.orden,
      busquedaVenta: busquedaVenta ?? state.busquedaVenta,
    );

    if (ventas.error.isNotEmpty) {
      state = state.copyWith(isLoading: false, error: ventas.error);
      return;
    }

    state = state.copyWith(
        isLoading: false,
        page: 1,
        total: ventas.total,
        ventas: ventas.resultado,
        search: search,
        estado: estado,
        input: input,
        orden: orden,
        isLastPage: false,
        busquedaVenta: busquedaVenta,
        isSearching: (search ?? state.search).isNotEmpty ||
            (busquedaVenta ?? state.busquedaVenta).isSearching());
  }

  void handleSearch() async {
    if (state.search.isEmpty) {
      return;
    }
    state = state.copyWith(
        total: state.totalSearched,
        ventas: state.searchedVentas,
        page: 1,
        searchedVentas: [],
        totalSearched: 0);
  }

  Future<void> createUpdateVenta(Map<String, dynamic> ventaMap) async {
    socket.emit('client:guardarData', ventaMap);
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
  void verificarEstadoVenta(Venta venta, BuildContext context) {
    if (venta.venEstado == "SIN AUTORIZAR") {
      final fechaFactura = DateTime.parse(venta.venFechaFactura);
      final hoy = DateTime.now();

      // Calcula la diferencia en días
      final diferencia = hoy.difference(fechaFactura).inDays;

      if (diferencia > 3) {
        // Mostrar alerta si han pasado más de 3 días
        mostrarAlerta(
          context,
          "Han pasado más de 3 días desde la fecha de la factura.",
          true,
        );
      } else {
        // Emitir evento al servidor si no han pasado más de 3 días

        socket.emit("client:guardarData", {
          ...venta.toJson(), // Incluye los datos de la venta
          "venOption": "3",
          "optionDocumento": venta.venTipoDocumento,
          "rucempresa": user.rucempresa,
          "rol": user.rol,
          "venUserUpdate": user.usuario,
          "venEmpresa": user.rucempresa,
          "venProductosAntiguos": venta.venProductos,
          "tabla": "venta",
        });
      }
    }
  }

  Future<void> _setFormasPago() async {
    state = state.copyWith(
      isLoading: true,
    );
    final formasPago = await ventasRepository.getFormasPago();
    if (formasPago.error.isNotEmpty) {
      state = state.copyWith(
          error: 'Hubo un error al obtener las formas de pago',
          isLoading: false);
      return;
    }
    state = state.copyWith(
      formasPago: formasPago.resultado,
      isLoading: false,
    );
  }

  Future<void> _setSurtidores() async {
    state = state.copyWith(
      isLoading: true,
    );
    final surtidoresResponse = await cierreSurtidoresRepository.getSurtidores();
    if (surtidoresResponse.error.isNotEmpty) {
      state = state.copyWith(
          error: 'Hubo un error al obtener los surtidores', isLoading: false);

      return;
    }
    state = state.copyWith(
        surtidoresData: surtidoresResponse.resultado, isLoading: false);
  }

  Future<ResponseSecuencia> getSecuencia() async {
    final estado = state.estado == VentaEstado.facturas ||
            state.estado == VentaEstado.sinAutorizar
        ? "FACTURA"
        // : state.estado == VentaEstado.notaVenta
        //     ? "NOTA DE VENTA"
        //     : state.estado == VentaEstado.proformas
        //         ? "PROFORMA"
        //         : state.estado == VentaEstado.notaCreditos
        //             ? "NOTA DE CREDITO"
        : '';
    final response = await ventasRepository.getSecuencia(estado);

    return response;
  }

  List<Surtidor> getUniqueSurtidores() {
    final Set<String> uniqueNames = {};
    final List<Surtidor> uniqueSurtidores = [];

    for (var surtidor in state.surtidoresData) {
      if (uniqueNames.add(surtidor.nombreSurtidor)) {
        uniqueSurtidores.add(surtidor);
      }
    }

    return uniqueSurtidores;
  }

  List<Surtidor> getLados(String nombreSurtidor) {
    return state.surtidoresData
        .where((surtidor) => surtidor.nombreSurtidor == nombreSurtidor)
        .toList();
  }

  void resetError() {
    state = state.copyWith(error: '');
  }

  void _initializeSocketListeners() {
    socket.on('connect', _onConnect);
    socket.on('disconnect', _onDisconnect);
    socket.on("server:actualizadoExitoso", _onActualizadoExitoso);
    socket.on("server:guardadoExitoso", _onGuardadoExitoso);
    socket.on("server:error", _onError);
  }

  void _onConnect(dynamic data) {
    print('Socket conectado ventas');
  }

  void _onDisconnect(dynamic data) {
    print('Socket desconectado');
  }

  void _onActualizadoExitoso(dynamic data) {
    try {
      print('HOLA EDITANDO');
      if (mounted) {
        if (data['tabla'] == 'venta' && data['rucempresa'] == user.rucempresa) {
          // Edita de la lista de ventas
          final updatedVenta = Venta.fromJson(data);
          final updatedVentasList = state.ventas.map((venta) {
            return venta.venId == updatedVenta.venId ? updatedVenta : venta;
          }).toList();
          state = state.copyWith(ventas: updatedVentasList);
        }
      }
    } catch (e) {
      print('Error en _onActualizadoExitoso: $e');
    }
  }

  void _onGuardadoExitoso(dynamic data) async {
    try {
      if (mounted) {
        print('LLEGANDO DATA ${data['tabla']}');
        if (data['tabla'] == 'venta' && data['rucempresa'] == user.rucempresa) {
          // Agrega a la lista de ventas
          final newVenta = Venta.fromJson(data);
          if (isAdmin || newVenta.venUser == user.usuario) {
            if (newVenta.venUser == user.usuario) {
              printTicket(newVenta, user, user.nombre);
            }
            state = state.copyWith(ventas: [
              newVenta,
              ...state.ventas,
            ]);
          }
        }
      }
    } catch (e) {
      print('Error en _onGuardadoExitoso: $e');
    }
  }

  void _onError(dynamic data) {
    try {
      if (mounted) {
        state = state.copyWith(
            error: data['msg'] ?? "Hubo un error ${data['tabla']}");
      }
    } catch (e) {
      print('Error en _onError: $e');
    }
  }

  @override
  void dispose() {
    // Limpia los listeners del socket
    socket.off('connect', _onConnect);
    socket.off('disconnect', _onDisconnect);
    socket.off("server:actualizadoExitoso", _onActualizadoExitoso);
    socket.off("server:guardadoExitoso", _onGuardadoExitoso);
    socket.off("server:error", _onError);

    print('Dispose VENTAS PROVIDER');
    super.dispose();
  }
}

class VentasState {
  final bool isLastPage;
  final bool isLoading;
  final int cantidad;
  final int page;
  final List<Venta> ventas;
  final String error;
  final int total;
  final String search;
  final VentaEstado estado;
  final String input;
  final bool orden;
  final List<Venta> searchedVentas;
  final int totalSearched;
  final List<FormaPago> formasPago;
  final BusquedaVenta busquedaVenta;
  final bool isSearching;
  final bool mostrarImprimirFactura;
  final List<Surtidor> surtidoresData;
  VentasState(
      {this.isLastPage = false,
      this.isLoading = false,
      this.cantidad = 10,
      this.page = 0,
      this.ventas = const [],
      this.error = '',
      this.total = 0,
      this.search = '',
      this.estado = VentaEstado.facturas,
      this.input = 'venId',
      this.orden = false,
      this.searchedVentas = const [],
      this.totalSearched = 0,
      this.formasPago = const [],
      this.busquedaVenta = const BusquedaVenta(),
      this.isSearching = false,
      this.mostrarImprimirFactura = false,
      this.surtidoresData = const []});

  VentasState copyWith(
      {bool? isLastPage,
      bool? isLoading,
      int? cantidad,
      int? page,
      List<Venta>? ventas,
      String? error,
      int? total,
      String? search,
      VentaEstado? estado,
      String? input,
      bool? orden,
      List<Venta>? searchedVentas,
      int? totalSearched,
      List<FormaPago>? formasPago,
      BusquedaVenta? busquedaVenta,
      bool? isSearching,
      bool? mostrarImprimirFactura,
      List<Surtidor>? surtidoresData}) {
    return VentasState(
      isLastPage: isLastPage ?? this.isLastPage,
      isLoading: isLoading ?? this.isLoading,
      cantidad: cantidad ?? this.cantidad,
      page: page ?? this.page,
      ventas: ventas ?? this.ventas,
      error: error ?? this.error,
      total: total ?? this.total,
      search: search ?? this.search,
      estado: estado ?? this.estado,
      input: input ?? this.input,
      orden: orden ?? this.orden,
      searchedVentas: searchedVentas ?? this.searchedVentas,
      totalSearched: totalSearched ?? this.totalSearched,
      formasPago: formasPago ?? this.formasPago,
      busquedaVenta: busquedaVenta ?? this.busquedaVenta,
      isSearching: isSearching ?? this.isSearching,
      mostrarImprimirFactura:
          mostrarImprimirFactura ?? this.mostrarImprimirFactura,
      surtidoresData: surtidoresData ?? this.surtidoresData,
    );
  }
}
