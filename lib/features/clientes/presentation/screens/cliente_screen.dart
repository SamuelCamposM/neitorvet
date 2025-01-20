import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/presentation/provider/cliente_provider.dart';

import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';

class ClienteScreen extends ConsumerWidget {
  final int clienteId;
  const ClienteScreen({super.key, required this.clienteId});
  @override
  Widget build(BuildContext context, ref) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(contextProvider.notifier).state = context;
    // });
    final clienteState = ref.watch(clienteProvider(clienteId));
    ref.listen(
      clienteProvider(clienteId),
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(
            context, next.error, SnackbarCategory.success);
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(clienteState.cliente?.perNombre ?? "NO CLIENTE"),
      ),
      body: clienteState.isLoading
          ? const FullScreenLoader()
          : _ClienteView(cliente: clienteState.cliente!),
    );
  }
}

class _ClienteView extends ConsumerWidget {
  final Cliente cliente;

  const _ClienteView({required this.cliente});
  @override
  Widget build(BuildContext context, ref) {
    return Center(child: Text('Hola'));
  }
}
