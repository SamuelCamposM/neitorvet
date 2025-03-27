import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_provider.dart';

final cierreCajaProvider = StateNotifierProvider.family
    .autoDispose<CierreCajaNotifier, CierreCajaState, int>((ref, cajaId) {
  final cierreCajasP = ref.watch(cierreCajasProvider.notifier);

  return CierreCajaNotifier(
    getCierreCajaById: cierreCajasP.getCierreCajaById,
    cajaId: cajaId,
  );
});

class CierreCajaNotifier extends StateNotifier<CierreCajaState> {
  final Future<GetCierreCajaResponse> Function(int cajaId) getCierreCajaById;
  CierreCajaNotifier({
    required this.getCierreCajaById,
    required int cajaId,
  }) : super(CierreCajaState(cajaId: cajaId)) {
    loadCierreCaja();
  }

  CierreCaja newEmptyCierreCaja() {
    return CierreCaja(
      cajaId: 0,
      cajaMonto: 0,
      cajaAutorizacion: "",
      cajaCredito: "",
      cajaDetalle: "",
      cajaEgreso: "",
      cajaEmpresa: "",
      cajaEstado: "",
      cajaFecha: "",
      cajaFecReg: "",
      cajaIdVenta: "",
      cajaIngreso: "",
      cajaNumero: "",
      cajaProcedencia: "",
      cajaTipoCaja: "",
      cajaTipoDocumento: "",
      cajaUser: "",
      todos: "",
    );
  }

  void loadCierreCaja() async {
    try {
      if (state.cajaId == 0) {
        state =
            state.copyWith(isLoading: false, cierreCaja: newEmptyCierreCaja());
        return;
      }
      final cierreCajaResponse = await getCierreCajaById(state.cajaId);
      if (cierreCajaResponse.error.isNotEmpty) {
        state = state.copyWith(error: cierreCajaResponse.error);
        return;
      }

//
      // *GENERA OTRO ESPACIO EN MEMORIA      cierreCaja: CierreCaja.fromJson(cierreCajaResponse.cierreCaja!.toJson()),
      //* no LO GENERA cierreCaja: cierreCajaResponse.cierreCaja,

      state = state.copyWith(
        isLoading: false,
        cierreCaja:
            CierreCaja.fromJson(cierreCajaResponse.cierreCaja!.toJson()),
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

class CierreCajaState {
  final int cajaId;
  final CierreCaja? cierreCaja;
  final bool isLoading;
  final String error;

  CierreCajaState(
      {required this.cajaId,
      this.cierreCaja,
      this.isLoading = true,
      this.error = ''});

  CierreCajaState copyWith(
          {int? cajaId,
          CierreCaja? cierreCaja,
          bool? isLoading,
          String? error}) =>
      CierreCajaState(
        cajaId: cajaId ?? this.cajaId,
        cierreCaja: cierreCaja ?? this.cierreCaja,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}
