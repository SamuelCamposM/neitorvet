import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/repositories/cierre_surtidores_repository.dart';
import 'package:neitorvet/features/cierre_surtidores/infrastructure/datasources/cierre_surtidores_datasource_impl.dart';
import 'package:neitorvet/features/cierre_surtidores/infrastructure/repositories/cierre_surtidores_repository_impl.dart';

final cierreSurtidoresRepositoryProvider = Provider<CierreSurtidoresRepository>(
  (ref) {
    final dio = ref.watch(authProvider.notifier).dio;
    final rucempresa = ref.watch(authProvider).user?.rucempresa ?? "";

    return CierreSurtidoresRepositoryImpl(
        datasource:
            CierreSurtidoresDatasourceImpl(dio: dio, rucempresa: rucempresa));
  },
);
