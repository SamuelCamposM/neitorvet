import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/clientes/presentation/delegates/search_cliente_delegate.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_provider.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
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
                    final searchClienteResult = await showSearch<SearchResult>(
                        query: clientesState.search,
                        context: context,
                        delegate: SearchClienteDelegate(
                          setSearch:
                              ref.read(clientesProvider.notifier).setSearch,
                          initalClientes: clientesState.searchedClientes,
                          searchClientes: ref
                              .read(clientesProvider.notifier)
                              .searchClientesByQuery,
                        ));
                    if (searchClienteResult?.wasLoading == true) {
                      ref
                          .read(clientesProvider.notifier)
                          .searchClientesByQueryWhileWasLoading();
                    }
                    if (searchClienteResult?.setBusqueda == true) {
                      ref.read(clientesProvider.notifier).handleSearch();
                    }
                    if (!context.mounted) return;
                    if (searchClienteResult?.cliente != null) {
                      context.push(
                          '/cliente/${searchClienteResult?.cliente?.perId}');
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
      body: const ClientesView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/cliente/0');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ClientesView extends ConsumerStatefulWidget {
  const ClientesView({super.key});

  @override
  ConsumerState createState() => ClientesViewState();
}

class ClientesViewState extends ConsumerState<ClientesView> {
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

    return Stack(
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
                  DropdownButton<String>(
                    value: clientesState.input,
                    items: const [
                      DropdownMenuItem(
                        value: 'perId',
                        child: Text('ID'),
                      ),
                      DropdownMenuItem(
                        value: 'perDocumento',
                        child: Text('DOCUMENTO'),
                      ),
                      DropdownMenuItem(
                        value: 'perNombre',
                        child: Text('NOMBRE'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(clientesProvider.notifier).resetQuery(
                              input: value,
                            );
                      }
                    },
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
                    return UserInfoCard(
                      nombreUsuario: cliente.perNombre,
                      cedula: cliente.perDocNumero,
                      correo: cliente.perEmail.isNotEmpty
                          ? cliente.perEmail[0]
                          : '--- --- ---',
                      size: size,
                      perId: cliente.perId,
                      fotoUrl: cliente.perFoto,
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
    );
  }
}

class UserInfoCard extends StatelessWidget {
  final String nombreUsuario;
  final String cedula;
  final String correo;
  final Responsive size;
  final int perId;
  final bool redirect;
  final String fotoUrl;
  const UserInfoCard({
    Key? key,
    required this.nombreUsuario,
    required this.cedula,
    required this.correo,
    required this.size,
    required this.perId,
    this.redirect = true,
    this.fotoUrl = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: size.iScreen(1), vertical: size.iScreen(.25)),
      child: Slidable(
        key: ValueKey(perId),
        startActionPane: ActionPane(
          motion:
              const DrawerMotion(), // Puedes cambiar ScrollMotion por otro tipo de Motion
          children: [
            SlidableAction(
              onPressed: (context) {
                // Acción de editar
                context.push('/cliente/$perId');
              },
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Editar',
            ),
            SlidableAction(
              onPressed: (context) {
                // Acción de eliminar
                // Implementa la lógica de eliminación aquí
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Eliminar',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion:
              const DrawerMotion(), // Puedes cambiar DrawerMotion por otro tipo de Motion
          children: [
            SlidableAction(
              onPressed: (context) {
                // Acción adicional
              },
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Compartir',
            ),
          ],
        ),
        child: GestureDetector(
          onTap: redirect
              ? () {
                  context.push('/cliente/$perId');
                }
              : null,
          child: Container(
            padding: EdgeInsets.all(size.iScreen(.50)),
            width: size.wScreen(100),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4), // Desplazamiento de la sombra
                ),
              ],
            ),
            child: Row(
              children: [
                // CircleAvatar(
                //   radius: size.iScreen(3.0),
                //   backgroundImage: NetworkImage(fotoUrl),
                //   onBackgroundImageError: (_, __) {
                //     // Manejar error de carga de imagen
                //   },
                // ),
                SizedBox(width: size.iScreen(.5)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombreUsuario,
                      style: TextStyle(
                          fontSize: size.iScreen(1.5),
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      cedula,
                      style: TextStyle(
                        fontSize: size.iScreen(1.5),
                      ),
                    ),
                    Text(
                      correo,
                      style: TextStyle(
                        fontSize: size.iScreen(1.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
