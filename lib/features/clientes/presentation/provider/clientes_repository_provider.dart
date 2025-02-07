import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/clientes/domain/repositories/clientes_repository.dart';
import 'package:neitorvet/features/clientes/infrastructure/datasources/clientes_datasource_impl.dart';
import 'package:neitorvet/features/clientes/infrastructure/repositories/clientes_repository_impl.dart';

final clientesRepositoryProvider = Provider<ClientesRepository>(
  (ref) {
    final dio = ref.watch(authProvider.notifier).dio;
    final rucempresa = ref.watch(authProvider).user?.rucempresa ?? '';

    final clientesRepository = ClientesRepositoryImpl(
        datasource: ClientesDatasourceImpl(dio: dio, rucempresa: rucempresa));

    return clientesRepository;
  },
);
