import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/domain/repostiries/clientes_repository.dart';
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
    socket.on('connect', (a) {
      print(socket);
    });

    socket.on('disconnect', (_) {
      print('Disconnected from WebSocket');
    });

    socket.on("server:actualizadoExitoso", (data) {
      print(data);
    });
  }

  Future loadNextPage() async {
    if (state.isLastPage || state.isLoading) {
      return;
    }
    state = state.copyWith(isLoading: true);

    final clientes = await clientesRepository.getClientesByPage(
        cantidad: state.cantidad, page: state.page);

    if (clientes.error.isNotEmpty) {
      state = state.copyWith(isLoading: false, error: clientes.error);
      return;
    }
    if (clientes.resultado.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
    }

    state = state.copyWith(
        isLoading: false,
        page: state.page + 1,
        total: clientes.total,
        clientes: [...state.clientes, ...clientes.resultado]);
  }

  Future<List<Cliente>> searchClientesByQuery({String search = ''}) async {
    final clientes = await clientesRepository.getClientesByPage(
      search: search,
      cantidad: 50,
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
    state = state.copyWith(search: search, searchedClientes: clientes.resultado);
    return clientes.resultado;
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

  Future<void> createUpdateCliente(Map<String, dynamic> clienteMap) async {
    socket.emit('client:actualizarData', clienteMap);
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

  ClientesState({
    this.isLastPage = false,
    this.isLoading = false,
    this.cantidad = 10,
    this.page = 0,
    this.clientes = const [],
    this.error = '',
    this.total = 0,
    this.search = '',
    this.perfil = 'CLIENTES',
    this.input = 'perId',
    this.orden = false,
    this.searchedClientes = const [],
  });

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
    );
  }
}
