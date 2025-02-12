import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';
import 'package:neitorvet/features/clientes/domain/entities/cliente_foreign.dart';

class ResponseClientesPaginacion {
  final List<Cliente> resultado;
  final int total;
  final String error;

  ResponseClientesPaginacion(
      {required this.resultado, required this.error, this.total = 0});
}

class ResponseCliente {
  final List<ClienteForeign> resultado;
  final String error;

  ResponseCliente({
    required this.resultado,
    required this.error,
  });
}

abstract class ClientesDatasource {
  Future<ResponseClientesPaginacion> getClientesByPage(
      {int cantidad = 10,
      int page = 0,
      String perfil = 'CLIENTES',
      String input = 'perId',
      bool orden = false,
      String search = ''});

  Future<ResponseCliente> getClientesByQueryInVentas(String search);
}
