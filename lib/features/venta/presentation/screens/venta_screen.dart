import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/clientes/presentation/delegates/search_cliente_delegate.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_provider.dart';
import 'package:neitorvet/features/clientes/presentation/provider/form/cliente_form_provider.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/venta/presentation/provider/form/venta_form_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/venta_provider.dart';

import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';

class VentaScreen extends ConsumerWidget {
  final int ventaId;
  const VentaScreen({super.key, required this.ventaId});
  @override
  Widget build(BuildContext context, ref) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(contextProvider.notifier).state = context;
    // });
    ref.listen(
      ventaProvider(ventaId),
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(context, next.error, SnackbarCategory.error);
      },
    );

    final ventaState = ref.watch(ventaProvider(ventaId));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              ventaState.venta?.venId == 0 ? 'Crear Venta' : 'Editar Venta'),
        ),
        body: ventaState.isLoading
            ? const FullScreenLoader()
            : ventaState.venta == null
                ? Center(child: Text('Venta no encontrada'))
                : _VentaForm(venta: ventaState.venta!),
        // floatingActionButton: ventaState.isLoading
        //     ? null
        //     : _FloatingButton(
        //         venta: ventaState.venta!,
        //       ),
      ),
    );
  }
}

// class _FloatingButton extends ConsumerWidget {
//   final Venta venta;

//   const _FloatingButton({required this.venta});
//   void showSnackBar(BuildContext context) {
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context)
//         .showSnackBar(const SnackBar(content: Text('Producto Actualizado')));
//   }

//   @override
//   Widget build(BuildContext context, ref) {
//     final productFormState = ref.watch(ventaFormProvider(venta));
//     return FloatingActionButton(
//       onPressed: () async {
//         if (productFormState.isPosting) {
//           return;
//         }
//         final exitoso = await ref
//             .read(ventaFormProvider(venta).notifier)
//             .onFormSubmit();

//         if (exitoso && context.mounted) {
//           NotificationsService.show(
//               context, 'Venta Actualizado', SnackbarCategory.success);
//         }
//       },
//       child: productFormState.isPosting
//           ? SpinPerfect(
//               duration: const Duration(seconds: 1),
//               spins: 10,
//               infinite: true,
//               child: const Icon(Icons.refresh),
//             )
//           : const Icon(Icons.save_as),
//     );
//   }
// }

class _VentaForm extends ConsumerWidget {
  final Venta venta;
  const _VentaForm({required this.venta});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ventaForm = ref.watch(ventaFormProvider(venta));
    final clientesState = ref.watch(clientesProvider);
    final size = Responsive.of(context);

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(ventaForm.venFechaFactura),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        locale: const Locale('es'), // Cambia 'es' al código de idioma deseado
      );
      ref.read(ventaFormProvider(venta).notifier).updateState(
            venFechaFactura: picked?.toString() ?? ventaForm.venFechaFactura,
          );
    }

    Future<SearchResult?> searchClienteResult() async {
      final clientesState = ref.read(clientesProvider);
      return await showSearch<SearchResult>(
          query: clientesState.search,
          context: context,
          delegate: SearchClienteDelegate(
            onlySelect: true,
            setSearch: ref.read(clientesProvider.notifier).setSearch,
            initalClientes: clientesState.searchedClientes,
            searchClientes:
                ref.read(clientesProvider.notifier).searchClientesByQuery,
          ));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
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
                ventaForm.venRucCliente.value,
                style: TextStyle(
                    fontSize: size.iScreen(2), fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: size.wScreen(1),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      controller: TextEditingController(
                          text: ventaForm.venRucCliente.value),
                      label: 'Ruc Cliente',
                      onChanged: (p0) {
                        ref
                            .read(ventaFormProvider(venta).notifier)
                            .updateState(venRucCliente: p0);
                      },
                      // errorMessage: clienteForm.perCanton.errorMessage,
                    ),
                  ),
                  const SizedBox(
                      width: 8.0), // Espacio entre el TextFormField y el botón
                  custom_btn_modals(size, Icons.search, () async {
                    final response = await searchClienteResult();
                    if (response?.cliente != null) {
                      ref.read(ventaFormProvider(venta).notifier).updateState(
                            placasData: response?.cliente!.perOtros,
                            venRucCliente: response?.cliente!.perDocNumero,
                            venNomCliente: response?.cliente!.perNombre,
                            venIdCliente: response?.cliente!.perId,
                            venTipoDocuCliente: response?.cliente!.perDocTipo,
                            venEmailCliente: response?.cliente!.perEmail,
                            venTelfCliente: response?.cliente!.perTelefono,
                            venCeluCliente: response?.cliente!.perCelular,
                            venDirCliente: response?.cliente!.perDireccion,
                            venOtrosDetalles:
                                response?.cliente?.perOtros.isEmpty ?? true
                                    ? ""
                                    : response!.cliente!.perOtros[0],
                          );
                    }
                  }),
                  custom_btn_modals(size, Icons.add, () {}),
                ],
              ),
              SizedBox(
                height: size.wScreen(1.5),
              ),
              CustomInputField(
                label: 'Cliente',
                controller:
                    TextEditingController(text: ventaForm.venNomCliente),
                onChanged: (p0) {
                  print(ventaForm.venRucCliente.value);
                  ref
                      .read(ventaFormProvider(venta).notifier)
                      .updateState(venNomCliente: p0);
                },
                // errorMessage: clienteForm.perCanton.errorMessage,
              ),
              SizedBox(
                height: size.wScreen(1.5),
              ),
              CustomSelectField(
                size: size,
                label: 'Otros',
                value: ventaForm.venOtrosDetalles,
                onChanged: (String? value) {
                  ref
                      .read(ventaFormProvider(venta).notifier)
                      .updateState(venOtrosDetalles: value);
                },
                options: ventaForm.placasData, // Lista de opciones
              ),
              SizedBox(
                height: size.wScreen(1.5),
              ),
              CustomSelectField(
                size: size,
                label: 'Formas de Pago',
                // value: selectedValue,
                onChanged: (String? value) {},
                options: const [
                  'Efectivo',
                  'Targeta de Crédito',
                  'Opción 3',
                  'Opción 4',
                  'Opción 5'
                ], // Lista de opciones
              ),
              YesNoRadioButton(
                size: size,
                selectedValueYesNo: ventaForm.venFacturaCredito,
                onChanged: (String? value) {
                  ref
                      .read(ventaFormProvider(venta).notifier)
                      .updateState(venFacturaCredito: value);
                },
                questionText: 'Crédito',
              ),
              SizedBox(
                height: size.wScreen(1),
              ),
              Row(
                children: [
                  Text(
                    ventaForm.venFechaFactura.substring(0,10),
                    style: TextStyle(
                        fontSize: size.iScreen(1.8),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                      width: size.wScreen(
                          4)), // Espacio entre el TextFormField y el botón
                  custom_btn_modals(size, Icons.date_range_outlined, () {
                    selectDate(context);
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
                children: ventaForm.venEmailCliente
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
                            const Icon(
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
                  SizedBox(
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
                  SizedBox(
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
                children: [].map((producto) {
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    width:
                        size.wScreen(100), // Ajusta el ancho según lo necesites
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                          blurRadius: 1.0,
                          offset: const Offset(0.0, 3.0),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Columna para Producto y Código
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' ${producto['Producto']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(
                          8.0), // Ajusta el radio como prefieras
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}
