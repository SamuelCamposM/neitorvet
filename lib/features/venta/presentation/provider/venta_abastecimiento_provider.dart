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
          selectedIndex: 0,
          tabs: [const TabItem(id: 0, label: 'Factura 1')],
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

  void onPageChanged(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  void addTab() {
    final newIndex = state.tabs.length;
    final newTab = TabItem(id: newIndex, label: 'Factura ${newIndex + 1}');
    state = state.copyWith(tabs: [...state.tabs, newTab]);
  }

  void removeTab() {
    if (state.tabs.length > 1) {
      final updatedTabs = [...state.tabs]..removeLast();
      final newIndex = state.selectedIndex >= updatedTabs.length
          ? updatedTabs.length - 1
          : state.selectedIndex;
      state = state.copyWith(tabs: updatedTabs, selectedIndex: newIndex);
    }
  }

  // Método para actualizar la manguera de un TabItem por su id
  void updateTabManguera(
    int id,
    String manguera, {
    String? nombreCombustible,
    double? monto,
  }) {
    // Verificar si el TabItem con el id proporcionado existe
    final tabExists = state.tabs.any((tab) => tab.id == id);

    if (!tabExists) {
      print('Error: No se encontró un TabItem con id $id');
      return; // Salir si no se encuentra el TabItem
    }

    // Actualizar el TabItem correspondiente
    final updatedTabs = state.tabs.map((tab) {
      if (tab.id == id) {
        return tab.copyWith(
          manguera: manguera,
          nombreCombustible: nombreCombustible,
          monto: monto,
        );
      }
      return tab;
    }).toList();

    // Actualizar el estado con los tabs modificados
    state = state.copyWith(tabs: updatedTabs);
  }

  void clearAbastecimientoSocket() {
    state = state.copyWith(abastecimientoSocket: null); 
  }
}

class VentaAbastecimientoState {
  final List<LiveVisualization> valores;
  final AbastecimientoSocket? abastecimientoSocket;
  final List<TabItem> tabs;
  final int selectedIndex;
  final MangueraStatus? manguerasStatus;

  VentaAbastecimientoState({
    this.valores = const [],
    this.abastecimientoSocket,
    List<TabItem>? tabs,
    this.selectedIndex = 0,
    this.manguerasStatus,
  }) : tabs = tabs ?? const [TabItem(id: 0, label: 'Factura 1')];

  VentaAbastecimientoState copyWith({
    List<LiveVisualization>? valores,
    AbastecimientoSocket? abastecimientoSocket,
    List<TabItem>? tabs,
    int? selectedIndex,
    MangueraStatus? manguerasStatus,
  }) {
    return VentaAbastecimientoState(
      valores: valores ?? this.valores,
      abastecimientoSocket: abastecimientoSocket ?? this.abastecimientoSocket,
      tabs: tabs ?? this.tabs,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      manguerasStatus: manguerasStatus ?? this.manguerasStatus,
    );
  }
}

class TabItem {
  final int id;
  final String label;
  final String manguera;
  final String nombreCombustible;
  final double monto;

  const TabItem({
    required this.id,
    required this.label,
    this.manguera = '',
    this.nombreCombustible = '',
    this.monto = 0.0,
  });

  TabItem copyWith({
    int? id,
    String? label,
    String? manguera,
    String? nombreCombustible,
    double? monto,
  }) {
    return TabItem(
      id: id ?? this.id,
      label: label ?? this.label,
      manguera: manguera ?? this.manguera,
      nombreCombustible: nombreCombustible ?? this.nombreCombustible,
      monto: monto ?? this.monto,
    );
  }
}

class MangueraStatus {
  final Map<String, Datum> data;

  MangueraStatus({required this.data});
}
