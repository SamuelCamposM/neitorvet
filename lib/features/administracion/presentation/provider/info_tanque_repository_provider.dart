import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:neitorvet/features/administracion/domain/entities/totalesTanque.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/shared/errors/error_api.dart';

final totalesRepositoryProvider = Provider<TotalesRepository>((ref) {
  final dio = ref.watch(authProvider.notifier).dio;
  return TotalesRepository(dio: dio);
});

class ResponseTotalesTanque {
  final String error;
  final Totalestanque? totales;
  ResponseTotalesTanque({required this.error, required this.totales});
}

class TotalesRepository {
  final Dio dio;

  TotalesRepository({required this.dio});

  Future<ResponseTotalesTanque> getTotalesTanque() async {
    try {
      final response = await dio
          .get('/abastecimientos/totales_anual_mensual_semanal_diara');
      final res = Totalestanque.fromJson(response.data);
      print(res);
      return ResponseTotalesTanque(
        error: '',
        totales: res,
      );
    } catch (e) {
      // Manejo de errores
      return ResponseTotalesTanque(
          error: ErrorApi.getErrorMessage(e, 'getTotales'), totales: null);
    }
  }
}
