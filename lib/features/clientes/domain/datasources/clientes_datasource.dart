import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';

class ResponseClientes {
  final List<Cliente> resultado;
  final String error;

  ResponseClientes({required this.resultado, required this.error});
}

abstract class ClientesDatasource {
  Future<ResponseClientes> getClientesByPage({
    int cantidad = 10,
    int page = 0,
    String perfil = 'CLIENTES',
    String input = 'perId',
    bool orden = false,
  });
}
