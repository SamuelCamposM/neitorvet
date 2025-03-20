import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:neitorvet/features/auth/domain/domain.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/shared/provider/download_pdf.dart';
import 'package:neitorvet/features/venta/domain/datasources/ventas_datasource.dart';
import 'package:neitorvet/features/venta/domain/entities/forma_pago.dart';
import 'package:neitorvet/features/venta/domain/entities/surtidor.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/venta/domain/repositories/ventas_repository.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_repository_provider.dart';

import 'package:neitorvet/features/shared/provider/socket.dart';
import 'package:neitorvet/features/venta/presentation/widgets/prit_Sunmi.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class GetVentaResponse {
  final Venta? venta;
  final String error;

  GetVentaResponse({required this.venta, required this.error});
}

final ventasProvider =
    StateNotifierProvider.autoDispose<VentasNotifier, VentasState>(
  (ref) {
    final user = ref.watch(authProvider).user;

    final ventasRepository = ref.watch(ventasRepositoryProvider);
    final socket = ref.watch(socketProvider);
    final downloadPDF = ref.watch(downloadPdfProvider.notifier).downloadPDF;
    return VentasNotifier(
        socket: socket,
        ventasRepository: ventasRepository,
        downloadPDF: downloadPDF,
        user: user!);
  },
);

class VentasNotifier extends StateNotifier<VentasState> {
  final VentasRepository ventasRepository;
  final io.Socket socket;
  final User user;
  final Future<void> Function(BuildContext? context, String infoPdf)
      downloadPDF;
  VentasNotifier(
      {required this.ventasRepository,
      required this.socket,
      required this.user,
      required this.downloadPDF})
      : super(VentasState()) {
    _initializeSocketListeners();
    loadNextPage();
    _setFormasPago();
    _setSurtidores();
  }
  void _initializeSocketListeners() {
    socket.on('disconnect', (_) {});

    socket.on('connect', (_) {});

    socket.on("server:actualizadoExitoso", (data) {
      if (data['tabla'] == 'venta') {
        // Edita de la lista de ventas
        final updatedVenta = Venta.fromJson(data);
        final updatedVentasList = state.ventas.map((venta) {
          return venta.venId == updatedVenta.venId ? updatedVenta : venta;
        }).toList();
        state = state.copyWith(ventas: updatedVentasList);
      }
    });

    socket.on("server:guardadoExitoso", (data) {
      if (data['tabla'] == 'venta') {
        // Agrega a la lista de ventas

        final newVenta = Venta.fromJson(data);
        if (newVenta.venUser == 'admin') {
          printTicket(
            newVenta,
            user,
          );

          // final pdfUrl =
          //     '${Environment.serverPhpUrl}reportes/facturaticket.php?codigo=${newVenta.venId}&empresa=${newVenta.venEmpresa}';
          // downloadPDF(null, pdfUrl);
        }
        state = state.copyWith(ventas: [
          newVenta,
          ...state.ventas,
        ]);
      }
    });
  }

  void resetImprimirFactura() {
    state = state.copyWith(
      mostrarImprimirFactura: false,
    );
  }

  Future loadNextPage() async {
    if (state.isLastPage || state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true);

    final ventas = await ventasRepository.getVentasByPage(
        cantidad: state.cantidad,
        page: state.page,
        search: state.search,
        estado: state.estado,
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
        estado: state.estado,
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
      estado: state.estado,
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
    String? estado,
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
      estado: estado ?? state.estado,
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
    final surtidoresResponse = await ventasRepository.getSurtidores();
    if (surtidoresResponse.error.isNotEmpty) {
      state = state.copyWith(
          error: 'Hubo un error al obtener los surtidores', isLoading: false);

      return;
    }
    state = state.copyWith(
        surtidoresData: surtidoresResponse.resultado, isLoading: false);
  }

  Future<ResponseSecuencia> getSecuencia() async {
    final estado = state.estado == "FACTURAS"
        ? "FACTURA"
        : state.estado == "NOTA VENTAS"
            ? "NOTA DE VENTA"
            : state.estado == "PROFORMAS"
                ? "PROFORMA"
                : state.estado == "NOTA CREDITOS"
                    ? "NOTA DE CREDITO"
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

  @override
  void dispose() {
    // Log para verificar que se está destruyendo
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
  final String estado;
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
      this.estado = 'FACTURAS',
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
      String? estado,
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
