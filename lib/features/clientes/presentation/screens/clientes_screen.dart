import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/clientes/infrastructure/delegatesFunction/delegates.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_provider.dart';
import 'package:neitorvet/features/clientes/presentation/widgets/cliente_card.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class ClientesScreen extends ConsumerStatefulWidget {
  const ClientesScreen({super.key});

  @override
  ConsumerState createState() => ClientesViewState();
}

class ClientesViewState extends ConsumerState<ClientesScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () {
        if (scrollController.position.pixels + 400 >=
            scrollController.position.maxScrollExtent) {
          ref.read(clientesProvider.notifier).loadNextPage();
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    final clientesState = ref.watch(clientesProvider);
    ref.listen(
      clientesProvider,
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(
            context, next.error, SnackbarCategory.success);
      },
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer(
            builder: (context, ref, child) {
              // final clientesState = ref.watch(clientesProvider);
              return IconButton(
                  onPressed: () async {
                    final clientesState = ref.read(clientesProvider);
                    // final searchedMovies = ref.read(searchmoviespro);
                    final searchClienteResult = await searchClientes(
                        context: context,
                        ref: ref,
                        clientesState: clientesState,
                        size: size);

                    if (searchClienteResult?.wasLoading == true) {
                      ref
                          .read(clientesProvider.notifier)
                          .searchClientesByQueryWhileWasLoading();
                    }
                    if (searchClienteResult?.setBusqueda == true) {
                      ref.read(clientesProvider.notifier).handleSearch();
                    }
                    if (!context.mounted) return;
                    if (searchClienteResult?.item != null) {
                      context
                          .push('/cliente/${searchClienteResult?.item?.perId}');
                    }
                  },
                  icon: const Icon(Icons.search));
            },
          ),
        ],
        title: Consumer(
          builder: (context, ref, child) {
            final clientesState = ref.watch(clientesProvider);
            return Text('Clientes ${clientesState.total}');
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (clientesState.search.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Buscando por: ${clientesState.search}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          ref
                              .read(clientesProvider.notifier)
                              .resetQuery(search: '');
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomSelectField(
                        size: size,
                        label: 'Ordenar Por',
                        value: clientesState.input,
                        onChanged: (String? value) {
                          ref.read(clientesProvider.notifier).resetQuery(
                                input: value,
                              );
                        },
                        options: [
                          // Option(label: "Fec. Reg.", value: "perId"),
                          Option(
                            label: "Documento",
                            value: "perDocNumero",
                          ),
                          Option(
                            label: "Nombre",
                            value: "perNombre",
                          ),
                        ].toList(),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        clientesState.orden
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                      ),
                      onPressed: () {
                        ref.read(clientesProvider.notifier).resetQuery(
                              orden: !clientesState.orden,
                            );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: clientesState.clientes.length,
                    itemBuilder: (context, index) {
                      final cliente = clientesState.clientes[index];
                      return ClienteCard(
                        nombreUsuario: cliente.perNombre,
                        cedula: cliente.perDocNumero,
                        correo: cliente.perEmail.isNotEmpty
                            ? cliente.perEmail[0]
                            : '--- --- ---',
                        size: size,
                        perId: cliente.perId,
                        fotoUrl: cliente.perFoto ?? '',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (clientesState.isLoading)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: SizedBox(
                width: size.wScreen(100),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/cliente/0');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
