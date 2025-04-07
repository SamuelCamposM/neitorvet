import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/widgets/cierre_caja_card.dart';
import 'package:neitorvet/features/shared/delegate/generic_delegate.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

Future<SearchGenericResult<CierreCaja>?> searchCierreCajas(
    {required BuildContext context,
    required WidgetRef ref,
    required CierreCajasState cierreCajasState,
    required bool isAdmin,
    required Responsive size}) async {
  return showSearch(
      query: cierreCajasState.search,
      context: context,
      delegate: GenericDelegate(
        onlySelect: false,
        itemWidgetBuilder: (item, onItemSelected) {
          return CierreCajaCard(
            redirect: false,
            cierreCaja: item,
            size: size,
            isAdmin: isAdmin,
            onDelete: () async {},
          );
        },
        setSearch: ref.read(cierreCajasProvider.notifier).setSearch,
        initialItems: cierreCajasState.searchedCierreCajas,
        searchItems: ({search = ''}) {
          return ref
              .read(cierreCajasProvider.notifier)
              .searchCierreCajasByQuery(search: search);
        },
      ));
}
