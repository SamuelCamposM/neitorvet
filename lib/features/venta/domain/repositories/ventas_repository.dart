import 'package:neitorvet/features/venta/domain/datasources/ventas_datasource.dart';
import 'package:neitorvet/features/venta/domain/entities/body_correo.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';

abstract class VentasRepository {
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
