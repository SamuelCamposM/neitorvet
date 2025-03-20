import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/domain/repositories/clientes_repository.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_repository_provider.dart';
import 'package:neitorvet/features/shared/provider/socket.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class GetClienteResponse {
  final Cliente? cliente;
  final String error;

  GetClienteResponse({required this.cliente, required this.error});
}

final clientesProvider =
    StateNotifierProvider.autoDispose<ClientesNotifier, ClientesState>(
  (ref) {
    final clientesRepository = ref.watch(clientesRepositoryProvider);
    final socket = ref.watch(socketProvider);
    return ClientesNotifier(
      socket: socket,
      clientesRepository: clientesRepository,
    );
  },
);

class ClientesNotifier extends StateNotifier<ClientesState> {
  final ClientesRepository clientesRepository;
  final io.Socket socket;

  ClientesNotifier({required this.clientesRepository, required this.socket})
      : super(ClientesState()) {
    _initializeSocketListeners();
    loadNextPage();
  }
  void _initializeSocketListeners() {
    socket.on('connect', (a) {});

    socket.on('disconnect', (_) {});

    socket.on("server:actualizadoExitoso", (data) {
      if (data['tabla'] == 'proveedor') {
        // Edita de la lista de clientes
        final updatedCliente = Cliente.fromJson(data);
        final updatedClientesList = state.clientes.map((cliente) {
          return cliente.perId == updatedCliente.perId
              ? updatedCliente
              : cliente;
        }).toList();
        state = state.copyWith(clientes: updatedClientesList);
      }
    });

    socket.on("server:guardadoExitoso", (data) { 
      if (data['tabla'] == 'proveedor') {
        // Agrega a la lista de clientes

        final newCliente = Cliente.fromJson(data);

        state = state.copyWith(clientes: [
          newCliente,
          ...state.clientes,
        ]);
      }
    });
  }

  Future loadNextPage() async {
    if (state.isLastPage || state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true);

    final clientes = await clientesRepository.getClientesByPage(
        cantidad: state.cantidad, page: state.page, search: state.search);

    if (clientes.error.isNotEmpty) {
      state = state.copyWith(isLoading: false, error: clientes.error);
      return;
    }
    if (clientes.resultado.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
        isLoading: false,
        page: state.page + 1,
        total: clientes.total,
        clientes: [...state.clientes, ...clientes.resultado]);
  }

  Future<List<Cliente>> searchClientesByQueryWhileWasLoading() async {
    final clientes = await clientesRepository.getClientesByPage(
      search: state.search,
      cantidad: state.cantidad,
      input: state.input,
      orden: state.orden,
      page: 0,
      perfil: state.perfil,
    );
    // ref.read(searchQueryProvider.notifier).update((state) => search);
    if (clientes.error.isNotEmpty) {
      state = state.copyWith(
        error: clientes.error,
      );
      return [];
    }

    state = state.copyWith(
        searchedClientes: clientes.resultado,
        totalSearched: clientes.total,
        total: clientes.total,
        clientes: clientes.resultado,
        isLastPage: false);
    return clientes.resultado;
  }

  Future<List<Cliente>> searchClientesByQuery({String search = ''}) async {
    final clientes = await clientesRepository.getClientesByPage(
      search: search,
      cantidad: state.cantidad,
      input: state.input,
      orden: state.orden,
      page: 0,
      perfil: state.perfil,
    );
    // ref.read(searchQueryProvider.notifier).update((state) => search);
    if (clientes.error.isNotEmpty) {
      state = state.copyWith(error: clientes.error, search: search);
      return [];
    }

    state = state.copyWith(
        search: search,
        searchedClientes: clientes.resultado,
        totalSearched: clientes.total,
        isLastPage: false);
    return clientes.resultado;
  }

  void setSearch(String search) {
    state = state.copyWith(search: search);
  }

  Future<GetClienteResponse> getClienteById(int perId) async {
    try {
      final exist = [...state.clientes, ...state.searchedClientes]
          .any((e) => e.perId == perId);
      if (!exist) {
        return GetClienteResponse(
            cliente: null, error: 'No se encontró el cliente');
      }
      return GetClienteResponse(
          cliente: [...state.clientes, ...state.searchedClientes].firstWhere(
            (cliente) => cliente.perId == perId,
          ),
          error: '');
    } catch (e) {
      return GetClienteResponse(
          cliente: null, error: 'Hubo un error al consultar el clinete');
    }
  }

  Future<void> resetQuery({
    String? search,
    String? perfil,
    String? input,
    bool? orden,
  }) async {
    if (state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true);

    final clientes = await clientesRepository.getClientesByPage(
      cantidad: state.cantidad,
      page: 0,
      search: search ?? state.search,
      perfil: perfil ?? state.perfil,
      input: input ?? state.input,
      orden: orden ?? state.orden,
    );

    if (clientes.error.isNotEmpty) {
      state = state.copyWith(isLoading: false, error: clientes.error);
      return;
    }

    state = state.copyWith(
        isLoading: false,
        page: 1,
        total: clientes.total,
        clientes: clientes.resultado,
        search: search,
        perfil: perfil,
        input: input,
        orden: orden,
        isLastPage: false);
  }

  void handleSearch() async {
    if (state.search.isEmpty) {
      return;
    }
    state = state.copyWith(
        total: state.totalSearched,
        clientes: state.searchedClientes,
        page: 1,
        searchedClientes: [],
        totalSearched: 0);
  }

  Future<void> createUpdateCliente(
      Map<String, dynamic> clienteMap, bool editando) async {
    if (editando) {
      socket.emit('client:actualizarData', clienteMap);
    } else {
      socket.emit("client:guardarData", clienteMap);
    }
  }

  @override
  void dispose() {
    // Log para verificar que se está destruyendo
    super.dispose();
  }
}

class ClientesState {
  final bool isLastPage;
  final bool isLoading;
  final int cantidad;
  final int page;
  final List<Cliente> clientes;
  final String error;
  final int total;
  final String search;
  final String perfil;
  final String input;
  final bool orden;
  final List<Cliente> searchedClientes;
  final int totalSearched;

  ClientesState(
      {this.isLastPage = false,
      this.isLoading = false,
      this.cantidad = 10,
      this.page = 0,
      this.clientes = const [],
      this.error = '',
      this.total = 0,
      this.search = '',
      this.perfil = 'CLIENTES',
      this.input = 'perDocNumero',
      this.orden = false,
      this.searchedClientes = const [],
      this.totalSearched = 0});

  ClientesState copyWith({
    bool? isLastPage,
    bool? isLoading,
    int? cantidad,
    int? page,
    List<Cliente>? clientes,
    String? error,
    int? total,
    String? search,
    String? perfil,
    String? input,
    bool? orden,
    List<Cliente>? searchedClientes,
    int? totalSearched,
  }) {
    return ClientesState(
      isLastPage: isLastPage ?? this.isLastPage,
      isLoading: isLoading ?? this.isLoading,
      cantidad: cantidad ?? this.cantidad,
      page: page ?? this.page,
      clientes: clientes ?? this.clientes,
      error: error ?? this.error,
      total: total ?? this.total,
      search: search ?? this.search,
      perfil: perfil ?? this.perfil,
      input: input ?? this.input,
      orden: orden ?? this.orden,
      searchedClientes: searchedClientes ?? this.searchedClientes,
      totalSearched: totalSearched ?? this.totalSearched,
    );
  }
}
