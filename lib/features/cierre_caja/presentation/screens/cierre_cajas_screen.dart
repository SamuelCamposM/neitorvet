import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/cierre_caja/infrastructure/delegatesFunction/delegates.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/widgets/cierre_caja_card.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/widgets/form/custom_date_picker_button.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class CierreCajasScreen extends ConsumerStatefulWidget {
  const CierreCajasScreen({super.key});

  @override
  ConsumerState createState() => CierreCajasViewState();
}

class CierreCajasViewState extends ConsumerState<CierreCajasScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(
      () {
        if (scrollController.position.pixels + 400 >=
            scrollController.position.maxScrollExtent) {
          ref.read(cierreCajasProvider.notifier).loadNextPage();
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
    final cierreCajasState = ref.watch(cierreCajasProvider);

    ref.listen(
      cierreCajasProvider,
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(
            context, next.error, SnackbarCategory.success);
        ref.read(cierreCajasProvider.notifier).resetError();
      },
    );

    return DefaultTabController(
      length: CierreCajaEstado.values.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  context.push('/get_info_cierre_cajas');
                },
                icon: const Icon(
                  Icons.print,
                )),
            if (cierreCajasState.isSearching)
              IconButton(
                  onPressed: () {
                    ref.read(cierreCajasProvider.notifier).resetQuery(
                        busquedaCierreCaja: const BusquedaCierreCaja(),
                        search: '');
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  )),
            IconButton(
                onPressed: () async {
                  final cierreCajasState = ref.read(cierreCajasProvider);
                  final searchCierreCajaResult = await searchCierreCajas(
                      context: context,
                      ref: ref,
                      cierreCajasState: cierreCajasState,
                      size: size);
                  if (searchCierreCajaResult?.wasLoading == true) {
                    ref
                        .read(cierreCajasProvider.notifier)
                        .searchCierreCajasByQueryWhileWasLoading();
                  }
                  if (searchCierreCajaResult?.setBusqueda == true) {
                    ref.read(cierreCajasProvider.notifier).handleSearch();
                  }
                  if (!context.mounted) return;
                },
                icon: const Icon(Icons.search)),
          ],
          title: Text('Cierre Cajas ${cierreCajasState.total}'),
          // bottom: TabBar(
          //   isScrollable: true,
          //   tabs: CierreCajaEstado.values.map((estado) {
          //     final isSelected = cierreCajasState.estado == estado;
          //     return Tab(
          //       child: Text(
          //         estado.value,
          //         style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           color: isSelected
          //               ? colors.onSecondary
          //               : colors.onSecondary.withAlpha(150),
          //         ),
          //       ),
          //     );
          //   }).toList(),
          //   onTap: (index) {
          //     final estado = CierreCajaEstado.values[index];
          //     ref.read(cierreCajasProvider.notifier).resetQuery(estado: estado);
          //   },
          // ),
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: CierreCajaEstado.values.map((estado) {
                      final isSelected = cierreCajasState.estado == estado;
                      final color = estado == CierreCajaEstado.anulada
                          ? colors.error
                          : colors.secondary;
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10, // Reducir el padding horizontal
                          ),
                          backgroundColor:
                              isSelected ? color : color.withAlpha(75),
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
                              .read(cierreCajasProvider.notifier)
                              .resetQuery(estado: estado);
                        },
                        child: Text(
                          estado.value,
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
                if (cierreCajasState.search.isNotEmpty)
                  Wrap(
                    children: [
                      Chip(
                        label: Text('Buscando por: ${cierreCajasState.search}'),
                        deleteIcon: const Icon(Icons.clear),
                        onDeleted: () {
                          ref
                              .read(cierreCajasProvider.notifier)
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
                            value:
                                cierreCajasState.busquedaCierreCaja.cajaFecha1,
                            getDate: (String date) {
                              ref.read(cierreCajasProvider.notifier).resetQuery(
                                  busquedaCierreCaja: cierreCajasState
                                      .busquedaCierreCaja
                                      .copyWith(cajaFecha1: date));
                            },
                          ),
                        ),
                        Expanded(
                          child: CustomDatePickerButton(
                            label: 'Fecha Fin',
                            value:
                                cierreCajasState.busquedaCierreCaja.cajaFecha2,
                            getDate: (String date) {
                              ref.read(cierreCajasProvider.notifier).resetQuery(
                                  busquedaCierreCaja: cierreCajasState
                                      .busquedaCierreCaja
                                      .copyWith(cajaFecha2: date));
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
                            value: cierreCajasState.input,
                            onChanged: (String? value) {
                              ref.read(cierreCajasProvider.notifier).resetQuery(
                                    input: value,
                                  );
                            },
                            options: [
                              Option(label: "Fec. Reg.", value: "cajaId"),
                              Option(
                                label: "Fecha",
                                value: "cajaFecha",
                              ),
                            ].toList(),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            cierreCajasState.orden
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                          ),
                          onPressed: () {
                            ref.read(cierreCajasProvider.notifier).resetQuery(
                                  orden: !cierreCajasState.orden,
                                );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: cierreCajasState.cierreCajas.length,
                    itemBuilder: (context, index) {
                      final cierreCaja = cierreCajasState.cierreCajas[index];
                      return CierreCajaCard(
                        cierreCaja: cierreCaja,
                        size: size,
                        redirect: true,
                      );
                    },
                  ),
                ),
              ],
            ),
            if (cierreCajasState.isLoading)
              Positioned(
                bottom: 150,
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
        bottomSheet: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // spacing: 5,
                children: [
                  // Botón para "Ingreso"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green.shade100, // Color de fondo del botón
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                    ),
                    onPressed: () {},
                    child: Column(
                      children: [
                        const Text(
                          'Ingreso',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          '${cierreCajasState.sumaIEC.ingreso}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botón para "Egreso"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red.shade100, // Color de fondo del botón
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                    ),
                    onPressed: () {},
                    child: Column(
                      children: [
                        const Text(
                          'Egreso',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          '${cierreCajasState.sumaIEC.egreso}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botón para "Crédito"
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue.shade100, // Color de fondo del botón
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                    ),
                    onPressed: () {},
                    child: Column(
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          '\$${Format.roundToTwoDecimals(cierreCajasState.sumaIEC.ingreso + cierreCajasState.sumaIEC.egreso)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: size.width),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.push('/cierre_cajas/0');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
