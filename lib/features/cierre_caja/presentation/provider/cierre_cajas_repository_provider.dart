import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_caja/domain/repositories/cierre_cajas_repository.dart';
import 'package:neitorvet/features/cierre_caja/infrastructure/datasources/cierre_cajas_datasource_impl.dart';
import 'package:neitorvet/features/cierre_caja/infrastructure/repositories/cierre_cajas_repository_impl.dart'; 

final cierreCajasRepositoryProvider = Provider<CierreCajasRepository>(
  (ref) {
    final dio = ref.watch(authProvider.notifier).dio;
    final rucempresa = ref.watch(authProvider).user?.rucempresa ?? '';

    final cierreCajasRepository = CierreCajasRepositoryImpl(
        datasource: CierreCajasDatasourceImpl(dio: dio, rucempresa: rucempresa));

    return cierreCajasRepository;
  },
);
