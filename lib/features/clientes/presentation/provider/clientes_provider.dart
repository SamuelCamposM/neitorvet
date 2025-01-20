import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/domain/repostiries/clientes_repository.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_repository_provider.dart';

class GetClienteResponse {
  final Cliente? cliente;
  final String error;

  GetClienteResponse({required this.cliente, required this.error});
}

final clientesProvider =
    StateNotifierProvider.autoDispose<ClientesNotifier, ClientesState>(
  (ref) {
    final clientesRepository = ref.watch(clientesRepositoryProvider);
    return ClientesNotifier(
      clientesRepository: clientesRepository,
    );
  },
);

class ClientesNotifier extends StateNotifier<ClientesState> {
  final ClientesRepository clientesRepository;
  ClientesNotifier({required this.clientesRepository})
      : super(ClientesState()) {
    loadNextPage();
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

  GetClienteResponse getClienteById(int perId) {
    try {
      final exist = state.clientes.any((e) => e.perId == perId);
      if (!exist) {
        return GetClienteResponse(
            cliente: null, error: 'No se encontró el cliente');
      }
      return GetClienteResponse(
          cliente: state.clientes.firstWhere(
            (cliente) => cliente.perId == perId,
          ),
          error: '');
    } catch (e) {
      return GetClienteResponse(
          cliente: null, error: 'Hubo un error al consultar el clinete');
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

  ClientesState({
    this.isLastPage = false,
    this.isLoading = false,
    this.cantidad = 10,
    this.page = 0,
    this.clientes = const [],
    this.error = '',
    this.total = 0,
  });

  ClientesState copyWith({
    bool? isLastPage,
    bool? isLoading,
    int? cantidad,
    int? page,
    List<Cliente>? clientes,
    String? error,
    int? total,
  }) =>
      ClientesState(
        isLastPage: isLastPage ?? this.isLastPage,
        isLoading: isLoading ?? this.isLoading,
        cantidad: cantidad ?? this.cantidad,
        page: page ?? this.page,
        clientes: clientes ?? this.clientes,
        error: error ?? this.error,
        total: total ?? this.total,
      );
}
