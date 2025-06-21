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
  Future<ResponseGenerarCierre> generarCierre({
    required List<String> codCombustible,
    required List<String> pistolas,
  });
  Future<ResponseSurtidores> getSurtidores();
  Future<ResponseStatusPicos> getStatusPicos({
    required String manguera,
  });
  Future<ResponsePresetExtendido> presetExtendido({
    required String manguera,
    required String valorPreset, // valor_preset
    required String tipoPreset, // tipo_preset
    required String nivelPrecio, // nivel_precio
  });
  Future<ResponseModoManguera> setModoManguera({
    required String manguera,
    required String modo,
  });
  Future<ResponseLastDispatch> getLastDispatch({
    required String manguera,
  });
  Future<ResponseAbastecimientoTieneFactura>
      getResponseAbastecimientoTieneFactura({
    required String manguera,
  });
  Future<ResponseValorManguera> getValorManguera({
    required String manguera,
  });
}
