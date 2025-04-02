import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/get_info_cierre_caja_provider.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/widgets/form/custom_date_picker_button.dart';
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
    final colors = Theme.of(context).colorScheme;
    final getInfoState = ref.watch(getInfoCierreCajaProvider);
    final buscarCliente =
        ref.watch(getInfoCierreCajaProvider.notifier).buscarCliente;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Buscar Información'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
                        buscarCliente(
                            searchController.text, getInfoState.fecha);
                      },
                      icon: const Icon(Icons.search),
                    ),
                    onFieldSubmitted: (p0) async {
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
                  const SizedBox(
                      height:
                          20), // Espacio entre el campo de búsqueda y los datos
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
                          ), // Separador entre las secciones
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
                    onPressed: () async {
                      printTicketBusqueda(getInfoState.datos,
                          ref.read(authProvider).user, getInfoState.fecha);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          colors.secondary, // Color de fondo del botón
                      foregroundColor: Colors.white, // Color del texto e íconos
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16), // Padding interno
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Bordes redondeados
                      ),
                      elevation: 4, // Sombra del botón
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.print, size: 20), // Ícono de impresión
                        SizedBox(width: 8), // Espacio entre el ícono y el texto
                        Text(
                          'Imprimir',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }
}
