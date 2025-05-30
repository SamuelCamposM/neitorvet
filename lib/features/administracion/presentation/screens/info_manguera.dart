import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/administracion/presentation/provider/info_manguera_provider.dart';
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

class InfoManguera extends ConsumerWidget {
  final String manguera;
  final String codigoProducto;
  const InfoManguera({
    super.key,
    required this.manguera,
    required this.codigoProducto,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoMangueraState =
        ref.watch(infoMangueraProvider('$manguera/+/$codigoProducto'));
    final nombreCombustible =
        '$manguera: ${getNombreCombustible(int.parse(codigoProducto))}';
    if (infoMangueraState.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Cargando... $nombreCombustible',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: const FullScreenLoader(),
      );
    }

    if (infoMangueraState.error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Hubo un error $nombreCombustible',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: FullScreenLoader(
          message: infoMangueraState.error,
        ),
      );
    }

    final totalDiario = infoMangueraState.totalDiario;
    final totalSemanal = infoMangueraState.totalSemanal;
    final totalMensual = infoMangueraState.totalMensual;
    final totalAnual = infoMangueraState.totalAnual;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          nombreCombustible,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (totalDiario != null)
              TotalCard(
                title: 'Hoy',
                valorTotal: totalDiario.valorTotal,
                volumenTotal: totalDiario.volumenTotal,
                color: Colors.blue.shade100,
              ),
            const SizedBox(height: 16),
            if (totalSemanal != null)
              TotalCard(
                title: 'Semanal',
                valorTotal: totalSemanal.valorTotal,
                volumenTotal: totalSemanal.volumenTotal,
                color: Colors.green.shade100,
              ),
            const SizedBox(height: 16),
            if (totalMensual != null)
              TotalCard(
                title: 'Mensual',
                valorTotal: totalMensual.valorTotal,
                volumenTotal: totalMensual.volumenTotal,
                color: Colors.orange.shade100,
              ),
            const SizedBox(height: 16),
            if (totalAnual != null)
              TotalCard(
                title: 'Anual',
                valorTotal: totalAnual.valorTotal,
                volumenTotal: totalAnual.volumenTotal,
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
