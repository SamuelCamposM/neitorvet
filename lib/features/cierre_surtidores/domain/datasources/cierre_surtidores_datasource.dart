import 'package:neitorvet/features/cierre_surtidores/domain/entities/cierre_surtidor.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/surtidor.dart';
import 'package:neitorvet/features/venta/domain/entities/socket/abastecimiento_socket.dart';

class ResponseCierreSurtidores {
  final List<CierreSurtidor> resultado;
  final int total;
  final String error;

  ResponseCierreSurtidores(
      {required this.resultado, required this.error, this.total = 0});
}

class ResponseSurtidores {
  final List<Surtidor> resultado;
  final String error;

  ResponseSurtidores({
    required this.resultado,
    required this.error,
  });
}

class ResponseGenerarCierre {
  final String uuid;
  final String error;

  ResponseGenerarCierre({
    required this.uuid,
    required this.error,
  });
}

class ResponseStatusPicos {
  final String error;
  final bool success;
  final String status;
  ResponseStatusPicos({
    required this.error,
    required this.success,
    required this.status,
  });
}

class ResponsePresetExtendido {
  final String error;
  ResponsePresetExtendido({
    required this.error,
  });
}

class ResponseModoManguera {
  final String error;
  ResponseModoManguera({
    required this.error,
  });
}

class ResponseLastDispatch {
  final String error;
  final AbastecimientoSocket? abastecimientoSocket;
  ResponseLastDispatch({
    required this.error,
    required this.abastecimientoSocket,
  });
}

abstract class CierreSurtidoresDatasource {
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

// POST => /api/cierre_surtidores/generar/cierre
// {
//     "cod_combustible": "0101,0185,0121",
//     "pistolas": "3,4,5,6,7,8"
// }
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
}
