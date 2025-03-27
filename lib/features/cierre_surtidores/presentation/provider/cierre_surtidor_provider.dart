import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/cierre_surtidor.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/provider/cierre_surtidores_provider.dart';

final cierreSurtidorProvider = StateNotifierProvider.family
    .autoDispose<CierreSurtidorNotifier, CierreSurtidorState, String>(
        (ref, uuidCierre) {
  final cierreSurtidoresP = ref.watch(cierreSurtidoresProvider.notifier);

  return CierreSurtidorNotifier(
    getCierreSurtidoresByUuid: cierreSurtidoresP.getCierreSurtidoresByUuid,
    uuidCierre: uuidCierre,
  );
});

class CierreSurtidorNotifier extends StateNotifier<CierreSurtidorState> {
  final Future<GetCierreSurtidorResponse> Function(String uuidCierre)
      getCierreSurtidoresByUuid;
  CierreSurtidorNotifier({
    required this.getCierreSurtidoresByUuid,
    required String uuidCierre,
  }) : super(CierreSurtidorState(uuidCierre: uuidCierre)) {
    loadCierreSurtidor();
  }

  // CierreSurtidor newEmptyCierreSurtidor() {
  //   return CierreSurtidor(
  //     idcierre: 0,
  //     contadorCierre: 0,
  //     combustibleCierre: 0,
  //     codigoCombustible: '',
  //     nombreCombustible: 0,
  //     pistolaCierre: 0,
  //     valorCierre: 0,
  //     tGalonesCierre: 0,
  //     fechaCierre: '',
  //     totInicioCierre: 0,
  //     totFinalCierre: 0,
  //     totalDiaValorCierre: 0,
  //     totalDiaGalonesCierre: 0,
  //     userCierre: '',
  //     uuid: '',
  //     fecReg: '',
  //   );
  // }

  void loadCierreSurtidor() async {
    try {
      if (state.uuidCierre.isEmpty) {
        state = state.copyWith(
          isLoading: false,
        );
        return;
      }

      final cierreSurtidorResponse =
          await getCierreSurtidoresByUuid(state.uuidCierre);
      if (cierreSurtidorResponse.error.isNotEmpty) {
        state = state.copyWith(error: cierreSurtidorResponse.error);
        return;
      }

      state = state.copyWith(
        isLoading: false,
        cierreSurtidores: cierreSurtidorResponse.cierreSurtidores,
      );
    } catch (e) {
      state = state.copyWith(error: 'Hubo un error');
    }
  }

  @override
  void dispose() { 
    // Log para verificar que se está destruyendo
    super.dispose();
  }
}

class CierreSurtidorState {
  final String uuidCierre;
  final List<CierreSurtidor> cierreSurtidores;
  final bool isLoading;
  final String error;
  final String secuencia;

  CierreSurtidorState(
      {required this.uuidCierre,
      this.cierreSurtidores = const [],
      this.isLoading = true,
      this.error = '',
      this.secuencia = ''});

  CierreSurtidorState copyWith(
          {String? uuidCierre,
          List<CierreSurtidor>? cierreSurtidores,
          bool? isLoading,
          String? error,
          String? secuencia}) =>
      CierreSurtidorState(
        uuidCierre: uuidCierre ?? this.uuidCierre,
        cierreSurtidores: cierreSurtidores ?? this.cierreSurtidores,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        secuencia: secuencia ?? this.secuencia,
      );
}
