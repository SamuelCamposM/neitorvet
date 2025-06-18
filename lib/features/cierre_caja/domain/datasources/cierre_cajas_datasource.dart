import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/egreso_usuario.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/no_facturado.dart';

class ResponseCierreCajasPaginacion {
  final List<CierreCaja> resultado;
  final int total;
  final String error;

  ResponseCierreCajasPaginacion(
      {required this.resultado, required this.error, this.total = 0});
}

// Ejemplo de la clase ResponseSumaIEC
class ResponseSumaIEC {
  final double ingreso;
  final double egreso;
  final double credito;
  final double transferencia;
  final double deposito;
  final double tarjetaCredito;
  final double tarjetaDebito;
  final double tarjetaPrepago;
  final String error;

  const ResponseSumaIEC({
    required this.ingreso,
    required this.egreso,
    required this.credito,
    required this.transferencia,
    required this.deposito,
    required this.tarjetaCredito,
    required this.tarjetaDebito,
    required this.tarjetaPrepago,
    required this.error,
  });
}

class ResponseEgresos {
  final String error;
  final List<EgresoUsuario> resultado;

  const ResponseEgresos({
    required this.error,
    required this.resultado,
  });
}

class ResponseNoFacturados {
  final List<NoFacturado> resultado;
  final String error;

  ResponseNoFacturados({required this.resultado, required this.error});
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
  Future<ResponseEgresos> getEgresos({
    required String documento,
  });
  Future<ResponseNoFacturados> getNoFacturados();
}
