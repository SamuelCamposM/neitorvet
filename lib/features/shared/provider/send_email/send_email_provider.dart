import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:neitorvet/features/shared/infrastructure/form/form_status.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/venta/domain/datasources/ventas_datasource.dart';
import 'package:neitorvet/features/venta/domain/entities/body_correo.dart'; 
import 'package:neitorvet/features/venta/presentation/provider/ventas_repository_provider.dart';

class EmailAndLabels {
  final List<String> emails;
  final List<Labels> labels;

  EmailAndLabels({required this.emails, required this.labels});
}

class Labels {
  final String label;
  final String value;

  Labels({required this.label, required this.value});
}

final sendEmailProvider = StateNotifierProvider.family
    .autoDispose<SendEmailNotifier, SendEmailState, EmailAndLabels>(
        (ref, initialData) {
  final initialEmails = initialData.emails;
  final initialLabels = initialData.labels;
  final sendCorreo = ref.watch(ventasRepositoryProvider).sendCorreo;
  return SendEmailNotifier(
      SendEmailState(
        status: Formstatus(),
        labels: initialLabels,
        emails: GenericRequiredListStr.dirty(initialEmails),
        nuevoEmail: const Email.pure(),
      ),
      sendCorreo: sendCorreo);
});

class SendEmailNotifier extends StateNotifier<SendEmailState> {
  final Future<ResponseCorreoVenta> Function(BodyCorreo bodyCorreo) sendCorreo;

  SendEmailNotifier(SendEmailState state, {required this.sendCorreo})
      : super(state);

  void updateState({
    String? nuevoEmail,
    List<String>? emails,
  }) {
    final updatedNuevoEmail =
        nuevoEmail != null ? Email.dirty(nuevoEmail) : state.nuevoEmail;
    final updatedEmails =
        emails != null ? GenericRequiredListStr.dirty(emails) : state.emails;

    state = state.copyWith(
      nuevoEmail: updatedNuevoEmail,
      emails: updatedEmails,
      status: state.status.copyWith(
        isFormValid: Formz.validate([updatedEmails]),
      ),
    );
  }

  bool agregarEmail(TextEditingController controller) {
    if (state.nuevoEmail.isNotValid) {
      state = state.copyWith(nuevoEmail: Email.dirty(state.nuevoEmail.value));
      return false;
    }
    state = state.copyWith(
        emails: GenericRequiredListStr.dirty(
            [state.nuevoEmail.value, ...state.emails.value]),
        nuevoEmail: const Email.pure());
    controller.text = '';
    return true;
  }

  void eliminarEmail(String email) {
    final updatedEmails = state.emails.value.where((e) => e != email).toList();
    state = state.copyWith(
      emails: GenericRequiredListStr.dirty(updatedEmails),
      status: state.status.copyWith(
        isFormValid:
            Formz.validate([GenericRequiredListStr.dirty(updatedEmails)]),
      ),
    );
  }

  Future<bool> onFormSubmit(int idRegistro) async {
    _touchedEverything();

    if (!state.status.isFormValid) {
      return false;
    }
    if (state.status.isPosting) {
      return false;
    }

    state = state.copyWith(status: state.status.copyWith(isPosting: true));

    try {
      final result = await sendCorreo(BodyCorreo(
          medioComunicacion: 'Correo',
          option: 'Venta',
          idRegistro: idRegistro,
          contacto: state.emails.value,
          contenidoMensaje: ''));
      if (result.error.isNotEmpty) {
        state = state.copyWith(status: state.status.copyWith(isPosting: false));
        return false;
      }
      state = state.copyWith(status: state.status.copyWith(isPosting: false));
      return true;
    } catch (e) {
      state = state.copyWith(status: state.status.copyWith(isPosting: false));
      return false;
    }
  }

  void _touchedEverything() {
    state = state.copyWith(
        status: state.status.copyWith(
            isFormValid: Formz.validate([
      GenericRequiredListStr.dirty(state.emails.value),
    ])));
  }
}

class SendEmailState {
  final Formstatus status;
  final List<Labels> labels;
  final Email nuevoEmail;
  final GenericRequiredListStr emails;

  SendEmailState({
    required this.status,
    required this.labels,
    required this.nuevoEmail,
    required this.emails,
  });

  SendEmailState copyWith({
    Formstatus? status,
    List<Labels>? labels,
    Email? nuevoEmail,
    GenericRequiredListStr? emails,
  }) {
    return SendEmailState(
      status: status ?? this.status,
      labels: labels ?? this.labels,
      nuevoEmail: nuevoEmail ?? this.nuevoEmail,
      emails: emails ?? this.emails,
    );
  }
}
