import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:neitorvet/features/auth/domain/domain.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_provider.dart';
import 'package:neitorvet/features/shared/infrastructure/inputs/generic_required_input.dart';
import 'package:neitorvet/features/shared/infrastructure/inputs/generic_required_input_number.dart';

final cierreCajaFormProvider = StateNotifierProvider.family
    .autoDispose<CierreCajaFormNotifier, CierreCajaFormState, CierreCaja>(
        (ref, cierreCaja) {
  final createUpdateCierreCaja =
      ref.watch(cierreCajasProvider.notifier).createUpdateCierreCaja;
  final dataDefaultMap = ref.watch(authProvider.notifier).dataDefaultMap;
  final user = ref.watch(authProvider).user;
  return CierreCajaFormNotifier(
      cierreCaja: cierreCaja,
      createUpdateCierreCaja: createUpdateCierreCaja,
      user: user!,
      dataDefaultMap: dataDefaultMap);
});

class CierreCajaFormNotifier extends StateNotifier<CierreCajaFormState> {
  final Future<void> Function(Map<String, dynamic> cierreCajaMap, bool editando)
      createUpdateCierreCaja;
  final User user;
  final Map<String, dynamic> Function(
      {String userProperty, String empresaPropery}) dataDefaultMap;
  CierreCajaFormNotifier(
      {required CierreCaja cierreCaja,
      required this.createUpdateCierreCaja,
      required this.user,
      required this.dataDefaultMap})
      : super(CierreCajaFormState(
          cierreCajaForm: CierreCajaForm.fromCierreCaja(cierreCaja),
        ));

  void updateState({CierreCajaForm? cierreCajaForm, String? searchDoc}) {
    state = state.copyWith(
      cierreCajaForm: cierreCajaForm ?? state.cierreCajaForm,
      searchDoc: searchDoc ?? state.searchDoc,
    );
    _touchedEverything(false);
  }

  Future<bool> onFormSubmit() async {
    state.cierreCajaForm;
    // Marcar todos los campos como tocados
    _touchedEverything(true);

    // Esperar un breve momento para asegurar que el estado se actualice

    // Verificar si el formulario es válido y si ya se está posteando
    if (!state.isFormValid) {
      return false;
    }
    if (state.isPosting) {
      return false;
    }
    // Actualizar el estado para indicar que se está posteando
    state = state.copyWith(isPosting: true);
    final cierreCajaMap = {
      ...state.cierreCajaForm.toCierreCaja().toJson(),
      ...dataDefaultMap(empresaPropery: 'perEmpresa', userProperty: 'perUser'),
      //ELIMINA LOS DUPLICADOS

      "tabla": "proveedor",
    };

    try {
      // socket.emit('editar-registro', cierreCajaMap);
      const result = true;
      await createUpdateCierreCaja(
          cierreCajaMap, state.cierreCajaForm.cajaId != 0);

      // Actualizar el estado para indicar que ya no se está posteando
      state = state.copyWith(isPosting: false);
      return result;
    } catch (e) {
      // Actualizar el estado para indicar que ya no se está posteando
      state = state.copyWith(isPosting: false);

      return false;
    }
  }

  void _touchedEverything(bool submit) {
    if (submit) {
      state = state.copyWith(
          cierreCajaForm: state.cierreCajaForm.copyWith(
            cajaDetalle: state.cierreCajaForm.cajaDetalle,
            cajaMonto: state.cierreCajaForm.cajaMonto,
            cajaTipoCaja: state.cierreCajaForm.cajaTipoCaja,
            cajaTipoDocumento: state.cierreCajaForm.cajaTipoDocumento,
          ),
          isFormValid: Formz.validate([
            // GenericRequiredInput.dirty(state.perCanton.value),
            // GenericRequiredInput.dirty(state.perDireccion.value),
            // GenericRequiredInput.dirty(state.perDocNumero.value),
            // GenericRequiredInput.dirty(state.perNombre.value),
            // GenericRequiredInput.dirty(state.perPais.value),
            // GenericRequiredInput.dirty(state.perProvincia.value),
            // GenericRequiredInput.dirty(state.perRecomendacion.value),
            GenericRequiredInput.dirty(state.cierreCajaForm.cajaDetalle),
            GenericRequiredInputNumber.dirty(state.cierreCajaForm.cajaMonto),
            GenericRequiredInput.dirty(state.cierreCajaForm.cajaTipoCaja),
            GenericRequiredInput.dirty(state.cierreCajaForm.cajaTipoDocumento),
          ]));
    } else {
      state = state.copyWith(
          isFormValid: Formz.validate([
        // GenericRequiredInput.dirty(state.perCanton.value),
        // GenericRequiredInput.dirty(state.perDireccion.value),
        // GenericRequiredInput.dirty(state.perDocNumero.value),
        // GenericRequiredInput.dirty(state.perNombre.value),
        // GenericRequiredInput.dirty(state.perPais.value),
        // GenericRequiredInput.dirty(state.perProvincia.value),
        // GenericRequiredInput.dirty(state.perRecomendacion.value),
        GenericRequiredInput.dirty(state.cierreCajaForm.cajaDetalle),
        GenericRequiredInputNumber.dirty(state.cierreCajaForm.cajaMonto),
        GenericRequiredInput.dirty(state.cierreCajaForm.cajaTipoCaja),
        GenericRequiredInput.dirty(state.cierreCajaForm.cajaTipoDocumento),
      ]));
    }
  }

  @override
  void dispose() { 
    // Log para verificar que se está destruyendo
    super.dispose();
  }
}

class CierreCajaFormState {
  final bool isFormValid;
  final bool isPosted;
  final bool isPosting;

  final String searchDoc;
  final CierreCajaForm cierreCajaForm;

  CierreCajaFormState(
      {this.isFormValid = false,
      this.isPosted = false,
      this.isPosting = false,
      this.searchDoc = '',
      required this.cierreCajaForm});
  CierreCajaFormState copyWith(
      {bool? isFormValid,
      bool? isPosted,
      bool? isPosting,
      CierreCajaForm? cierreCajaForm,
      String? searchDoc}) {
    return CierreCajaFormState(
      isFormValid: isFormValid ?? this.isFormValid,
      isPosted: isPosted ?? this.isPosted,
      isPosting: isPosting ?? this.isPosting,
      cierreCajaForm: cierreCajaForm ?? this.cierreCajaForm,
      searchDoc: searchDoc ?? this.searchDoc,
    );
  }
}
