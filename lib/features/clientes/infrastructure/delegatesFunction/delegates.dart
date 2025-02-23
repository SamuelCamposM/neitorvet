import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_provider.dart';
import 'package:neitorvet/features/clientes/presentation/widgets/cliente_card.dart';
import 'package:neitorvet/features/shared/delegate/generic_delegate.dart';
import 'package:neitorvet/features/shared/delegate/item_generic_search.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart'; 
import 'package:neitorvet/features/clientes/presentation/provider/clientes_repository_provider.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

Future<Cliente?> searchClienteDoc({
  required BuildContext context,
  required WidgetRef ref,
}) async {
  final res = await showSearch(
    query: '',
    context: context,
    delegate: GenericDelegate(
      onlySelect: false,
      itemWidgetBuilder: (clienteItem, onItemSelected) => ItemGenericSearch(
        item: clienteItem,
        title: '${clienteItem.perNombre} - ${clienteItem.perOtros}',
        onItemSelected: onItemSelected,
      ),
      searchItems: ({search = ''}) async {
        //error del endpoint se valida aca
        final res = await ref
            .read(clientesRepositoryProvider)
            .getNewClienteByDoc(search);
        if (res.error.isNotEmpty) {
          if (context.mounted) {
            NotificationsService.show(
                context, res.error, SnackbarCategory.error);
          }
          return <Cliente>[];
        }
        return [res.resultado!];
      },
      //funcion que settea el buscador
      setSearch: (_) => {},
      initialItems: <Cliente>[],
    ),
  );
  return res?.item;
}

Future<SearchGenericResult<Cliente>?> searchClientes(
    {required BuildContext context,
    required WidgetRef ref,
    required ClientesState clientesState,
    required Responsive size}) async {
  return showSearch(
      query: clientesState.search,
      context: context,
      delegate: GenericDelegate(
        onlySelect: false,
        itemWidgetBuilder: (item, onItemSelected) {
          return ClienteCard(
              redirect: false,
              nombreUsuario: item.perNombre,
              cedula: item.perDocNumero,
              correo:
                  item.perEmail.isNotEmpty ? item.perEmail[0] : '--- --- ---',
              size: size,
              perId: item.perId);
        },
        setSearch: ref.read(clientesProvider.notifier).setSearch,
        initialItems: clientesState.searchedClientes,
        searchItems: ({search = ''}) {
          return ref
              .read(clientesProvider.notifier)
              .searchClientesByQuery(search: search);
        },
      ));
}
