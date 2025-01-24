import 'package:neitorvet/features/factura/domain/datasources/ventas_datasource.dart';

abstract class VentasRepository {
  Future<ResponseVentas> getVentasByPage(
      {int cantidad = 10,
      int page = 0,
      String estado = 'FACTURAS',
      String input = 'venId',
      bool orden = false,
      String search = ''});
}
