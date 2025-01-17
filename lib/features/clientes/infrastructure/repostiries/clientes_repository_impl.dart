import 'package:neitorvet/features/clientes/domain/datasources/clientes_datasource.dart';
import 'package:neitorvet/features/clientes/domain/repostiries/clientes_repository.dart';

class ClientesRepositoryImpl extends ClientesRepository {
  final ClientesDatasource datasource;

  ClientesRepositoryImpl({required this.datasource});
  @override
  Future<ResponseClientes> getClientesByPage(
      {int cantidad = 10,
      int page = 0,
      String perfil = 'CLIENTES',
      String input = 'perId',
      bool orden = false}) {
    return datasource.getClientesByPage(
      cantidad: cantidad,
      page: page,
      perfil: perfil,
      input: input,
      orden: orden,
    );
  }
}
