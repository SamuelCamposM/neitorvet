import 'package:flutter/material.dart';

class Factura extends StatelessWidget {
  const Factura({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Factura'),
      ),
      body: const Column(
        children: [
          Icon(Icons.abc),
          Text('Hola'),
        ],
      ),
    );
  }
}
