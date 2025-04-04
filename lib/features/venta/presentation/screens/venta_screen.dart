import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/form/email_list.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/venta/infrastructure/delegatesFunction/delegates.dart';
import 'package:neitorvet/features/venta/presentation/provider/form/venta_form_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/venta_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_provider.dart';

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
    ref.listen(
      ventasProvider,
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(
            context, next.error, SnackbarCategory.error);
        ref.read(ventasProvider.notifier).resetError();
      },
    );

    final ventaState = ref.watch(ventaProvider(ventaId));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
              ventaState.venta?.venId == 0 ? 'Nueva Venta' : 'Editar Venta'),
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

  @override
  Widget build(BuildContext context, ref) {
    final ventaFState = ref.watch(ventaFormProvider(venta));
    final ventasState = ref.watch(ventasProvider);
    return FloatingActionButton(
      onPressed: () async {
        if (ventaFState.isPosting) {
          return;
        }
        final exitoso =
            await ref.read(ventaFormProvider(venta).notifier).onFormSubmit();

        if (exitoso && context.mounted) {
          context.pop();
          NotificationsService.show(context, '${ventasState.estado} Creada',
              SnackbarCategory.success);
        }
      },
      child: ventaFState.isPosting
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
    final size = Responsive.of(context);
    final ventaFState = ref.watch(ventaFormProvider(venta));
    final ventasState = ref.watch(ventasProvider);
    final updateForm = ref.read(ventaFormProvider(venta).notifier).updateState;
    final colors = Theme.of(context).colorScheme;
    // final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Factura #: ',
                    style: TextStyle(
                      fontSize: size.iScreen(1.8),
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color, // Asegurando el color correcto
                    ),
                  ),
                  Text(
                    secuencia,
                    style: TextStyle(
                      fontSize: size.iScreen(1.8),
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color, // Asegurando el color correcto
                    ),
                  ),
                ],
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
                  if (ventaFState.permitirCredito)
                    CustomRadioBotton(
                      size: size,
                      selectedValue: ventaFState.ventaForm.venFacturaCredito,
                      onChanged: (String? value) {
                        updateForm(
                            ventaForm: ventaFState.ventaForm
                                .copyWith(venFacturaCredito: value));
                      },
                      questionText: 'Crédito',
                    ),
                  SizedBox(width: size.wScreen(4)),
                ],
              ),
              // Text('HOLA ${ventaFState.ventaForm.venRucClienteInput.value}'),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      readOnly: true,
                      controller: TextEditingController(
                          text: ventaFState.ventaForm.venRucCliente),
                      label: 'Ruc Cliente',
                      onChanged: (p0) {
                        updateForm(
                            ventaForm: ventaFState.ventaForm
                                .copyWith(venRucCliente: p0));
                      },
                    ),
                  ),
                  customBtnModals(size, Icons.search, () async {
                    final cliente =
                        await searchClienteResult(context: context, ref: ref);
                    if (cliente != null) {
                      updateForm(
                          permitirCredito: cliente.perCredito == 'SI',
                          placasData: cliente.perOtros,
                          ventaForm: ventaFState.ventaForm.copyWith(
                            venRucCliente: cliente.perDocNumero,
                            venNomCliente: cliente.perNombre,
                            venIdCliente: cliente.perId,
                            venTipoDocuCliente: cliente.perDocTipo,
                            venEmailCliente: cliente.perEmail,
                            venTelfCliente: cliente.perTelefono,
                            venCeluCliente: cliente.perCelular,
                            venDirCliente: cliente.perDireccion,
                            venOtrosDetalles: cliente.perOtros.isEmpty
                                ? ""
                                : cliente.perOtros[0],
                          ));
                    }
                  }),
                  customBtnModals(size, Icons.add, () {
                    context.push('/cliente/0');
                  }),
                  customBtnModals(size, Icons.mark_email_read, () async {
                    ref
                        .read(ventaFormProvider(venta).notifier)
                        .handleOcultarEmail();
                  }),
                ],
              ),
              Text(ventaFState.nuevoEmail.value),
              if (!ventaFState.ocultarEmail)
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
                  errorMessage: ventaFState.nuevoEmail.errorMessage,
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
                controller: TextEditingController(
                    text: ventaFState.ventaForm.venNomCliente),
                onChanged: (p0) {
                  updateForm(
                      ventaForm:
                          ventaFState.ventaForm.copyWith(venNomCliente: p0));
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
                      value: ventaFState.ventaForm.venFormaPago,
                      onChanged: (String? value) {
                        final exist = ventasState.formasPago
                            .any((e) => e.fpagoNombre == value);
                        if (exist) {
                          updateForm(
                              ventaForm: ventaFState.ventaForm
                                  .copyWith(venFormaPago: value));
                          ref
                              .read(ventaFormProvider(venta).notifier)
                              .setPorcentajeFormaPago(value!);
                        }
                      },
                      options: ventasState.formasPago.map(
                        (e) {
                          return Option(
                              label: e.fpagoNombre, value: e.fpagoNombre);
                        },
                      ).toList(),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final placa = await searchPlacas(
                          context: context,
                          ref: ref,
                          venOtrosDetalles:
                              ventaFState.ventaForm.venOtrosDetalles,
                          placasData: ventaFState.placasData,
                          setSearch: (String search) {
                            updateForm(
                                ventaForm: ventaFState.ventaForm
                                    .copyWith(venOtrosDetalles: search));
                          });
                      if (placa != null) {
                        updateForm(
                            ventaForm: ventaFState.ventaForm
                                .copyWith(venOtrosDetalles: placa));
                      }
                    },
                    icon: const Icon(Icons.create),
                    label: Text(ventaFState.ventaForm.venOtrosDetalles),
                  ),
                ],
              ),
              EmailList(
                emails: ventaFState.ventaForm.venEmailCliente,
                eliminarEmail: (email) {
                  ref
                      .read(ventaFormProvider(venta).notifier)
                      .eliminarEmail(email);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: size.wScreen(50.0),
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        context.push('/seleccionSurtidor/${venta.venId}');
                        // context.push('/venta/${venta.venId}');
                        // final inventario =
                        //     await searchInventario(context: context, ref: ref);
                        // if (inventario != null) {
                        //   final exist = ventaFState
                        //       .ventaForm.venProductosInput.value
                        //       .any((e) => e.codigo == inventario.invSerie);
                        //   if (exist) {
                        //     if (context.mounted) {
                        //       NotificationsService.show(
                        //           context,
                        //           'Este Producto ya se encuentra en la lista',
                        //           SnackbarCategory.error);
                        //     }
                        //     return;
                        //   }
                        //   ref
                        //       .read(ventaFormProvider(venta).notifier)
                        //       .updateState(
                        //           nuevoProducto: Producto(
                        //         cantidad: 0,
                        //         codigo: inventario.invSerie,
                        //         descripcion: inventario.invNombre,
                        //         valUnitarioInterno: Parse.parseDynamicToDouble(
                        //             inventario.invprecios[0]),
                        //         valorUnitario: Parse.parseDynamicToDouble(
                        //             inventario.invprecios[0]),
                        //         llevaIva: inventario.invIva,
                        //         incluyeIva: inventario.invIncluyeIva,
                        //         recargoPorcentaje: 0,
                        //         recargo: 0,
                        //         descPorcentaje: venta.venDescPorcentaje,
                        //         descuento: 0,
                        //         precioSubTotalProducto: 0,
                        //         valorIva: 0,
                        //         costoProduccion: 0,
                        //       ));
                        // }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color:
                                ventaFState.nuevoProducto.errorMessage != null
                                    ? Colors.red
                                    : Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      icon: const Icon(Icons.create),
                      label: Text(
                        ventaFState.nuevoProducto.errorMessage != null
                            ? ventaFState.nuevoProducto.errorMessage!
                            : ventaFState.nuevoProducto.value.descripcion == ''
                                ? "Producto*"
                                : '${ventaFState.nuevoProducto.value.descripcion} \$${ventaFState.nuevoProducto.value.valorUnitario}',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.wScreen(30.0),
                    child: CustomInputField(
                      textAlign: TextAlign.center,
                      label: 'Precio',
                      controller: montoController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      onFieldSubmitted: (_) {
                        ref
                            .read(ventaFormProvider(venta).notifier)
                            .agregarProducto(montoController);
                      },
                      onChanged: (p0) {
                        ref
                            .read(ventaFormProvider(venta).notifier)
                            .updateState(monto: p0);
                      },
                      suffixIcon: IconButton(
                          onPressed: ventaFState.monto == 0
                              ? null
                              : () {
                                  ref
                                      .read(ventaFormProvider(venta).notifier)
                                      .agregarProducto(montoController);
                                },
                          icon: const Icon(Icons.add_circle)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.wScreen(1),
              ),
              _ProductsList(
                  size: size,
                  products: ventaFState.ventaForm.venProductosInput.value,
                  eliminarProducto: ref
                      .read(ventaFormProvider(venta).notifier)
                      .eliminarProducto),
              SizedBox(
                height: size.wScreen(1),
              ),
              Container(
                  padding: EdgeInsets.only(
                      left: size.iScreen(1.5),
                      right: size.iScreen(1.5),
                      bottom: size.iScreen(1.0),
                      top: size.iScreen(0.5)),
                  width: size.wScreen(95.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
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
                            '${ventaFState.ventaForm.venSubTotal12}',
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
                            '${ventaFState.ventaForm.venSubtotal0}',
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
                            '${ventaFState.ventaForm.venDescuento}',
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
                            '${ventaFState.ventaForm.venSubTotal}',
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
                            ventaFState.ventaForm.venAbono,
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
                            '${ventaFState.ventaForm.venTotalIva}',
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
                            '${ventaFState.ventaForm.venTotal}',
                            style: TextStyle(
                                fontSize: size.iScreen(1.8),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (ventaFState.ventaForm.venTotalInput.errorMessage !=
                          null)
                        Text(
                          '${ventaFState.ventaForm.venTotalInput.errorMessage}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.iScreen(1.2),
                            color: colors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (ventaFState
                              .ventaForm.venProductosInput.errorMessage !=
                          null)
                        Text(
                          '${ventaFState.ventaForm.venProductosInput.errorMessage}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.iScreen(1.2),
                            color: colors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (ventaFState
                              .ventaForm.venRucClienteInput.errorMessage !=
                          null)
                        Text(
                          '${ventaFState.ventaForm.venRucClienteInput.errorMessage}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.iScreen(1.2),
                            color: colors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  )),
              SizedBox(height: size.hScreen(15)),
            ],
          )),
    );
  }
}

class _ProductsList extends ConsumerWidget {
  final List<Producto> products;
  final Responsive size;
  final void Function(String codigo) eliminarProducto;
  const _ProductsList(
      {required this.size,
      required this.products,
      required this.eliminarProducto});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
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
            eliminarProducto(producto.codigo);

            // Muestra un mensaje de confirmación

            NotificationsService.show(context,
                '${producto.descripcion} Eliminado', SnackbarCategory.error);
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Icon(
              Icons.delete,
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(5.0),
            width: size.wScreen(100), // Ajusta el ancho según lo necesites
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 1.0,
                  color: colors.shadow,
                  offset: const Offset(0.0, 3.0),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Código: ${producto.codigo}'),
                    Text('Precio: \$${producto.valorUnitario}'),
                    Text('Cantidad: ${producto.cantidad}'),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        producto.descripcion,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ),
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
