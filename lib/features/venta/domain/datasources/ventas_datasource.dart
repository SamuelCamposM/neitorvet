import 'package:neitorvet/features/venta/domain/entities/forma_pago.dart';
import 'package:neitorvet/features/venta/domain/entities/inventario.dart';
import 'package:neitorvet/features/venta/domain/entities/producto.dart';
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

abstract class VentasDatasource {
  Future<ResponseVentas> getVentasByPage(
      {int cantidad = 10,
      int page = 0,
      String estado = 'FACTURAS',
      String input = 'venId',
      bool orden = false,
      String search = ''});

  Future<ResponseFormasPago> getFormasPago();
  Future<ResponseSecuencia> getSecuencia(String tipo);
  Future<ResponseInventario> getInventarioByQuery(String search);
}
