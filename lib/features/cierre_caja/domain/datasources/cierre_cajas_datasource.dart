import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';

class ResponseCierreCajasPaginacion {
  final List<CierreCaja> resultado;
  final int total;
  final String error;

  ResponseCierreCajasPaginacion(
      {required this.resultado, required this.error, this.total = 0});
}

class ResponseSumaIEC {
  final double ingreso;
  final double egreso;
  final double credito;
  final double transferencia;
  final double deposito;
  final String error;

  ResponseSumaIEC({
    required this.ingreso,
    required this.egreso,
    required this.credito,
    required this.transferencia,
    required this.deposito,
    required this.error,
  });
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
  // cajas/saldo-total/ingreso-egreso-credito?search=&fecha=2025-03-28
  Future<ResponseSumaIEC> getSumaIEC({
    required String fecha,
    required String search,
  });
}
