import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cuentas_por_cobrar/domain/entities/cuenta_por_cobrar.dart';
import 'package:neitorvet/features/cuentas_por_cobrar/infrastructure/delegatesFunction/delegates.dart';
import 'package:neitorvet/features/cuentas_por_cobrar/presentation/provider/cuentas_por_cobrar_provider.dart';
import 'package:neitorvet/features/cuentas_por_cobrar/presentation/widgets/cuenta_por_cobrar_card.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/modal/cupertino_modal.dart';

class CuentasPorCobrarScreen extends ConsumerStatefulWidget {
  const CuentasPorCobrarScreen({super.key});

  @override
  ConsumerState createState() => CuentasPorCobrarViewState();
}

class CuentasPorCobrarViewState extends ConsumerState<CuentasPorCobrarScreen> {
  final ScrollController scrollController = ScrollController();

  //************  PARTE PARA CONFIGURAR LA IMPRESORA*******************//

  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";

  /// must binding ur printer at first init in app
  // Future<bool?> _bindingPrinter() async {
  //   final bool? result = await SunmiPrinter.bindingPrinter();
  //   return result;
  // }

  //***********************************************/

  @override
  void initState() {
    super.initState();

// //************  INICIALIZA LA IMPRESORA*******************//
//     _bindingPrinter().then((bool? isBind) async {
//       SunmiPrinter.paperSize().then((int size) {
//         setState(() {
//           paperSize = size;
//         });
//       });

//       SunmiPrinter.printerVersion().then((String version) {
//         setState(() {
//           printerVersion = version;
//         });
//       });

//       SunmiPrinter.serialNumber().then((String serial) {
//         setState(() {
//           serialNumber = serial;
//         });
//       });

//       setState(() {
//         printBinded = isBind!;
//       });
//     });
// //***********************************************/

    scrollController.addListener(
      () {
        if (scrollController.position.pixels + 400 >=
            scrollController.position.maxScrollExtent) {
          ref.read(cuentasPorCobrarProvider.notifier).loadNextPage();
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
    final cuentasPorCobrarState = ref.watch(cuentasPorCobrarProvider);
    // final deleteCuentaPorCobrar =
    //     ref.watch(cuentasPorCobrarProvider.notifier).;
    final isAdmin = ref.watch(authProvider).isAdmin;
    ref.listen(
      cuentasPorCobrarProvider,
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(context, next.error, SnackbarCategory.error);
        ref.read(cuentasPorCobrarProvider.notifier).resetError();
      },
    );

    return DefaultTabController(
      length: CuentaPorCobrarEstado.values.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (cuentasPorCobrarState.isSearching)
              IconButton(
                  onPressed: () {
                    ref.read(cuentasPorCobrarProvider.notifier).resetQuery(
                        busquedaCuentaPorCobrar:
                            const BusquedaCuentasPorCobrar(),
                        search: '');
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  )),
            IconButton(
                onPressed: () async {
                  final cuentasPorCobrarState =
                      ref.read(cuentasPorCobrarProvider);
                  final searchCuentaPorCobrarResult =
                      await searchCuentasPorCobrar(
                    context: context,
                    ref: ref,
                    cuentasPorCobrarState: cuentasPorCobrarState,
                    isAdmin: isAdmin,
                    size: size,
                  );
                  if (searchCuentaPorCobrarResult?.wasLoading == true) {
                    ref
                        .read(cuentasPorCobrarProvider.notifier)
                        .searchCuentasPorCobrarByQueryWhileWasLoading();
                  }
                  if (searchCuentaPorCobrarResult?.setBusqueda == true) {
                    ref.read(cuentasPorCobrarProvider.notifier).handleSearch();
                  }
                  if (!context.mounted) return;
                },
                icon: const Icon(Icons.search)),
          ],
          title: Text('Cuentas Cobrar ${cuentasPorCobrarState.total}'),
          // bottom: TabBar(
          //   isScrollable: true,
          //   tabs: CuentaPorCobrarEstado.values.map((estado) {
          //     final isSelected = cuentasPorCobrarState.estado == estado;
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
          //     final estado = CuentaPorCobrarEstado.values[index];
          //     ref.read(cuentasPorCobrarProvider.notifier).resetQuery(estado: estado);
          //   },
          // ),
        ),
        body: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                return ref.read(cuentasPorCobrarProvider.notifier).resetQuery();
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // children: CuentaPorCobrarEstado.values.map((estado) {
                      children: [].map((estado) {
                        final isSelected =
                            cuentasPorCobrarState.estado == estado;
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10, // Reducir el padding horizontal
                            ),
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
                                .read(cuentasPorCobrarProvider.notifier)
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
                  if (cuentasPorCobrarState.search.isNotEmpty)
                    Wrap(
                      children: [
                        Chip(
                          label: Text(
                              'Buscando por: ${cuentasPorCobrarState.search}'),
                          deleteIcon: const Icon(Icons.clear),
                          onDeleted: () {
                            ref
                                .read(cuentasPorCobrarProvider.notifier)
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
                          // Expanded(
                          //   child: CustomDatePickerButton(
                          //     label: 'Fecha inicio',
                          //     value: cuentasPorCobrarState
                          //         .busquedaCuentaPorCobrar.cajaFecha1,
                          //     getDate: (String date) {
                          //       ref
                          //           .read(cuentasPorCobrarProvider.notifier)
                          //           .resetQuery(
                          //               busquedaCuentaPorCobrar:
                          //                   cuentasPorCobrarState
                          //                       .busquedaCuentaPorCobrar
                          //                       .copyWith(cajaFecha1: date));
                          //     },
                          //   ),
                          // ),
                          // Expanded(
                          //   child: CustomDatePickerButton(
                          //     label: 'Fecha Fin',
                          //     value: cuentasPorCobrarState
                          //         .busquedaCuentaPorCobrar.cajaFecha2,
                          //     getDate: (String date) {
                          //       ref
                          //           .read(cuentasPorCobrarProvider.notifier)
                          //           .resetQuery(
                          //               busquedaCuentaPorCobrar:
                          //                   cuentasPorCobrarState
                          //                       .busquedaCuentaPorCobrar
                          //                       .copyWith(cajaFecha2: date));
                          //     },
                          //   ),
                          // ),
                          
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomSelectField(
                              size: size,
                              label: 'Ordenar Por',
                              value: cuentasPorCobrarState.input,
                              onChanged: (String? value) {
                                ref
                                    .read(cuentasPorCobrarProvider.notifier)
                                    .resetQuery(
                                      input: value,
                                    );
                              },
                              options: [
                                Option(label: "Fec. Reg.", value: "ccId"),
                                Option(
                                  label: "Estado",
                                  value: "ccEstado",
                                ),
                              ].toList(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              cuentasPorCobrarState.orden
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                            ),
                            onPressed: () {
                              ref
                                  .read(cuentasPorCobrarProvider.notifier)
                                  .resetQuery(
                                    orden: !cuentasPorCobrarState.orden,
                                  );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: cuentasPorCobrarState.cuentasPorCobrar.length,
                      itemBuilder: (context, index) {
                        final cuentaPorCobrar =
                            cuentasPorCobrarState.cuentasPorCobrar[index];
                        return CuentaPorCobrarCard(
                          isAdmin: isAdmin,
                          cuentaPorCobrar: cuentaPorCobrar,
                          size: size,
                          redirect: true,
                          onDelete: () async {
                            if (isAdmin) {
                              final res = await cupertinoModal(
                                  context,
                                  size,
                                  '¿Esta seguro de eliminar este registro: ${cuentaPorCobrar.ccNomCliente}?',
                                  ['SI', 'NO']);
                              if (res == 'SI') {
                                // deleteCuentaPorCobrar(cuentaPorCobrar.cajaId);
                              }
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (cuentasPorCobrarState.isLoading)
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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     context.push('/cuenta_cobrar/0');
        //   },
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}
