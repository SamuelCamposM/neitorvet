import 'package:neitorvet/features/cierre_surtidores/domain/entities/cierre_surtidor.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/surtidor.dart';

class ResponseCierreSurtidores {
  final List<CierreSurtidor> resultado;
  final int total;
  final String error;

  ResponseCierreSurtidores(
      {required this.resultado, required this.error, this.total = 0});
}

class ResponseSurtidores {
  final List<Surtidor> resultado;
  final String error;

  ResponseSurtidores({
    required this.resultado,
    required this.error,
  });
}

abstract class CierreSurtidoresDatasource {
  Future<ResponseCierreSurtidores> getCierreSurtidoresByPage(
      {required int cantidad,
      required int page,
      required String input,
      required bool orden,
      required String search,
      required BusquedaCierreSurtidor busquedaCierreSurtidor});
  Future<ResponseCierreSurtidores> getCierreSurtidoresUuid({
    required String uuid,
  });

  Future<ResponseSurtidores> getSurtidores();
}
