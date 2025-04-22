import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:neitorvet/features/auth/domain/domain.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_provider.dart';
import 'package:neitorvet/features/shared/infrastructure/inputs/generic_required_input.dart';
import 'package:neitorvet/features/shared/infrastructure/inputs/generic_required_list_str.dart';

final clienteFormProvider = StateNotifierProvider.family
    .autoDispose<ClienteFormNotifier, ClienteFormState, Cliente>(
        (ref, cliente) {
  final createUpdateCliente =
      ref.watch(clientesProvider.notifier).createUpdateCliente;
  final dataDefaultMap = ref.watch(authProvider.notifier).dataDefaultMap;
  final user = ref.watch(authProvider).user;
  return ClienteFormNotifier(
      cliente: cliente,
      createUpdateCliente: createUpdateCliente,
      user: user!,
      dataDefaultMap: dataDefaultMap);
});

class ClienteFormNotifier extends StateNotifier<ClienteFormState> {
  final Future<void> Function(Map<String, dynamic> clienteMap, bool editando)
      createUpdateCliente;
  final User user;
  final Map<String, dynamic> Function(
      {String userProperty, String empresaPropery}) dataDefaultMap;
  ClienteFormNotifier(
      {required Cliente cliente,
      required this.createUpdateCliente,
      required this.user,
      required this.dataDefaultMap})
      : super(ClienteFormState(
          clienteForm: ClienteForm.fromCliente(cliente),
        ));

  void updateState({ClienteForm? clienteForm, String? searchDoc}) {
    state = state.copyWith(
      clienteForm: clienteForm ?? state.clienteForm,
      searchDoc: searchDoc ?? state.searchDoc,
    );
    _touchedEverything(false);
  }

  Future<bool> onFormSubmit() async {
    state.clienteForm;
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
    final clienteMap = {
      ...state.clienteForm
          .copyWith(
            perCelular:
                state.clienteForm.perCelular.isEmpty ? ['0900000000'] : null,
            perEmail: state.clienteForm.perEmail.isEmpty
                ? ['correo@sincorreo.com']
                : null,
            perNombre: state.clienteForm.perNombre.toUpperCase(),
          )
          .toCliente()
          .toJson(),
      ...dataDefaultMap(empresaPropery: 'perEmpresa', userProperty: 'perUser'),
      //ELIMINA LOS DUPLICADOS
      'perPerfil': [
        ...{...state.clienteForm.perPerfil, 'CLIENTE'}
      ],
      'perEmpresa': [
        ...{...state.clienteForm.perEmpresa, user.rucempresa}
      ],
      "tabla": "proveedor",
    };

    try {
      // socket.emit('editar-registro', clienteMap);
      const result = true;
      await createUpdateCliente(clienteMap, state.clienteForm.perId != 0);

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
          clienteForm: state.clienteForm.copyWith(
            perDocTipo: state.clienteForm.perDocTipo,
            perDocNumero: state.clienteForm.perDocNumero,
            perNombre: state.clienteForm.perNombre,
            perDireccion: state.clienteForm.perDireccion,
            // perCelular: state.clienteForm.perCelular,
            // perEmail: state.clienteForm.perEmail,
            perOtros: state.clienteForm.perOtros,
          ),
          isFormValid: Formz.validate([
            // GenericRequiredInput.dirty(state.perCanton.value),
            // GenericRequiredInput.dirty(state.perDireccion.value),
            // GenericRequiredInput.dirty(state.perDocNumero.value),
            // GenericRequiredInput.dirty(state.perNombre.value),
            // GenericRequiredInput.dirty(state.perPais.value),
            // GenericRequiredInput.dirty(state.perProvincia.value),
            // GenericRequiredInput.dirty(state.perRecomendacion.value),
            GenericRequiredInput.dirty(state.clienteForm.perDocTipo),
            GenericRequiredInput.dirty(state.clienteForm.perDocNumero),
            GenericRequiredInput.dirty(state.clienteForm.perNombre),
            GenericRequiredInput.dirty(state.clienteForm.perDireccion),
            // GenericRequiredListStr.dirty(state.clienteForm.perEmail),
            // GenericRequiredListStr.dirty(state.clienteForm.perCelular),
            GenericRequiredListStr.dirty(state.clienteForm.perOtros),
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
        GenericRequiredInput.dirty(state.clienteForm.perDocTipo),
        GenericRequiredInput.dirty(state.clienteForm.perDocNumero),
        GenericRequiredInput.dirty(state.clienteForm.perNombre),
        GenericRequiredInput.dirty(state.clienteForm.perDireccion),
        // GenericRequiredListStr.dirty(state.clienteForm.perEmail),
        // GenericRequiredListStr.dirty(state.clienteForm.perCelular),
        GenericRequiredListStr.dirty(state.clienteForm.perOtros),
      ]));
    }
  }

  @override
  void dispose() {
    // Log para verificar que se está destruyendo
    super.dispose();
  }
}

class ClienteFormState {
  final bool isFormValid;
  final bool isPosted;
  final bool isPosting;

  final String searchDoc;
  final ClienteForm clienteForm;

  ClienteFormState(
      {this.isFormValid = false,
      this.isPosted = false,
      this.isPosting = false,
      this.searchDoc = '',
      required this.clienteForm});
  ClienteFormState copyWith(
      {bool? isFormValid,
      bool? isPosted,
      bool? isPosting,
      ClienteForm? clienteForm,
      String? searchDoc}) {
    return ClienteFormState(
      isFormValid: isFormValid ?? this.isFormValid,
      isPosted: isPosted ?? this.isPosted,
      isPosting: isPosting ?? this.isPosting,
      clienteForm: clienteForm ?? this.clienteForm,
      searchDoc: searchDoc ?? this.searchDoc,
    );
  }
}
