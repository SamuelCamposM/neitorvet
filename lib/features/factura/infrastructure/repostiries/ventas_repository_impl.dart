import 'package:neitorvet/features/factura/domain/datasources/ventas_datasource.dart'; 
import 'package:neitorvet/features/factura/domain/repositories/ventas_repository.dart';


class VentasRepositoryImpl extends VentasRepository {
  final VentasDatasource datasource;

  VentasRepositoryImpl({required this.datasource});
  @override
  Future<ResponseVentas> getVentasByPage(
      {int cantidad = 10,
      int page = 0,
      String estado = 'FACTURAS',
      String input = 'venId',
      bool orden = false,
      String search = ''}) {
    return datasource.getVentasByPage(
        cantidad: cantidad,
        page: page,
        estado: estado,
        input: input,
        orden: orden,
        search: search);
  }
}
