import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:neitorvet/features/administracion/domain/entities/tanque.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ListaTanqueScreen extends StatefulWidget {
  const ListaTanqueScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ListaTanqueScreen> createState() => _ListaTanqueScreenState();
}

class _ListaTanqueScreenState extends State<ListaTanqueScreen> {
  late WebSocketChannel _channelInventario;
  List<Tanque> listaDeTanques = [];

  @override
  void initState() {
    super.initState();
    // Conectar al WebSocket
    _channelInventario = WebSocketChannel.connect(
      Uri.parse('wss://zaracayapi.neitor.com/ws/inventario_actual'),
    );

    // Escuchar mensajes del WebSocket
    _channelInventario.stream.listen((data) {
      final decodedData = json.decode(data); // Decodificar el string JSON
      if (decodedData['type'] == 'inventory_update') {
        // Procesar los datos de los tanques
        // final List tanquesJson = decodedData['data'];
        print(decodedData['data']);
        final List<Tanque> tanques =
            decodedData['data'].map<Tanque>((e) => Tanque.fromJson(e)).toList();

        setState(() {
          listaDeTanques = tanques;
        });
      }
    });
  }

  @override
  void dispose() {
    _channelInventario.sink.close(); // Cerrar la conexión al salir
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Tanques'),
      ),
      body: LiquidCircularProgressIndicatorPage(
        tanque: listaDeTanques,
      ),
    );
  }
}

class LiquidCircularProgressIndicatorPage extends StatelessWidget {
  final List<Tanque> tanque;

  const LiquidCircularProgressIndicatorPage({super.key, required this.tanque});
  @override
  Widget build(BuildContext context) {
    Color getColorForProducto(int tanque) {
      if (tanque == 3) {
        return Colors.yellow.shade300;
      } else if (tanque == 2) {
        return Colors.lightBlue.shade300;
      } else if (tanque == 1) {
        return Colors.blueGrey.shade200;
      }
      return Colors.grey.shade700;
      // Color predeterminado si no coincide
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: ListView.builder(
        itemCount: tanque.length,
        itemBuilder: (BuildContext context, int index) {
          final itemTanque = tanque[index];

          return _AnimatedLiquidCircularProgressIndicator(
            targetPercentage: ((itemTanque.volumen /
                        (itemTanque.volumen + itemTanque.vacio)) *
                    100)
                .round(),
            tanque: itemTanque,
            color: getColorForProducto(itemTanque.tanque),
          );
        },
      ),
    );
  }
}

class _AnimatedLiquidCircularProgressIndicator extends StatefulWidget {
  final int targetPercentage;
  final Tanque tanque;
  final Color color;

  const _AnimatedLiquidCircularProgressIndicator(
      {required this.targetPercentage,
      required this.tanque,
      required this.color});

  @override
  State<StatefulWidget> createState() =>
      _AnimatedLiquidCircularProgressIndicatorState();
}

class _AnimatedLiquidCircularProgressIndicatorState
    extends State<_AnimatedLiquidCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
      upperBound: widget.targetPercentage / 100,
    );

    _animationController.addListener(() {
      setState(() {});
      if (_animationController.value == _animationController.upperBound) {
        _animationController.stop();
      }
    });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage = _animationController.value * 100;
    final combustible = widget.tanque;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    padding: const EdgeInsets.all(0.5),
                    child: SizedBox(
                      width: 70.0,
                      height: 70.0,
                      child: LiquidCircularProgressIndicator(
                        value: _animationController.value,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation(widget.color),
                        center: Text(
                          "${percentage.toStringAsFixed(0)}%",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * 0.03,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Combustible",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.width * 0.03,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      combustible.tanque == 1
                                          ? "SUPER"
                                          : combustible.tanque == 2
                                              ? "EXTRA"
                                              : "DIESEL",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.width * 0.04,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                         
                              children: [
                                Text(
                                  'Vol. Actual: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: widget.color),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.01),
                                  child: Text(
                                    combustible.volumen.toStringAsFixed(2),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: size.width * 0.05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Fecha",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  Format.formatFechaHora(combustible
                                      .timestampDispositivo
                                      .toString()),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                height: 1,
                width: size.width * 0.8,
                color: Colors.grey,
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "Temperatura",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "${combustible.temperatura.toStringAsFixed(2)} °C",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Volumen",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        combustible.volumen.toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Vacio",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        combustible.vacio.toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                height: 1,
                width: size.width * 0.8,
                color: Colors.grey,
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        "Agua",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        combustible.agua.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Capacidad",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        (combustible.volumen + combustible.vacio)
                            .toStringAsFixed(2),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
