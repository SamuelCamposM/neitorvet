import 'package:neitorvet/features/venta/domain/entities/venta.dart';

class ResponseVentas {
  final List<Venta> resultado;
  final int total;
  final String error;

  ResponseVentas(
      {required this.resultado, required this.error, this.total = 0});
}

abstract class VentasDatasource {
  Future<ResponseVentas> getVentasByPage(
      {int cantidad = 10,
      int page = 0,
      String estado = 'FACTURAS',
      String input = 'venId',
      bool orden = false,
      String search = ''});
}
