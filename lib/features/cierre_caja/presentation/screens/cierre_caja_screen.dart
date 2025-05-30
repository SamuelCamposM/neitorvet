import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_caja_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/form/cierre_caja_form_provider.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:neitorvet/features/shared/helpers/get_date.dart';

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
              ? 'Nueva Caja'
              : 'Editar Caja'),
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
    final cierreCajaFState = ref.watch(cierreCajaFormProvider(cierreCaja));
    final cierreCajasState = ref.watch(cierreCajasProvider);
    return FloatingActionButton(
      onPressed: () async {
        await ref
            .read(cierreCajasProvider.notifier)
            .setSumaIEC(fecha: GetDate.today);
        final suma = Format.roundToTwoDecimals(
            cierreCajasState.sumaIEC.ingreso + cierreCajasState.sumaIEC.egreso);
        if (cierreCajaFState.cierreCajaForm.cajaMonto > suma &&
            cierreCajaFState.cierreCajaForm.cajaTipoDocumento == 'EGRESO') {
          NotificationsService.show(
              context,
              'El monto de la caja es mayor a la suma de ingresos y egresos',
              SnackbarCategory.error);
          return;
        }
        if (cierreCajaFState.isPosting) {
          return;
        }
        final exitoso = await ref
            .read(cierreCajaFormProvider(cierreCaja).notifier)
            .onFormSubmit();

        if (exitoso && context.mounted) {
          context.pop();
          NotificationsService.show(
              context,
              cierreCajaFState.cierreCajaForm.cajaDetalle,
              SnackbarCategory.success);
        }
      },
      child: cierreCajaFState.isPosting
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
    final isAdmin = ref.watch(authProvider).isAdmin;
    final cierreCajasState = ref.watch(cierreCajasProvider);
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       'Cierre Caja: ',
            //       style: TextStyle(
            //         fontSize: size.iScreen(1.5),
            //         fontWeight: FontWeight.normal,
            //         color: Theme.of(context)
            //             .textTheme
            //             .bodyLarge
            //             ?.color, // Asegurando el color correcto
            //       ),
            //     ),
            //     Expanded(
            //       child: Text(
            //         cierreCajaFState.cierreCajaForm.cajaId == 0
            //             ? 'NUEVO'
            //             : widget.cierreCaja.cajaDetalle,
            //         style: TextStyle(
            //           fontSize: size.iScreen(1.5),
            //           fontWeight: FontWeight.bold,
            //           color: Theme.of(context)
            //               .textTheme
            //               .bodyLarge
            //               ?.color, // Asegurando el color correcto
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            SwitchListTile(
              dense: true, // Hace que el SwitchListTile sea más compacto
              value: cierreCajaFState.cierreCajaForm.cajaEstado == 'ACTIVA',
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              title: Text(
                'Estado',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.iScreen(1.8),
                ),
              ),

              activeColor: colors.secondary
                  .withAlpha(75), // Color del interruptor cuando está activo
              activeTrackColor:
                  colors.secondary, // Color de la pista cuando está activo

              onChanged: cierreCajaFState.cierreCajaForm.cajaId == 0
                  ? null // Deshabilitar el interruptor si la caja es nueva
                  : (value) {
                      updateForm(
                        cierreCajaForm: cierreCajaFormCopyWith(
                          cajaEstado: value ? 'ACTIVA' : 'ANULADA',
                        ),
                      );
                    },
            ),
            const Divider(), // Línea divisoria para separar secciones 
            CustomSelectField(
              bold: true,
              errorMessage: cierreCajaFState
                  .cierreCajaForm.cajaTipoCajaInput.errorMessage,
              size: size,
              label: 'Tipo de Caja',
              value: cierreCajaFState.cierreCajaForm.cajaTipoCaja,
              onChanged: (String? value) async {
                updateForm(
                  cierreCajaForm: cierreCajaFormCopyWith(cajaTipoCaja: value),
                );
              },
              options: [
                Option(label: 'EFECTIVO', value: 'EFECTIVO'),
                Option(label: "CHEQUE", value: "CHEQUE", enabled: isAdmin),
                Option(
                    label: "TRANSFERENCIA",
                    value: "TRANSFERENCIA",
                    enabled: isAdmin),
                Option(label: "DEPOSITO", value: "DEPOSITO", enabled: isAdmin),
                Option(label: "TARJETA DE DÉBITO", value: "TARJETA DE DÉBITO", enabled: isAdmin),
                Option(label: "	TARJETA DE CRÉDITO", value: "	TARJETA DE CRÉDITO", enabled: isAdmin),
              ],
            ),
            const SizedBox(height: 10),
            CustomSelectField(
              bold: false,
              errorMessage: cierreCajaFState
                  .cierreCajaForm.cajaTipoDocumentoInput.errorMessage,
              size: size,
              label: 'Tipo',
              value: cierreCajaFState.cierreCajaForm.cajaTipoDocumento,
              onChanged: (String? value) async {
                updateForm(
                    cierreCajaForm:
                        cierreCajaFormCopyWith(cajaTipoDocumento: value));
              },
              options: [
                Option(label: 'APERTURA', value: 'APERTURA'),
                Option(label: 'INGRESO', value: 'INGRESO'),
                Option(label: 'EGRESO', value: 'EGRESO'),
                Option(label: 'DEPOSITO', value: 'DEPOSITO'),
                Option(label: 'CAJA CHICA', value: 'CAJA CHICA'),
                Option(label: 'TRANSFERENCIA', value: 'TRANSFERENCIA'),
              ],
            ),
            //  cajaMonto
// cajaAutorizacion
// cajaDetalle
            CustomInputField(
              label:
                  'Monto${cierreCajaFState.cierreCajaForm.cajaTipoDocumento == 'EGRESO' ? ' Maximo: \$${Format.roundToTwoDecimals(cierreCajasState.sumaIEC.ingreso + cierreCajasState.sumaIEC.egreso)}' : ""}',

              errorMessage:
                  cierreCajaFState.cierreCajaForm.cajaMontoInput.errorMessage,
              keyboardType: TextInputType.number,
              initialValue:
                  cierreCajaFState.cierreCajaForm.cajaMonto.toString(),
              onChanged: (p0) {
                updateForm(
                    cierreCajaForm: cierreCajaFormCopyWith(
                        cajaMonto: double.tryParse(p0) ?? 0));
              },
              // errorMessage: clienteForm.perCanton.errorMessage,
            ),
            CustomInputField(
              label: 'Autorizacion',
              initialValue:
                  cierreCajaFState.cierreCajaForm.cajaAutorizacion.toString(),
              onChanged: (p0) {
                updateForm(
                    cierreCajaForm:
                        cierreCajaFormCopyWith(cajaAutorizacion: p0));
              },
              // errorMessage: clienteForm.perCanton.errorMessage,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CustomInputField(
                label: 'Detalle',
                lines: 3,
                errorMessage: cierreCajaFState
                    .cierreCajaForm.cajaDetalleInput.errorMessage,
                initialValue:
                    cierreCajaFState.cierreCajaForm.cajaDetalle.toString(),
                onChanged: (p0) {
                  updateForm(
                      cierreCajaForm: cierreCajaFormCopyWith(cajaDetalle: p0));
                },
                // errorMessage: clienteForm.perCanton.errorMessage,
              ),
            ),

            // Text('${cierreCajaFState.cierreCajaForm.cajaTipoCaja}'),
            // Text('${cierreCajaFState.cierreCajaForm.cajaTipoDocumento}'),
            // Text('${cierreCajaFState.cierreCajaForm.cajaMonto}'),
            // Text('${cierreCajaFState.cierreCajaForm.cajaAutorizacion}'),
            // Text('${cierreCajaFState.cierreCajaForm.cajaDetalle}'),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
