import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/venta/domain/datasources/ventas_datasource.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/venta/presentation/provider/ventas_provider.dart';

final ventaProvider = StateNotifierProvider.family
    .autoDispose<VentaNotifier, VentaState, int>((ref, venId) {
  final ventasP = ref.watch(ventasProvider.notifier);

  return VentaNotifier(
    getVentaById: ventasP.getVentaById,
    getSecuencia: ventasP.getSecuencia,
    venId: venId,
  );
});

class VentaNotifier extends StateNotifier<VentaState> {
  final Future<GetVentaResponse> Function(int venId) getVentaById;
  final Future<ResponseSecuencia> Function() getSecuencia;
  VentaNotifier({
    required this.getVentaById,
    required this.getSecuencia,
    required int venId,
  }) : super(VentaState(venId: venId)) {
    loadVenta();
  }

  Venta newEmptyVenta() {
    return Venta(
      venId: 0,
      venOtros: '',
      venFecReg: '',
      venOption: '',
      venTipoDocumento: '',
      venIdCliente: 0,
      venRucCliente: '',
      venTipoDocuCliente: '',
      venNomCliente: '',
      venEmailCliente: [],
      venTelfCliente: '',
      venCeluCliente: [],
      venDirCliente: '',
      venEmpRuc: '',
      venEmpNombre: '',
      venEmpComercial: '',
      venEmpDireccion: '',
      venEmpTelefono: '',
      venEmpEmail: '',
      venEmpObligado: '',
      venEmpRegimen: '',
      venFormaPago: 'EFECTIVO',
      venNumero: '',
      venFacturaCredito: 'NO',
      venDias: '',
      venAbono: '',
      venDescPorcentaje: 0,
      venOtrosDetalles: '',
      venObservacion: '',
      venSubTotal12: 0,
      venSubtotal0: 0,
      venDescuento: 0,
      venSubTotal: 0,
      venTotalIva: 0,
      venTotal: 0,
      venCostoProduccion: 0,
      venUser: '',
      venFechaFactura: DateTime.now().toLocal().toString().split(' ')[0],
      venNumFactura: '',
      venNumFacturaAnterior: '',
      venAutorizacion: '',
      venFechaAutorizacion: '',
      venErrorAutorizacion: '',
      venEstado: '',
      venEnvio: '',
      fechaSustentoFactura: '',
      venTotalRetencion: '',
      venEmpresa: '',
      venProductos: [],
      venEmpAgenteRetencion: '',
      venEmpContribuyenteEspecial: '',
      venEmpLeyenda: '',
      venEmpIva: 0,
    );
  }

  void loadVenta() async {
    try {
      if (state.venId == 0) {
        final secuenciaResponse = await getSecuencia();
        if (secuenciaResponse.error.isNotEmpty) {
          state = state.copyWith(error: secuenciaResponse.error);
          return;
        }
        state = state.copyWith(
            isLoading: false,
            venta: newEmptyVenta(),
            secuencia: secuenciaResponse.resultado);
        return;
      }

      final ventaResponse = await getVentaById(state.venId);
      if (ventaResponse.error.isNotEmpty) {
        state = state.copyWith(error: ventaResponse.error);
        return;
      }

      state = state.copyWith(
          isLoading: false,
          venta: ventaResponse.venta,
          secuencia: ventaResponse.venta!.venNumFactura);
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

class VentaState {
  final int venId;
  final Venta? venta;
  final bool isLoading;
  final String error;
  final String secuencia;

  VentaState(
      {required this.venId,
      this.venta,
      this.isLoading = true,
      this.error = '',
      this.secuencia = ''});

  VentaState copyWith(
          {int? venId,
          Venta? venta,
          bool? isLoading,
          String? error,
          String? secuencia}) =>
      VentaState(
        venId: venId ?? this.venId,
        venta: venta ?? this.venta,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        secuencia: secuencia ?? this.secuencia,
      );
}
