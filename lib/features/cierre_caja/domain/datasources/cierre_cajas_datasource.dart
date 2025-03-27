import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';

class ResponseCierreCajasPaginacion {
  final List<CierreCaja> resultado;
  final int total;
  final String error;

  ResponseCierreCajasPaginacion(
      {required this.resultado, required this.error, this.total = 0});
}

abstract class CierreCajasDatasource {
  Future<ResponseCierreCajasPaginacion> getCierreCajasByPage(
      {required int cantidad,
      required int page,
      required String search,
      required String input,
      required bool orden,
      required BusquedaCierreCaja busquedaCierreCaja,
      required String estado});
}
