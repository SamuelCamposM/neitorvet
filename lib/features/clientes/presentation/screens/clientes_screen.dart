import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_provider.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class ClientesScreen extends StatelessWidget {
  const ClientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: _ClientesView(),
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
        Showsnackbar.show(context, next.error, SnackbarCategory.success);
      },
    );

    return Stack(
      children: [
        ListView.builder(
          controller: scrollController,
          itemCount: clientesState.clientes.length,
          itemBuilder: (context, index) {
            final cliente = clientesState.clientes[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: ListTile(
                title: Text(cliente.perNombre),
              ),
            );
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
