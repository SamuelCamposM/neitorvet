import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/domain/domain.dart';
import 'package:neitorvet/features/auth/infrastructure/infrastructure.dart';
import 'package:neitorvet/features/shared/infrastructure/services/key_value_storage_impl.dart';

enum AuthStatus { checking, authenticated, noAuthenticated }

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorage = KeyValueStorageImpl();
  return AuthNotifier(
      authRepository: authRepository, keyValueStorage: keyValueStorage);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageImpl keyValueStorage;

  AuthNotifier({required this.authRepository, required this.keyValueStorage})
      : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(
      String empresa, String usuario, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.login(empresa, usuario, password);
      _setLoggedUser(user);
      // } on WrongCredentials catch (_) {
    } on CustomError catch (e) {
      logout(errorMessage: e.message);
    } catch (e) {
      logout(errorMessage: 'Hubo un error');
    }
  }

  void registerUser(String email, String password) async {}
  void checkAuthStatus() async {
    final token = await keyValueStorage.getValue<String>('token');
    if (token == null) logout();
    try {
      final user = await authRepository.checkAuthStatus(token!);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  void _setLoggedUser(User user) async {
    await keyValueStorage.setKeyValue<String>('token', user.token);
    state = state.copywith(
        user: user, authStatus: AuthStatus.authenticated, errorMessage: '');
  }

  Future<void> logout({String? errorMessage}) async {
    await keyValueStorage.removeKey(
      'token',
    );
    state = state.copywith(
        authStatus: AuthStatus.noAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String? errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copywith(
          {AuthStatus? authStatus, User? user, String? errorMessage}) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage);
}
