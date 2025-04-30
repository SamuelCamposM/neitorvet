import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/administracion/presentation/provider/info_tanque_provider.dart';
import 'package:neitorvet/features/shared/screen/full_screen_loader.dart';

String getNombreCombustible(int codigoCombustible) {
  switch (codigoCombustible) {
    case 57:
      return 'GASOLINA EXTRA';
    case 58:
      return 'GASOLINA SÚPER';
    case 59:
      return 'DIESEL PREMIUM';
    default:
      return 'DESCONOCIDO';
  }
}

class InfoTanque extends ConsumerWidget {
  final String combustible;

  const InfoTanque({super.key, required this.combustible});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoTanqueState = ref.watch(infoTanqueProvider(combustible));

    if (infoTanqueState.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(getNombreCombustible(int.parse(combustible))),
        ),
        body: const FullScreenLoader(),
      );
    }

    if (infoTanqueState.error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            getNombreCombustible(int.parse(combustible)),
          ),
        ),
        body: FullScreenLoader(
          message: infoTanqueState.error,
        ),
      );
    }

    final totalDiario = infoTanqueState.totalDiario?.first;
    final totalSemanal = infoTanqueState.totalSemanal?.first;
    final totalMensual = infoTanqueState.totalMensual?.first;
    final totalAnual = infoTanqueState.totalAnual?.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          getNombreCombustible(int.parse(combustible)),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TotalCard(
              title: 'Hoy',
              valorTotal: totalDiario?.valorTotal ?? 0,
              volumenTotal: totalDiario?.volumenTotal ?? 0,
              color: Colors.blue.shade100,
            ),
            const SizedBox(height: 16),
            TotalCard(
              title: 'Semanal',
              valorTotal: totalSemanal?.valorTotal ?? 0,
              volumenTotal: totalSemanal?.volumenTotal ?? 0,
              color: Colors.green.shade100,
            ),
            const SizedBox(height: 16),
            TotalCard(
              title: 'Mensual',
              valorTotal: totalMensual?.valorTotal ?? 0,
              volumenTotal: totalMensual?.volumenTotal ?? 0,
              color: Colors.orange.shade100,
            ),
            const SizedBox(height: 16),
            TotalCard(
              title: 'Anual',
              valorTotal: totalAnual?.valorTotal ?? 0,
              volumenTotal: totalAnual?.volumenTotal ?? 0,
              color: Colors.purple.shade100,
            ),
          ],
        ),
      ),
    );
  }
}

class TotalCard extends StatelessWidget {
  final String title;
  final double valorTotal;
  final double volumenTotal;
  final Color color;

  const TotalCard({
    super.key,
    required this.title,
    required this.valorTotal,
    required this.volumenTotal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Container(
        width: size.width, // Ocupa todo el ancho disponible
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total de Ventas: \$${valorTotal.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Volumen Total: ${volumenTotal.toStringAsFixed(2)} G',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
