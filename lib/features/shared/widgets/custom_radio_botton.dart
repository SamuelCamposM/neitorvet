import 'package:flutter/material.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class YesNoRadioButton extends StatelessWidget {
  final Responsive size;
  final String? selectedValueYesNo; // Valor seleccionado
  final Function(String?)?
      onChanged; // Función de callback para el cambio de valor
  final String questionText; // Texto de la pregunta

  // Constructor
  const YesNoRadioButton({
    Key? key,
    required this.selectedValueYesNo,
    required this.onChanged,
    required this.questionText,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          questionText,
          style: TextStyle(fontSize: 18),
        ),
        // Opción Sí
        Row(
          children: [
            Radio<String>(
              value: 'Sí',
              groupValue: selectedValueYesNo,
              onChanged: onChanged,
            ),
            Text(
              'Sí',
              style: TextStyle(
                  fontSize: size.iScreen(1.8), fontWeight: FontWeight.normal),
            ),
          ],
        ),
        // Opción No
        Row(
          children: [
            Radio<String>(
              value: 'No',
              groupValue: selectedValueYesNo,
              onChanged: onChanged,
            ),
            Text('No'),
          ],
        ),
      ],
    );
  }
}
