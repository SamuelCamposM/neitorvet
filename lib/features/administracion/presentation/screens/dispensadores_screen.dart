import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/administracion/presentation/widgets/estacion_card.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/provider/cierre_surtidores_provider.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class DispensadoresScreen extends ConsumerWidget {
  const DispensadoresScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cierreSurtidoresState = ref.watch(cierreSurtidoresProvider);
    final size = Responsive.of(context);
    return Scaffold(
         appBar: AppBar(
        title: const Text('Mangueras'),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: cierreSurtidoresState.estacionesData.length,
                  itemBuilder: (context, index) {
                    final estacion =
                        cierreSurtidoresState.estacionesData[index];
                    return EstacionCard(
                      estacion: estacion,
                      size: size,
                      redirect: true,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
