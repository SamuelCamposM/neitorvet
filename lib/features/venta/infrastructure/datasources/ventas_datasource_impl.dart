import 'package:dio/dio.dart';
import 'package:neitorvet/features/venta/domain/datasources/ventas_datasource.dart';
import 'package:neitorvet/features/venta/domain/entities/body_correo.dart';
import 'package:neitorvet/features/venta/domain/entities/forma_pago.dart';
import 'package:neitorvet/features/venta/domain/entities/inventario.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/shared/errors/error_api.dart';

class VentasDatasourceImpl extends VentasDatasource {
  final Dio dio;
  final String rucempresa;
  VentasDatasourceImpl({required this.dio, required this.rucempresa});

  @override
  Future<ResponseVentas> getVentasByPage(
      {int cantidad = 10,
      int page = 0,
      String estado = 'NOTA VENTAS',
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

  @override
  Future<ResponseFormasPago> getFormasPago() async {
    try {
      final response = await dio.get('/formaPagos/filtro/0');
      final List<FormaPago> formasPago = (response.data['data'] as List)
          .map((e) => FormaPago.fromJson(e))
          .toList();
      return ResponseFormasPago(resultado: formasPago, error: '');
    } on DioException catch (e) {
      return ResponseFormasPago(
          resultado: [], error: ErrorApi.getErrorMessage(e));
    }
  }

  @override
  Future<ResponseSecuencia> getSecuencia(String tipo) async {
    try {
      final response = await dio.get(
        '/secuencias/filtro/0?empresa=$rucempresa&search=$tipo',
      );
      final String inventario = response.data['secuencia'];
      return ResponseSecuencia(
        resultado: inventario,
        error: '',
      );
    } on DioException catch (e) {
      return ResponseSecuencia(
        resultado: '',
        error: ErrorApi.getErrorMessage(e),
      );
    }
  }

  @override
  Future<ResponseInventario> getInventarioByQuery(String search) async {
    try {
      final response = await dio.get(
        '/inventario/filtro/0?empresa=$rucempresa&search=$search',
      );

      final List<Inventario> inventarioData = response.data['data']
          .map<Inventario>((e) => Inventario.fromJson(e))
          .toList();

      return ResponseInventario(
        resultado: inventarioData,
        error: '',
      );
    } on DioException catch (e) {
      return ResponseInventario(
        resultado: [],
        error: ErrorApi.getErrorMessage(e),
      );
    }
  }

  @override
  Future<ResponseCorreoVenta> sendCorreo(BodyCorreo bodyCorreo) async {
    try {
      final res = await dio.post("/mensajeria", data: bodyCorreo.toJson());
      final String msg = res.data['msg'];
      return ResponseCorreoVenta(msg: msg, error: '');
    } catch (e) {
      return ResponseCorreoVenta(
          msg: '', error: 'Hubo un error al enviar correo');
    }
  }
}
