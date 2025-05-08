import 'package:dio/dio.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';
import 'package:neitorvet/features/venta/domain/datasources/ventas_datasource.dart';
import 'package:neitorvet/features/venta/domain/entities/body_correo.dart';
import 'package:neitorvet/features/venta/domain/entities/forma_pago.dart';
import 'package:neitorvet/features/venta/domain/entities/inventario.dart';
import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:neitorvet/features/shared/errors/error_api.dart';

class VentasDatasourceImpl extends VentasDatasource {
  final Dio dio;
  final String rucempresa;
  final bool isAdmin;
  VentasDatasourceImpl(
      {required this.dio, required this.rucempresa, required this.isAdmin});

  @override
  Future<ResponseVentas> getVentasByPage(
      {required int cantidad,
      required int page,
      required String estado,
      required String input,
      required bool orden,
      required String search,
      required BusquedaVenta busquedaVenta}) async {
    try {
      final queryParameters = {
        'search': search,
        'cantidad': cantidad,
        'page': page,
        'input': input,
        'orden': orden,
        'estado': estado,
        'mis_facturas_emitidas': 'SI',
        'fromApp': true,
        'datos': busquedaVenta.toJsonString(), // Con
      };
      final response = await dio.get(
          isAdmin ? '/ventas/' : '/ventas/lista/diaria',
          queryParameters: queryParameters);
      final List<Venta> newVentas = isAdmin
          ? response.data['data']['results']
              .map<Venta>((e) => Venta.fromJson(e))
              .toList()
          : response.data.map<Venta>((e) => Venta.fromJson(e)).toList();

      return ResponseVentas(
          resultado: newVentas,
          error: '',
          total: isAdmin
              ? response.data['data']['pagination']['numRows'] ?? 0
              : newVentas.length);
    } on DioException catch (e) {
      return ResponseVentas(
          resultado: [], error: ErrorApi.getErrorMessage(e, 'getVentasByPage'));
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
          resultado: [], error: ErrorApi.getErrorMessage(e, 'getFormasPago'));
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
        error: ErrorApi.getErrorMessage(e, 'getSecuencia'),
      );
    }
  }

  @override
  Future<ResponseInventario> getInventarioByQuery(
      {required String search, bool filterByCategory = false}) async {
    try {
      final response = await dio.get(
        '/inventario/filtro/0?empresa=$rucempresa&search=$search',
      );

      final List<Inventario> inventarioData = response.data['data']
          .map<Inventario>((e) => Inventario.fromJson(e))
          .toList();

      return ResponseInventario(
        resultado: filterByCategory
            ? inventarioData
                .where((element) => element.invCategoria == 'PRODUCTO')
                .toList()
            : inventarioData,
        error: '',
      );
    } on DioException catch (e) {
      return ResponseInventario(
        resultado: [],
        error: ErrorApi.getErrorMessage(e, 'getInventarioByQuery'),
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

  @override
  Future<ResponseInventarioIndividual> getInventarioByPistola(
      {required String pistola,
      required String codigoCombustible,
      required String numeroTanque,
      int? idRegistroNoFacturado}) async {
    try {
      final data = {
        // "pistola": 5,
        // "codigoCombustible": "0101",
        // "numeroTanque": 2

        "pistola": pistola,
        "codigoCombustible": codigoCombustible,
        "numeroTanque": numeroTanque,
        'idRegistro': idRegistroNoFacturado
      };
      final response =
          await dio.post('/abastecimientos/obtener_item', data: data);

      final Inventario inventario =
          Inventario.fromJson(response.data['producto']);
      return ResponseInventarioIndividual(
          resultado: inventario,
          error: '',
          idAbastecimiento: Parse.parseDynamicToInt(
            response.data['abastecimiento']['idAbastecimiento'],
          ),
          totInicio: Parse.parseDynamicToDouble(
            response.data['abastecimiento']['totInicio'],
          ),
          totFinal: Parse.parseDynamicToDouble(
            response.data['abastecimiento']['totFinal'],
          ),
          total: Parse.parseDynamicToString(
            response.data['abastecimiento']['valorTotal'],
          ));
    } on DioException catch (e) {
      return ResponseInventarioIndividual(
          resultado: null,
          error: ErrorApi.getErrorMessage(e, 'getInventarioByPistola'),
          total: '0',
          idAbastecimiento: 0,
          totFinal: 0,
          totInicio: 0);
    }
  }

  @override
  Future<ResponseInventarioIndividual> getLastInventarioByPistola(
      {required String pistola}) async {
    try {
      final response = await dio.get('/abastecimientos/$pistola/last_dispatch');

      // final Inventario inventario =
      //     Inventario.fromJson(response.data['producto']);
      return ResponseInventarioIndividual(
          resultado: Inventario(
              invTipo: '',
              invNombre: '',
              invDescripcion: '',
              invCosto1: '',
              invCosto2: '',
              invCosto3: '',
              invStock: 0,
              invIva: '',
              invIncluyeIva: '',
              invEstado: '',
              invprecios: [],
              invProveedor: '',
              invCategoria: '',
              invSubCategoria: '',
              invUnidad: '',
              invMarca: '',
              invSubsidio: '',
              invPlanCuenta: '',
              invEmpresa: '',
              invUser: '',
              invId: 0,
              invSerie: '',
              invNumVentas: 0,
              invFecReg: '',
              invFecUpd: '',
              invFotos: []),
          error: '',
          idAbastecimiento: Parse.parseDynamicToInt(
            response.data['abastecimiento']['idAbastecimiento'],
          ),
          totInicio: Parse.parseDynamicToDouble(
            response.data['abastecimiento']['totInicio'],
          ),
          totFinal: Parse.parseDynamicToDouble(
            response.data['abastecimiento']['totFinal'],
          ),
          total: Parse.parseDynamicToString(
            response.data['abastecimiento']['valorTotal'],
          ));
    } on DioException catch (e) {
      return ResponseInventarioIndividual(
          resultado: null,
          error: ErrorApi.getErrorMessage(e, 'getInventarioByPistola'),
          total: '0',
          idAbastecimiento: 0,
          totFinal: 0,
          totInicio: 0);
    }
  }
}
