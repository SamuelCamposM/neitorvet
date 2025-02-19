import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/presentation/provider/cliente_provider.dart'; 
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
          context.pop('/cliente');
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

class _ClienteForm extends ConsumerWidget {
  final Cliente cliente;

  const _ClienteForm({required this.cliente});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = Responsive.of(context);
    final clienteFState = ref.watch(clienteFormProvider(cliente));
    final updateForm =
        ref.read(clienteFormProvider(cliente).notifier).updateState;
    final clienteFormCopyWith = clienteFState.clienteForm.copyWith;
    //* VALIDADOS
    // perDocTipoInput
    // perDocNumeroInput
    // perNombreInput
    // perDireccionInput
    // perFecNacimientoInput
    // perCelularInput
    // perOtrosInput
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: 'Cliente: ',
                style: TextStyle(
                  fontSize: size.iScreen(1.8),
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: clienteFState.clienteForm.perId == 0
                        ? 'NUEVO'
                        : cliente.perNombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            CustomSelectField(
              errorMessage:
                  clienteFState.clienteForm.perDocTipoInput.errorMessage,
              size: size,
              label: 'F. de Pago',
              value: clienteFState.clienteForm.perDocTipo,
              onChanged: (String? value) {
                updateForm(clienteForm: clienteFormCopyWith(perDocTipo: value));
              },
              options: [
                Option(label: 'RUC', value: 'RUC'),
                Option(label: "CEDULA", value: "CEDULA"),
                Option(label: "PASAPORTE", value: "PASAPORTE"),
              ],
            ),
            CustomInputField(
              autofocus: true,
              label: 'Número Doc.',
              initialValue: clienteFState.clienteForm.perDocNumeroInput.value,
              onChanged: (p0) {
                updateForm(clienteForm: clienteFormCopyWith(perDocNumero: p0));
              },
              errorMessage:
                  clienteFState.clienteForm.perDocNumeroInput.errorMessage,
            ),
            CustomInputField(
              label: 'Nombres',
              initialValue: clienteFState.clienteForm.perNombre,
              onChanged: (p0) {
                updateForm(clienteForm: clienteFormCopyWith(perNombre: p0));
              },
              errorMessage:
                  clienteFState.clienteForm.perNombreInput.errorMessage,
            ),
            CustomInputField(
              label: 'Dirección',
              initialValue: clienteFState.clienteForm.perDireccionInput.value,
              onChanged: (p0) {
                updateForm(clienteForm: clienteFormCopyWith(perDireccion: p0));
              },
              errorMessage:
                  clienteFState.clienteForm.perDireccionInput.errorMessage,
            ),
            // CustomInputField(
            //   label: 'Fecha Nacimiento',
            //   initialValue: clienteFState.clienteForm.perFecNacimiento,
            //   onChanged: (p0) {
            //     updateForm(
            //         clienteForm: clienteFormCopyWith(perFecNacimiento: p0));
            //   },
            // ),
            CustomDatePickerButton(
              label: 'Fecha Nacimiento',
              value: clienteFState.clienteForm.perFecNacimiento,
              getDate: (String date) {
                updateForm(
                    clienteForm: clienteFormCopyWith(perFecNacimiento: date));
              },
            ),

            CustomExpandableEmailList(
              errorMessage:
                  clienteFState.clienteForm.perEmailInput.errorMessage,
              label: 'Correos: ',
              onAddValue: (p0) {
                updateForm(
                    clienteForm: clienteFormCopyWith(
                        perEmail: [p0, ...clienteFState.clienteForm.perEmail]));
              },
              onDeleteValue: (p0) {
                updateForm(clienteForm: clienteFormCopyWith(perEmail: p0));
              },
              values: clienteFState.clienteForm.perEmail,
            ),
            CustomExpandablePhoneList(
              errorMessage:
                  clienteFState.clienteForm.perCelularInput.errorMessage,
              label: 'Celulares:',
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
            CustomExpandablePlacaList(
              errorMessage:
                  clienteFState.clienteForm.perOtrosInput.errorMessage,
              label: 'Placas:',
              onAddValue: (p0) {
                updateForm(
                    clienteForm: clienteFormCopyWith(
                        perOtros: [p0, ...clienteFState.clienteForm.perOtros]));
              },
              onDeleteValue: (p0) {
                updateForm(clienteForm: clienteFormCopyWith(perOtros: p0));
              },
              values: clienteFState.clienteForm.perOtros,
            ),

            // CustomInputField(
            //
            //   label: 'perCelularInput',
            //   initialValue: clienteFState.clienteForm.perCelularInput.value,
            //   onChanged: (p0) {
            //     updateForm(
            //         clienteForm: clienteFormCopyWith(perCelular: p0));
            //   },
            //   errorMessage:
            //       clienteFState.clienteForm.perCelularInput.errorMessage,
            // ),
            // CustomInputField(
            //
            //   label: 'perOtrosInput',
            //   initialValue: clienteFState.clienteForm.perOtrosInput.value,
            //   onChanged: (p0) {
            //     updateForm(clienteForm: clienteFormCopyWith(perOtros: p0));
            //   },
            //   errorMessage:
            //       clienteFState.clienteForm.perOtrosInput.errorMessage,
            // ),
            // Text(clienteFState.clienteForm.perDocTipoInput.value),
            // Text(clienteFState.clienteForm.perDocNumeroInput.value),
            // Text(clienteFState.clienteForm.perNombreInput.value),
            // Text(clienteFState.clienteForm.perDireccionInput.value),

            // Text(clienteFState.clienteForm.perEmailInput.value.toString()),
            // Text(clienteFState.clienteForm.perCelularInput.value.toString()),
            // Text(clienteFState.clienteForm.perOtrosInput.value.toString()),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
