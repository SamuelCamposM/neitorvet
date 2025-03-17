import 'package:neitorvet/features/venta/domain/entities/body_correo.dart';
import 'package:neitorvet/features/venta/domain/entities/forma_pago.dart';
import 'package:neitorvet/features/venta/domain/entities/inventario.dart';
import 'package:neitorvet/features/venta/domain/entities/surtidor.dart';
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

  ResponseInventarioIndividual({
    required this.resultado,
    required this.error,
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
  Future<ResponseSurtidores> getSurtidores();
  Future<ResponseSecuencia> getSecuencia(String tipo);
  Future<ResponseInventario> getInventarioByQuery(String search);
  Future<ResponseInventarioIndividual> getInventarioByPistola({
    required String pistola,
    required String codigoCombustible,
    required String numeroTanque,
  });
  Future<ResponseCorreoVenta> sendCorreo(BodyCorreo bodyCorreo);
}
