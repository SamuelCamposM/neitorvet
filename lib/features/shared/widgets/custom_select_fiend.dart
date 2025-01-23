import 'package:flutter/material.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class CustomSelectField extends StatelessWidget {
  final String? value; // Valor seleccionado
  final String? label;
  final Responsive? size;
  final Function(String?)? onChanged; // Evento cuando cambia el valor
  final List<String> options; // Lista de opciones dinámicas

  const CustomSelectField({
    super.key,
    this.value,
    this.onChanged,
    this.label,
    required this.size,
    required this.options, // Recibimos las opciones como parámetro
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: UnderlineInputBorder(
          borderSide:
              BorderSide(color: colors.onSurface), // Usar color del tema
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colors
                .primary, // Usar color principal del tema cuando está enfocado
          ),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: colors.error), // Usar color de error del tema
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: colors.error, // Color de error cuando está enfocado
          ),
        ),
      ),
      isExpanded: true, // Asegura que el dropdown ocupe el espacio disponible
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(
            option,
            style: TextStyle(fontSize: size!.iScreen(1.8)),
            overflow: TextOverflow.ellipsis, // Truncar texto largo
            maxLines: 1, // Limitar a una sola línea
          ),
        );
      }).toList(),
    );
  }
}
