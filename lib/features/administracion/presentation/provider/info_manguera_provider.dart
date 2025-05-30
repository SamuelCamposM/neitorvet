import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/administracion/domain/entities/totalesTanque.dart';
import 'package:neitorvet/features/administracion/presentation/provider/info_tanque_repository_provider.dart';

final infoMangueraProvider = StateNotifierProvider.family
    .autoDispose<InfoMangueraNotifier, InfoMangueraState, String>(
        (ref, mangueraCodigoCombustible) {
  final totalesRepository = ref.watch(totalesRepositoryProvider);

  return InfoMangueraNotifier(
    getInfoManguera: totalesRepository.getInfoManguera,
    manguera: mangueraCodigoCombustible.split('/+/')[0],
    codigoCombustible: mangueraCodigoCombustible.split('/+/')[1],
  );
});

class InfoMangueraNotifier extends StateNotifier<InfoMangueraState> {
  final Future<ResponseTotalesTanque> Function({required String manguera})
      getInfoManguera;
  final String manguera;
  final String codigoCombustible;

  InfoMangueraNotifier({
    required this.getInfoManguera,
    required this.manguera,
    required this.codigoCombustible,
  }) : super(InfoMangueraState(manguera: manguera)) {
    loadInfoManguera(manguera: manguera);
  }

  void loadInfoManguera({required String manguera}) async {
    try {
      final response = await getInfoManguera(manguera: manguera);
      if (response.error.isNotEmpty) {
        state = state.copyWith(error: response.error);
        return;
      }

      final totales = response.totales;
      if (totales == null) {
        state = state.copyWith(error: 'No se encontró información de totales.');
        return;
      }

      // Filtrar los datos según el código de combustible
      final totalDiario = totales.totalDiario
          .firstWhere((item) => item.codigoCombustible == codigoCombustible,
              orElse: () => Total.defaultWithCodigo(
                    codigoCombustible,
                  ));
      final totalSemanal = totales.totalSemanal
          .firstWhere((item) => item.codigoCombustible == codigoCombustible,
              orElse: () => Total.defaultWithCodigo(
                    codigoCombustible,
                  ));
      final totalMensual = totales.totalMensual
          .firstWhere((item) => item.codigoCombustible == codigoCombustible,
              orElse: () => Total.defaultWithCodigo(
                    codigoCombustible,
                  ));
      final totalAnual = totales.totalAnual
          .firstWhere((item) => item.codigoCombustible == codigoCombustible,
              orElse: () => Total.defaultWithCodigo(
                    codigoCombustible,
                  ));

      // if (totalDiario.isEmpty &&
      //     totalSemanal.isEmpty &&
      //     totalMensual.isEmpty &&
      //     totalAnual.isEmpty) {
      //   state = state.copyWith(
      //       error: 'No se encontró información para el código de combustible.');
      //   return;
      // }

      state = state.copyWith(
        isLoading: false,
        totalDiario: totalDiario,
        totalSemanal: totalSemanal,
        totalMensual: totalMensual,
        totalAnual: totalAnual,
      );
    } catch (e) {
      state = state.copyWith(
          error: 'Hubo un error al cargar la información del tanque.');
    }
  }

  @override
  void dispose() {
    // Log para verificar que se está destruyendo
    super.dispose();
  }
}

class InfoMangueraState {
  final String manguera;
  final String codigoCombustible;
  final Total? totalDiario;
  final Total? totalSemanal;
  final Total? totalMensual;
  final Total? totalAnual;
  final bool isLoading;
  final String error;

  InfoMangueraState({
    required this.manguera,
    this.codigoCombustible = '',
    this.totalDiario,
    this.totalSemanal,
    this.totalMensual,
    this.totalAnual,
    this.isLoading = true,
    this.error = '',
  });

  InfoMangueraState copyWith({
    String? manguera,
    String? codigoCombustible,
    Total? totalDiario,
    Total? totalSemanal,
    Total? totalMensual,
    Total? totalAnual,
    bool? isLoading,
    String? error,
  }) =>
      InfoMangueraState(
        manguera: manguera ?? this.manguera,
        codigoCombustible: codigoCombustible ?? this.codigoCombustible,
        totalDiario: totalDiario ?? this.totalDiario,
        totalSemanal: totalSemanal ?? this.totalSemanal,
        totalMensual: totalMensual ?? this.totalMensual,
        totalAnual: totalAnual ?? this.totalAnual,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}
