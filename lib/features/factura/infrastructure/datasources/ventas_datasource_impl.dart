import 'package:dio/dio.dart';
import 'package:neitorvet/features/factura/domain/datasources/ventas_datasource.dart';
import 'package:neitorvet/features/factura/domain/entities/venta.dart';
import 'package:neitorvet/features/shared/errors/error_api.dart';

class VentasDatasourceImpl extends VentasDatasource {
  final Dio dio;
  VentasDatasourceImpl({required this.dio});

  @override
  Future<ResponseVentas> getVentasByPage(
      {int cantidad = 10,
      int page = 0,
      String estado = 'FACTURAS',
      String input = 'venId',
      bool orden = false,
      String search = ''}) async {
    try {
      final response = await dio.get(
        '/ventas/?search=$search&cantidad=$cantidad&page=$page&input=$input&orden=$orden&estado=$estado',
      );
      final List<Venta> newVentas = response.data['data']['results']
          .map<Venta>((e) => Venta.fromJson(e))
          .toList();

      return ResponseVentas(
          resultado: newVentas,
          error: '',
          total: response.data['data']['pagination']['numRows'] ?? 0);
    } on DioException catch (e) {
      return ResponseVentas(resultado: [], error: ErrorApi.getErrorMessage(e));
    }
  }
}
