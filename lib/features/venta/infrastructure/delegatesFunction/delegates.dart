import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/shared/delegate/generic_delegate.dart';
import 'package:neitorvet/features/shared/delegate/item_generic_search.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente_foreign.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_repository_provider.dart';
import 'package:neitorvet/features/venta/domain/entities/inventario.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_repository_provider.dart';

Future<ClienteForeign?> searchClienteResult({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final res = await showSearch(
    query: '',
    context: context,
    delegate: GenericDelegate(
      itemWidgetBuilder: (clienteItem, onItemSelected) => ItemGenericSearch(
        item: clienteItem,
        title: '${clienteItem.perNombre} - ${clienteItem.perOtros}',
        onItemSelected: onItemSelected,
      ),
      searchItems: ({search = ''}) async {
        final res = await ref
            .read(clientesRepositoryProvider)
            .getClientesByQueryInVentas(search);
        if (res.error.isNotEmpty) {
          if (context.mounted) {
            NotificationsService.show(
                context, res.error, SnackbarCategory.error);
          }
          return <ClienteForeign>[];
        }
        return res.resultado;
      },
      setSearch: (_) => {},
      initialItems: <ClienteForeign>[],
    ),
  );
  return res?.item;
}

Future<String?> searchPlacas({
  required BuildContext context,
  required WidgetRef ref,
  required String venOtrosDetalles,
  required List<String> placasData,
  required void Function(String search) setSearch,
}) async {
  final res = await showSearch(
    query: venOtrosDetalles,
    context: context,
    delegate: GenericDelegate(
      itemWidgetBuilder: (placa, onItemSelected) => ItemGenericSearch(
        title: placa,
        item: placa,
        onItemSelected: onItemSelected,
      ),
      searchItems: ({search = ''}) async {
        return placasData;
        // return ventaForm.placasData
        //     .where((placa) => placa.contains(search))
        //     .toList();
      },
      setSearch: setSearch,
      initialItems: placasData,
    ),
  );
  return res?.item;
}

Future<Inventario?> searchInventario({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final res = await showSearch(
    context: context,
    delegate: GenericDelegate(
      itemWidgetBuilder: (inventarioItem, onItemSelected) => ItemGenericSearch(
        item: inventarioItem,
        title: '${inventarioItem.invNombre} - ${inventarioItem.invSerie}',
        onItemSelected: onItemSelected,
      ),
      searchItems: ({search = ''}) async {
        final res = await ref.read(ventasRepositoryProvider).getInventarioByQuery(search);
        if (res.error.isNotEmpty) {
          if (context.mounted) {
            NotificationsService.show(context, res.error, SnackbarCategory.error);
          }
          return <Inventario>[];
        }
        return res.resultado;
      },
      setSearch: (_) {},
      initialItems: <Inventario>[],
    ),
  );
  return res?.item;
}