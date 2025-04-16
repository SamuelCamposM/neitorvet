import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:neitorvet/features/administracion/domain/entities/tanque.dart';

class ListaTanqueScreen extends StatelessWidget {
  const ListaTanqueScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Tanque> listaDeTanques = [];

    List tanquesJson = [
      {
        "idTanque": 2,
        "numeroTanque": "02",
        "volumenTotal": 5200,
        "codigoCombustible": "92",
        "fechaHora": "2025-04-04T20:30:15.000Z",
        "estado": "0000",
        "volumen": 3450.65,
        "volumenTemperatura": 3450.65,
        "vacio": 1749.35,
        "altura": 1250.38,
        "agua": 12.5,
        "temperatura": 26.18,
        "volumenAgua": 15.3,
        "columnaExtra": "08"
      },
      {
        "idTanque": 3,
        "numeroTanque": "03",
        "volumenTotal": 3800,
        "codigoCombustible": "95",
        "fechaHora": "2025-04-04T20:28:45.000Z",
        "estado": "0000",
        "volumen": 2100.22,
        "volumenTemperatura": 2100.22,
        "vacio": 1699.78,
        "altura": 950.75,
        "agua": 0,
        "temperatura": 25.89,
        "volumenAgua": 0,
        "columnaExtra": "10"
      },
      {
        "idTanque": 4,
        "numeroTanque": "04",
        "volumenTotal": 6000,
        "codigoCombustible": "98",
        "fechaHora": "2025-04-04T20:31:30.000Z",
        "estado": "0001",
        "volumen": 5800.91,
        "volumenTemperatura": 5800.91,
        "vacio": 199.09,
        "altura": 1845.62,
        "agua": 0,
        "temperatura": 28.05,
        "volumenAgua": 0,
        "columnaExtra": "14"
      },
      {
        "idTanque": 5,
        "numeroTanque": "05",
        "volumenTotal": 4500,
        "codigoCombustible": "94",
        "fechaHora": "2025-04-04T20:27:20.000Z",
        "estado": "0002",
        "volumen": 250.33,
        "volumenTemperatura": 250.33,
        "vacio": 4249.67,
        "altura": 180.15,
        "agua": 5.2,
        "temperatura": 26.75,
        "volumenAgua": 8.7,
        "columnaExtra": "09"
      },
      {
        "idTanque": 6,
        "numeroTanque": "06",
        "volumenTotal": 3500,
        "codigoCombustible": "90",
        "fechaHora": "2025-04-04T20:32:50.000Z",
        "estado": "0000",
        "volumen": 1750.48,
        "volumenTemperatura": 1750.48,
        "vacio": 1749.52,
        "altura": 820.36,
        "agua": 0,
        "temperatura": 27.93,
        "volumenAgua": 0,
        "columnaExtra": "11"
      }
    ];

    // No necesitamos reconstruir _pages aquí, la lista listaDeTanques ya está siendo pasada
    // a la ListaTanqueScreen que se está mostrando.
    listaDeTanques = tanquesJson.map((json) => Tanque.fromJson(json)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Tanques'),
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
    final Random random = Random();

    Color generarColorAleatorio() {
      return Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1.0,
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: ListView.builder(
        itemCount: tanque.length,
        itemBuilder: (BuildContext context, int index) {
          final itemTanque = tanque[index];
          final backgroundColor = generarColorAleatorio();

          return _AnimatedLiquidCircularProgressIndicator(
            targetPercentage:
                (itemTanque.volumen / itemTanque.volumenTotal * 100).round(),
            tanque: itemTanque,
            color: backgroundColor,
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
      duration: Duration(seconds: 3),
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
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    padding: EdgeInsets.all(0.5),
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
                                Text(
                                  'Tanque #: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  combustible.numeroTanque.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Vol.Total: ',
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
                                    combustible.volumenTotal.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
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
                                  "Combustible",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width * 0.03,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  combustible.codigoCombustible.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width * 0.04,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
                                  formatearFecha(
                                      combustible.fechaHora.toString()),
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
                        "Estado",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        combustible.estado.toString(),
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
                        combustible.volumen.toString(),
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
                        "Volumen Temp",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        combustible.temperatura.toString(),
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
                        "Temperatura",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        combustible.temperatura.toString(),
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
                        "Volumen Temp",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        combustible.volumenTemperatura.toString(),
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

//=================== FORMATEA A HORA LOCAL =============================//
String formatearFecha(String fechaOriginal) {
  DateTime dateTime = DateTime.parse(fechaOriginal).toLocal();
  // Restar 5 horas para la zona horaria de Ecuador (UTC-5)
  DateTime ecuadorTime = dateTime.subtract(const Duration(hours: 5));
  String anio = ecuadorTime.year.toString();
  String mes = ecuadorTime.month.toString().padLeft(2, '0');
  String dia = ecuadorTime.day.toString().padLeft(2, '0');
  String hora = ecuadorTime.hour.toString().padLeft(2, '0');
  String minuto = ecuadorTime.minute.toString().padLeft(2, '0');

  return "$anio-$mes-$dia $hora:$minuto";
}
