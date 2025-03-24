import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/presentation/provider/cliente_provider.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_repository_provider.dart';
import 'package:neitorvet/features/clientes/presentation/provider/form/cliente_form_provider.dart';

import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/form/custom_date_picker_button.dart';
import 'package:neitorvet/features/shared/widgets/form/custom_expandable_email_list.dart';
import 'package:neitorvet/features/shared/widgets/form/custom_expandable_phone_list.dart';
import 'package:neitorvet/features/shared/widgets/form/custom_expandable_placa_list.dart';

class ClienteScreen extends ConsumerWidget {
  final int clienteId;
  const ClienteScreen({super.key, required this.clienteId});
  @override
  Widget build(BuildContext context, ref) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(contextProvider.notifier).state = context;
    // });
    ref.listen(
      clienteProvider(clienteId),
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(context, next.error, SnackbarCategory.error);
      },
    );

    final clienteState = ref.watch(clienteProvider(clienteId));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(clienteState.cliente?.perId == 0
              ? 'Nuevo Cliente'
              : 'Editar Cliente'),
        ),
        body: clienteState.isLoading
            ? const FullScreenLoader()
            : _ClienteForm(cliente: clienteState.cliente!),
        floatingActionButton: clienteState.isLoading
            ? null
            : _FloatingButton(
                cliente: clienteState.cliente!,
              ),
      ),
    );
  }
}

class _FloatingButton extends ConsumerWidget {
  final Cliente cliente;

  const _FloatingButton({required this.cliente});

  @override
  Widget build(BuildContext context, ref) {
    final ventaState = ref.watch(clienteFormProvider(cliente));
    return FloatingActionButton(
      onPressed: () async {
        if (ventaState.isPosting) {
          return;
        }
        final exitoso = await ref
            .read(clienteFormProvider(cliente).notifier)
            .onFormSubmit();

        if (exitoso && context.mounted) {
          context.pop();
          NotificationsService.show(context, ventaState.clienteForm.perNombre,
              SnackbarCategory.success);
        }
      },
      child: ventaState.isPosting
          ? SpinPerfect(
              duration: const Duration(seconds: 1),
              spins: 10,
              infinite: true,
              child: const Icon(Icons.refresh),
            )
          : const Icon(Icons.save_as),
    );
  }
}

class _ClienteForm extends ConsumerStatefulWidget {
  final Cliente cliente;

  const _ClienteForm({required this.cliente});

  @override
  _ClienteFormState createState() => _ClienteFormState();
}

class _ClienteFormState extends ConsumerState<_ClienteForm> {
  late TextEditingController docController = TextEditingController();
  late TextEditingController nombreController = TextEditingController();
  late TextEditingController dirController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    docController = TextEditingController(text: widget.cliente.perDocNumero);
    nombreController = TextEditingController(text: widget.cliente.perNombre);
    dirController = TextEditingController(text: widget.cliente.perDireccion);
  }

  @override
  void dispose() {
    docController.dispose();
    nombreController.dispose();
    dirController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    final clienteFState = ref.watch(clienteFormProvider(widget.cliente));
    final updateForm =
        ref.read(clienteFormProvider(widget.cliente).notifier).updateState;
    final clienteFormCopyWith = clienteFState.clienteForm.copyWith;

    void buscarCliente(String search) async {
      setState(() {
        isLoading = true;
      });
      final res = clienteFState.clienteForm.perDocTipo == 'PLACA'
          ? await ref
              .read(clientesRepositoryProvider)
              .getNewClienteByPlaca(search)
          : await ref
              .read(clientesRepositoryProvider)
              .getNewClienteByDoc(search);
      if (res.error.isNotEmpty) {
        if (context.mounted) {
          NotificationsService.show(context, res.error, SnackbarCategory.error);
        }
      }

      if (res.resultado != null) {
        searchController.text = '';

        updateForm(clienteForm: ClienteForm.fromCliente(res.resultado!));
        docController.text = res.resultado!.perDocNumero;
        nombreController.text = res.resultado!.perNombre;
        dirController.text = res.resultado!.perDireccion;
      }
      setState(() {
        isLoading = false;
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Cliente: ',
                  style: TextStyle(
                    fontSize: size.iScreen(1.5),
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color, // Asegurando el color correcto
                  ),
                ),
                Text(
                  clienteFState.clienteForm.perId == 0
                      ? 'NUEVO'
                      : widget.cliente.perNombre,
                  style: TextStyle(
                    fontSize: size.iScreen(1.5),
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color, // Asegurando el color correcto
                  ),
                ),
              ],
            ),
            // Text(clienteFState.clienteForm.perDocTipo),
            CustomSelectField(
              errorMessage:
                  clienteFState.clienteForm.perDocTipoInput.errorMessage,
              size: size,
              label: 'Tipo Documento',
              value: clienteFState.clienteForm.perDocTipo,
              onChanged: (String? value) async {
                searchController.text = '';
                final clienteForm = ClienteForm.fromCliente(widget.cliente);
                final clienteFormUpdated =
                    clienteForm.copyWith(perDocTipo: value);

                updateForm(clienteForm: clienteFormUpdated);
                docController.text = clienteFormUpdated.perDocNumero;
                nombreController.text = clienteFormUpdated.perNombre;
                dirController.text = clienteFormUpdated.perDireccion;
              },
              options: [
                Option(label: 'RUC', value: 'RUC'),
                Option(label: "CEDULA", value: "CEDULA"),
                Option(label: "PASAPORTE", value: "PASAPORTE"),
                Option(label: "PLACA", value: "PLACA"),
              ],
            ),
            CustomInputField(
              keyboardType: clienteFState.clienteForm.perDocTipo == 'PLACA'
                  ? TextInputType.text
                  : TextInputType.number,
              toUpperCase: clienteFState.clienteForm.perDocTipo == 'PLACA',
              autofocus: true,
              label: clienteFState.clienteForm.perDocTipo == 'PLACA'
                  ? 'Buscar por Placa'
                  : 'Buscar por RUC O CEDULA.',
              controller: searchController,
              onChanged: (p0) {
                searchController.text = p0;
              },
              isLoading: isLoading,
              suffixIcon: IconButton(
                  onPressed: () async {
                    buscarCliente(searchController.text);
                  },
                  icon: const Icon(Icons.search)),
              onFieldSubmitted: (p0) async {
                buscarCliente(searchController.text);
              },
            ),
            if (isLoading) const Text('cargando'),
            CustomInputField(
              controller: docController,
              label: 'Número Doc.',
              initialValue: clienteFState.clienteForm.perDocNumeroInput.value,
              onChanged: (p0) {
                docController.text = p0;
                updateForm(clienteForm: clienteFormCopyWith(perDocNumero: p0));
              },
              errorMessage:
                  clienteFState.clienteForm.perDocNumeroInput.errorMessage,
            ),
            CustomInputField(
              controller: nombreController,
              label: 'Nombres',
              initialValue: clienteFState.clienteForm.perNombre,
              onChanged: (p0) {
                nombreController.text = p0;
                updateForm(clienteForm: clienteFormCopyWith(perNombre: p0));
              },
              errorMessage:
                  clienteFState.clienteForm.perNombreInput.errorMessage,
            ),
            CustomInputField(
              label: 'Dirección',
              controller: dirController,
              initialValue: clienteFState.clienteForm.perDireccionInput.value,
              onChanged: (p0) {
                dirController.text = p0;
                updateForm(clienteForm: clienteFormCopyWith(perDireccion: p0));
              },
              errorMessage:
                  clienteFState.clienteForm.perDireccionInput.errorMessage,
            ),
            CustomDatePickerButton(
              label: 'Fecha Nacimiento',
              value: clienteFState.clienteForm.perFecNacimiento,
              getDate: (String date) {
                updateForm(
                    clienteForm: clienteFormCopyWith(perFecNacimiento: date));
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: size.iScreen(0.3)),
              color: Colors.grey.shade100,
              child: CustomExpandableEmailList(
                errorMessage:
                    clienteFState.clienteForm.perEmailInput.errorMessage,
                label: 'Correos',
                onAddValue: (p0) {
                  updateForm(
                      clienteForm: clienteFormCopyWith(perEmail: [
                    p0,
                    ...clienteFState.clienteForm.perEmail
                  ]));
                },
                onDeleteValue: (p0) {
                  updateForm(clienteForm: clienteFormCopyWith(perEmail: p0));
                },
                values: clienteFState.clienteForm.perEmail,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: size.iScreen(0.3)),
              color: Colors.grey.shade100,
              child: CustomExpandablePhoneList(
                // errorMessage:
                //     clienteFState.clienteForm.perCelularInput.errorMessage,
                label: 'Celulares',
                onAddValue: (p0) {
                  updateForm(
                      clienteForm: clienteFormCopyWith(perCelular: [
                    p0,
                    ...clienteFState.clienteForm.perCelular
                  ]));
                },
                onDeleteValue: (p0) {
                  updateForm(clienteForm: clienteFormCopyWith(perCelular: p0));
                },
                values: clienteFState.clienteForm.perCelular,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: size.iScreen(0.3)),
              color: Colors.grey.shade100,
              child: CustomExpandablePlacaList(
                errorMessage:
                    clienteFState.clienteForm.perOtrosInput.errorMessage,
                label: 'Placas',
                onAddValue: (p0) {
                  updateForm(
                      clienteForm: clienteFormCopyWith(perOtros: [
                    p0,
                    ...clienteFState.clienteForm.perOtros
                  ]));
                },
                onDeleteValue: (p0) {
                  updateForm(clienteForm: clienteFormCopyWith(perOtros: p0));
                },
                values: clienteFState.clienteForm.perOtros,
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
