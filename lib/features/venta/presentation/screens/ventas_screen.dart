import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/widgets/form/custom_date_picker_button.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/venta/infrastructure/delegatesFunction/delegates.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_provider.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/venta/presentation/widgets/venta_card.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class VentasScreen extends ConsumerStatefulWidget {
  const VentasScreen({super.key});

  @override
  ConsumerState createState() => VentasViewState();
}

class VentasViewState extends ConsumerState<VentasScreen> {
  final ScrollController scrollController = ScrollController();

  //************  PARTE PARA CONFIGURAR LA IMPRESORA*******************//

  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";

  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

//***********************************************/

  @override
  void initState() {
    super.initState();

    _bindingPrinter().then((bool? isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });

      SunmiPrinter.printerVersion().then((String version) {
        setState(() {
          printerVersion = version;
        });
      });

      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });

      setState(() {
        printBinded = isBind!;
      });
    });

    scrollController.addListener(
      () {
        if (scrollController.position.pixels + 400 >=
            scrollController.position.maxScrollExtent) {
          ref.read(ventasProvider.notifier).loadNextPage();
        }
      },
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    final ventasState = ref.watch(ventasProvider);
    final user = ref.watch(authProvider).user;
    ref.listen(
      ventasProvider,
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(
            context, next.error, SnackbarCategory.success);
        ref.read(ventasProvider.notifier).resetError();
      },
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                ref.read(ventasProvider.notifier).resetQuery(
                    busquedaVenta: const BusquedaVenta(), search: '');
              },
              icon: ventasState.isSearching
                  ? const Icon(
                      Icons.close,
                      color: Colors.red,
                    )
                  : const SizedBox()),
          IconButton(
              onPressed: () async {
                final ventasState = ref.read(ventasProvider);
                final searchVentaResult = await searchVentas(
                    context: context,
                    ref: ref,
                    ventasState: ventasState,
                    size: size);
                if (searchVentaResult?.wasLoading == true) {
                  ref
                      .read(ventasProvider.notifier)
                      .searchVentasByQueryWhileWasLoading();
                }
                if (searchVentaResult?.setBusqueda == true) {
                  ref.read(ventasProvider.notifier).handleSearch();
                }
                if (!context.mounted) return;
                // if (searchVentaResult?.item != null) {
                //   context.push('/venta/${searchVentaResult?.item?.venId}');
                // }
              },
              icon: const Icon(Icons.search)),
        ],
        title: Text('Ventas ${ventasState.total}'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ventasState.search.isNotEmpty)
                  if (ventasState.search.isNotEmpty)
                    Wrap(
                      children: [
                        Chip(
                          label: Text('Buscando por: ${ventasState.search}'),
                          deleteIcon: const Icon(Icons.clear),
                          onDeleted: () {
                            ref
                                .read(ventasProvider.notifier)
                                .resetQuery(search: '');
                          },
                        ),
                      ],
                    ),
                const SizedBox(height: 10),
                ExpansionTile(
                  dense: true,
                  title: const Text('Buscar - Ordenar'),
                  children: [
                    Row(
                      verticalDirection: VerticalDirection.down,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: CustomDatePickerButton(
                            label: 'Fecha inicio',
                            value: ventasState.busquedaVenta.venFechaFactura1,
                            getDate: (String date) {
                              ref.read(ventasProvider.notifier).resetQuery(
                                  busquedaVenta: ventasState.busquedaVenta
                                      .copyWith(venFechaFactura1: date));
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomDatePickerButton(
                            label: 'Fecha Fin',
                            value: ventasState.busquedaVenta.venFechaFactura2,
                            getDate: (String date) {
                              ref.read(ventasProvider.notifier).resetQuery(
                                  busquedaVenta: ventasState.busquedaVenta
                                      .copyWith(venFechaFactura2: date));
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomSelectField(
                            size: size,
                            label: 'Ordenar Por',
                            value: ventasState.input,
                            onChanged: (String? value) {
                              ref.read(ventasProvider.notifier).resetQuery(
                                    input: value,
                                  );
                            },
                            options: [
                              Option(label: "Fec. Reg.", value: "venId"),
                              Option(
                                label: "Nombre Cliente",
                                value: "venNomCliente",
                              ),
                              Option(
                                label: "Documento",
                                value: "venRucCliente",
                              ),
                            ].toList(),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            ventasState.orden
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                          ),
                          onPressed: () {
                            ref.read(ventasProvider.notifier).resetQuery(
                                  orden: !ventasState.orden,
                                );
                          },
                        ),
                      ],
                    ),
                    CustomSelectField(
                      size: size,
                      label: 'Tipo',
                      value: ventasState.estado.value,
                      onChanged: (String? value) {
                        final estado = VentaEstado.values
                            .firstWhere((e) => e.value == value);
                        ref.read(ventasProvider.notifier).resetQuery(
                              estado: estado,
                            );
                      },
                      options: VentaEstado.values
                          .map((estado) =>
                              Option(label: estado.value, value: estado.value))
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: ventasState.ventas.length,
                    itemBuilder: (context, index) {
                      final venta = ventasState.ventas[index];
                      return VentaCard(
                        venta: venta,
                        size: size,
                        user: user,
                        redirect: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (ventasState.isLoading)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: SizedBox(
                width: size.wScreen(100),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/venta/0');
          // context.push('/menuDespacho');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
