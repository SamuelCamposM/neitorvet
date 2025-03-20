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
      // optionDocumento: "",
      // venKilometrajeFinal: "",
      // venKilometrajeInicio: "",
      // venProductosAntiguos: [],
      venIdCliente: 1,
      venCostoProduccion: 0,
      venDescPorcentaje: 0,
      venDescuento: 0,
      venEmpIva: 0,
      venSubTotal: 0,
      venSubtotal0: 0,
      venSubTotal12: 0,
      venTotal: 0,
      venTotalIva: 0,
      venUser: "",
      fechaSustentoFactura: "",
      venAbono: "0",
      venAutorizacion: "0",
      venDias: "0",
      venDirCliente: "s/n",
      venEmpAgenteRetencion: "",
      venEmpComercial: "",
      venEmpContribuyenteEspecial: '',
      venEmpDireccion: "",
      venEmpEmail: "",
      venEmpLeyenda: "",
      venEmpNombre: "",
      venEmpObligado: "",
      venEmpRegimen: "",
      venEmpresa: "",
      venEmpRuc: "",
      venEmpTelefono: "",
      venEnvio: "NO",
      venErrorAutorizacion: "NO",
      venEstado: "ACTIVA",
      venFacturaCredito: "NO",
      venFechaAutorizacion: "",
      venFechaFactura: DateTime.now().toLocal().toString().split(' ')[0],
      venFecReg: '',
      venFormaPago: "EFECTIVO",
      venNomCliente: "CONSUMIDOR FINAL",
      venNumero: "0",
      venNumFactura: "",
      venNumFacturaAnterior: "",
      venObservacion: "",
      venOption: "1",
      venOtros: '',
      venOtrosDetalles: "",
      venRucCliente: "9999999999999",
      venTelfCliente: "0000000001",
      venTipoDocuCliente: "RUC",
      venTipoDocumento: "N",
      venTotalRetencion: "0.00",
      venCeluCliente: [],
      venEmailCliente: ["sin@sincorreo.com"],
      venProductos: [],
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
    print('DISPOSE VENTA');
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
