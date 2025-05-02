import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/administracion/domain/entities/live_visualization.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';
import 'package:neitorvet/features/shared/screen/full_screen_loader.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';
import 'package:neitorvet/features/venta/domain/entities/socket/abastecimiento_socket.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/venta/presentation/provider/form/venta_form_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FullScreenLoaderVenta extends ConsumerStatefulWidget {
  final String manguera;
  final String venId;

  const FullScreenLoaderVenta({
    super.key,
    required this.manguera,
    required this.venId,
  });

  @override
  FullScreenLoaderVentaState createState() => FullScreenLoaderVentaState();
}

class FullScreenLoaderVentaState extends ConsumerState<FullScreenLoaderVenta> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Despachando Combustible'),
          backgroundColor: colors.primary,
          elevation: 0,
        ),
        body: const FullScreenLoader());
  }
}

class BodyFullScreenLoaderVenta extends ConsumerStatefulWidget {
  final ColorScheme colors;
  final FullScreenLoaderVenta widget;
  final int venId;
  final String manguera;
  final Venta venta;
  const BodyFullScreenLoaderVenta(
      {super.key,
      required this.colors,
      required this.widget,
      required this.venId,
      required this.manguera,
      required this.venta});

  @override
  ConsumerState<BodyFullScreenLoaderVenta> createState() =>
      _BodyFullScreenLoaderVentaState();
}

class _BodyFullScreenLoaderVentaState
    extends ConsumerState<BodyFullScreenLoaderVenta> {
  late WebSocketChannel _channelVisualizacion; 
  late WebSocketChannel _channelAbastecimientos;
  String valor = '0.00';
  late VentaForm ventaForm;
  late VentaFormNotifier ventaFormNotifier;
  @override
  void initState() {
    super.initState();

    _channelVisualizacion = WebSocketChannel.connect(
      Uri.parse('wss://zaracayapi.neitor.com/ws/despachos_visualizacion'),
    );
 
    _channelAbastecimientos = WebSocketChannel.connect(
      Uri.parse('wss://zaracayapi.neitor.com/ws/abastecimientos'),
    );

    _channelVisualizacion.stream.listen((data) {
      try {
        final decodedData = json.decode(data); // Decodificar el string JSON
        if (decodedData['type'] == 'live_visualization') {
          // Redirigir a otra pantalla

          final List<LiveVisualization> liveVisualizationListData =
              (decodedData['data'] as List)
                  .map((item) => LiveVisualization.fromJson(item))
                  .toList();
          setState(() {
            for (var liveVisualization in liveVisualizationListData) {
              if (liveVisualization.pico.toString() == widget.manguera) {
                valor = liveVisualization.valorActual.toString();
              }
            }
          });
        }
      } catch (e) {}
    });

    _channelAbastecimientos.stream.listen((data) async {
      try {
        final decodedData = json.decode(data);
        if (decodedData['type'] == "dispatch") {
          final abastecimientoSocket =
              AbastecimientoSocket.fromJson(decodedData['data']);
          if (abastecimientoSocket.pico !=
              Parse.parseDynamicToInt(widget.manguera)) {
            return;
          }
          // Variables para descripción y código según el códigoCombustible
          String descripcion = '';
          String codigo = '';

          // Asignar valores según el códigoCombustible
          switch (abastecimientoSocket.codigoCombustible) {
            case 57:
              descripcion = 'GASOLINA EXTRA';
              codigo = '0101';
              break;
            case 58:
              descripcion = 'GASOLINA SÚPER';
              codigo = '0185';
              break;
            case 59:
              descripcion = 'DIESEL PREMIUM';
              codigo = '0121';
              break;
            default:
              descripcion = 'DESCONOCIDO';
              codigo = '0000';
          }

          ventaFormNotifier.updateState(
            monto: valor,
            ventaForm: ventaForm.copyWith(
              idAbastecimiento: Parse.parseDynamicToInt(abastecimientoSocket
                  .indiceMemoria), // "indice_memoria": "004429",
              totInicio: abastecimientoSocket
                  .totalizadorInicial, //"totalizador_inicial": 116.993,
              totFinal: abastecimientoSocket
                  .totalizadorFinal, // "totalizador_final": 117.194,
            ),
            nuevoProducto: Producto(
              cantidad: 0,
              codigo: codigo, // Código asignado según el códigoCombustible
              descripcion:
                  descripcion, // Descripción asignada según el códigoCombustible
              valUnitarioInterno: Parse.parseDynamicToDouble(
                  abastecimientoSocket.precioUnitario),
              valorUnitario: Parse.parseDynamicToDouble(
                  abastecimientoSocket.precioUnitario),
              llevaIva: 'NO',
              incluyeIva: 'NO',
              recargoPorcentaje: 0,
              recargo: 0,
              descPorcentaje: ventaForm.venDescPorcentaje,
              descuento: 0,
              precioSubTotalProducto: 0,
              valorIva: 0,
              costoProduccion: 0,
            ),
          );
          ventaFormNotifier.agregarProducto(null);

          context.pop();
          context.pop();
        }
      } catch (e) {}
    });
  }

  @override
  void dispose() {
    _channelVisualizacion.sink.close(); 
    _channelAbastecimientos.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.colors.primary, widget.colors.secondary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   padding: const EdgeInsets.all(20),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     shape: BoxShape.circle,
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.black.withAlpha(25),
          //         blurRadius: 10,
          //         offset: const Offset(0, 5),
          //       ),
          //     ],
          //   ),
          //   child: Image.asset(
          //     'assets/loaders/gas-loader.gif',
          //     width: 100,
          //     height: 100,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          const SizedBox(height: 30),
          Text(
            'Valor: \$$valor',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Manguera: ${widget.widget.venId}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Manguera: ${widget.widget.manguera}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 50),
          IconButton(
            onPressed: () {
              context.pop();
              context.pop();
            },
            icon: const Icon(Icons.backspace_outlined),
          ),
          const Text(
            'Por favor, espere mientras se procesa la venta...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
