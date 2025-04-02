import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/domain/domain.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_caja/domain/datasources/cierre_cajas_datasource.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_repository_provider.dart';
import 'package:neitorvet/features/shared/helpers/get_date.dart';

final getInfoCierreCajaProvider =
    StateNotifierProvider.autoDispose<GenInfoCierreCajaNotifier, GenInfoCierreCajaState>(
  (ref) {
    final cierreCajasP = ref.watch(cierreCajasProvider.notifier);
    final user = ref.watch(authProvider).user!;
    return GenInfoCierreCajaNotifier(
      getCierreCajaById: cierreCajasP.getCierreCajaById,
      user: user,
      ref: ref,
    );
  },
);

class GenInfoCierreCajaNotifier extends StateNotifier<GenInfoCierreCajaState> {
  final Future<GetCierreCajaResponse> Function(int cajaId) getCierreCajaById;
  final User user;
  final Ref ref;

  GenInfoCierreCajaNotifier({
    required this.getCierreCajaById,
    required this.user,
    required this.ref,
  }) : super(GenInfoCierreCajaState()) {
    buscarCliente(user.usuario, GetDate.today);
  }

  Future<void> buscarCliente(String search, String fecha) async {
    // Actualizar el estado a "cargando"
    state = state.copyWith(isLoading: true);

    try {
      // Llamada al repositorio para obtener los datos
      final res = await ref
          .read(cierreCajasRepositoryProvider)
          .getSumaIEC(fecha: fecha, search: search);

      // Manejar errores si los hay
      if (res.error.isNotEmpty) {
        state = state.copyWith(error: res.error);
        return;
      }

      // Actualizar el estado con los datos obtenidos
      state = state.copyWith(
        fecha: fecha,
        isLoading: false,
        datos: res,
      );
    } catch (e) {
      // Manejar errores inesperados
      state = state.copyWith(
        isLoading: false,
        datos: const ResponseSumaIEC(
          ingreso: 0,
          egreso: 0,
          credito: 0,
          transferencia: 0,
          deposito: 0,
          error: 'Error al cargar los datos',
        ),
      );
    }
  }
}

class GenInfoCierreCajaState {
  final bool isLoading;
  final ResponseSumaIEC datos;
  final String fecha;
  final String error;
  GenInfoCierreCajaState({
    this.error = '',
    this.isLoading = false,
    this.datos = const ResponseSumaIEC(
      ingreso: 0,
      egreso: 0,
      credito: 0,
      transferencia: 0,
      deposito: 0,
      error: '',
    ),
    this.fecha = '',
  });

  GenInfoCierreCajaState copyWith({
    String? error,
    bool? isLoading,
    ResponseSumaIEC? datos,
    String? fecha,
  }) {
    return GenInfoCierreCajaState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      datos: datos ?? this.datos,
      fecha: fecha ?? this.fecha,
    );
  }
}
