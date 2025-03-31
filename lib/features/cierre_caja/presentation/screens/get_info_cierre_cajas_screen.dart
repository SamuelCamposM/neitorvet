import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_caja/domain/datasources/cierre_cajas_datasource.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_repository_provider.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/widgets/form/custom_date_picker_button.dart';

class GetInfoCierreCajasScreen extends ConsumerStatefulWidget {
  const GetInfoCierreCajasScreen({super.key});

  @override
  ConsumerState<GetInfoCierreCajasScreen> createState() =>
      _GetInfoCierreCajasScreenState();
}

class _GetInfoCierreCajasScreenState
    extends ConsumerState<GetInfoCierreCajasScreen> {
  bool isLoading = false;
  ResponseSumaIEC datos = ResponseSumaIEC(
    ingreso: 0,
    egreso: 0,
    credito: 0,
    error: '',
    transferencia: 0,
    deposito: 0,
  );
  String fecha = '';

  TextEditingController searchController = TextEditingController(text: '');
  @override
  void initState() {
    super.initState();
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
    void buscarCliente(String search, String fecha) async {
      setState(() {
        isLoading = true;
      });
      final res = await ref
          .read(cierreCajasRepositoryProvider)
          .getSumaIEC(fecha: fecha, search: search);
      if (res.error.isNotEmpty) {
        if (context.mounted) {
          NotificationsService.show(context, res.error, SnackbarCategory.error);
        }
      }

      datos = res;
      searchController.text = '';

      // updateForm(clienteForm: ClienteForm.fromCliente(res.resultado!));

      setState(() {
        isLoading = false;
      });
    }

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
                    isLoading: isLoading,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        buscarCliente(searchController.text, fecha);
                      },
                      icon: const Icon(Icons.search),
                    ),
                    onFieldSubmitted: (p0) async {
                      buscarCliente(searchController.text, fecha);
                    },
                  ),
                  CustomDatePickerButton(
                    label: 'Fecha',
                    value: fecha,
                    getDate: (String date) {
                      setState(() {
                        fecha = date;
                      });
                      buscarCliente(searchController.text, fecha);
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
                            'Ingreso: \$${datos.ingreso}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Egreso: -\$${datos.egreso}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            'Total Efectivo: \$${datos.ingreso - datos.egreso}',
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
                            'Transferencia: \$${datos.transferencia}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          Text(
                            'Crédito: \$${datos.credito}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            'Deposito: \$${datos.deposito}',
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
                    onPressed: () async {},
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
