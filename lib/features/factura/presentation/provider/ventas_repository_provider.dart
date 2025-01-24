import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/factura/domain/repositories/ventas_repository.dart';
import 'package:neitorvet/features/factura/infrastructure/datasources/ventas_datasource_impl.dart';
import 'package:neitorvet/features/factura/infrastructure/repostiries/ventas_repository_impl.dart';

final ventasRepositoryProvider = Provider<VentasRepository>(
  (ref) {
    final dio = ref.watch(authProvider.notifier).dio;

    return VentasRepositoryImpl(datasource: VentasDatasourceImpl(dio: dio));
  },
);
