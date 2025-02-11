import 'package:neitorvet/features/venta/domain/datasources/ventas_datasource.dart';
import 'package:neitorvet/features/venta/domain/entities/body_correo.dart';

abstract class VentasRepository {
  Future<ResponseVentas> getVentasByPage(
      {int cantidad = 10,
      int page = 0,
      String estado = 'NOTA VENTAS',
      String input = 'venId',
      bool orden = false,
      String search = ''});

  Future<ResponseFormasPago> getFormasPago();
  Future<ResponseSecuencia> getSecuencia(String tipo);
  Future<ResponseInventario> getInventarioByQuery(String search);
  Future<ResponseCorreoVenta> sendCorreo(BodyCorreo bodyCorreo);
}
