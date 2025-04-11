import 'package:neitorvet/features/venta/domain/datasources/ventas_datasource.dart';
import 'package:neitorvet/features/venta/domain/entities/body_correo.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/venta/domain/repositories/ventas_repository.dart';

class VentasRepositoryImpl extends VentasRepository {
  final VentasDatasource datasource;

  VentasRepositoryImpl({required this.datasource});
  @override
  Future<ResponseVentas> getVentasByPage(
      {required int cantidad,
      required int page,
      required String estado,
      required String input,
      required bool orden,
      required String search,
      required BusquedaVenta busquedaVenta}) {
    return datasource.getVentasByPage(
        cantidad: cantidad,
        page: page,
        estado: estado,
        input: input,
        orden: orden,
        search: search,
        busquedaVenta: busquedaVenta);
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
  Future<ResponseInventario> getInventarioByQuery(
      {required String search, bool filterByCategory = false}) async {
    return datasource.getInventarioByQuery(
        search: search, filterByCategory: filterByCategory);
  }

  @override
  Future<ResponseCorreoVenta> sendCorreo(BodyCorreo bodyCorreo) {
    return datasource.sendCorreo(bodyCorreo);
  }

  @override
  Future<ResponseInventarioIndividual> getInventarioByPistola(
      {required String pistola,
      required String codigoCombustible,
      required String numeroTanque,
      int? idRegistroNoFacturado}) {
    return datasource.getInventarioByPistola(
        pistola: pistola,
        codigoCombustible: codigoCombustible,
        numeroTanque: numeroTanque,
        idRegistroNoFacturado: idRegistroNoFacturado);
  }
}
