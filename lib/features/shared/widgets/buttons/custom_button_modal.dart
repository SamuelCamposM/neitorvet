import 'package:flutter/material.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

Container customBtnModals(
    Responsive size, IconData icon, VoidCallback onPressed) {
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: size.iScreen(0.5), vertical: size.iScreen(0.0)),
    height: size.iScreen(4.5), // Tamaño del botón más pequeño
    width: size.iScreen(4.5),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(size.iScreen(1)), // Reducir el relleno interno
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8), // Bordes redondeados de 8 píxeles
        ),
      ),
      onPressed: onPressed, // Usar la función onPressed pasada como parámetro
      child: Icon(
        icon,
        size: size.iScreen(2.5), // Tamaño más pequeño del ícono
      ),
    ),
  );
}
