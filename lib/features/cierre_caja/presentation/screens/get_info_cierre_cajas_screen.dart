import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/get_info_cierre_caja_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/widgets/no_facturado_card.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/form/custom_date_picker_button.dart';
import 'package:neitorvet/features/venta/presentation/provider/form/venta_form_provider.dart';
import 'package:neitorvet/features/venta/presentation/provider/venta_provider.dart';
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
    final colors = Theme.of(context).colorScheme;
    final getInfoState = ref.watch(getInfoCierreCajaProvider);
    final buscarCliente =
        ref.watch(getInfoCierreCajaProvider.notifier).buscarCliente;
    final getNoFacturados =
        ref.read(getInfoCierreCajaProvider.notifier).getNoFacturados;
    final size = Responsive.of(context);
    final surtidoresData = ref.watch(ventasProvider).surtidoresData;
    // Validar si hay una venta
    final venta = ref.watch(ventaProvider(0));
    if (venta.venta == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cargando'),
        ),
        body: const Center(
          child: Text(
            'No hay una venta disponible.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    ref.watch(ventaFormProvider(venta.venta!));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Buscar Información'),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CustomInputField(
                  readOnly: !ref.read(authProvider).isAdmin,
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
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: getInfoState.noFacturados.isEmpty &&
                          !getInfoState.deshabilitarPrint
                      ? () async {
                          final response =
                              await getNoFacturados(surtidoresData);
                          if (response.isEmpty) {
                            printTicketBusqueda(
                                getInfoState.datos,
                                ref.read(authProvider).user,
                                getInfoState.fecha);
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
                const SizedBox(height: 20),
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
                      venta: venta.venta!,
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
// Column(
// Expanded(
// child: ListView.builder(
