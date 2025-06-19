import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/administracion/domain/entities/live_visualization.dart';
import 'package:neitorvet/features/administracion/domain/entities/manguera_status.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart'; 
import 'package:neitorvet/features/shared/helpers/get_date.dart';
import 'package:neitorvet/features/venta/domain/entities/socket/abastecimiento_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final ventaAbastecimientoProvider = StateNotifierProvider.autoDispose<
    VentaAbastecimientoNotifier, VentaAbastecimientoState>((ref) {
  final user = ref.watch(authProvider).user;

  return VentaAbastecimientoNotifier(
    rucempresa: user!.rucempresa,
  );
});

class VentaAbastecimientoNotifier
    extends StateNotifier<VentaAbastecimientoState> {
  late WebSocketChannel _channelVisualizacion;
  late WebSocketChannel _channelAbastecimientos;
  late WebSocketChannel _channelStatus;
  final String rucempresa;
  VentaAbastecimientoNotifier({
    required this.rucempresa,
  }) : super(VentaAbastecimientoState(
          valores: [],
          abastecimientoSocket: null,
          manguerasStatus: null,
        )) {
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
        e;
      }
    });

    // Escuchar mensajes del WebSocket de abastecimientos
    _channelAbastecimientos.stream.listen((data) async { 
      try {
        final decodedData = json.decode(data);
        if (decodedData['type'] == "dispatch") {
          final abastecimientoSocket =
              AbastecimientoSocket.fromJson(decodedData['data']);
          GetDate.today;
          abastecimientoSocket.fecha;
          if (abastecimientoSocket.codEmp != rucempresa) {
            return; // Ignorar abastecimientos de otras empresas
          }
          if (GetDate.today != abastecimientoSocket.fecha) {
            return;
          }
          // Actualizar el estado con el nuevo abastecimiento
          state = state.copyWith(abastecimientoSocket: abastecimientoSocket);
          state = state.copyWith(clearAbastecimientoSocket: true);
        }
      } catch (e) {
        e;
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
        e;
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
