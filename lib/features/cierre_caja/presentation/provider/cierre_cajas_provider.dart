import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/domain/domain.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/cierre_caja/domain/repositories/cierre_cajas_repository.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_repository_provider.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/repositories/cierre_surtidores_repository.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/provider/cierre_surtidores_repository_provider.dart';
import 'package:neitorvet/features/shared/helpers/get_date.dart';
import 'package:neitorvet/features/shared/provider/download_pdf.dart';

import 'package:neitorvet/features/shared/provider/socket.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum CierreCajaEstado {
  diaria("DIARIA"),
  general("GENERAL"),
  anulada("ANULADA");
  // notaCierreCajas("NOTA VENTAS"),
  // proformas("PROFORMAS"),
  // notaCreditos("NOTA CREDITOS");

  final String value;
  const CierreCajaEstado(this.value);
}

class SumaIEC {
  final double ingreso;
  final double egreso;
  final double credito;
  const SumaIEC({
    this.ingreso = 0,
    this.egreso = 0,
    this.credito = 0,
  });
}

class GetCierreCajaResponse {
  final CierreCaja? cierreCaja;
  final String error;

  GetCierreCajaResponse({required this.cierreCaja, required this.error});
}

final cierreCajasProvider =
    StateNotifierProvider.autoDispose<CierreCajasNotifier, CierreCajasState>(
  (ref) {
    final user = ref.watch(authProvider).user;
    final isAdmin = ref.watch(authProvider).isAdmin;

    final cierreCajasRepository = ref.watch(cierreCajasRepositoryProvider);
    final cierreSurtidoresRepository =
        ref.watch(cierreSurtidoresRepositoryProvider);
    final socket = ref.watch(socketProvider);
    final downloadPDF = ref.watch(downloadPdfProvider.notifier).downloadPDF;
    return CierreCajasNotifier(
        socket: socket,
        cierreCajasRepository: cierreCajasRepository,
        downloadPDF: downloadPDF,
        user: user!,
        isAdmin: isAdmin,
        cierreSurtidoresRepository: cierreSurtidoresRepository);
  },
);

class CierreCajasNotifier extends StateNotifier<CierreCajasState> {
  final CierreCajasRepository cierreCajasRepository;
  final CierreSurtidoresRepository cierreSurtidoresRepository;
  final io.Socket socket;
  final User user;
  final bool isAdmin;
  final Future<void> Function(BuildContext? context, String infoPdf)
      downloadPDF;
  CierreCajasNotifier({
    required this.cierreCajasRepository,
    required this.socket,
    required this.user,
    required this.isAdmin,
    required this.downloadPDF,
    required this.cierreSurtidoresRepository,
  }) : super(CierreCajasState()) {
    _initializeSocketListeners();
    loadNextPage();
    setSumaIEC(fecha: GetDate.today);
  }

  void _initializeSocketListeners() {
    socket.on('disconnect', (_) {});

    socket.on('connect', (_) {});

    socket.on("server:actualizadoExitoso", (data) {
      if (mounted) {
        if (data['tabla'] == 'caja' && data['rucempresa'] == user.rucempresa) {
          // Edita de la lista de cierreCajas
          final updatedCierreCaja = CierreCaja.fromJson(data);
          final updatedCierreCajasList = state.cierreCajas.map((cierreCaja) {
            return cierreCaja.cajaId == updatedCierreCaja.cajaId
                ? updatedCierreCaja
                : cierreCaja;
          }).toList();
          state = state.copyWith(cierreCajas: updatedCierreCajasList);
        }
      }
    });

    socket.on("server:guardadoExitoso", (data) {
      if (mounted) {
        if (data['tabla'] == 'caja' && data['rucempresa'] == user.rucempresa) {
          final newCierreCaja = CierreCaja.fromJson(data);
          state = state.copyWith(cierreCajas: [
            newCierreCaja,
            ...state.cierreCajas,
          ]);
          // final pdfUrl =
          //     '${Environment.serverPhpUrl}reportes/facturaticket.php?codigo=${newCierreCaja.cajaId}&empresa=${newCierreCaja.venEmpresa}';
          // downloadPDF(null, pdfUrl);
        }
      }
    });
  }

  Future loadNextPage() async {
    if (state.isLastPage || state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true);

    final cierreCajas = await cierreCajasRepository.getCierreCajasByPage(
        cantidad: state.cantidad,
        page: state.page,
        search: state.search,
        estado: state.estado.value,
        input: state.input,
        orden: state.orden,
        busquedaCierreCaja: state.busquedaCierreCaja);

    if (cierreCajas.error.isNotEmpty) {
      state = state.copyWith(isLoading: false, error: cierreCajas.error);
      return;
    }
    if (cierreCajas.resultado.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
        error: '',
        isLoading: false,
        page: state.page + 1,
        total: cierreCajas.total,
        cierreCajas: [...state.cierreCajas, ...cierreCajas.resultado]);
  }

  Future<List<CierreCaja>> searchCierreCajasByQueryWhileWasLoading() async {
    state = state.copyWith(isLoading: true);
    final cierreCajas = await cierreCajasRepository.getCierreCajasByPage(
        search: state.search,
        cantidad: state.cantidad,
        input: state.input,
        orden: state.orden,
        page: 0,
        estado: state.estado.value,
        busquedaCierreCaja: state.busquedaCierreCaja);
    // ref.read(searchQueryProvider.notifier).update((state) => search);
    if (cierreCajas.error.isNotEmpty) {
      state = state.copyWith(error: cierreCajas.error, isLoading: false);
      return [];
    }

    state = state.copyWith(
        searchedCierreCajas: cierreCajas.resultado,
        totalSearched: cierreCajas.total,
        total: cierreCajas.total,
        cierreCajas: cierreCajas.resultado,
        isLastPage: false,
        isLoading: false,
        isSearching:
            state.search.isNotEmpty || state.busquedaCierreCaja.isSearching());
    return cierreCajas.resultado;
  }

  Future<List<CierreCaja>> searchCierreCajasByQuery(
      {String search = ''}) async {
    final cierreCajas = await cierreCajasRepository.getCierreCajasByPage(
      search: search,
      cantidad: state.cantidad,
      input: state.input,
      orden: state.orden,
      page: 0,
      estado: state.estado.value,
      busquedaCierreCaja: state.busquedaCierreCaja,
    );
    // ref.read(searchQueryProvider.notifier).update((state) => search);
    if (cierreCajas.error.isNotEmpty) {
      state = state.copyWith(error: cierreCajas.error, search: search);
      return [];
    }

    state = state.copyWith(
        search: search,
        searchedCierreCajas: cierreCajas.resultado,
        totalSearched: cierreCajas.total,
        isLastPage: false,
        isSearching:
            search.isNotEmpty || state.busquedaCierreCaja.isSearching());
    return cierreCajas.resultado;
  }

  void setSearch(String search) {
    state = state.copyWith(search: search);
  }

  Future<GetCierreCajaResponse> getCierreCajaById(int cajaId) async {
    try {
      final exist = [...state.cierreCajas, ...state.searchedCierreCajas]
          .any((e) => e.cajaId == cajaId);
      if (!exist) {
        return GetCierreCajaResponse(
            cierreCaja: null, error: 'No se encontró el cierreCaja');
      }
      return GetCierreCajaResponse(
          cierreCaja:
              [...state.cierreCajas, ...state.searchedCierreCajas].firstWhere(
            (cierreCaja) => cierreCaja.cajaId == cajaId,
          ),
          error: '');
    } catch (e) {
      return GetCierreCajaResponse(
          cierreCaja: null, error: 'Hubo un error al consultar el clinete');
    }
  }

  Future<void> resetQuery({
    String? search,
    CierreCajaEstado? estado,
    String? input,
    bool? orden,
    BusquedaCierreCaja? busquedaCierreCaja,
  }) async {
    if (state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true);

    final cierreCajas = await cierreCajasRepository.getCierreCajasByPage(
      cantidad: state.cantidad,
      page: 0,
      search: search ?? state.search,
      estado: estado?.value ?? state.estado.value,
      input: input ?? state.input,
      orden: orden ?? state.orden,
      busquedaCierreCaja: busquedaCierreCaja ?? state.busquedaCierreCaja,
    );

    if (cierreCajas.error.isNotEmpty) {
      state = state.copyWith(isLoading: false, error: cierreCajas.error);
      return;
    }
    if (state.estado != estado) {
      setSumaIEC(fecha: estado == CierreCajaEstado.diaria ? GetDate.today : "");
    }

    state = state.copyWith(
        isLoading: false,
        page: 1,
        total: cierreCajas.total,
        cierreCajas: cierreCajas.resultado,
        search: search,
        estado: estado,
        input: input,
        orden: orden,
        isLastPage: false,
        busquedaCierreCaja: busquedaCierreCaja,
        isSearching: (search ?? state.search).isNotEmpty ||
            (busquedaCierreCaja ?? state.busquedaCierreCaja).isSearching());
  }

  void handleSearch() async {
    if (state.search.isEmpty) {
      return;
    }
    state = state.copyWith(
        total: state.totalSearched,
        cierreCajas: state.searchedCierreCajas,
        page: 1,
        searchedCierreCajas: [],
        totalSearched: 0);
  }

  Future<void> createUpdateCierreCaja(
      Map<String, dynamic> clienteMap, bool editando) async {
    if (editando) {
      socket.emit('client:actualizarData', clienteMap);
    } else {
      socket.emit("client:guardarData", clienteMap);
    }
  }

  void resetError() {
    state = state.copyWith(error: '');
  }

  void setSumaIEC({required String fecha}) async {
    final res = await cierreCajasRepository.getSumaIEC(
        fecha: fecha, search: isAdmin ? '' : user.usuario);
    if (res.error.isNotEmpty) {
      state = state.copyWith(isLoading: false, error: res.error);
      return;
    }
    state = state.copyWith(
        sumaIEC: SumaIEC(
            ingreso: res.credito, egreso: res.egreso, credito: res.credito));
  }
}

class CierreCajasState {
  final bool isLastPage;
  final bool isLoading;
  final int cantidad;
  final int page;
  final List<CierreCaja> cierreCajas;
  final String error;
  final int total;
  final String search;
  final CierreCajaEstado estado;
  final String input;
  final bool orden;
  final List<CierreCaja> searchedCierreCajas;
  final int totalSearched;
  final BusquedaCierreCaja busquedaCierreCaja;
  final bool isSearching;
  final SumaIEC sumaIEC;

  CierreCajasState({
    this.isLastPage = false,
    this.isLoading = false,
    this.cantidad = 10,
    this.page = 0,
    this.cierreCajas = const [],
    this.error = '',
    this.total = 0,
    this.search = '',
    this.estado = CierreCajaEstado.diaria,
    this.input = 'cajaId',
    this.orden = false,
    this.searchedCierreCajas = const [],
    this.totalSearched = 0,
    this.busquedaCierreCaja = const BusquedaCierreCaja(),
    this.isSearching = false,
    this.sumaIEC = const SumaIEC(),
  });

  CierreCajasState copyWith({
    bool? isLastPage,
    bool? isLoading,
    int? cantidad,
    int? page,
    List<CierreCaja>? cierreCajas,
    String? error,
    int? total,
    String? search,
    CierreCajaEstado? estado,
    String? input,
    bool? orden,
    List<CierreCaja>? searchedCierreCajas,
    int? totalSearched,
    BusquedaCierreCaja? busquedaCierreCaja,
    bool? isSearching,
    SumaIEC? sumaIEC,
  }) {
    return CierreCajasState(
      isLastPage: isLastPage ?? this.isLastPage,
      isLoading: isLoading ?? this.isLoading,
      cantidad: cantidad ?? this.cantidad,
      page: page ?? this.page,
      cierreCajas: cierreCajas ?? this.cierreCajas,
      error: error ?? this.error,
      total: total ?? this.total,
      search: search ?? this.search,
      estado: estado ?? this.estado,
      input: input ?? this.input,
      orden: orden ?? this.orden,
      searchedCierreCajas: searchedCierreCajas ?? this.searchedCierreCajas,
      totalSearched: totalSearched ?? this.totalSearched,
      busquedaCierreCaja: busquedaCierreCaja ?? this.busquedaCierreCaja,
      isSearching: isSearching ?? this.isSearching,
      sumaIEC: sumaIEC ?? this.sumaIEC,
    );
  }
}
