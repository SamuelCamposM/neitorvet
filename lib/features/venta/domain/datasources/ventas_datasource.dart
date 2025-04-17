import 'package:neitorvet/features/venta/domain/entities/body_correo.dart';
import 'package:neitorvet/features/venta/domain/entities/forma_pago.dart';
import 'package:neitorvet/features/venta/domain/entities/inventario.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/surtidor.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';

class ResponseVentas {
  final List<Venta> resultado;
  final int total;
  final String error;

  ResponseVentas(
      {required this.resultado, required this.error, this.total = 0});
}

class ResponseFormasPago {
  final List<FormaPago> resultado;
  final String error;

  ResponseFormasPago({
    required this.resultado,
    required this.error,
  });
}

class ResponseSurtidores {
  final List<Surtidor> resultado;
  final String error;

  ResponseSurtidores({
    required this.resultado,
    required this.error,
  });
}

class ResponseSecuencia {
  final String resultado;
  final String error;

  ResponseSecuencia({
    required this.resultado,
    required this.error,
  });
}

class ResponseInventario {
  final List<Inventario> resultado;
  final String error;

  ResponseInventario({
    required this.resultado,
    required this.error,
  });
}

class ResponseInventarioIndividual {
  final Inventario? resultado;
  final String error;
  final String total;
  final int idAbastecimiento;
  final double totInicio;
  final double totFinal;
  ResponseInventarioIndividual({
    required this.resultado,
    required this.total,
    required this.error,
    required this.idAbastecimiento,
    required this.totInicio,
    required this.totFinal,
  });
}

class ResponseCorreoVenta {
  final String msg;
  final String error;

  ResponseCorreoVenta({
    required this.msg,
    required this.error,
  });
}

abstract class VentasDatasource {
  Future<ResponseVentas> getVentasByPage(
      {required int cantidad,
      required int page,
      required String estado,
      required String input,
      required bool orden,
      required String search,
      required BusquedaVenta busquedaVenta});

  Future<ResponseFormasPago> getFormasPago();
  Future<ResponseSecuencia> getSecuencia(String tipo);
  Future<ResponseInventario> getInventarioByQuery(
      {required String search, bool filterByCategory = false});
  Future<ResponseInventarioIndividual> getInventarioByPistola({
    required String pistola,
    required String codigoCombustible,
    required String numeroTanque,
    int? idRegistroNoFacturado,
  });
  Future<ResponseInventarioIndividual> getLastInventarioByPistola({
    required String pistola,
  });
  Future<ResponseCorreoVenta> sendCorreo(BodyCorreo bodyCorreo);
}
