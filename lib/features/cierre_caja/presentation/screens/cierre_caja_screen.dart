import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_caja_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/form/cierre_caja_form_provider.dart';

import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

class CierreCajaScreen extends ConsumerWidget {
  final int cajaId;
  const CierreCajaScreen({super.key, required this.cajaId});
  @override
  Widget build(BuildContext context, ref) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(contextProvider.notifier).state = context;
    // });
    ref.listen(
      cierreCajaProvider(cajaId),
      (_, next) {
        if (next.error.isEmpty) return;
        NotificationsService.show(context, next.error, SnackbarCategory.error);
      },
    );

    final cierreCajaState = ref.watch(cierreCajaProvider(cajaId));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(cierreCajaState.cierreCaja?.cajaId == 0
              ? 'Nuevo CierreCaja'
              : 'Editar CierreCaja'),
        ),
        body: cierreCajaState.isLoading
            ? const FullScreenLoader()
            : _CierreCajaForm(cierreCaja: cierreCajaState.cierreCaja!),
        floatingActionButton: cierreCajaState.isLoading
            ? null
            : _FloatingButton(
                cierreCaja: cierreCajaState.cierreCaja!,
              ),
      ),
    );
  }
}

class _FloatingButton extends ConsumerWidget {
  final CierreCaja cierreCaja;

  const _FloatingButton({required this.cierreCaja});

  @override
  Widget build(BuildContext context, ref) {
    final ventaState = ref.watch(cierreCajaFormProvider(cierreCaja));
    return FloatingActionButton(
      onPressed: () async {
        if (ventaState.isPosting) {
          return;
        }
        final exitoso = await ref
            .read(cierreCajaFormProvider(cierreCaja).notifier)
            .onFormSubmit();

        if (exitoso && context.mounted) {
          context.pop();
          NotificationsService.show(context,
              ventaState.cierreCajaForm.cajaDetalle, SnackbarCategory.success);
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

class _CierreCajaForm extends ConsumerStatefulWidget {
  final CierreCaja cierreCaja;

  const _CierreCajaForm({required this.cierreCaja});

  @override
  _CierreCajaFormState createState() => _CierreCajaFormState();
}

class _CierreCajaFormState extends ConsumerState<_CierreCajaForm> {
  // late TextEditingController docController = TextEditingController();
  // late TextEditingController nombreController = TextEditingController();
  // late TextEditingController dirController = TextEditingController();
  // TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    // docController = TextEditingController(text: widget.cierreCaja.perDocNumero);
    // nombreController = TextEditingController(text: widget.cierreCaja.perNombre);
    // dirController = TextEditingController(text: widget.cierreCaja.perDireccion);
  }

  @override
  void dispose() {
    // docController.dispose();
    // nombreController.dispose();
    // dirController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    final cierreCajaFState =
        ref.watch(cierreCajaFormProvider(widget.cierreCaja));
    final updateForm = ref
        .read(cierreCajaFormProvider(widget.cierreCaja).notifier)
        .updateState;
    final cierreCajaFormCopyWith = cierreCajaFState.cierreCajaForm.copyWith;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'CierreCaja: ',
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
                  cierreCajaFState.cierreCajaForm.cajaId == 0
                      ? 'NUEVO'
                      : widget.cierreCaja.cajaDetalle,
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
            // Text(cierreCajaFState.cierreCajaForm.perDocTipo),
            // CustomSelectField(
            //   errorMessage:
            //       cierreCajaFState.cierreCajaForm.perDocTipoInput.errorMessage,
            //   size: size,
            //   label: 'Tipo Documento',
            //   value: cierreCajaFState.cierreCajaForm.perDocTipo,
            //   onChanged: (String? value) async {
            //     searchController.text = '';
            //     final cierreCajaForm = CierreCajaForm.fromCierreCaja(widget.cierreCaja);
            //     final cierreCajaFormUpdated =
            //         cierreCajaForm.copyWith(perDocTipo: value);

            //     updateForm(cierreCajaForm: cierreCajaFormUpdated);
            //     docController.text = cierreCajaFormUpdated.perDocNumero;
            //     nombreController.text = cierreCajaFormUpdated.perNombre;
            //     dirController.text = cierreCajaFormUpdated.perDireccion;
            //   },
            //   options: [
            //     Option(label: 'RUC', value: 'RUC'),
            //     Option(label: "CEDULA", value: "CEDULA"),
            //     Option(label: "PASAPORTE", value: "PASAPORTE"),
            //     Option(label: "PLACA", value: "PLACA"),
            //   ],
            // ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
