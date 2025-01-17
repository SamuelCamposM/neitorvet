import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_provider.dart';

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

class _ClientesView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientesState = ref.watch(clientesProvider);
    
    return ListView.builder(
      itemCount: clientesState.clientes.length,
      itemBuilder: (context, index) {
        final cliente = clientesState.clientes[index];
        return ListTile(
          title: Text('Cliente test'),
        );
      },
    );
  }
}
