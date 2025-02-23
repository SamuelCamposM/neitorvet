import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/presentation/widgets/cliente_card.dart'; 
import 'package:neitorvet/features/shared/utils/responsive.dart';

typedef SarchClientesCallback = Future<List<Cliente>> Function({String search});

class SearchResult {
  final Cliente? cliente;
  final bool? setBusqueda;
  final bool? wasLoading;
  SearchResult({this.cliente, this.setBusqueda, this.wasLoading = false});
}

class SearchClienteDelegate extends SearchDelegate<SearchResult> {
  final SarchClientesCallback searchClientes;
  final void Function(String search) setSearch;
  final bool onlySelect;
  List<Cliente> initalClientes;
  StreamController<List<Cliente>> devounceClientes =
      StreamController.broadcast();
  StreamController<bool> loadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchClienteDelegate({
    required this.searchClientes,
    required this.initalClientes,
    required this.setSearch,
    this.onlySelect = false,
  }) : super(searchFieldLabel: 'Buscar');

  void clearStreams() {
    devounceClientes.close();
    loadingStream.close();
  }

  void _onQueryChanged(String search) {
    Future.microtask(() => setSearch(search));
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    loadingStream.add(true);

    _debounceTimer = Timer(
      const Duration(milliseconds: 1000),
      () async {
        if (search.isEmpty) {
          if (!devounceClientes.isClosed) {
            devounceClientes.add([]);
          }
          return;
        }
        final clientes = await searchClientes(search: search);
        initalClientes = clientes;

        if (!devounceClientes.isClosed) {
          devounceClientes.add(clientes);
        }
        if (!loadingStream.isClosed) {
          loadingStream.add(false);
        }
      },
    );
  }

  StreamBuilder<List<Cliente>> buildResultsAndSuggestions() {
    return StreamBuilder(
      initialData: initalClientes,
      stream: devounceClientes.stream,
      builder: (context, snapshot) {
        final clientes = snapshot.data ?? [];
        return ListView.builder(
          itemCount: clientes.length,
          itemBuilder: (context, index) => _ClienteItem(
              cliente: clientes[index],
              onClienteSelected: (context, cliente) {
                clearStreams();
                close(context, SearchResult(cliente: cliente));
              }),
        );
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        stream: loadingStream.stream,
        builder: (context, snapshot) {
          return snapshot.data ?? false
              ? SpinPerfect(
                  duration: const Duration(seconds: 1),
                  spins: 10,
                  infinite: true,
                  animate: query.isNotEmpty,
                  child: IconButton(
                      onPressed: () => query = '',
                      icon: const Icon(Icons.refresh)))
              : FadeIn(
                  animate: query.isNotEmpty,
                  child: IconButton(
                      onPressed: () => query = '',
                      icon: const Icon(Icons.clear)));
        },
      ),
      StreamBuilder(
        stream: loadingStream.stream,
        builder: (context, snapshot) {
          return onlySelect
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    if (!onlySelect) {
                      close(
                          context,
                          SearchResult(
                              setBusqueda: true,
                              wasLoading: snapshot.data ?? false));
                      clearStreams();
                    }
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();

        close(context, SearchResult());
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Diferir la llamada a close hasta después de la fase de construcción
    Future.microtask(() async {
      bool wasLoading = true;

      // Crear una suscripción al stream
      StreamSubscription<bool> subscription =
          loadingStream.stream.listen((bool isLoading) {
        wasLoading = isLoading;
      });

      // Cancelar la suscripción después de obtener el valor
      await subscription.cancel();

      // Aquí puedes manejar el valor bool emitido por el StreamController
      if (context.mounted) {
        if (!onlySelect) {
          close(
              context, SearchResult(setBusqueda: true, wasLoading: wasLoading));
        }
      }
    });

    // Retornar un widget vacío o un indicador de carga mientras se cierra el diálogo
    return buildResultsAndSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return buildResultsAndSuggestions();
  }
}

class _ClienteItem extends StatelessWidget {
  final Cliente cliente;
  final Function onClienteSelected;

  const _ClienteItem({required this.cliente, required this.onClienteSelected});

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    return GestureDetector(
      onTap: () => onClienteSelected(context, cliente),
      child: ClienteCard(
          redirect: false,
          nombreUsuario: cliente.perNombre,
          cedula: cliente.perDocNumero,
          correo:
              cliente.perEmail.isNotEmpty ? cliente.perEmail[0] : '--- --- ---',
          size: size,
          perId: cliente.perId),
    );
  }
}
