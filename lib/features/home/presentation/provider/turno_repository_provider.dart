 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/home/domain/repositories/turno_repository.dart';
import 'package:neitorvet/features/home/infrastructure/datasources/turno_datasource_impl.dart';
import 'package:neitorvet/features/home/infrastructure/repositories/turno_repository_impl.dart';

final turnoRepositoryProvider = Provider<TurnoRepository>(
  (ref) {
    final dio = ref.watch(authProvider.notifier).dio;
    final rucempresa = ref.watch(authProvider).user?.rucempresa ?? '';

    final turnoRepository = TurnoRepositoryImpl(
        datasource: TurnoDatasourceImpl(dio: dio, rucempresa: rucempresa));

    return turnoRepository;
  },
);
