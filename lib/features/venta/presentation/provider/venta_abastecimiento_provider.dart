import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/administracion/domain/entities/live_visualization.dart';
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

  VentaAbastecimientoNotifier() : super(VentaAbastecimientoState()) {
    print('CONECTA VentaAbastecimientoNotifier');
    // Conectar a los WebSockets
    _channelVisualizacion = WebSocketChannel.connect(
      Uri.parse('wss://zaracayapi.neitor.com/ws/despachos_visualizacion'),
    );

    _channelAbastecimientos = WebSocketChannel.connect(
      Uri.parse('wss://zaracayapi.neitor.com/ws/abastecimientos'),
    );

    // Escuchar mensajes del WebSocket de visualización
    _channelVisualizacion.stream.listen((data) {
      try {
        final decodedData = json.decode(data); // Decodificar el string JSON
        if (decodedData['type'] == 'live_visualization') {
          print(decodedData);
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
        print(decodedData);
        if (decodedData['type'] == "dispatch") {
          final abastecimientoSocket =
              AbastecimientoSocket.fromJson(decodedData['data']);

          // Actualizar el estado con el nuevo abastecimiento
          state = state.copyWith(abastecimientoSocket: abastecimientoSocket);
        }
      } catch (e) {
        print('Error en abastecimientos: $e');
      }
    });
  }

  @override
  void dispose() {
    // Cerrar las conexiones de WebSocket al eliminar el provider
    _channelVisualizacion.sink.close();
    _channelAbastecimientos.sink.close();
    print('Dispose VentaAbastecimientoNotifier');
    super.dispose();
  }
}

class VentaAbastecimientoState {
  final List<LiveVisualization> valores;
  final AbastecimientoSocket? abastecimientoSocket;

  VentaAbastecimientoState({
    this.valores = const [],
    this.abastecimientoSocket,
  });

  VentaAbastecimientoState copyWith({
    List<LiveVisualization>? valores,
    AbastecimientoSocket? abastecimientoSocket,
  }) {
    return VentaAbastecimientoState(
      valores: valores ?? this.valores,
      abastecimientoSocket: abastecimientoSocket ?? this.abastecimientoSocket,
    );
  }
}
