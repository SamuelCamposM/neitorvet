import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/cierre_caja/infrastructure/delegatesFunction/delegates.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/widgets/cierre_caja_card.dart';
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

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                ref.read(cierreCajasProvider.notifier).resetQuery(
                    busquedaCierreCaja: const BusquedaCierreCaja(), search: '');
              },
              icon: cierreCajasState.isSearching
                  ? const Icon(
                      Icons.close,
                      color: Colors.red,
                    )
                  : const SizedBox()),
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
                // if (searchCierreCajaResult?.item != null) {
                //   context.push('/cierre_cajas/${searchCierreCajaResult?.item?.cajaId}');
                // }
              },
              icon: const Icon(Icons.search)),
        ],
        title: Text('CierreCajas ${cierreCajasState.total}'),
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
                            .read(cierreCajasProvider.notifier)
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
                          value: cierreCajasState.busquedaCierreCaja.cajaFecha1,
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
                          value: cierreCajasState.busquedaCierreCaja.cajaFecha2,
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
          context.push('/cierre_cajas/0');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
