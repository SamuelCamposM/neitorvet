import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/clientes/presentation/delegates/search_cliente_delegate.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_provider.dart';
import 'package:neitorvet/features/shared/delegate/generic_delegate.dart';
import 'package:neitorvet/features/shared/delegate/item_generic_search.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/venta/domain/entities/inventario.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/venta/presentation/provider/form/venta_form_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/venta_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_repository_provider.dart';

class VentaScreen extends ConsumerWidget {
  final int ventaId;
  const VentaScreen({super.key, required this.ventaId});
  @override
  Widget build(BuildContext context, ref) {
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
                ? const Center(child: Text('Venta no encontrada'))
                : _VentaForm(
                    venta: ventaState.venta!,
                    secuencia: ventaState.secuencia,
                  ),
        floatingActionButton: ventaState.isLoading
            ? null
            : _FloatingButton(
                venta: ventaState.venta!,
              ),
      ),
    );
  }
}

class _FloatingButton extends ConsumerWidget {
  final Venta venta;

  const _FloatingButton({required this.venta});
  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Producto Actualizado')));
  }

  @override
  Widget build(BuildContext context, ref) {
    final productFormState = ref.watch(ventaFormProvider(venta));
    return FloatingActionButton(
      onPressed: () async {
        if (productFormState.isPosting) {
          return;
        }
        final exitoso =
            await ref.read(ventaFormProvider(venta).notifier).onFormSubmit();

        if (exitoso && context.mounted) {
          NotificationsService.show(
              context, 'Venta Actualizado', SnackbarCategory.success);
        }
      },
      child: productFormState.isPosting
          ? SpinPerfect(
              duration: const Duration(seconds: 1),
              spins: 10,
              infinite: true,
              child: const Icon(Icons.refresh),
            )
          : const Icon(Icons.save_as),
    );
  }
}

class _VentaForm extends ConsumerWidget {
  final Venta venta;
  final String secuencia;
  final nuevoEmailController = TextEditingController();
  final montoController = TextEditingController();
  _VentaForm({required this.venta, required this.secuencia});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ventaForm = ref.watch(ventaFormProvider(venta));
    ref.watch(clientesProvider);
    final ventasState = ref.watch(ventasProvider);
    final size = Responsive.of(context);

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
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  text: 'Factura #: ',
                  style: TextStyle(
                    fontSize: size.iScreen(1.8),
                    fontWeight: FontWeight.normal,
                    color: Colors
                        .black, // Asegúrate de establecer el color del texto
                  ),
                  children: [
                    TextSpan(
                      text: secuencia,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      venta.venFechaFactura,
                      style: TextStyle(
                          fontSize: size.iScreen(2),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  CustomRadioBotton(
                    size: size,
                    selectedValue: ventaForm.venFacturaCredito,
                    onChanged: (String? value) {
                      ref
                          .read(ventaFormProvider(venta).notifier)
                          .updateState(venFacturaCredito: value);
                    },
                    questionText: 'Crédito',
                  ),
                  SizedBox(width: size.wScreen(4)),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      readOnly: true,
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
                  customBtnModals(size, Icons.search, () async {
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
                  customBtnModals(size, Icons.add, () {
                    context.push('/cliente/0');
                  }),
                  customBtnModals(size, Icons.mark_email_read, () async {
                    ref
                        .read(ventaFormProvider(venta).notifier)
                        .handleOcultarEmail();

                    // showCustomInputModal(
                    //     context: context,
                    //     label: 'Agregar Email',
                    //     field: CustomInputField(
                    //       label: 'Correo',
                    //       onFieldSubmitted: (_) {
                    //         final result = ref
                    //             .read(ventaFormProvider(venta).notifier)
                    //             .agregarEmail(nuevoEmailController);
                    //         if (result) {
                    //           Navigator.of(context).pop();
                    //         }
                    //       },
                    //       controller: nuevoEmailController,
                    //       onChanged: (p0) {
                    //         print(ventaForm.nuevoEmail.errorMessage);
                    //         ref
                    //             .read(ventaFormProvider(venta).notifier)
                    //             .updateState(nuevoEmail: p0);
                    //       },
                    //       errorMessage: ventaForm.nuevoEmail.errorMessage,
                    //     ));
                  }),
                ],
              ),
              if (!ventaForm.ocultarEmail)
                CustomInputField(
                  autofocus: true,
                  label: 'Correo',
                  onFieldSubmitted: (_) {
                    ref
                        .read(ventaFormProvider(venta).notifier)
                        .agregarEmail(nuevoEmailController);
                  },
                  controller: nuevoEmailController,
                  onChanged: (p0) {
                    ref
                        .read(ventaFormProvider(venta).notifier)
                        .updateState(nuevoEmail: p0);
                  },
                  errorMessage: ventaForm.nuevoEmail.errorMessage,
                  suffixIcon: IconButton(
                      onPressed: () {
                        ref
                            .read(ventaFormProvider(venta).notifier)
                            .agregarEmail(nuevoEmailController);
                      },
                      icon: const Icon(Icons.add_circle_outline)),
                ),
              CustomInputField(
                readOnly: true,
                label: 'Cliente',
                controller:
                    TextEditingController(text: ventaForm.venNomCliente),
                onChanged: (p0) {
                  ref
                      .read(ventaFormProvider(venta).notifier)
                      .updateState(venNomCliente: p0);
                },
                // errorMessage: clienteForm.perCanton.errorMessage,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomSelectField(
                      size: size,
                      label: 'F. de Pago',
                      value: ventaForm.venFormaPago,
                      onChanged: (String? value) {
                        final exist = ventasState.formasPago
                            .any((e) => e.fpagoNombre == value);
                        if (exist) {
                          ref
                              .read(ventaFormProvider(venta).notifier)
                              .updateState(venFormaPago: value);
                          ref
                              .read(ventaFormProvider(venta).notifier)
                              .setPorcentajeFormaPago(value!);
                        }
                      },
                      options: ventasState.formasPago.map(
                        (e) {
                          return e.fpagoNombre;
                        },
                      ).toList(),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final res = await showSearch(
                          query: ventaForm.venOtrosDetalles,
                          context: context,
                          delegate: GenericDelegate(
                            itemWidgetBuilder: (cliente, onItemSelected) =>
                                _ItemWidget(
                              item: cliente,
                              onItemSelected: onItemSelected,
                            ),
                            searchItems: ({search = ''}) async {
                              return ventaForm.placasData;
                              // return ventaForm.placasData
                              //     .where((placa) => placa.contains(search))
                              //     .toList();
                            },
                            setSearch: (search) => ref
                                .read(ventaFormProvider(venta).notifier)
                                .updateState(venOtrosDetalles: search),
                            initialItems: ventaForm.placasData,
                          ));
                      if (res?.item != null) {
                        ref
                            .read(ventaFormProvider(venta).notifier)
                            .updateState(venOtrosDetalles: res!.item);
                      }
                    },
                    icon: const Icon(Icons.create),
                    label: Text(ventaForm.venOtrosDetalles),
                  ),
                ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: size.wScreen(50.0),
                    child: Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final res = await showSearch(
                              query: ventaForm.productoSearch,
                              context: context,
                              delegate: GenericDelegate(
                                itemWidgetBuilder:
                                    (inventarioItem, onItemSelected) =>
                                        ItemGenericSearch(
                                  item: inventarioItem,
                                  title:
                                      '${inventarioItem.invNombre} - ${inventarioItem.invSerie}',
                                  onItemSelected: onItemSelected,
                                ),
                                searchItems: ({search = ''}) async {
                                  final res = await ref
                                      .read(ventasRepositoryProvider)
                                      .getInventarioByQuery(search);
                                  if (res.error.isNotEmpty) {
                                    if (context.mounted) {
                                      NotificationsService.show(context,
                                          res.error, SnackbarCategory.error);
                                    }
                                    return <Inventario>[];
                                  }
                                  return res.resultado;
                                },
                                setSearch: (search) => ref
                                    .read(ventaFormProvider(venta).notifier)
                                    .updateState(productoSearch: search),
                                initialItems: <Inventario>[], //
                              ));

                          if (res?.item != null) {
                            final exist = ventaForm.venProductos.value
                                .any((e) => e.codigo == res!.item!.invSerie);
                            if (exist) {
                              if (context.mounted) {
                                NotificationsService.show(
                                    context,
                                    'Este Producto ya se encuentra en la lista',
                                    SnackbarCategory.error);
                              }
                              return;
                            }

                            ref
                                .read(ventaFormProvider(venta).notifier)
                                .updateState(
                                    nuevoProducto: Producto(
                                  cantidad: 0,
                                  codigo: res!.item!.invSerie,
                                  descripcion: res.item!.invNombre,
                                  valUnitarioInterno:
                                      Parse.parseDynamicToDouble(
                                          res.item!.invprecios[0]),
                                  valorUnitario: Parse.parseDynamicToDouble(
                                      res.item!.invprecios[0]),
                                  llevaIva: res.item!.invIva,
                                  incluyeIva: res.item!.invIncluyeIva,
                                  recargoPorcentaje: 0,
                                  recargo: 0,
                                  descPorcentaje: venta.venDescPorcentaje,
                                  descuento: 0,
                                  precioSubTotalProducto: 0,
                                  valorIva: 0,
                                  costoProduccion: 0,
                                ));
                          }
                        },
                        icon: const Icon(Icons.create),
                        label: Text(ventaForm
                                .nuevoProducto.value.descripcion.isEmpty
                            ? "Ingrese un producto*"
                            : '${ventaForm.nuevoProducto.value.descripcion} \$${ventaForm.nuevoProducto.value.valorUnitario}'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.wScreen(30.0),
                    child: Expanded(
                      child: CustomInputField(
                        textAlign: TextAlign.center,
                        label: 'Precio',
                        controller: montoController,
                        keyboardType: const TextInputType.numberWithOptions(),
                        onChanged: (p0) {
                          ref
                              .read(ventaFormProvider(venta).notifier)
                              .updateState(monto: p0);
                        },
                        suffixIcon: IconButton(
                            onPressed: () {
                              ref
                                  .read(ventaFormProvider(venta).notifier)
                                  .agregarProducto(montoController);
                            },
                            icon: const Icon(Icons.add_circle)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.wScreen(1),
              ),
              _ProductsList(
                size: size,
                products: ventaForm.venProductos.value,
              ),
              Container(
                  padding: EdgeInsets.only(
                      left: size.iScreen(1.5),
                      right: size.iScreen(1.5),
                      top: size.iScreen(0.5)),
                  width: size.wScreen(95.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            //TODO* IVA DEL USUARIO
                            'Subtotal 15 %:',
                            style: TextStyle(
                                fontSize: size.iScreen(1.4),
                                fontWeight: FontWeight.normal),
                          ),
                          Text(
                            '${ventaForm.venSubTotal12}',
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
                            '${ventaForm.venSubtotal0}',
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
                            '${ventaForm.venDescuento}',
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
                            '${ventaForm.venSubTotal}',
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
                            ventaForm.venAbono,
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
                            //TODO* IVA DEL USUARIO
                            'Iva: 15 %',
                            style: TextStyle(
                                fontSize: size.iScreen(1.4),
                                fontWeight: FontWeight.normal),
                          ),
                          Text(
                            '${ventaForm.venTotalIva}',
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
                            '${ventaForm.venTotal}',
                            style: TextStyle(
                                fontSize: size.iScreen(1.8),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  )),
              SizedBox(height: size.hScreen(15)),
            ],
          )),
    );
  }
}
// ...existing code...

class _ProductsList extends ConsumerWidget {
  final List<Producto> products;
  final Responsive size;
  const _ProductsList({
    required this.size,
    required this.products,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: products.map((producto) {
        return Dismissible(
          key: Key(producto
              .codigo), // Asegúrate de que cada producto tenga una clave única
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            // Elimina el producto de la lista
            print(producto);

            // Muestra un mensaje de confirmación
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${producto.descripcion} eliminado')),
            );
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Container(
            padding: const EdgeInsets.all(5.0),
            width: size.wScreen(100), // Ajusta el ancho según lo necesites
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
                Column(
                  children: [
                    SizedBox(
                      width: size.width *
                          0.4, // Ajusta el ancho según sea necesario
                      child: Text(
                        producto.descripcion,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines:
                            4, // Ajusta el número de líneas según sea necesario
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Cantidad: ${producto.cantidad}'),
                    Text('Precio: \$${producto.valorUnitario}'),
                    Text('Código: ${producto.codigo}'),
                    Text('Iva: \$${producto.valorIva}'),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ItemWidget<T> extends StatelessWidget {
  final T item;
  final void Function(BuildContext context, T item) onItemSelected;

  const _ItemWidget({required this.item, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.toString()), // Customize this as needed
      onTap: () => onItemSelected(context, item),
    );
  }
}
