import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FullScreenLoaderVenta extends StatefulWidget {
  final String manguera;
  const FullScreenLoaderVenta({super.key, required this.manguera});

  @override
  FullScreenLoaderVentaState createState() => FullScreenLoaderVentaState();
}

class FullScreenLoaderVentaState extends State<FullScreenLoaderVenta> {
  late WebSocketChannel _channel;
  late WebSocketChannel _channel2;
  String valor = '0.00';

  @override
  void initState() {
    super.initState();
    // Conectar al WebSocket
    _channel = WebSocketChannel.connect(
      Uri.parse('wss://zaracayapi.neitor.com/api/ws/visualizacion'),
    );
    _channel2 = WebSocketChannel.connect(
      Uri.parse('wss://zaracayapi.neitor.com/api/status-realtime'),
    );

    // Escuchar mensajes
    _channel.stream.listen((message) {
      setState(() {
        print(
            'Mensaje recibido2: $message'); // Imprimir el mensaje en la consola
        // valor = message; // Actualizar el valor con el mensaje recibido
      });
    });
    _channel2.stream.listen((message) {
      print('Mensaje recibido2: $message'); // Imprimir el mensaje en la consola
    });
  }

  @override
  void dispose() {
    _channel.sink.close(); // Cerrar la conexión al salir
    _channel2.sink.close(); // Cerrar la conexión al salir
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Despachando Combustible'),
        backgroundColor: colors.primary,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity, // Asegura que el contenedor ocupe todo el ancho
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colors.primary, colors.secondary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indicador de carga reemplazado por un GIF
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/loaders/gas-loader.gif', // Reemplaza con la ruta de tu GIF
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            // Texto del valor
            Text(
              'Valor: \$${valor}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            // Texto de la manguera
            Text(
              'Manguera: ${widget.manguera}',
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
                icon: Icon(Icons.backspace_outlined)),
            // Mensaje adicional
            Text(
              'Por favor, espere mientras se procesa la venta...',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
