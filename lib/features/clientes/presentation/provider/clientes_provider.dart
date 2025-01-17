import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/domain/repostiries/clientes_repository.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_repository_provider.dart';

final clientesProvider = StateNotifierProvider<ClientesNotifier, ClientesState>(
  (ref) {
    final clientesRepository = ref.watch(clientesRepositoryProvider);
    return ClientesNotifier(clientesRepository: clientesRepository);
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
      return;
    }
    if (clientes.resultado.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
    }

    state = state.copyWith(
        isLoading: false,
        page: state.page + 1,
        clientes: [...state.clientes, ...clientes.resultado]);
  }
}

class ClientesState {
  final bool isLastPage;
  final bool isLoading;
  final int cantidad;
  final int page;
  final List<Cliente> clientes;

  ClientesState(
      {this.isLastPage = false,
      this.isLoading = false,
      this.cantidad = 10,
      this.page = 0,
      this.clientes = const []});

  ClientesState copyWith({
    bool? isLastPage,
    bool? isLoading,
    int? cantidad,
    int? page,
    List<Cliente>? clientes,
  }) =>
      ClientesState(
        isLastPage: isLastPage ?? this.isLastPage,
        isLoading: isLoading ?? this.isLoading,
        cantidad: cantidad ?? this.cantidad,
        page: page ?? this.page,
        clientes: clientes ?? this.clientes,
      );
}
