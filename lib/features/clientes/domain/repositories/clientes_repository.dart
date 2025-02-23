import 'package:neitorvet/features/clientes/domain/datasources/clientes_datasource.dart';

abstract class ClientesRepository {
  Future<ResponseClientesPaginacion> getClientesByPage(
      {int cantidad = 10,
      int page = 0,
      String perfil = 'CLIENTES',
      String input = 'perId',
      bool orden = false,
      String search = ''});

  Future<ResponseClientesForeign> getClientesByQueryInVentas(String search);
  Future<ResponseClienteForeign> getNewClienteByPlaca(String placa);
  Future<ResponseClienteForeign> getNewClienteByDoc(String doc);
}
