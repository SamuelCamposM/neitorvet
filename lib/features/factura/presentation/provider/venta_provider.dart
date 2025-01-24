import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/factura/domain/entities/venta.dart';
import 'package:neitorvet/features/factura/presentation/provider/ventas_provider.dart';

final ventaProvider = StateNotifierProvider.family
    .autoDispose<VentaNotifier, VentaState, int>((ref, venId) {
  final ventasP = ref.watch(ventasProvider.notifier);

  return VentaNotifier(
    getVentaById: ventasP.getVentaById,
    venId: venId,
  );
});

class VentaNotifier extends StateNotifier<VentaState> {
  final Future<GetVentaResponse> Function(int venId) getVentaById;
  VentaNotifier({
    required this.getVentaById,
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
      venFormaPago: '',
      venNumero: '',
      venFacturaCredito: '',
      venDias: '',
      venAbono: '',
      venDescPorcentaje: '',
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
      venFechaFactura: '',
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
        state = state.copyWith(isLoading: false, venta: newEmptyVenta());
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

class VentaState {
  final int venId;
  final Venta? venta;
  final bool isLoading;
  final String error;

  VentaState(
      {required this.venId,
      this.venta,
      this.isLoading = true,
      this.error = ''});

  VentaState copyWith(
          {int? venId, Venta? venta, bool? isLoading, String? error}) =>
      VentaState(
        venId: venId ?? this.venId,
        venta: venta ?? this.venta,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}
