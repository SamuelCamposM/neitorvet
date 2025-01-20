import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/presentation/provider/clientes_provider.dart';

final clienteProvider = StateNotifierProvider.family
    .autoDispose<ClienteNotifier, ClienteState, int>((ref, perId) {
  final clientesP = ref.watch(clientesProvider.notifier);

  return ClienteNotifier(
    getClienteById: clientesP.getClienteById,
    perId: perId,
  );
});

class ClienteNotifier extends StateNotifier<ClienteState> {
  final GetClienteResponse Function(int perId) getClienteById;
  ClienteNotifier({
    required this.getClienteById,
    required int perId,
  }) : super(ClienteState(perId: perId)) {
    loadCliente();
  }

  Cliente newEmptyCliente() {
    return Cliente(
      perNombreComercial: '',
      perEmpresa: [],
      perPais: '',
      perProvincia: '',
      perCanton: '',
      perTipoProveedor: '',
      perTiempoCredito: '',
      perDocTipo: '',
      perDocNumero: '',
      perPerfil: [],
      perNombre: 'NUEVO CLIENTE',
      perDireccion: '',
      perObligado: '',
      perCredito: '',
      perTelefono: '',
      perCelular: [],
      perEstado: '',
      perObsevacion: '',
      perEmail: [],
      perOtros: [],
      perNickname: '',
      perUser: '',
      perFoto: '',
      perUbicacion: PerUbicacion.fromJson({
        "longitud": "",
        "latitud": "",
      }),
      perDocumento: '',
      perGenero: '',
      perRecomendacion: '',
      perFecNacimiento: '',
      perEspecialidad: '',
      perTitulo: '',
      perSenescyt: '',
      perPersonal: '',
      perId: 0,
      perCodigo: '',
      perUsuario: '',
      perOnline: 0,
      perSaldo: 0,
      perFecReg: '',
      perFecUpd: '',
    );
  }

  void loadCliente() async {
    try {
      if (state.perId == 0) {
        state = state.copyWith(isLoading: false, cliente: newEmptyCliente());
      }
      final clienteResponse = getClienteById(state.perId);
      if (clienteResponse.error.isNotEmpty) {
        return setError(clienteResponse.error);
      }

      state = state.copyWith(
        isLoading: false,
        cliente: clienteResponse.cliente,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void setError(String error) async {
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(error: error);
  }

  @override
  void dispose() {
    // Log para verificar que se está destruyendo
    super.dispose();
  }
}

class ClienteState {
  final int perId;
  final Cliente? cliente;
  final bool isLoading;
  final String error;

  ClienteState(
      {required this.perId,
      this.cliente,
      this.isLoading = true,
      this.error = ''});

  ClienteState copyWith(
          {int? perId, Cliente? cliente, bool? isLoading, String? error}) =>
      ClienteState(
        perId: perId ?? this.perId,
        cliente: cliente ?? this.cliente,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}
