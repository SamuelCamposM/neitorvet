import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_repository_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/get_info_cierre_caja_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/widgets/no_facturado_card.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/surtidor.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/form/custom_date_picker_button.dart';
import 'package:neitorvet/features/venta/presentation/provider/form/venta_form_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_provider.dart';
import 'package:neitorvet/features/venta/presentation/widgets/prit_Sunmi.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class GetInfoCierreCajasScreen extends ConsumerStatefulWidget {
  const GetInfoCierreCajasScreen({super.key});

  @override
  ConsumerState<GetInfoCierreCajasScreen> createState() =>
      _GetInfoCierreCajasScreenState();
}

class _GetInfoCierreCajasScreenState
    extends ConsumerState<GetInfoCierreCajasScreen> {
  TextEditingController searchController = TextEditingController(text: '');

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

//************  INICIALIZA LA IMPRESORA*******************//
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
//***********************************************/
    // Leer el valor inicial desde Riverpod y asignarlo al controlador
    final initialSearchValue = ref.read(authProvider).user?.usuario ??
        ''; // Asignar el valor al controlador
    searchController.text = initialSearchValue;
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    ref.listen(
      getInfoCierreCajaProvider,
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(context, next.error, SnackbarCategory.error);
        ref.read(getInfoCierreCajaProvider.notifier).resetError();
      },
    );

    // Validar si hay una venta
    final ventaFormProviderParams =
        VentaFormProviderParams(editar: false, id: 0);
    final ventaFState = ref.watch(ventaFormProvider(ventaFormProviderParams));
    final ventaFNotifier =
        ref.watch(ventaFormProvider(ventaFormProviderParams).notifier);
    final surtidoresData = ref.watch(ventasProvider).surtidoresData;
    final getInfoState = ref.watch(getInfoCierreCajaProvider);
    return ventaFState.isLoading
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Cargando'),
            ),
            body: const Center(
              child: Text(
                'No hay una venta disponible.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          )
        : _BodyInfoCierreCajas(
            searchController: searchController,
            surtidoresData: surtidoresData,
            getInfoState: getInfoState,
            ventaFState: ventaFState,
            ventaFNotifier: ventaFNotifier,
          );
  }
}
// Column(
// Expanded(
// child: ListView.builder(

class _BodyInfoCierreCajas extends ConsumerWidget {
  final VentaFormState ventaFState;
  final VentaFormNotifier ventaFNotifier;
  final TextEditingController searchController;
  final List<Surtidor> surtidoresData;
  final GenInfoCierreCajaState getInfoState;
  const _BodyInfoCierreCajas({
    required this.searchController,
    required this.surtidoresData,
    required this.getInfoState,
    required this.ventaFState,
    required this.ventaFNotifier,
  });

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;
    final buscarCliente =
        ref.read(getInfoCierreCajaProvider.notifier).buscarCliente;
    final getNoFacturados =
        ref.read(getInfoCierreCajaProvider.notifier).getNoFacturados;
    final size = Responsive.of(context);
    final isAdmin = !ref.read(authProvider).isAdmin;
    final venta = ventaFState.ventaForm;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Facturas Pendientes'),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CustomInputField(
                  readOnly: isAdmin,
                  autofocus: true,
                  label: 'Buscar USUARIO.',
                  controller: searchController,
                  onChanged: (p0) {
                    searchController.text = p0;
                  },
                  isLoading: getInfoState.isLoading,
                  suffixIcon: IconButton(
                    onPressed: () async {
                      getNoFacturados(surtidoresData);
                      buscarCliente(searchController.text, getInfoState.fecha);
                    },
                    icon: const Icon(Icons.search),
                  ),
                  onFieldSubmitted: (p0) async {
                    getNoFacturados(surtidoresData);
                    buscarCliente(searchController.text, getInfoState.fecha);
                  },
                ),
                CustomDatePickerButton(
                  label: 'Fecha',
                  value: getInfoState.fecha,
                  getDate: (String date) {
                    buscarCliente(searchController.text, date);
                  },
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ingreso: \$${getInfoState.datos.ingreso}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'Egreso: -\$${getInfoState.datos.egreso}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          'Total Efectivo: \$${Format.roundToTwoDecimals(getInfoState.datos.ingreso + getInfoState.datos.egreso)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const Divider(
                          height: 30,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Text(
                          'Transferencia: \$${getInfoState.datos.transferencia}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        Text(
                          'Crédito: \$${getInfoState.datos.credito}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        Text(
                          'Deposito: \$${getInfoState.datos.deposito}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        Text(
                          'Tar. Crédito: \$${getInfoState.datos.tarjetaCredito}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        Text(
                          'Tar. Débito: \$${getInfoState.datos.tarjetaDebito}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.cyanAccent.shade700,
                          ),
                        ),
                        Text(
                          'Tar. Prepago: \$${getInfoState.datos.tarjetaPrepago}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent.shade700,
                          ),
                        ),
// Suma total de medios de pago
                        Text(
                          'Total CxC: \$${Format.roundToTwoDecimals(getInfoState.datos.transferencia + getInfoState.datos.credito + getInfoState.datos.deposito + getInfoState.datos.tarjetaCredito + getInfoState.datos.tarjetaDebito + getInfoState.datos.tarjetaPrepago)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: getInfoState.noFacturados.isEmpty &&
                                !getInfoState.deshabilitarPrint
                            ? () async {
                                final response =
                                    await getNoFacturados(surtidoresData);

                                if (response.isEmpty) {
                                  final response = await ref
                                      .read(cierreCajasRepositoryProvider)
                                      .getEgresos(
                                          documento: searchController.text);
                                  if (response.error.isNotEmpty &&
                                      context.mounted) {
                                    NotificationsService.show(context,
                                        response.error, SnackbarCategory.error);
                                    return;
                                  }
                                  printTicketBusqueda(
                                    getInfoState.datos,
                                    ref.read(authProvider).user,
                                    getInfoState.fecha,
                                    response.resultado,
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.secondary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 4,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.print, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Cierre de turno',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () async {
                        final response = await ref
                            .read(cierreCajasRepositoryProvider)
                            .getEgresos(documento: searchController.text);
                        if (response.error.isNotEmpty && context.mounted) {
                          NotificationsService.show(
                              context, response.error, SnackbarCategory.error);
                          return;
                        }
                        printEgresos(
                          ref.read(authProvider).user,
                          getInfoState.fecha,
                          response.resultado,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.error,
                        foregroundColor: colors.onError,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.print,
                            size: 20,
                            color: colors.onError,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Egresos',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
                if (getInfoState.noFacturados.isNotEmpty)
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Mangueras: ${getInfoState.noFacturados.length}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: getInfoState.noFacturados.length,
                  itemBuilder: (context, index) {
                    final noFacturado = getInfoState.noFacturados[index];
                    return NoFacturadoCard(
                      noFacturado: noFacturado,
                      size: size,
                      redirect: true,
                      venta: venta,
                      ventaFState: ventaFState,
                      ventaFormNotifier: ventaFNotifier,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
