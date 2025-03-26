import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/cierre_surtidor.dart';
import 'package:neitorvet/features/cierre_surtidores/infrastructure/delegatesFunction/delegates.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/provider/ventas_provider.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/widgets/cierre_surtidor_card.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/widgets/form/custom_date_picker_button.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class CierreSurtidoresScreen extends ConsumerStatefulWidget {
  const CierreSurtidoresScreen({super.key});

  @override
  ConsumerState createState() => CierreSurtidoresViewState();
}

class CierreSurtidoresViewState extends ConsumerState<CierreSurtidoresScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(
      () {
        if (scrollController.position.pixels + 400 >=
            scrollController.position.maxScrollExtent) {
          ref.read(cierreSurtidoresProvider.notifier).loadNextPage();
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
    // final colors = Theme.of(context).colorScheme;
    final size = Responsive.of(context);
    final cierreSurtidoresState = ref.watch(cierreSurtidoresProvider);
    ref.listen(
      cierreSurtidoresProvider,
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(
            context, next.error, SnackbarCategory.success);
        ref.read(cierreSurtidoresProvider.notifier).resetError();
      },
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                ref.read(cierreSurtidoresProvider.notifier).resetQuery(
                    busquedaCierreSurtidor: const BusquedaCierreSurtidor(),
                    search: '');
              },
              icon: cierreSurtidoresState.isSearching
                  ? const Icon(
                      Icons.close,
                      color: Colors.red,
                    )
                  : const SizedBox()),
          IconButton(
              onPressed: () async {
                final cierreSurtidoresState =
                    ref.read(cierreSurtidoresProvider);
                final searchCierreSurtidorResult =
                    await searchsearchCierreSurtidores(
                        context: context,
                        ref: ref,
                        cierreSurtidoresState: cierreSurtidoresState,
                        size: size);
                if (searchCierreSurtidorResult?.wasLoading == true) {
                  ref
                      .read(cierreSurtidoresProvider.notifier)
                      .searchCierreSurtidoresByQueryWhileWasLoading();
                }
                if (searchCierreSurtidorResult?.setBusqueda == true) {
                  ref.read(cierreSurtidoresProvider.notifier).handleSearch();
                }
                if (!context.mounted) return;
                // if (searchCierreSurtidorResult?.item != null) {
                //   context.push('/cierreSurtidor/${searchCierreSurtidorResult?.item?.idcierre}');
                // }
              },
              icon: const Icon(Icons.search)),
        ],
        title: Text('Cierre Surtidores ${cierreSurtidoresState.total}'),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: CierreSurtidorEstado.values.map((estado) {
              //       final isSelected = cierreSurtidoresState.estado == estado;
              //       return ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: isSelected
              //               ? colors.secondary
              //               : colors.secondary.withAlpha(75),
              //           shape: const RoundedRectangleBorder(
              //             borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(12.0),
              //               topRight: Radius.circular(12.0),
              //               bottomLeft: Radius.circular(0),
              //               bottomRight: Radius.circular(0),
              //             ),
              //           ),
              //         ),
              //         onPressed: () {
              //           ref
              //               .read(cierreSurtidoresProvider.notifier)
              //               .resetQuery(estado: estado);
              //         },
              //         child: Text(
              //           estado.value == 'FACTURAS'
              //               ? 'AUTORIZADO'
              //               : "SIN AUTORIZAR",
              //           style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             color: isSelected
              //                 ? colors.onSecondary
              //                 : colors.onSecondary,
              //           ),
              //         ),
              //       );
              //     }).toList(),
              //   ),
              // ),
              if (cierreSurtidoresState.search.isNotEmpty)
                Wrap(
                  children: [
                    Chip(
                      label:
                          Text('Buscando por: ${cierreSurtidoresState.search}'),
                      deleteIcon: const Icon(Icons.clear),
                      onDeleted: () {
                        ref
                            .read(cierreSurtidoresProvider.notifier)
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
                          value: cierreSurtidoresState
                              .busquedaCierreSurtidor.fechaCierre1,
                          getDate: (String date) {
                            ref
                                .read(cierreSurtidoresProvider.notifier)
                                .resetQuery(
                                    busquedaCierreSurtidor:
                                        cierreSurtidoresState
                                            .busquedaCierreSurtidor
                                            .copyWith(fechaCierre1: date));
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomDatePickerButton(
                          label: 'Fecha Fin',
                          value: cierreSurtidoresState
                              .busquedaCierreSurtidor.fechaCierre2,
                          getDate: (String date) {
                            ref
                                .read(cierreSurtidoresProvider.notifier)
                                .resetQuery(
                                    busquedaCierreSurtidor:
                                        cierreSurtidoresState
                                            .busquedaCierreSurtidor
                                            .copyWith(fechaCierre2: date));
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
                          value: cierreSurtidoresState.input,
                          onChanged: (String? value) {
                            ref
                                .read(cierreSurtidoresProvider.notifier)
                                .resetQuery(
                                  input: value,
                                );
                          },
                          options: [
                            Option(label: "Fec. Reg.", value: "idcierre"),
                          ].toList(),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          cierreSurtidoresState.orden
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                        ),
                        onPressed: () {
                          ref
                              .read(cierreSurtidoresProvider.notifier)
                              .resetQuery(
                                orden: !cierreSurtidoresState.orden,
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
                  itemCount: cierreSurtidoresState.cierreSurtidores.length,
                  itemBuilder: (context, index) {
                    final cierreSurtidor =
                        cierreSurtidoresState.cierreSurtidores[index];
                    return CierreSurtidorCard(
                      cierreSurtidor: cierreSurtidor,
                      size: size,
                      redirect: true,
                    );
                  },
                ),
              ),
            ],
          ),
          if (cierreSurtidoresState.isLoading)
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
          context.push('/surtidores');
          // context.push('/menuDespacho');
        },
        child: const Icon(Icons.addchart),
      ),
    );
  }
}
