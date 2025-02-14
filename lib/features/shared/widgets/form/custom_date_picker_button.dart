import 'package:flutter/material.dart';

class CustomDatePickerButton extends StatelessWidget {
  final String? errorMessage;
  final Function(String value) getDate;
  final String label;
  final String value;

  const CustomDatePickerButton({
    super.key,
    this.errorMessage,
    required this.getDate,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max, // Utiliza todo el ancho disponible
      children: [
        SizedBox(
          width: double.infinity, // Ocupa todo el ancho disponible
          child: OutlinedButton.icon(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                String formattedDate =
                    "${pickedDate.toLocal().year}-${pickedDate.toLocal().month.toString().padLeft(2, '0')}-${pickedDate.toLocal().day.toString().padLeft(2, '0')}";
                getDate(formattedDate);
              }
            },
            style: OutlinedButton.styleFrom(
              alignment:
                  Alignment.centerLeft, // Alinear contenido a la izquierda
              side: BorderSide(
                color: errorMessage != null ? Colors.red : colors.primary,
              ),
            ),
            icon: const Icon(Icons.calendar_today),
            label: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      color: errorMessage != null ? Colors.red : colors.primary,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left, // Alinear texto a la izquierda
                ),
                Text(
                  value == '' ? 'Seleccione' : value,
                  style: TextStyle(
                    color: errorMessage != null ? Colors.red : colors.primary,
                  ),
                  textAlign: TextAlign.left, // Alinear texto a la izquierda
                ),
              ],
            ),
          ),
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
