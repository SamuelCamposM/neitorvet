import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:neitorvet/features/auth/domain/domain.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/home/domain/entities/turno.dart';
import 'package:neitorvet/features/home/domain/repositories/turno_repository.dart';
import 'package:neitorvet/features/home/presentation/provider/turno_repository_provider.dart';

final turnoProvider =
    StateNotifierProvider.autoDispose<TurnoNotifier, TurnoState>(
  (ref) {
    final turnosRepository = ref.watch(turnoRepositoryProvider);
    final user = ref.watch(authProvider).user;
    return TurnoNotifier(turnosRepository: turnosRepository, user: user!);
  },
);

class TurnoNotifier extends StateNotifier<TurnoState> {
  final TurnoRepository turnosRepository;
  final User user;

  TurnoNotifier({
    required this.turnosRepository,
    required this.user,
  }) : super(TurnoState()) {
    verificarTurnoActivo();
  }

  Future<void> verificarTurnoActivo() async {
    state = state.copyWith(loading: true);
    final response = await turnosRepository.verificarTurnoActivo();
    if (response.error.isNotEmpty) {
      state = state.copyWith(
        loading: false,
        errorMessage: response.error,
      );
    } else {
      state = state.copyWith(
        loading: false,
        turno: response.turno,
        turnoActivo: response.response,
      );
    }
  }

  Future<void> startScanning(BuildContext context) async {
    try {
      // Escanear el código QR
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color de la línea del escáner
        'Cancelar', // Texto del botón de cancelar
        true, // Mostrar el flash icon
        ScanMode.QR, // Tipo de código a escanear
      );

      // Obtener las coordenadas del dispositivo
      final position = await _determinePosition();

      // Actualizar el estado con el resultado del escaneo y las coordenadas
      state = state.copyWith(
        qrUbicacion: barcodeScanRes,
      );

      // Llamar al repositorio para iniciar el turno
      if (state.turnoActivo) {
        final resTurno = await turnosRepository.finalizarTurno(
          qrUbicacion: state.qrUbicacion,
          coordenadasFinalizar: PerUbicacion(
            latitud: position.latitude,
            longitud: position.longitude,
          ),
          regId: state.turno!.regId,
        );
        if (resTurno.error.isNotEmpty) {
          state = state.copyWith(
            errorMessage: resTurno.error,
          );
          return;
        }
        state = state.copyWith(
            resetTurno: true, turnoActivo: false, errorMessage: resTurno.msg);
      } else {
        final resTurno = await turnosRepository.iniciarTurno(
          qrUbicacion: state.qrUbicacion,
          regCoordenadas: PerUbicacion(
            latitud: position.latitude,
            longitud: position.longitude,
          ),
          regDispositivo: '',
        );

        if (resTurno.error.isNotEmpty) {
          state = state.copyWith(
            errorMessage: resTurno.error,
          );
          return;
        }
        state = state.copyWith(
            turno: resTurno.turno,
            turnoActivo: true,
            errorMessage: resTurno.msg);
      }
    } catch (e) {
      state = state.copyWith(
          errorMessage:
              'Error al escanear el código QR o leer las coordenadas');
      return;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('El servicio de ubicación está deshabilitado.');
    }

    // Solicitar permisos de ubicación
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Los permisos de ubicación fueron denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Los permisos de ubicación están denegados permanentemente.');
    }

    // Obtener la posición actual
    return await Geolocator.getCurrentPosition();
  }

  void resetQrResult() {
    state = state.copyWith(qrUbicacion: '');
  }

  void resetErrorMessage() {
    state = state.copyWith(errorMessage: '');
  }
}

class TurnoState {
  final String qrUbicacion;
  final bool turnoActivo;
  final bool loading;
  final String errorMessage;
  final Turno? turno;

  TurnoState({
    this.qrUbicacion = '',
    this.turnoActivo = false,
    this.loading = false,
    this.errorMessage = '',
    this.turno,
  });

  TurnoState copyWith({
    String? qrUbicacion,
    bool? turnoActivo,
    bool? loading,
    String? errorMessage, 
    Turno? turno,
    bool resetTurno = false, // Nuevo marcador para sobrescribir con null
  }) {
    return TurnoState(
      qrUbicacion: qrUbicacion ?? this.qrUbicacion,
      turnoActivo: turnoActivo ?? this.turnoActivo,
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
      turno:
          resetTurno ? null : (turno ?? this.turno), // Manejo explícito de null
    );
  }
}
