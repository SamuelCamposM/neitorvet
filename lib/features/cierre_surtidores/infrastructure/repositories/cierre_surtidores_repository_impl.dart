import 'package:neitorvet/features/cierre_surtidores/domain/datasources/cierre_surtidores_datasource.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/cierre_surtidor.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/repositories/cierre_surtidores_repository.dart';

class CierreSurtidoresRepositoryImpl extends CierreSurtidoresRepository {
  final CierreSurtidoresDatasource datasource;

  CierreSurtidoresRepositoryImpl({required this.datasource});
  @override
  Future<ResponseCierreSurtidores> getCierreSurtidoresByPage(
      {required int cantidad,
      required int page,
      required String input,
      required bool orden,
      required String search,
      required BusquedaCierreSurtidor busquedaCierreSurtidor}) {
    return datasource.getCierreSurtidoresByPage(
        cantidad: cantidad,
        page: page,
        input: input,
        orden: orden,
        search: search,
        busquedaCierreSurtidor: busquedaCierreSurtidor);
  }

  @override
  Future<ResponseCierreSurtidores> getCierreSurtidoresUuid({
    required String uuid,
  }) {
    return datasource.getCierreSurtidoresUuid(
      uuid: uuid,
    );
  }

  @override
  Future<ResponseSurtidores> getSurtidores() {
    return datasource.getSurtidores();
  }

  @override
  Future<ResponseGenerarCierre> generarCierre(
      {required List<String> codCombustible, required List<String> pistolas}) {
    return datasource.generarCierre(
        codCombustible: codCombustible, pistolas: pistolas);
  }
}
