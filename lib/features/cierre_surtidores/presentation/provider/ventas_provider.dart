import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/domain/domain.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/cierre_surtidor.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/repositories/cierre_surtidores_repository.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/provider/cierre_surtidores_repository_provider.dart';
import 'package:neitorvet/features/shared/provider/download_pdf.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/surtidor.dart';

import 'package:neitorvet/features/shared/provider/socket.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum CierreSurtidorEstado {
  facturas("FACTURAS"),
  sinAutorizar("SIN AUTORIZAR");
  // notaCierreSurtidores("NOTA VENTAS"),
  // proformas("PROFORMAS"),
  // notaCreditos("NOTA CREDITOS");

  final String value;
  const CierreSurtidorEstado(this.value);
}

class GetCierreSurtidorResponse {
  final List<CierreSurtidor> cierreSurtidores;
  final String error;

  GetCierreSurtidorResponse(
      {required this.cierreSurtidores, required this.error});
}

final cierreSurtidoresProvider = StateNotifierProvider.autoDispose<
    CierreSurtidoresNotifier, CierreSurtidoresState>(
  (ref) {
    final user = ref.watch(authProvider).user;

    final cierreSurtidoresRepository =
        ref.watch(cierreSurtidoresRepositoryProvider);
    final socket = ref.watch(socketProvider);
    final downloadPDF = ref.watch(downloadPdfProvider.notifier).downloadPDF;
    return CierreSurtidoresNotifier(
      socket: socket,
      cierreSurtidoresRepository: cierreSurtidoresRepository,
      downloadPDF: downloadPDF,
      user: user!,
    );
  },
);

class CierreSurtidoresNotifier extends StateNotifier<CierreSurtidoresState> {
  final CierreSurtidoresRepository cierreSurtidoresRepository;
  final io.Socket socket;
  final User user;
  final Future<void> Function(BuildContext? context, String infoPdf)
      downloadPDF;
  CierreSurtidoresNotifier({
    required this.cierreSurtidoresRepository,
    required this.socket,
    required this.user,
    required this.downloadPDF,
  }) : super(CierreSurtidoresState()) {
    _initializeSocketListeners();
    loadNextPage();
    _setSurtidores();
  }

  void _initializeSocketListeners() {
    socket.on('disconnect', (_) {});

    socket.on('connect', (_) {});

    socket.on("server:actualizadoExitoso", (data) {
      if (mounted) {
        // if (data['tabla'] == 'cierreSurtidor') {}
      }
    });

    socket.on("server:guardadoExitoso", (data) {
      if (mounted) {
        // if (data['tabla'] == 'cierreSurtidor') {}
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

    final cierreSurtidores =
        await cierreSurtidoresRepository.getCierreSurtidoresByPage(
            cantidad: state.cantidad,
            page: state.page,
            search: state.search,
            input: state.input,
            orden: state.orden,
            busquedaCierreSurtidor: state.busquedaCierreSurtidor);

    if (cierreSurtidores.error.isNotEmpty) {
      state = state.copyWith(isLoading: false, error: cierreSurtidores.error);
      return;
    }
    if (cierreSurtidores.resultado.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
        error: '',
        isLoading: false,
        page: state.page + 1,
        total: cierreSurtidores.total,
        cierreSurtidores: [
          ...state.cierreSurtidores,
          ...cierreSurtidores.resultado
        ]);
  }

  Future<List<CierreSurtidor>>
      searchCierreSurtidoresByQueryWhileWasLoading() async {
    state = state.copyWith(isLoading: true);
    final cierreSurtidores =
        await cierreSurtidoresRepository.getCierreSurtidoresByPage(
            search: state.search,
            cantidad: state.cantidad,
            input: state.input,
            orden: state.orden,
            page: 0,
            busquedaCierreSurtidor: state.busquedaCierreSurtidor);
    // ref.read(searchQueryProvider.notifier).update((state) => search);
    if (cierreSurtidores.error.isNotEmpty) {
      state = state.copyWith(error: cierreSurtidores.error, isLoading: false);
      return [];
    }

    state = state.copyWith(
        searchedCierreSurtidores: cierreSurtidores.resultado,
        totalSearched: cierreSurtidores.total,
        total: cierreSurtidores.total,
        cierreSurtidores: cierreSurtidores.resultado,
        isLastPage: false,
        isLoading: false,
        isSearching: state.search.isNotEmpty ||
            state.busquedaCierreSurtidor.isSearching());
    return cierreSurtidores.resultado;
  }

  Future<List<CierreSurtidor>> searchCierreSurtidoresByQuery(
      {String search = ''}) async {
    final cierreSurtidores =
        await cierreSurtidoresRepository.getCierreSurtidoresByPage(
      search: search,
      cantidad: state.cantidad,
      input: state.input,
      orden: state.orden,
      page: 0,
      busquedaCierreSurtidor: state.busquedaCierreSurtidor,
    );
    // ref.read(searchQueryProvider.notifier).update((state) => search);
    if (cierreSurtidores.error.isNotEmpty) {
      state = state.copyWith(error: cierreSurtidores.error, search: search);
      return [];
    }

    state = state.copyWith(
        search: search,
        searchedCierreSurtidores: cierreSurtidores.resultado,
        totalSearched: cierreSurtidores.total,
        isLastPage: false,
        isSearching:
            search.isNotEmpty || state.busquedaCierreSurtidor.isSearching());
    return cierreSurtidores.resultado;
  }

  void setSearch(String search) {
    state = state.copyWith(search: search);
  }

  Future<GetCierreSurtidorResponse> getCierreSurtidoresByUuid(
      String idcierre) async {
    final cierreSurtidoresResponse = await cierreSurtidoresRepository
        .getCierreSurtidoresUuid(uuid: idcierre);

    if (cierreSurtidoresResponse.error.isNotEmpty) {
      return GetCierreSurtidorResponse(
          cierreSurtidores: [], error: cierreSurtidoresResponse.error);
    }
    return GetCierreSurtidorResponse(cierreSurtidores: cierreSurtidoresResponse.resultado, error: '');
  }

  Future<void> resetQuery({
    String? search,
    String? input,
    bool? orden,
    BusquedaCierreSurtidor? busquedaCierreSurtidor,
  }) async {
    if (state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true);

    final cierreSurtidores =
        await cierreSurtidoresRepository.getCierreSurtidoresByPage(
      cantidad: state.cantidad,
      page: 0,
      search: search ?? state.search,
      input: input ?? state.input,
      orden: orden ?? state.orden,
      busquedaCierreSurtidor:
          busquedaCierreSurtidor ?? state.busquedaCierreSurtidor,
    );

    if (cierreSurtidores.error.isNotEmpty) {
      state = state.copyWith(isLoading: false, error: cierreSurtidores.error);
      return;
    }

    state = state.copyWith(
        isLoading: false,
        page: 1,
        total: cierreSurtidores.total,
        cierreSurtidores: cierreSurtidores.resultado,
        search: search,
        input: input,
        orden: orden,
        isLastPage: false,
        busquedaCierreSurtidor: busquedaCierreSurtidor,
        isSearching: (search ?? state.search).isNotEmpty ||
            (busquedaCierreSurtidor ?? state.busquedaCierreSurtidor)
                .isSearching());
  }

  void handleSearch() async {
    if (state.search.isEmpty) {
      return;
    }
    state = state.copyWith(
        total: state.totalSearched,
        cierreSurtidores: state.searchedCierreSurtidores,
        page: 1,
        searchedCierreSurtidores: [],
        totalSearched: 0);
  }

  Future<void> createUpdateCierreSurtidor(
      Map<String, dynamic> cierreSurtidorMap) async {
    socket.emit('client:guardarData', cierreSurtidorMap);
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
    super.dispose();
  }
}

class CierreSurtidoresState {
  final bool isLastPage;
  final bool isLoading;
  final int cantidad;
  final int page;
  final List<CierreSurtidor> cierreSurtidores;
  final String error;
  final int total;
  final String search;
  final String input;
  final bool orden;
  final List<CierreSurtidor> searchedCierreSurtidores;
  final int totalSearched;
  final BusquedaCierreSurtidor busquedaCierreSurtidor;
  final bool isSearching;
  final bool mostrarImprimirFactura;
  final List<Surtidor> surtidoresData;
  CierreSurtidoresState(
      {this.isLastPage = false,
      this.isLoading = false,
      this.cantidad = 10,
      this.page = 0,
      this.cierreSurtidores = const [],
      this.error = '',
      this.total = 0,
      this.search = '',
      this.input = 'idcierre',
      this.orden = false,
      this.searchedCierreSurtidores = const [],
      this.totalSearched = 0,
      this.busquedaCierreSurtidor = const BusquedaCierreSurtidor(),
      this.isSearching = false,
      this.mostrarImprimirFactura = false,
      this.surtidoresData = const []});

  CierreSurtidoresState copyWith(
      {bool? isLastPage,
      bool? isLoading,
      int? cantidad,
      int? page,
      List<CierreSurtidor>? cierreSurtidores,
      String? error,
      int? total,
      String? search,
      String? input,
      bool? orden,
      List<CierreSurtidor>? searchedCierreSurtidores,
      int? totalSearched,
      BusquedaCierreSurtidor? busquedaCierreSurtidor,
      bool? isSearching,
      bool? mostrarImprimirFactura,
      List<Surtidor>? surtidoresData}) {
    return CierreSurtidoresState(
      isLastPage: isLastPage ?? this.isLastPage,
      isLoading: isLoading ?? this.isLoading,
      cantidad: cantidad ?? this.cantidad,
      page: page ?? this.page,
      cierreSurtidores: cierreSurtidores ?? this.cierreSurtidores,
      error: error ?? this.error,
      total: total ?? this.total,
      search: search ?? this.search,
      input: input ?? this.input,
      orden: orden ?? this.orden,
      searchedCierreSurtidores:
          searchedCierreSurtidores ?? this.searchedCierreSurtidores,
      totalSearched: totalSearched ?? this.totalSearched,
      busquedaCierreSurtidor:
          busquedaCierreSurtidor ?? this.busquedaCierreSurtidor,
      isSearching: isSearching ?? this.isSearching,
      mostrarImprimirFactura:
          mostrarImprimirFactura ?? this.mostrarImprimirFactura,
      surtidoresData: surtidoresData ?? this.surtidoresData,
    );
  }
}
