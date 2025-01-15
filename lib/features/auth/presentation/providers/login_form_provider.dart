import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:neitorvet/features/auth/infrastructure/inputs/input.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/shared/shared.dart';

//! 3- StateNotifier - consume afuera

final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  return LoginFormNotifier(loginUserCallback: loginUserCallback);
});

//! 2- Como implementamos un notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Future<void> Function(String, String, String) loginUserCallback;
  LoginFormNotifier({required this.loginUserCallback})
      : super(LoginFormState());

  void _updateState({
    Usuario? usuario,
    Password? password,
    Empresa? empresa,
  }) {
    state = state.copyWith(
      usuario: usuario ?? state.usuario,
      password: password ?? state.password,
      empresa: empresa ?? state.empresa,
      isValid: Formz.validate([
        usuario ?? state.usuario,
        password ?? state.password,
        empresa ?? state.empresa,
      ]),
    );
  }

  void onEmpresaChange(String value) {
    final newEmpresa = Empresa.dirty(value);
    _updateState(empresa: newEmpresa);
  }

  void onUsuarioChange(String value) {
    final newUsuario = Usuario.dirty(value);
    _updateState(usuario: newUsuario);
  }

  void onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    _updateState(password: newPassword);
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    await loginUserCallback(
        state.empresa.value, state.usuario.value, state.password.value);
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final usuario = Usuario.dirty(state.usuario.value);
    final password = Password.dirty(state.password.value);
    state = state.copyWith(
      isFormPosted: true,
      usuario: usuario,
      password: password,
      isValid: Formz.validate([usuario, password]),
    );
  }
}

//! 1- State de este provider
class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Empresa empresa;
  final Usuario usuario;
  final Password password;

  LoginFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.empresa = const Empresa.pure(),
      this.usuario = const Usuario.pure(),
      this.password = const Password.pure()});

  LoginFormState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          Empresa? empresa,
          Usuario? usuario,
          Password? password}) =>
      LoginFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          empresa: empresa ?? this.empresa,
          usuario: usuario ?? this.usuario,
          password: password ?? this.password);

  @override
  String toString() {
    return '''
    isPosting: $isPosting,
    isFormPosted: $isFormPosted,
    isValid: $isValid,
    usuario: $usuario,
    password: $password
    ''';
  }
}
