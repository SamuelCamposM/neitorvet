import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/products/domain/domain.dart';
import 'package:neitorvet/features/products/infrastructure/infrastructure.dart';

//AQUI ESTA LA CLASE QUE CONTIENE LOS METODOS CON LA QUE NOS COMUNICAMOS A LA API
final productsRepositoryProvider = Provider<ProductsRepository>(
  (ref) {
    final accessToken = ref.watch(authProvider).user?.token ?? '';

    final productsRepository = ProductsRepositoryImpl(
        datasource: ProductsDatasourceImpl(accessToken: accessToken));
    return productsRepository;
  },
);
