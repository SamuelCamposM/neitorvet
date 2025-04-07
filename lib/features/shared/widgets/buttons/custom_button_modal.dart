import 'package:flutter/material.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class CustomButtonModal extends StatelessWidget {
  final Responsive size;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomButtonModal({
    Key? key,
    required this.size,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.iScreen(0.5),
        vertical: size.iScreen(0.0),
      ),
      height: size.iScreen(4.5), // Tamaño del botón más pequeño
      width: size.iScreen(4.5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(size.iScreen(1)), // Reducir el relleno interno
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Bordes redondeados
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
}