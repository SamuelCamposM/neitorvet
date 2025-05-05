import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/administracion/domain/entities/live_visualization.dart';
import 'package:neitorvet/features/administracion/domain/entities/manguera_status.dart';
import 'package:neitorvet/features/venta/domain/entities/socket/abastecimiento_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final ventaAbastecimientoProvider = StateNotifierProvider.autoDispose<
    VentaAbastecimientoNotifier, VentaAbastecimientoState>((ref) {
  return VentaAbastecimientoNotifier();
});

class VentaAbastecimientoNotifier
    extends StateNotifier<VentaAbastecimientoState> {
  late WebSocketChannel _channelVisualizacion;
  late WebSocketChannel _channelAbastecimientos;
  late WebSocketChannel _channelStatus;

  VentaAbastecimientoNotifier()
      : super(VentaAbastecimientoState(
          valores: [],
          abastecimientoSocket: null,
          manguerasStatus: null,
        )) {
    print('CONECTA VentaAbastecimientoNotifier');

    // Conectar a los WebSockets
    _channelVisualizacion = WebSocketChannel.connect(
      Uri.parse('wss://zaracayapi.neitor.com/ws/despachos_visualizacion'),
    );

    _channelAbastecimientos = WebSocketChannel.connect(
      Uri.parse('wss://zaracayapi.neitor.com/ws/abastecimientos'),
    );

    _channelStatus = WebSocketChannel.connect(
      Uri.parse('wss://zaracayapi.neitor.com/ws/status_picos'),
    );

    // Escuchar mensajes del WebSocket de visualización
    _channelVisualizacion.stream.listen((data) {
      print('Mensaje recibido del WebSocket de visualización: $data');
      try {
        final decodedData = json.decode(data); // Decodificar el string JSON
        if (decodedData['type'] == 'live_visualization') {
          final List<LiveVisualization> liveVisualizationListData =
              (decodedData['data'] as List)
                  .map((item) => LiveVisualization.fromJson(item))
                  .toList();

          // Actualizar el estado con los nuevos valores
          state = state.copyWith(valores: liveVisualizationListData);
        }
      } catch (e) {
        print('Error en visualización: $e');
      }
    });

    // Escuchar mensajes del WebSocket de abastecimientos
    _channelAbastecimientos.stream.listen((data) async {
      try {
        final decodedData = json.decode(data);
        print('Decoded data: $decodedData'); // Imprimir el JSON decodificado
        if (decodedData['type'] == "dispatch") {
          final abastecimientoSocket =
              AbastecimientoSocket.fromJson(decodedData['data']);

          // Actualizar el estado con el nuevo abastecimiento
          state = state.copyWith(abastecimientoSocket: abastecimientoSocket);
          state = state.copyWith(clearAbastecimientoSocket: true);
        }
      } catch (e) {
        print('Error en abastecimientos: $e');
      }
    });

    // Escuchar mensajes del WebSocket de estado de mangueras
    _channelStatus.stream.listen((data) {
      try {
        final decodedData = json.decode(data); // Decodificar el string JSON
        if (decodedData['type'] == 'pico_status') {
          final Map<String, Datum> parsedData = Map<String, Datum>.from(
            (decodedData['data'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(key, datumValues.map[value]!),
            ),
          );

          // Actualizar el estado con el nuevo estado de las mangueras
          state =
              state.copyWith(manguerasStatus: MangueraStatus(data: parsedData));
        }
      } catch (e) {
        print('Error en estado de mangueras: $e');
      }
    });
  }

  void clearAbastecimientoSocket() {
    state = state.copyWith(abastecimientoSocket: null);
  }

  @override
  void dispose() {
    // Cerrar las conexiones de WebSocket al eliminar el provider
    _channelVisualizacion.sink.close();
    _channelAbastecimientos.sink.close(); // Cerrar _channelAbastecimientos
    _channelStatus.sink.close();
    print('Dispose VentaAbastecimientoNotifier');
    super.dispose();
  }
}

class VentaAbastecimientoState {
  final List<LiveVisualization> valores;
  final AbastecimientoSocket? abastecimientoSocket;
  final MangueraStatus? manguerasStatus;

  VentaAbastecimientoState({
    this.valores = const [],
    this.abastecimientoSocket,
    this.manguerasStatus,
  });

  VentaAbastecimientoState copyWith({
    List<LiveVisualization>? valores,
    AbastecimientoSocket? abastecimientoSocket,
    MangueraStatus? manguerasStatus,
    bool? clearAbastecimientoSocket, // Nuevo parámetro para forzar null
  }) {
    return VentaAbastecimientoState(
      valores: valores ?? this.valores,
      abastecimientoSocket: clearAbastecimientoSocket == true
          ? null
          : abastecimientoSocket ?? this.abastecimientoSocket,
      manguerasStatus: manguerasStatus ?? this.manguerasStatus,
    );
  }
}

class MangueraStatus {
  final Map<String, Datum> data;

  MangueraStatus({required this.data});
}
