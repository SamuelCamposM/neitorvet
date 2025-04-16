import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/venta/domain/repositories/ventas_repository.dart';
import 'package:neitorvet/features/venta/infrastructure/datasources/ventas_datasource_impl.dart';
import 'package:neitorvet/features/venta/infrastructure/repositories/ventas_repository_impl.dart';

final ventasRepositoryProvider = Provider<VentasRepository>(
  (ref) {
    final authState = ref.watch(authProvider); // Un solo ref.watch
    final dio = ref.watch(authProvider.notifier).dio;

    return VentasRepositoryImpl(
        datasource: VentasDatasourceImpl(
            dio: dio,
            rucempresa: authState.user!.rucempresa,
            isAdmin: authState.isAdmin));
  },
);
