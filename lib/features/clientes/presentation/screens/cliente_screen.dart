import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/presentation/provider/cliente_provider.dart';
import 'package:neitorvet/features/clientes/presentation/provider/form/cliente_form_provider.dart';

import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';

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
              ? 'Crear Cliente'
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
  void showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Producto Actualizado')));
  }

  @override
  Widget build(BuildContext context, ref) {
    final productFormState = ref.watch(clienteFormProvider(cliente));
    return FloatingActionButton(
      onPressed: () async {
        if (productFormState.isPosting) {
          return;
        }
        final exitoso = await ref
            .read(clienteFormProvider(cliente).notifier)
            .onFormSubmit();

        if (exitoso && context.mounted) {
          NotificationsService.show(
              context, 'Cliente Actualizado', SnackbarCategory.success);
        }
      },
      child: productFormState.isPosting
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
    final clienteForm = ref.watch(clienteFormProvider(cliente));
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
                child: Text(clienteForm.perNombre.value,
                    textAlign: TextAlign.center, style: textStyles.titleSmall)),
            const SizedBox(height: 10),
            const Text('Mis datos', textAlign: TextAlign.center),
            const SizedBox(height: 15),
            CustomProductField(
              autoFocus: true,
              isTopField: true,
              label: 'Nombre',
              initialValue: clienteForm.perNombre.value,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perNombre: p0);
              },
              errorMessage: clienteForm.perNombre.errorMessage,
            ),
            CustomProductField(
              label: 'Canton',
              initialValue: clienteForm.perCanton.value,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perCanton: p0);
              },
              errorMessage: clienteForm.perCanton.errorMessage,
            ),
            CustomProductField(
              label: 'Direccion',
              initialValue: clienteForm.perDireccion.value,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perDireccion: p0);
              },
              errorMessage: clienteForm.perDireccion.errorMessage,
            ),
            CustomProductField(
              label: 'Doc Numero',
              initialValue: clienteForm.perDocNumero.value,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perDocNumero: p0);
              },
              errorMessage: clienteForm.perDocNumero.errorMessage,
            ),
            CustomProductField(
              label: 'Pais',
              initialValue: clienteForm.perPais.value,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perPais: p0);
              },
              errorMessage: clienteForm.perPais.errorMessage,
            ),
            CustomProductField(
              label: 'Provincia',
              initialValue: clienteForm.perProvincia.value,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perProvincia: p0);
              },
              errorMessage: clienteForm.perProvincia.errorMessage,
            ),
            CustomProductField(
              label: 'Recomendacion',
              initialValue: clienteForm.perRecomendacion.value,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perRecomendacion: p0);
              },
              errorMessage: clienteForm.perRecomendacion.errorMessage,
            ),
            CustomProductField(
              label: 'Codigo',
              initialValue: clienteForm.perCodigo,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perCodigo: p0);
              },
            ),
            CustomProductField(
              label: 'Credito',
              initialValue: clienteForm.perCredito,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perCredito: p0);
              },
            ),
            CustomProductField(
              label: 'Doc Tipo',
              initialValue: clienteForm.perDocTipo,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perDocTipo: p0);
              },
            ),
            CustomProductField(
              label: 'Documento',
              initialValue: clienteForm.perDocumento,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perDocumento: p0);
              },
            ),
            CustomProductField(
              label: 'Especialidad',
              initialValue: clienteForm.perEspecialidad,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perEspecialidad: p0);
              },
            ),
            CustomProductField(
              label: 'Estado',
              initialValue: clienteForm.perEstado,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perEstado: p0);
              },
            ),
            CustomProductField(
              label: 'Fec Nacimiento',
              initialValue: clienteForm.perFecNacimiento,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perFecNacimiento: p0);
              },
            ),
            CustomProductField(
              label: 'Fec Reg',
              initialValue: clienteForm.perFecReg,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perFecReg: p0);
              },
            ),
            CustomProductField(
              label: 'Fec Upd',
              initialValue: clienteForm.perFecUpd,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perFecUpd: p0);
              },
            ),
            CustomProductField(
              label: 'Foto',
              initialValue: clienteForm.perFoto,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perFoto: p0);
              },
            ),
            CustomProductField(
              label: 'Genero',
              initialValue: clienteForm.perGenero ?? '',
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perGenero: p0);
              },
            ),
            CustomProductField(
              label: 'Nombre Comercial',
              initialValue: clienteForm.perNombreComercial,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perNombreComercial: p0);
              },
            ),
            CustomProductField(
              label: 'Obligado',
              initialValue: clienteForm.perObligado,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perObligado: p0);
              },
            ),
            CustomProductField(
              label: 'Obsevacion',
              initialValue: clienteForm.perObsevacion,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perObsevacion: p0);
              },
            ),
            CustomProductField(
              label: 'Personal',
              initialValue: clienteForm.perPersonal,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perPersonal: p0);
              },
            ),
            CustomProductField(
              label: 'Senescyt',
              initialValue: clienteForm.perSenescyt,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perSenescyt: p0);
              },
            ),
            CustomProductField(
              label: 'Telefono',
              initialValue: clienteForm.perTelefono,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perTelefono: p0);
              },
            ),
            CustomProductField(
              label: 'Tiempo Credito',
              initialValue: clienteForm.perTiempoCredito,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perTiempoCredito: p0);
              },
            ),
            CustomProductField(
              label: 'Tipo Proveedor',
              initialValue: clienteForm.perTipoProveedor,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perTipoProveedor: p0);
              },
            ),
            CustomProductField(
              label: 'Titulo',
              initialValue: clienteForm.perTitulo,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perTitulo: p0);
              },
            ),
            CustomProductField(
              label: 'User',
              initialValue: clienteForm.perUser,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perUser: p0);
              },
            ),
            CustomProductField(
              label: 'Usuario',
              initialValue: clienteForm.perUsuario,
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perUsuario: p0);
              },
            ),
            CustomProductField(
              isBottomField: true,
              label: 'Nickname',
              initialValue: clienteForm.perNickname ?? '',
              onChanged: (p0) {
                ref
                    .read(clienteFormProvider(cliente).notifier)
                    .updateState(perNickname: p0);
              },
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
