import 'package:flutter/material.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/custom_botton_modal.dart';
import 'package:neitorvet/features/shared/widgets/custom_input_field.dart';
import 'package:neitorvet/features/shared/widgets/custom_radio_botton.dart';
import 'package:neitorvet/features/shared/widgets/custom_select_fiend.dart';

class FacturaScreen extends StatefulWidget {
  final int facturaId;

  const FacturaScreen({super.key, required this.facturaId});

  @override
  State<FacturaScreen> createState() => _FacturaScreenState();
}

class _FacturaScreenState extends State<FacturaScreen> {
  String? selectedValue;
  String? selectedValueYesNo = 'Sí';
  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nueva Factura'),
        ),
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: size.iScreen(1.0)),
            width: size.wScreen(100),
            height: size.hScreen(100.0),
            child: Stack(
              children: [
                SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          width: size.wScreen(100),
                          child: Text(
                            'Factura #:',
                            style: TextStyle(
                                fontSize: size.iScreen(1.8),
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Text(
                          '001-010-00000000000000000459',
                          style: TextStyle(
                              fontSize: size.iScreen(2),
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: size.wScreen(1),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomInputField(
                                label: 'Ruc Cliente',
                                // initialValue: clienteForm.perCanton.value,
                                onChanged: (p0) {
                                  // ref
                                  //     .read(clienteFormProvider(cliente).notifier)
                                  //     .updateState(perCanton: p0);
                                },
                                // errorMessage: clienteForm.perCanton.errorMessage,
                              ),
                            ),
                            SizedBox(
                                width:
                                    8.0), // Espacio entre el TextFormField y el botón
                            custom_btn_modals(size, Icons.add, () {}),
                          ],
                        ),
                        SizedBox(
                          height: size.wScreen(1.5),
                        ),
                        CustomInputField(
                          label: 'Cliente',
                          // initialValue: clienteForm.perCanton.value,
                          onChanged: (p0) {
                            // ref
                            //     .read(clienteFormProvider(cliente).notifier)
                            //     .updateState(perCanton: p0);
                          },
                          // errorMessage: clienteForm.perCanton.errorMessage,
                        ),
                        SizedBox(
                          height: size.wScreen(1.5),
                        ),
                        CustomSelectField(
                          size: size,
                          label: 'Otros',
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                            });
                            print('Opción seleccionada: $value');
                          },
                          options: [
                            'Efectivo',
                            'Targeta de Crédito',
                            'Opción 3',
                            'Opción 4',
                            'Opción 5'
                          ], // Lista de opciones
                        ),
                        SizedBox(
                          height: size.wScreen(1.5),
                        ),
                        CustomSelectField(
                          size: size,
                          label: 'Placa',
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                            });
                            print('Opción seleccionada: $value');
                          },
                          options: [
                            'Efectivo',
                            'Targeta de Crédito',
                            'Opción 3',
                            'Opción 4',
                            'Opción 5'
                          ], // Lista de opciones
                        ),
                        YesNoRadioButton(
                          size: size,
                          selectedValueYesNo: selectedValueYesNo,
                          onChanged: (String? value) {
                            setState(() {
                              selectedValueYesNo = value;
                            });
                          },
                          questionText: 'Crédito',
                        ),
                        SizedBox(
                          height: size.wScreen(1),
                        ),
                        Row(
                          children: [
                            Text(
                              '23-01-2025',
                              style: TextStyle(
                                  fontSize: size.iScreen(1.8),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                                width: size.wScreen(
                                    4)), // Espacio entre el TextFormField y el botón
                            custom_btn_modals(size, Icons.date_range_outlined,
                                () {
                              _selectDate(context);
                            }),
                          ],
                        ),
                        SizedBox(
                          height: size.wScreen(1),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomInputField(
                                label: 'Correo',
                                // initialValue: clienteForm.perCanton.value,
                                onChanged: (p0) {
                                  // ref
                                  //     .read(clienteFormProvider(cliente).notifier)
                                  //     .updateState(perCanton: p0);
                                },
                                // errorMessage: clienteForm.perCanton.errorMessage,
                              ),
                            ),

                            SizedBox(
                                width: size.wScreen(
                                    4)), // Espacio entre el TextFormField y el botón
                            custom_btn_modals(size, Icons.add, () {
                              // _selectDate(context);
                            }),
                          ],
                        ),
                        SizedBox(
                          height: size.wScreen(1),
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          children: _listaCorreos
                              .map((e) => Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(8)),
                                  margin: EdgeInsets.all(size.iScreen(0.4)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.iScreen(0.2),
                                      horizontal: size.iScreen(1.0)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        e,
                                        style: TextStyle(
                                            fontSize: size.iScreen(1.8),
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Icon(
                                        Icons.close_rounded,
                                        color: Colors.red,
                                      )
                                    ],
                                  )))
                              .toList(),
                        ),
                        SizedBox(
                          height: size.wScreen(2),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: size.wScreen(50.0),
                              child: Expanded(
                                child: CustomInputField(
                                  textAlign: TextAlign.center,
                                  label: 'Ingrese Producto',
                                  // initialValue: clienteForm.perCanton.value,
                                  onChanged: (p0) {
                                    // ref
                                    //     .read(clienteFormProvider(cliente).notifier)
                                    //     .updateState(perCanton: p0);
                                  },
                                  // errorMessage: clienteForm.perCanton.errorMessage,
                                ),
                              ),
                            ),
                            Container(
                              width: size.wScreen(30.0),
                              child: Expanded(
                                child: CustomInputField(
                                  textAlign: TextAlign.center,
                                  label: 'Ingrese Monto',
                                  // initialValue: clienteForm.perCanton.value,
                                  onChanged: (p0) {
                                    // ref
                                    //     .read(clienteFormProvider(cliente).notifier)
                                    //     .updateState(perCanton: p0);
                                  },
                                  // errorMessage: clienteForm.perCanton.errorMessage,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.iScreen(3),
                        ),

//=========LISTA DE PRODUCTOS==========//
                        SizedBox(
                          height: size.wScreen(1),
                        ),
                        Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: _listaProductos.map((producto) {
                            return Container(
                              padding: const EdgeInsets.all(8.0),
                              width: size.wScreen(
                                  100), // Ajusta el ancho según lo necesites
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 1.0,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Columna para Producto y Código
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ' ${producto['Producto']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('Código: ${producto['Codigo']}'),
                                      Text('Costo: \$${producto['Costo']}'),
                                    ],
                                  ),
                                  // Columna para Cantidad, Precio y Costo
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Cantidad: ${producto['Cantidad']}'),
                                      Text('Precio: \$${producto['Precio']}'),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                        SizedBox(
                          height: size.wScreen(2),
                        ),
//===================//
                        Container(
                            padding: EdgeInsets.only(
                                left: size.iScreen(1.5),
                                right: size.iScreen(1.5),
                                top: size.iScreen(0.5)),
                            width: size.wScreen(95.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    8.0), // Ajusta el radio como prefieras
                                topRight: Radius.circular(8.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Subtotal 15 %:',
                                      style: TextStyle(
                                          fontSize: size.iScreen(1.4),
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      '\$ 3000',
                                      style: TextStyle(
                                          fontSize: size.iScreen(1.4),
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Subtotal 0 %:',
                                      style: TextStyle(
                                          fontSize: size.iScreen(1.4),
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      '\$ 3000',
                                      style: TextStyle(
                                          fontSize: size.iScreen(1.4),
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Descuento:',
                                      style: TextStyle(
                                          fontSize: size.iScreen(1.4),
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      '\$ 3000',
                                      style: TextStyle(
                                          fontSize: size.iScreen(1.4),
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Subtotal:',
                                      style: TextStyle(
                                          fontSize: size.iScreen(1.4),
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      '\$ 3000',
                                      style: TextStyle(
                                          fontSize: size.iScreen(1.4),
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Abono',
                                      style: TextStyle(
                                          fontSize: size.iScreen(1.4),
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      '\$ 3000',
                                      style: TextStyle(
                                          fontSize: size.iScreen(1.4),
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Iva: 15 %',
                                      style: TextStyle(
                                          fontSize: size.iScreen(1.4),
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      '\$ 3000',
                                      style: TextStyle(
                                          fontSize: size.iScreen(1.4),
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total:',
                                      style: TextStyle(
                                          fontSize: size.iScreen(1.8),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '\$ 5000',
                                      style: TextStyle(
                                          fontSize: size.iScreen(1.8),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ))
//===================//
                      ],
                    )),
              ],
            )),
      ),
    );
  }

  List<String> _listaCorreos = [
    'test@test.com',
    'juan@test.com',
    'maria@test.com',
    'mar23@test.com',
    'loren4@test.com',
    'ana2@test.com',
  ];
  List<Map<String, dynamic>> _listaProductos = [
    {
      'Producto': 'Manzanas',
      'Codigo': 'P001',
      'Cantidad': 10,
      'Precio': 1.5,
      'Costo': 15.0,
    },
    {
      'Producto': 'Naranjas',
      'Codigo': 'P002',
      'Cantidad': 20,
      'Precio': 2.0,
      'Costo': 40.0,
    },
    {
      'Producto': 'Peras',
      'Codigo': 'P003',
      'Cantidad': 15,
      'Precio': 1.8,
      'Costo': 27.0,
    },
    {
      'Producto': 'Uvas',
      'Codigo': 'P004',
      'Cantidad': 5,
      'Precio': 3.0,
      'Costo': 15.0,
    },
    {
      'Producto': 'Bananas',
      'Codigo': 'P005',
      'Cantidad': 12,
      'Precio': 1.2,
      'Costo': 14.4,
    },
    {
      'Producto': 'Melones',
      'Codigo': 'P006',
      'Cantidad': 8,
      'Precio': 2.5,
      'Costo': 20.0,
    },
  ];

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('es'), // Cambia 'es' al código de idioma deseado
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }
}
