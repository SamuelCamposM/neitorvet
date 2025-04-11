import 'package:flutter/material.dart';

class DispensadoresScreen extends StatelessWidget {
  const DispensadoresScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dispensadores'),
      ),
      body: Center(
        child: Text('Dispensadores'),
      ),
    );
  }
}
