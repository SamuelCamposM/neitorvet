import 'package:neitorvet/features/clientes/domain/entities/cliente.dart';

class ResponseClientes {
  final List<Cliente> resultado;
  final int total;
  final String error;

  ResponseClientes(
      {required this.resultado, required this.error, this.total = 0});
}

abstract class ClientesDatasource {
  Future<ResponseClientes> getClientesByPage(
      {int cantidad = 10,
      int page = 0,
      String perfil = 'CLIENTES',
      String input = 'perId',
      bool orden = false,
      String search = ''});
}
