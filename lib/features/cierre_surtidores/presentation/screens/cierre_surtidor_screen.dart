import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/cierre_surtidor.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/provider/cierre_surtidor_provider.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/widgets/cierre_surtidor_card.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class CierreSurtidorScreen extends ConsumerWidget {
  final String cierreSurtidorUuid;
  const CierreSurtidorScreen({super.key, required this.cierreSurtidorUuid});
  @override
  Widget build(BuildContext context, ref) {
    ref.listen(
      cierreSurtidorProvider(cierreSurtidorUuid),
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(context, next.error, SnackbarCategory.error);
      },
    );
    final cierreSurtidorState =
        ref.watch(cierreSurtidorProvider(cierreSurtidorUuid));
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
                'Cierre Surtidor: ${cierreSurtidorState.cierreSurtidores.length}'),
          ),
          body: cierreSurtidorState.isLoading
              ? const FullScreenLoader()
              : cierreSurtidorState.cierreSurtidores.isEmpty
                  ? const Center(
                      child: Text('Cierre surtidores no encontrados'))
                  : _CierreSurtidoresBodyScreen(
                      cierreSurtidores: cierreSurtidorState.cierreSurtidores,
                    ),
          // floatingActionButton:
          //     cierreSurtidorState.isLoading ? null : _FloatingButton(),
        ));
  }
}

// class _FloatingButton extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, ref) {
//     return FloatingActionButton(
//       onPressed: () async {},
//       child: const Icon(Icons.back_hand),
//     );
//   }
// }

class _CierreSurtidoresBodyScreen extends ConsumerWidget {
  final List<CierreSurtidor> cierreSurtidores;
  const _CierreSurtidoresBodyScreen({
    required this.cierreSurtidores,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = Responsive.of(context);

    // final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          const Row(
            children: [
              // Text(
              //   'Cantidad: ',
              //   style: TextStyle(
              //     fontSize: size.iScreen(1.8),
              //     fontWeight: FontWeight.normal,
              //     color: Theme.of(context)
              //         .textTheme
              //         .bodyLarge
              //         ?.color, // Asegurando el color correcto
              //   ),
              // ),
              // Text(
              //   '${cierreSurtidores.length}',
              //   style: TextStyle(
              //     fontSize: size.iScreen(1.8),
              //     fontWeight: FontWeight.bold,
              //     color: Theme.of(context)
              //         .textTheme
              //         .bodyLarge
              //         ?.color, // Asegurando el color correcto
              //   ),
              // ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cierreSurtidores.length,
              itemBuilder: (context, index) {
                final cierreSurtidor = cierreSurtidores[index];
                return CierreSurtidorCard(
                  cierreSurtidor: cierreSurtidor,
                  size: size,redirect: false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
