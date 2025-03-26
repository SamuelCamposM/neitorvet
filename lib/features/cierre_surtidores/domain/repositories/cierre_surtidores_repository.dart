import 'package:neitorvet/features/cierre_surtidores/domain/datasources/cierre_surtidores_datasource.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/cierre_surtidor.dart';

abstract class CierreSurtidoresRepository {
  Future<ResponseCierreSurtidores> getCierreSurtidoresByPage(
      {required int cantidad,
      required int page,
      required String input,
      required bool orden,
      required String search,
      required BusquedaCierreSurtidor busquedaCierreSurtidor});
  Future<ResponseCierreSurtidores> getCierreSurtidoresUuid({
    required String uuid,
  });
  Future<ResponseSurtidores> getSurtidores();
}
