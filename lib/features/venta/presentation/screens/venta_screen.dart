import 'package:animate_do/animate_do.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/administracion/domain/entities/live_visualization.dart';
import 'package:neitorvet/features/administracion/presentation/widgets/estacion_card.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/surtidor.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/form/email_list.dart';
import 'package:neitorvet/features/shared/widgets/modal/cupertino_modal.dart';
import 'package:neitorvet/features/venta/domain/entities/abastecimiento.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';
import 'package:neitorvet/features/venta/infrastructure/delegatesFunction/delegates.dart';
import 'package:neitorvet/features/venta/presentation/provider/form/venta_form_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/tabs_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/venta_abastecimiento_provider.dart';

import 'package:neitorvet/features/venta/presentation/provider/ventas_provider.dart';

class VentaTabsScreen extends ConsumerStatefulWidget {
  const VentaTabsScreen({Key? key}) : super(key: key);

  @override
  VentaTabsScreenState createState() => VentaTabsScreenState();
}

class VentaTabsScreenState extends ConsumerState<VentaTabsScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabsState = ref.watch(tabsProvider);
    final tabsNotifier = ref.read(tabsProvider.notifier);
    final colors = Theme.of(context).colorScheme;
    final authState = ref.watch(authProvider);
    ref.listen<VentaAbastecimientoState>(
      ventaAbastecimientoProvider,
      (_, next) {
        for (var valor in next.valores) {
          print('llegando valores: ${valor.pico}: ${valor.valorActual}');
          final tabFind = tabsState.tabs.firstWhere(
            (tab) => tab.manguera == valor.pico.toString(),
            orElse: () => const TabItem(id: 0, label: '', manguera: ""),
          );
          if (tabFind.manguera.isNotEmpty) {
            final ventaFormProviderParams = VentaFormProviderParams(
              editar: false,
              id: tabFind.id,
            );
            final ventaFNotifier =
                ref.watch(ventaFormProvider(ventaFormProviderParams).notifier);

            ventaFNotifier.setValor(valor.valorActual);
            final estado =
                next.manguerasStatus!.data[tabFind.manguera.toString()];
            ventaFNotifier.setEstadoManguera(estado);
            tabsNotifier.updateTabManguera(tabFind.id,
                monto: valor.valorActual);
          }
        }
      },
    );
    ref.listen<VentaAbastecimientoState>(
      ventaAbastecimientoProvider,
      (_, next) {
        if (next.abastecimientoSocket != null) {
          final tabFind = tabsState.tabs.firstWhere(
            (tab) => tab.manguera == next.abastecimientoSocket?.pico.toString(),
            orElse: () => const TabItem(id: 0, label: '', manguera: ""),
          );
          if (tabFind.manguera.isNotEmpty) {
            final ventaFormProviderParams = VentaFormProviderParams(
              editar: false,
              id: tabFind.id,
            );
            final ventaFNotifier =
                ref.watch(ventaFormProvider(ventaFormProviderParams).notifier);

            final ventaFState =
                ref.watch(ventaFormProvider(ventaFormProviderParams));
            // Variables para descripción y código según el códigoCombustible
            String descripcion = '';
            String codigo = '';

            // Asignar valores según el códigoCombustible
            switch (next.abastecimientoSocket?.codigoCombustible) {
              case 57:
                descripcion = 'GASOLINA EXTRA';
                codigo = '0101';
                break;
              case 58:
                descripcion = 'GASOLINA SÚPER';
                codigo = '0185';
                break;
              case 59:
                descripcion = 'DIESEL PREMIUM';
                codigo = '0121';
                break;
              default:
                descripcion = 'DESCONOCIDO';
                codigo = '0000';
            }

            ventaFNotifier.updateState(
              monto: ventaFState.valor.toString(),
              ventaForm: ventaFState.ventaForm.copyWith(
                // idAbastecimiento: Parse.parseDynamicToInt(
                //     next.abastecimientoSocket!.indiceMemoria),
                totInicio: next.abastecimientoSocket!.totalizadorInicial,
                totFinal: next.abastecimientoSocket!.totalizadorFinal,
                abastecimiento: Abastecimiento(
                  registro:
                      next.abastecimientoSocket!.indiceMemoria, //indice_memoria
                  pistola: next.abastecimientoSocket!.pico, //pico
                  numeroTanque: next.abastecimientoSocket!.tanque, //tanque
                  codigoCombustible: next.abastecimientoSocket!.codigoCombustible, //tanque
                  valorTotal: next.abastecimientoSocket!.total, //total
                  volTotal: next.abastecimientoSocket!.volumen, //volumen
                  precioUnitario: next.abastecimientoSocket!.precioUnitario,
                  tiempo: next.abastecimientoSocket!
                      .duracionSegundos, // duracion_segundos
                  fechaHora:
                      '${next.abastecimientoSocket!.fecha} ${next.abastecimientoSocket!.hora}', // fecha
                  // "": "08:50:09",
                  totInicio: Parse.parseDynamicToInt(next.abastecimientoSocket!
                      .totalizadorInicial), //totalizadorInicial
                  totFinal: next.abastecimientoSocket!
                      .totalizadorFinal, //totalizadorFinal
                  iDoperador:
                      next.abastecimientoSocket!.idFrentista, //id_frentista
                  iDcliente: next.abastecimientoSocket!.idCliente, //id_cliente
                  volTanque: Parse.parseDynamicToInt(next.abastecimientoSocket!
                      .odometroOVolTanque), //odometro_o_vol_tanque
                  facturado: 1,
                  nombreCombustible: descripcion, //descripcion
                  usuario: authState.user!.usuario,
                  cedulaCliente: ventaFState.ventaForm.venRucCliente,
                  nombreCliente: ventaFState.ventaForm.venNomCliente,
                ),
              ),
              nuevoProducto: Producto(
                cantidad: 0,
                codigo: codigo,
                descripcion: descripcion,
                valUnitarioInterno: Parse.parseDynamicToDouble(
                    next.abastecimientoSocket!.precioUnitario),
                valorUnitario: Parse.parseDynamicToDouble(
                    next.abastecimientoSocket!.precioUnitario),
                llevaIva: 'SI',
                incluyeIva: 'SI',
                recargoPorcentaje: 0,
                recargo: 0,
                descPorcentaje: ventaFState.ventaForm.venDescPorcentaje,
                descuento: 0,
                precioSubTotalProducto: 0,
                valorIva: 0,
                costoProduccion: 0,
              ),
            );
            ventaFNotifier.agregarProducto(null, sinAlerta: true);
            ventaFNotifier.onFormSubmit();
          }
        }
      },
    );

    for (var tab in tabsState.tabs) {
      ref.listen<VentaFormState>(
        ventaFormProvider(VentaFormProviderParams(editar: false, id: tab.id)),
        (_, next) {
          if (next.error.isNotEmpty) {
            NotificationsService.show(
              context,
              next.error,
              SnackbarCategory.error,
            );
          }
        },
      );
    }
    return PopScope(
      canPop: !tabsState.tabs.any(
        (tab) => tab.manguera.isNotEmpty,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Facturación'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                tabsNotifier.addTab(_pageController);
              },
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: tabsNotifier.removeTab,
            ),
          ],
        ),
        body: PageView.builder(
          controller: _pageController,
          onPageChanged: tabsNotifier.onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tabsState.tabs.length,
          itemBuilder: (context, index) {
            final tab = tabsState.tabs[index];
            return VentaScreen(
              ventaFormProviderParams: VentaFormProviderParams(
                editar: false,
                id: tab.id,
              ),
            );
          },
        ),
        bottomNavigationBar: tabsState.tabs.length < 2
            ? const SizedBox.shrink()
            : BottomNavigationBar(
                currentIndex: tabsState.selectedIndex,
                onTap: (index) {
                  tabsNotifier.onPageChanged(index);
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                backgroundColor: colors.surfaceDim,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                items: tabsState.tabs
                    .map(
                      (tab) => BottomNavigationBarItem(
                        icon: Icon(
                          Icons.receipt,

                          color: tab.nombreCombustible == 'DIESEL PREMIUN'
                              ? Colors.yellow.shade300
                              : tab.nombreCombustible == 'GASOLINA EXTRA'
                                  ? Colors.lightBlue.shade300
                                  : tab.nombreCombustible == 'GASOLINA SUPER'
                                      ? Colors.blueGrey.shade200
                                      : Colors
                                          .grey, // Color predeterminado si no coincide con ningún caso
                        ),
                        label: tab.manguera.isNotEmpty
                            ? '${tab.manguera} - \$${tab.monto}'
                            : tab.label,
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}

class VentaScreen extends ConsumerWidget {
  final VentaFormProviderParams ventaFormProviderParams;
  const VentaScreen({
    super.key,
    required this.ventaFormProviderParams,
  });
  @override
  Widget build(BuildContext context, ref) {
    final ventaFState = ref.watch(ventaFormProvider(ventaFormProviderParams));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ventaFState.isLoading
            ? const FullScreenLoader()
            : _VentaForm(
                ventaFState: ventaFState,
                // ventaFNotifier: ventaFNotifier,
                ventaFormProviderParams: ventaFormProviderParams,
              ),
        floatingActionButton: ventaFState.isLoading
            ? null
            : _FloatingButton(
                ventaFState: ventaFState,
                ventaFormProviderParams: ventaFormProviderParams),
      ),
    );
  }
}

class _FloatingButton extends ConsumerWidget {
  final VentaFormState ventaFState;

  final VentaFormProviderParams ventaFormProviderParams;
  const _FloatingButton({
    required this.ventaFState,
    required this.ventaFormProviderParams,
  });

  @override
  Widget build(BuildContext context, ref) {
    final ventasState = ref.watch(ventasProvider);
    final ventaFNotifier =
        ref.watch(ventaFormProvider(ventaFormProviderParams).notifier);
    return FloatingActionButton(
      onPressed: () async {
        if (ventaFState.isPosting || ventaFState.saved) {
          return;
        }
        final exitoso = await ventaFNotifier.onFormSubmit();

        if (exitoso && context.mounted) {
          context.pop();
          NotificationsService.show(context,
              '${ventasState.estado.value} Creada', SnackbarCategory.success);
        }
      },
      child: ventaFState.isPosting || ventaFState.saved
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

class _VentaForm extends ConsumerStatefulWidget {
  final VentaFormState ventaFState;
  final VentaFormProviderParams ventaFormProviderParams;

  const _VentaForm({
    required this.ventaFState,
    required this.ventaFormProviderParams,
  });

  @override
  _VentaFormState createState() => _VentaFormState();
}

class _VentaFormState extends ConsumerState<_VentaForm> {
  late TextEditingController nuevoEmailController;
  late TextEditingController montoController;

  @override
  void initState() {
    super.initState();
    nuevoEmailController = TextEditingController();
    montoController = TextEditingController();
  }

  @override
  void dispose() {
    nuevoEmailController.dispose();
    montoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    final colors = Theme.of(context).colorScheme;
    final ventasState = ref.watch(ventasProvider);
    final ventaFNotifier =
        ref.read(ventaFormProvider(widget.ventaFormProviderParams).notifier);
    final updateForm = ventaFNotifier.updateState;
    final venta = widget.ventaFState.ventaForm;
    final ventaFState = widget.ventaFState;
    // ref.listen(
    //   ventaProvider(venta.venId),
    //   (_, next) {
    //     if (next.error.isEmpty) return;
    //     NotificationsService.show(context, next.error, SnackbarCategory.error);
    //   },
    // );
    ref.listen(
      ventasProvider,
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(context, next.error, SnackbarCategory.error);
        ref.read(ventasProvider.notifier).resetError();
      },
    );
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
                    'Factura #:  ',
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
                    ventaFState.ventaFormProviderParams.id.toString(),
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
                  if (widget.ventaFState.permitirCredito)
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
                      suffixIcon: ventaFState.ventaForm.venRucCliente !=
                              '9999999999999'
                          ? IconButton(
                              onPressed: () async {
                                final res = await cupertinoModal(
                                    context,
                                    size,
                                    '¿Está seguro que desea cambiar a ${ventaFState.ventaForm.venRucCliente.length == 10 ? 'RUC' : "CÉDULA"}?',
                                    ['SI', 'NO'],
                                    warning: true);

                                if (res == 'SI') {
                                  String nuevoRucCliente =
                                      ventaFState.ventaForm.venRucCliente;

                                  if (nuevoRucCliente.length == 10) {
                                    // Agregar 3 dígitos "001"
                                    nuevoRucCliente = '${nuevoRucCliente}001';
                                  } else if (nuevoRucCliente.length == 13) {
                                    // Quitar los últimos 3 dígitos
                                    nuevoRucCliente =
                                        nuevoRucCliente.substring(0, 10);
                                  }

                                  updateForm(
                                    ventaForm: ventaFState.ventaForm.copyWith(
                                        venRucCliente: nuevoRucCliente,
                                        venTipoDocuCliente: ventaFState
                                                    .ventaForm
                                                    .venRucCliente
                                                    .length ==
                                                10
                                            ? 'RUC'
                                            : "CEDULA"),
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.sync,
                                color: colors.primary,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Text(ventaFState.ventaForm.venTipoDocuCliente),
                  CustomButtonModal(
                    size: size,
                    icon: Icons.search,
                    onPressed: () async {
                      final cliente = await searchClienteResult(
                          context: context,
                          ref: ref,
                          customWidget: CustomButtonModal(
                            size: size,
                            icon: Icons.add,
                            onPressed: () {
                              context.pop();
                              context.push('/cliente/0');
                            },
                          ));
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
                    },
                  ),
                  // CustomButtonModal(
                  //   size: size,
                  //   icon: Icons.add,
                  //   onPressed: () {
                  //     context.push('/cliente/0');
                  //   },
                  // ),
                  CustomButtonModal(
                    size: size,
                    icon: Icons.mark_email_read,
                    onPressed: () async {
                      ventaFNotifier.handleOcultarEmail();
                    },
                  ),
                ],
              ),
              Text(ventaFState.nuevoEmail.value),
              if (!ventaFState.ocultarEmail)
                CustomInputField(
                  autofocus: true,
                  label: 'Correo',
                  onFieldSubmitted: (_) {
                    ventaFNotifier.agregarEmail(nuevoEmailController);
                  },
                  controller: nuevoEmailController,
                  onChanged: (p0) {
                    ventaFNotifier.updateState(nuevoEmail: p0);
                  },
                  errorMessage: ventaFState.nuevoEmail.errorMessage,
                  suffixIcon: IconButton(
                      onPressed: () {
                        ventaFNotifier.agregarEmail(nuevoEmailController);
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
                          ventaFNotifier.setPorcentajeFormaPago(value!);
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
                  ventaFNotifier.eliminarEmail(email);
                },
              ),
              if (ventaFState.nombreCombustible.isNotEmpty)
                EstacionCard(
                    estacion: Estacion(
                      nombreProducto: ventaFState.nombreCombustible,
                      numeroPistola:
                          Parse.parseDynamicToInt(ventaFState.manguera),
                    ),
                    size: size,
                    dato: ventaFState.estadoManguera,
                    visualization: LiveVisualization(
                      pico: Parse.parseDynamicToInt(ventaFState.manguera),
                      valorActual:
                          Parse.parseDynamicToDouble(ventaFState.valor),
                    )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: size.wScreen(50.0),
                    child: OutlinedButton.icon(
                      onPressed:
                          ventaFState.ventaForm.venRucCliente == '9999999999999'
                              ? null
                              : () async {
                                  context.push(
                                      '/seleccionSurtidor/${ventaFState.ventaFormProviderParams.id}');
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
                        ventaFNotifier.agregarProducto(montoController);
                      },
                      onChanged: (p0) {
                        ventaFNotifier.updateState(monto: p0);
                      },
                      suffixIcon: IconButton(
                          onPressed: ventaFState.monto == 0
                              ? null
                              : () {
                                  ventaFNotifier
                                      .agregarProducto(montoController);
                                },
                          icon: const Icon(Icons.add_circle)),
                    ),
                  ),
                ],
              ),
              // IconButton(
              //     onPressed: () {
              //       ref
              //           .read(tabsProvider.notifier)
              //           .updateTabManguera(0, monto: 10);
              //     },
              //     icon: Icon(Icons.change_circle)),
              SizedBox(
                height: size.wScreen(1),
              ),
              _ProductsList(
                  size: size,
                  products: ventaFState.ventaForm.venProductosInput.value,
                  eliminarProducto: ventaFNotifier.eliminarProducto),
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
