import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/presentation/delegates/search_cliente_delegate.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_provider.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';

import 'package:neitorvet/features/shared/utils/responsive.dart';

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
              return IconButton(
                  onPressed: () async {
                    // final searchedMovies = ref.read(searchmoviespro);
                    final clientesState = ref.read(clientesProvider);
                    final cliente = await showSearch<Cliente?>(
                        query: clientesState.search,
                        context: context,
                        delegate: SearchClienteDelegate(
                          initalClientes: clientesState.searchedClientes,
                          searchClientes: ref
                              .read(clientesProvider.notifier)
                              .searchClientesByQuery,
                        ));

                    if (cliente == null || !context.mounted) return;
                    context.push('/cliente/${cliente.perId}');
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
      body: _ClientesView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/cliente/0');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ClientesView extends ConsumerStatefulWidget {
  @override
  ConsumerState createState() => ClientesViewState();
}

class ClientesViewState extends ConsumerState<_ClientesView> {
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
        ListView.builder(
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
                perId: cliente.perId);
            // Container(
            //   margin: const EdgeInsets.symmetric(vertical: 20),
            //   child: ListTile(
            //     title: Text(cliente.perNombre),
            //     subtitle: Text(cliente.perDocNumero),
            //   ),
            // );
          },
        ),
        Positioned(
          bottom: 40,
          child: clientesState.isLoading
              ? SizedBox(
                  width: size.wScreen(100),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
        )
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

  const UserInfoCard(
      {Key? key,
      required this.nombreUsuario,
      required this.cedula,
      required this.correo,
      required this.size,
      required this.perId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/cliente/$perId');
      },
      child: Container(
        width: size.wScreen(100),
        padding: EdgeInsets.all(size.iScreen(1.0)),
        margin: EdgeInsets.symmetric(
            horizontal: size.iScreen(1.2), vertical: size.iScreen(0.5)),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nombreUsuario,
              style: TextStyle(
                  fontSize: size.iScreen(1.5), fontWeight: FontWeight.bold),
            ),
            // SizedBox(height: size.iScreen(0.5)), // Espaciado entre los textos

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
      ),
    );
  }
}
