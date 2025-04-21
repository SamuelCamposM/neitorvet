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
    final colors = Theme.of(context).colorScheme;
    final size = Responsive.of(context);
    final ventasState = ref.watch(ventasProvider);
    final verificarEstadoVenta =
        ref.watch(ventasProvider.notifier).verificarEstadoVenta;
    final authState = ref.watch(authProvider);

    ref.listen(
      ventasProvider,
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(context, next.error, SnackbarCategory.error);
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
              },
              icon: const Icon(Icons.search)),
        ],
        title: Text('Ventas ${authState.isAdmin ? '' : ventasState.total}'),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              return ref.read(ventasProvider.notifier).resetQuery();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // children: VentaEstado.values.map((estado) {
                    children: [].map((estado) {
                      final isSelected = ventasState.estado == estado;
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected
                              ? colors.secondary
                              : colors.secondary.withAlpha(75),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          ref
                              .read(ventasProvider.notifier)
                              .resetQuery(estado: estado);
                        },
                        child: Text(
                          estado.value == 'FACTURAS'
                              ? 'AUTORIZADO'
                              : "SIN AUTORIZAR",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? colors.onSecondary
                                : colors.onSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
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
                  ],
                ),
                const SizedBox(height: 10),
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
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: ventasState.ventas.length,
                    itemBuilder: (context, index) {
                      final venta = ventasState.ventas[index];
                      return VentaCard(
                        venta: venta,
                        size: size,
                        user: authState.user,
                        redirect: true,
                        verificarEstadoVenta: verificarEstadoVenta,
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
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
