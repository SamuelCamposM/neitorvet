import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/venta/presentation/provider/form/venta_form_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/venta_provider.dart';

class GetVenta extends ConsumerWidget {
  final int ventaId;
  final Widget Function(VentaState ventaState, VentaFormState ventaFState)
      child;
  const GetVenta({super.key, required this.ventaId, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ventaState = ref.watch(ventaProvider(ventaId));
    final ventaFState = ref.watch(ventaFormProvider(ventaState.venta!));

    return child(ventaState, ventaFState);
  }
}
  // const MenuDespacho({super.key, required this.ventaId});
  // @override
  // Widget build(BuildContext context, WidgetRef ref) {
  //   final ventaState = ref.watch(ventaProvider(ventaId));
  //   final ventaFState = ref.watch(ventaFormProvider(ventaState.venta!));
