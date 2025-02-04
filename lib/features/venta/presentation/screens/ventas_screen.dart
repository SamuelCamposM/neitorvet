import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/shared/screen/full_screen_loader.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_provider.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class VentasScreen extends StatelessWidget {
  const VentasScreen({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer(
            builder: (context, ref, child) {
              // final ventasState = ref.watch(ventasProvider);
              return IconButton(
                  onPressed: () async {
                    // final ventasState = ref.read(ventasProvider);
                    // // final searchedMovies = ref.read(searchmoviespro);
                    // final searchVentaResult = await showSearch<SearchResult>(
                    //     query: ventasState.search,
                    //     context: context,
                    //     delegate: SearchVentaDelegate(
                    //       setSearch:
                    //           ref.read(ventasProvider.notifier).setSearch,
                    //       initalVentas: ventasState.searchedVentas,
                    //       searchVentas: ref
                    //           .read(ventasProvider.notifier)
                    //           .searchVentasByQuery,
                    //     ));
                    // if (searchVentaResult?.wasLoading == true) {
                    //   ref
                    //       .read(ventasProvider.notifier)
                    //       .searchVentasByQueryWhileWasLoading();
                    // }
                    // if (searchVentaResult?.setBusqueda == true) {
                    //   ref.read(ventasProvider.notifier).handleSearch();
                    // }
                    // if (!context.mounted) return;
                    // if (searchVentaResult?.venta != null) {
                    //   context.push(
                    //       '/venta/${searchVentaResult?.venta?.perId}');
                    // }
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
      body: Consumer(builder: (context, ref, child) {
        final ventasState = ref.watch(ventasProvider);
        if (ventasState.isLoading) {
          return const FullScreenLoader();
        }
        return const VentasView();
        // },
      }),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Buscando por: ${ventasState.search}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        ref
                            .read(ventasProvider.notifier)
                            .resetQuery(search: '');
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: ventasState.input,
                    items: const [
                      DropdownMenuItem(
                        value: 'venId',
                        child: Text('ID'),
                      ),
                      DropdownMenuItem(
                        value: 'perDocumento',
                        child: Text('DOCUMENTO'),
                      ),
                      DropdownMenuItem(
                        value: 'perNombre',
                        child: Text('NOMBRE'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(ventasProvider.notifier).resetQuery(
                              input: value,
                            );
                      }
                    },
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
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: ventasState.ventas.length,
                  itemBuilder: (context, index) {
                    final venta = ventasState.ventas[index];
                    return InvoiceInfoCard(
                        numeroFactura: venta.venNumFactura,
                        cliente: venta.venNomCliente,
                        documento: venta.venRucCliente,
                        fecha: venta.venFechaFactura,
                        total: venta.venTotal,
                        size: size,
                        invoiceId: venta.venId,
                        redirect: true,
                        pdfUrl:
                            'https://syscontable.neitor.com/reportes/factura.php?codigo=${venta.venId}&empresa=${venta.venEmpresa}');
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
    );
  }
}

class InvoiceInfoCard extends StatelessWidget {
  final String numeroFactura;
  final String cliente;
  final String documento;
  final String fecha;
  final double total;
  final Responsive size;
  final int invoiceId;
  final bool redirect;
  final String pdfUrl;

  const InvoiceInfoCard(
      {Key? key,
      required this.numeroFactura,
      required this.cliente,
      required this.fecha,
      required this.total,
      required this.size,
      required this.invoiceId,
      this.redirect = true,
      required this.documento,
      required this.pdfUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: redirect
          ? () {
              context.push('/venta/$invoiceId');
            }
          : null,
      child: Container(
        width: size.wScreen(100),
        padding: EdgeInsets.all(size.iScreen(1.0)),
        margin: EdgeInsets.symmetric(
            horizontal: size.iScreen(1.2), vertical: size.iScreen(0.5)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha((0.5 * 255).toInt()),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4), // Desplazamiento de la sombra
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.wScreen(60.0),
                  child: Text(
                    "# $numeroFactura",
                    style: TextStyle(
                        fontSize: size.iScreen(1.5),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: size.wScreen(60.0),
                  child: Text(
                    cliente,
                    style: TextStyle(
                      fontSize: size.iScreen(1.5),
                    ),
                  ),
                ),
                Text(
                  documento,
                  style: TextStyle(
                    fontSize: size.iScreen(1.5),
                  ),
                ),
                Text(
                  "Fecha: $fecha",
                  style: TextStyle(
                    fontSize: size.iScreen(1.5),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: size.wScreen(20),
              child: Column(
                children: [
                  Text(
                    "Total",
                    style: TextStyle(
                        fontSize: size.iScreen(1.5),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${total.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: size.iScreen(1.7),
                        fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {},
                      onLongPress: () {
                        context.push(
                            '/PDF/Factura/${Uri.encodeComponent(pdfUrl)}');
                      },
                      child: Text(
                        'PDF',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: size.iScreen(1.7),
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
