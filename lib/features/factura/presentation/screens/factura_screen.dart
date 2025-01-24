import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/factura/domain/entities/venta.dart';
import 'package:neitorvet/features/factura/presentation/provider/form/venta_form_provider.dart';
import 'package:neitorvet/features/factura/presentation/provider/venta_provider.dart';

import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';

class FacturaScreen extends ConsumerWidget {
  final int ventaId;
  const FacturaScreen({super.key, required this.ventaId});
  @override
  Widget build(BuildContext context, ref) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(contextProvider.notifier).state = context;
    // });
    ref.listen(
      ventaProvider(ventaId),
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(context, next.error, SnackbarCategory.error);
      },
    );

    final ventaState = ref.watch(ventaProvider(ventaId));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              ventaState.venta?.venId == 0 ? 'Crear Venta' : 'Editar Venta'),
        ),
        body: ventaState.isLoading
            ? const FullScreenLoader()
            : _VentaForm(venta: ventaState.venta!),
        // floatingActionButton: ventaState.isLoading
        //     ? null
        //     : _FloatingButton(
        //         venta: ventaState.venta!,
        //       ),
      ),
    );
  }
}

// class _FloatingButton extends ConsumerWidget {
//   final Venta venta;

//   const _FloatingButton({required this.venta});
//   void showSnackBar(BuildContext context) {
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text('Producto Actualizado')));
//   }

//   @override
//   Widget build(BuildContext context, ref) {
//     final productFormState = ref.watch(ventaFormProvider(venta));
//     return FloatingActionButton(
//       onPressed: () async {
//         if (productFormState.isPosting) {
//           return;
//         }
//         final exitoso = await ref
//             .read(ventaFormProvider(venta).notifier)
//             .onFormSubmit();

//         if (exitoso && context.mounted) {
//           NotificationsService.show(
//               context, 'Venta Actualizado', SnackbarCategory.success);
//         }
//       },
//       child: productFormState.isPosting
//           ? SpinPerfect(
//               duration: const Duration(seconds: 1),
//               spins: 10,
//               infinite: true,
//               child: const Icon(Icons.refresh),
//             )
//           : const Icon(Icons.save_as),
//     );
//   }
// }

class _VentaForm extends ConsumerWidget {
  final Venta venta;
  const _VentaForm({required this.venta});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ventaForm = ref.watch(ventaFormProvider(venta));
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${ventaForm.venId}'),
            Text(ventaForm.venRucCliente.value),
            Text('${ventaForm.venEmpEmail}'),
            // CustomProductField(
            //   autoFocus: true,
            //   isTopField: true,
            //   label: 'Nombre',
            //   initialValue: ventaForm.perNombre.value,
            //   onChanged: (p0) {
            //     ref
            //         .read(ventaFormProvider(venta).notifier)
            //         .updateState(perNombre: p0);
            //   },
            //   errorMessage: ventaForm.perNombre.errorMessage,
            // ),

            // CustomProductField(
            //   isBottomField: true,
            //   label: 'Nickname',
            //   initialValue: ventaForm.perNickname ?? '',
            //   onChanged: (p0) {
            //     ref
            //         .read(ventaFormProvider(venta).notifier)
            //         .updateState(perNickname: p0);
            //   },
            // ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
    ;
  }
}
