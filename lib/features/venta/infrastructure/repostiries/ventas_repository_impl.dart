import 'package:neitorvet/features/venta/domain/datasources/ventas_datasource.dart';
import 'package:neitorvet/features/venta/domain/repositories/ventas_repository.dart';

class VentasRepositoryImpl extends VentasRepository {
  final VentasDatasource datasource;

  VentasRepositoryImpl({required this.datasource});
  @override
  Future<ResponseVentas> getVentasByPage(
      {int cantidad = 10,
      int page = 0,
      String estado = 'NOTA VENTAS',
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

  @override
  Future<ResponseFormasPago> getFormasPago() {
    return datasource.getFormasPago();
  }

  @override
  Future<ResponseSecuencia> getSecuencia(String tipo) {
    return datasource.getSecuencia(tipo);
  }

  @override
  Future<ResponseInventario> getInventarioByQuery(String search) {
    return datasource.getInventarioByQuery(search);
  }
}
