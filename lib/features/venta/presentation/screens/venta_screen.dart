import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_provider.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';
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

  @override
  Widget build(BuildContext context, ref) {
    final ventaState = ref.watch(ventaFormProvider(venta));
    final ventasState = ref.watch(ventasProvider);
    return FloatingActionButton(
      onPressed: () async {
        if (ventaState.isPosting) {
          return;
        }
        final exitoso =
            await ref.read(ventaFormProvider(venta).notifier).onFormSubmit();

        if (exitoso && context.mounted) {
          context.pop('/ventas');
          NotificationsService.show(
              context, '${ventasState.estado} Creada', SnackbarCategory.success);
        }
      },
      child: ventaState.isPosting
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
                    color: Colors.black,
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
                    ),
                  ),
                  customBtnModals(size, Icons.search, () async {
                    final cliente =
                        await searchClienteResult(context: context, ref: ref);
                    if (cliente != null) {
                      ref.read(ventaFormProvider(venta).notifier).updateState(
                            placasData: cliente.perOtros,
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
                      final placa = await searchPlacas(
                          context: context,
                          ref: ref,
                          venOtrosDetalles: ventaForm.venOtrosDetalles,
                          placasData: ventaForm.placasData,
                          setSearch: (String search) {
                            ref
                                .read(ventaFormProvider(venta).notifier)
                                .updateState(venOtrosDetalles: search);
                          });
                      if (placa != null) {
                        ref
                            .read(ventaFormProvider(venta).notifier)
                            .updateState(venOtrosDetalles: placa);
                      }
                    },
                    icon: const Icon(Icons.create),
                    label: Text(ventaForm.venOtrosDetalles),
                  ),
                ],
              ),
              EmailList(
                emails: ventaForm.venEmailCliente,
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
                        final inventario =
                            await searchInventario(context: context, ref: ref);
                        if (inventario != null) {
                          final exist = ventaForm.venProductos.value
                              .any((e) => e.codigo == inventario.invSerie);
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
                                codigo: inventario.invSerie,
                                descripcion: inventario.invNombre,
                                valUnitarioInterno: Parse.parseDynamicToDouble(
                                    inventario.invprecios[0]),
                                valorUnitario: Parse.parseDynamicToDouble(
                                    inventario.invprecios[0]),
                                llevaIva: inventario.invIva,
                                incluyeIva: inventario.invIncluyeIva,
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
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                            color: ventaForm.nuevoProducto.errorMessage != null
                                ? Colors.red
                                : Colors.black),
                      ),
                      icon: const Icon(Icons.create),
                      label: Text(
                        ventaForm.nuevoProducto.errorMessage != null
                            ? ventaForm.nuevoProducto.errorMessage!
                            : ventaForm.nuevoProducto.value.descripcion == ''
                                ? "Producto*"
                                : '${ventaForm.nuevoProducto.value.descripcion} \$${ventaForm.nuevoProducto.value.valorUnitario}',
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
                          onPressed: ventaForm.monto == 0
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
                  products: ventaForm.venProductos.value,
                  eliminarProducto: ref
                      .read(ventaFormProvider(venta).notifier)
                      .eliminarProducto),
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
