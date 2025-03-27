import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/cierre_surtidor.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/provider/cierre_surtidores_provider.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/widgets/cierre_surtidor_card.dart';
import 'package:neitorvet/features/shared/delegate/generic_delegate.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

Future<SearchGenericResult<CierreSurtidor>?> searchsearchCierreSurtidores(
    {required BuildContext context,
    required WidgetRef ref,
    required CierreSurtidoresState cierreSurtidoresState,
    required Responsive size}) async {
  return showSearch(
      query: cierreSurtidoresState.search,
      context: context,
      delegate: GenericDelegate(
        onlySelect: false,
        itemWidgetBuilder: (item, onItemSelected) {
          return CierreSurtidorCard(
            cierreSurtidor: item,
            size: size,
          );
        },
        setSearch: ref.read(cierreSurtidoresProvider.notifier).setSearch,
        initialItems: cierreSurtidoresState.searchedCierreSurtidores,
        searchItems: ({search = ''}) {
          return ref
              .read(cierreSurtidoresProvider.notifier)
              .searchCierreSurtidoresByQuery(search: search);
        },
      ));
}
