import 'package:neitorvet/features/cierre_caja/domain/datasources/cierre_cajas_datasource.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/cierre_caja/domain/repositories/cierre_cajas_repository.dart';

class CierreCajasRepositoryImpl extends CierreCajasRepository {
  final CierreCajasDatasource datasource;

  CierreCajasRepositoryImpl({required this.datasource});

  @override
  Future<ResponseCierreCajasPaginacion> getCierreCajasByPage(
      {required int cantidad,
      required int page,
      required String search,
      required String input,
      required bool orden,
      required BusquedaCierreCaja busquedaCierreCaja,
      required String estado}) {
    return datasource.getCierreCajasByPage(
        cantidad: cantidad,
        page: page,
        search: search,
        input: input,
        orden: orden,
        busquedaCierreCaja: busquedaCierreCaja,
        estado: estado);
  }

  @override
  Future<ResponseSumaIEC> getSumaIEC(
      {required String fecha, required String search}) {
    return datasource.getSumaIEC(fecha: fecha, search: search);
  }
}
