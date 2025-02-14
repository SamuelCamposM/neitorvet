import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/shared/delegate/generic_delegate.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_provider.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/venta/presentation/widgets/venta_card.dart';

class VentasScreen extends StatelessWidget {
  const VentasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                  onPressed: () async {
                    final ventasState = ref.read(ventasProvider);
                    final searchVentaResult = await showSearch(
                        query: ventasState.search,
                        context: context,
                        delegate: GenericDelegate(
                          onlySelect: false,
                          itemWidgetBuilder: (item, onItemSelected) {
                            return VentaCard(venta: item, size: size);
                          },
                          setSearch:
                              ref.read(ventasProvider.notifier).setSearch,
                          initialItems: ventasState.searchedVentas,
                          searchItems: ({search = ''}) {
                            return ref
                                .read(ventasProvider.notifier)
                                .searchVentasByQuery(search: search);
                          },
                        ));
                    if (searchVentaResult?.wasLoading == true) {
                      ref
                          .read(ventasProvider.notifier)
                          .searchVentasByQueryWhileWasLoading();
                    }
                    if (searchVentaResult?.setBusqueda == true) {
                      ref.read(ventasProvider.notifier).handleSearch();
                    }
                    if (!context.mounted) return;
                    if (searchVentaResult?.item != null) {
                      context.push('/venta/${searchVentaResult?.item?.venId}');
                    }
                  },
                  icon: const Icon(Icons.search));
            },
          ),
        ],
        title: Consumer(
          builder: (context, ref, child) {
            final ventasState = ref.watch(ventasProvider);
            return Text('Ventas ${ventasState.total}');
          },
        ),
      ),
      body: const VentasView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/venta/0');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class VentasView extends ConsumerStatefulWidget {
  const VentasView({super.key});

  @override
  ConsumerState createState() => VentasViewState();
}

class VentasViewState extends ConsumerState<VentasView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
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
    ref.listen(
      ventasProvider,
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(
            context, next.error, SnackbarCategory.success);
      },
    );

    return Stack(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            // Realiza la búsqueda con la fecha seleccionada
                            // ref.read(ventasProvider.notifier).resetQuery(
                            //       fecha: picked,
                            //     );
                          }
                        },
                        child: const Text('Seleccionar fecha inicio'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            // Realiza la búsqueda con la fecha seleccionada
                            // ref.read(ventasProvider.notifier).resetQuery(
                            //       fecha: picked,
                            //     );
                          }
                        },
                        child: const Text('Seleccionar fecha fin'),
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
                          options: const [
                            "venId",
                            "perDocumento",
                            "perNombre",
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
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: ventasState.ventas.length,
                  itemBuilder: (context, index) {
                    final venta = ventasState.ventas[index];
                    return VentaCard(
                      venta: venta,
                      size: size,
                      redirect: true,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Positioned(
        //   bottom: 40,
        //   left: 0,
        //   right: 0,
        //   child: IconButton(
        //       onPressed: () {
        //         LocalNotifications.showLocalNotification(
        //           id: 0,
        //           title: 'Descarga completada',
        //           body: 'Toca para abrir el archivo',
        //           data: '/path/to/your/file.pdf', // Asegúrate de proporcionar una ruta válida
        //         );
        //       },
        //       icon: const Icon(Icons.notification_add)),
        // ),
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
    );
  }
}
