import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/administracion/domain/entities/live_visualization.dart';
import 'package:neitorvet/features/administracion/domain/entities/manguera_status.dart';
import 'package:neitorvet/features/administracion/presentation/widgets/estacion_card.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/provider/cierre_surtidores_provider.dart';
import 'package:neitorvet/features/shared/screen/full_screen_loader.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class DispensadoresScreen extends ConsumerStatefulWidget {
  const DispensadoresScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DispensadoresScreen> createState() =>
      _DispensadoresScreenState();
}

class _DispensadoresScreenState extends ConsumerState<DispensadoresScreen> {
  late WebSocketChannel _channelStatus;
  late WebSocketChannel _channelPrecios;
  MangueraStatus? manguerasStatus;
  List<LiveVisualization> liveVisualizationList = [];
  @override
  void initState() {
    final rucempresa = ref.read(authProvider).user!.rucempresa;
    super.initState();
    // Conectar al WebSocket
    _channelStatus = WebSocketChannel.connect(
      Uri.parse('wss://zaracayapi.neitor.com/ws/status_picos'),
    );
    _channelPrecios = WebSocketChannel.connect(
      Uri.parse('wss://zaracayapi.neitor.com/ws/despachos_visualizacion'),
    );

    // Escuchar mensajes segúrate de importar esto para usar json.decode

    _channelStatus.stream.listen((data) {
      print(rucempresa);
      final decodedData = json.decode(data); // Decodificar el string JSON
      if (decodedData['type'] == 'pico_status') {
        final Map<String, Datum> parsedData = Map<String, Datum>.from(
          (decodedData['data'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, datumValues.map[value]!),
          ),
        );

        setState(() {
          manguerasStatus = MangueraStatus(data: parsedData);
        });
      }
    });
    _channelPrecios.stream.listen((data) {
      final decodedData = json.decode(data); // Decodificar el string JSON
      if (decodedData['type'] == 'live_visualization') {
        // Convertir los datos a una lista de LiveVisualization
        final List<LiveVisualization> liveVisualizationListData =
            (decodedData['data'] as List)
                .map((item) => LiveVisualization.fromJson(item))
                .toList();
        setState(() {
          liveVisualizationList = liveVisualizationListData;
        });
      }
    });
  }

  @override
  void dispose() {
    _channelStatus.sink.close(); // Cerrar la conexión al salir
    _channelPrecios.sink.close(); // Cerrar la conexión al salir
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cierreSurtidoresState = ref.watch(cierreSurtidoresProvider);
    final size = Responsive.of(context);

    // Crear una copia de la lista y luego ordenarla
    final estacionesOrdenadas =
        List.from(cierreSurtidoresState.estacionesData.reversed)
          ..sort((a, b) {
            // Verificar si manguerasStatus o data es null
            if (manguerasStatus == null) {
              return 0; // No realizar ningún cambio en el orden si es null
            }

            final datoa = manguerasStatus!.data[a.numeroPistola.toString()];
            final datab = manguerasStatus!.data[b.numeroPistola.toString()];

            // Comparar los valores, asegurándote de manejar valores null
            if (datoa == null && datab == null) return 0;
            if (datoa == null) return 1;
            if (datab == null) return -1;

            return datoa == Datum.A ? 0 : 1;
          });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mangueras'),
      ),
      body: manguerasStatus == null
          ? const FullScreenLoader()
          : Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: estacionesOrdenadas
                            .length, // Usar estacionesOrdenadas
                        itemBuilder: (context, index) {
                          final estacion = estacionesOrdenadas[
                              index]; // Usar estacionesOrdenadas
                          final dato = manguerasStatus!
                              .data[estacion.numeroPistola.toString()];
                          final visualization =
                              liveVisualizationList.firstWhere(
                            (visualizationItem) =>
                                visualizationItem.pico ==
                                estacion.numeroPistola,
                            orElse: () => LiveVisualization(
                                pico: estacion.numeroPistola!, valorActual: 0),
                          );
                          return EstacionCard(
                              estacion: estacion,
                              size: size,
                              redirect: true,
                              dato: dato,
                              visualization: visualization);
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
