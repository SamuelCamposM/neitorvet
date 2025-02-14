import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CustomExpandablePhoneList extends StatefulWidget {
  final String label;
  final String? errorMessage;
  final void Function(String) onAddValue;
  final void Function(List<String>) onDeleteValue;
  final List<String> values;

  const CustomExpandablePhoneList({
    super.key,
    required this.label,
    this.errorMessage,
    required this.onAddValue,
    required this.onDeleteValue,
    required this.values,
  });

  @override
  CustomExpandablePhoneListState createState() =>
      CustomExpandablePhoneListState();
}

class CustomExpandablePhoneListState extends State<CustomExpandablePhoneList> {
  final TextEditingController inputController = TextEditingController();
  String? phoneNumber;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String isoCode = 'EC'; // Variable para el código ISO

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
                  Form(
                    key: formKey,
                    child: InternationalPhoneNumberInput(
                      
                      onInputChanged: (PhoneNumber number) {
                        setState(() {
                          phoneNumber = number.phoneNumber;
                          isoCode = number.isoCode ?? 'EC'; // Actualiza el isoCode
                        });
                      },
                      onFieldSubmitted: (p0) {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        setState(() {
                          inputController.text = '';
                          if (phoneNumber != null) {
                            widget.onAddValue(phoneNumber!);
                          }
                        });
                      },
                      onInputValidated: (bool value) {
                        setState(() {
                          // Puedes manejar la validación adicional aquí si es necesario
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa un número de celular válido.';
                        }
                        return null;
                      },
                      selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                      ),
                      ignoreBlank: false,
                      autoValidateMode: AutovalidateMode.disabled,
                      initialValue: PhoneNumber(isoCode: isoCode),
                      textFieldController: inputController,
                      formatInput: false,
                      inputDecoration: const InputDecoration(
                        labelText: 'Número de Celular',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: false,
                      ),
                      onSaved: (PhoneNumber number) {
                        setState(() {
                          isoCode = number.isoCode ?? 'EC'; // Actualiza el isoCode
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
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
