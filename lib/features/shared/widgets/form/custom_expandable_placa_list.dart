import 'package:flutter/material.dart';
import 'package:neitorvet/features/shared/infrastructure/inputs/placa.dart';
import 'package:neitorvet/features/shared/shared.dart';

class CustomExpandablePlacaList extends StatefulWidget {
  final String label;
  final String? errorMessage;
  final void Function(String) onAddValue;
  final void Function(List<String>) onDeleteValue;
  final List<String> values;

  const CustomExpandablePlacaList({
    super.key,
    required this.label,
    this.errorMessage,
    required this.onAddValue,
    required this.onDeleteValue,
    required this.values,
  });

  @override
  CustomExpandablePlacaListState createState() =>
      CustomExpandablePlacaListState();
}

class CustomExpandablePlacaListState extends State<CustomExpandablePlacaList> {
  final TextEditingController inputController = TextEditingController();
  Placa nuevaPlaca = const Placa.pure();

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          dense: true,
          title: Text(
            '${widget.label} ${widget.errorMessage ?? ""}',
            style: TextStyle(
              color: widget.errorMessage != null ? Colors.red : colors.primary,
              fontSize: 12,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomInputField(
                    
                    label: 'Agregar',
                    controller: inputController,
                    errorMessage: nuevaPlaca.errorMessage,
                    onFieldSubmitted: (p0) {
                      if (nuevaPlaca.isNotValid) {
                        return;
                      }
                      setState(() {
                        inputController.text = '';
                        widget.onAddValue(nuevaPlaca.value);
                        nuevaPlaca = const Placa
                            .pure(); // Reinicia nuevaPlaca a su estado inicial
                      });
                    },
                    onChanged: (p0) {
                      setState(() {
                        nuevaPlaca = Placa.dirty(
                            p0); // Actualiza nuevaPlaca cada vez que cambia el valor
                      });
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (nuevaPlaca.isNotValid) {
                          return;
                        }
                        setState(() {
                          inputController.text = '';
                          widget.onAddValue(nuevaPlaca.value);
                          nuevaPlaca = const Placa
                              .pure(); // Reinicia nuevaPlaca a su estado inicial
                        });
                      },
                      icon: const Icon(Icons.add_circle),
                    ),
                  ),
                  Wrap(
                    spacing: 1.0, // Espacio horizontal entre elementos
                    runSpacing:
                        1.0, // Espacio vertical entre líneas de elementos
                    children: widget.values.map((value) {
                      return Chip(
                        label: Text(
                          value,
                          style: const TextStyle(fontSize: 12),
                        ),
                        onDeleted: () {
                          setState(() {
                            List<String> updatedValues =
                                List.from(widget.values);
                            updatedValues
                                .remove(value); // Elimina el valor del arreglo
                            widget.onDeleteValue(
                                updatedValues); // Llama a la función de eliminación con el arreglo actualizado
                          });
                        },
                        deleteIcon: const Icon(
                          Icons.close,
                          size: 16,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
