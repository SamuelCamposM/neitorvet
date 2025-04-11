import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/auth/domain/domain.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_caja/domain/datasources/cierre_cajas_datasource.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/no_facturado.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_repository_provider.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/entities/surtidor.dart'; 
import 'package:neitorvet/features/shared/helpers/get_date.dart';

final getInfoCierreCajaProvider = StateNotifierProvider.autoDispose<
    GenInfoCierreCajaNotifier, GenInfoCierreCajaState>(
  (ref) {
    final cierreCajasP = ref.watch(cierreCajasProvider.notifier);
    final user = ref.watch(authProvider).user!;
    final isAdmin = ref.watch(authProvider).isAdmin;
    return GenInfoCierreCajaNotifier(
      getCierreCajaById: cierreCajasP.getCierreCajaById,
      user: user,
      ref: ref,
      isAdmin: isAdmin,
    );
  },
);

class GenInfoCierreCajaNotifier extends StateNotifier<GenInfoCierreCajaState> {
  final Future<GetCierreCajaResponse> Function(int cajaId) getCierreCajaById;
  final User user;
  final Ref ref;

  final bool isAdmin;

  GenInfoCierreCajaNotifier({
    required this.getCierreCajaById,
    required this.user,
    required this.isAdmin,
    required this.ref,
  }) : super(GenInfoCierreCajaState()) {
    buscarCliente(user.usuario, GetDate.today);
  }

  Future<void> buscarCliente(String search, String fecha) async {
    // Actualizar el estado a "cargando"
    state = state.copyWith(isLoading: true);

    try {
      // Llamada al repositorio para obtener los datos
      final res = await ref
          .read(cierreCajasRepositoryProvider)
          .getSumaIEC(fecha: fecha, search: search);

      // Verificar si el StateNotifier sigue montado
      if (!mounted) return;

      // Manejar errores si los hay
      if (res.error.isNotEmpty) {
        state = state.copyWith(error: res.error);
        return;
      }

      // Actualizar el estado con los datos obtenidos
      state = state.copyWith(
        fecha: fecha,
        isLoading: false,
        datos: res,
      );
    } catch (e) {
      // Verificar si el StateNotifier sigue montado
      if (!mounted) return;

      // Manejar errores inesperados
      state = state.copyWith(
        isLoading: false,
        datos: const ResponseSumaIEC(
          ingreso: 0,
          egreso: 0,
          credito: 0,
          transferencia: 0,
          deposito: 0,
          error: 'Error al cargar los datos',
        ),
      );
    }
  }

  Future<List<NoFacturado>> getNoFacturados(
      List<Surtidor> surtidoresData) async {
    // Actualizar el estado a "cargando"
    state = state.copyWith(
      isLoading: true,
    );

    try {
      // Llamada al repositorio para obtener los datos
      final res =
          await ref.read(cierreCajasRepositoryProvider).getNoFacturados();

      // Manejar errores si los hay
      if (res.error.isNotEmpty) {
        state = state.copyWith(error: res.error);
        return [];
      }

      List<Estacion> pistolas = [];
      if (!isAdmin) {
        for (var surtidor in surtidoresData) {
          final existeUsuario =
              surtidor.usuarios.any((element) => element.perId == user.id);
          if (existeUsuario) {
            final List<Estacion> estaciones = [
              surtidor.estacion1,
              surtidor.estacion2,
              surtidor.estacion3,
            ]
                .where((element) => element?.nombreProducto != null)
                .cast<Estacion>()
                .toList();
            for (var element in estaciones) {
              pistolas.add(element);
            }
          }
        }
      }

      final resultadoFiltrado = res.resultado.where(
        (element) {
          return pistolas
              .any((pistola) => pistola.numeroPistola == element.pistola);
        },
      ).toList();

      // Ordenar los resultados por fechaHora de forma ascendente
      final sortedNoFacturados = (isAdmin ? res.resultado : resultadoFiltrado)
        ..sort((a, b) =>
            DateTime.parse(b.fechaHora).compareTo(DateTime.parse(a.fechaHora)));

      // Actualizar el estado con los datos obtenidos
      state = state.copyWith(
        isLoading: false,
        noFacturados: sortedNoFacturados,
        deshabilitarPrint: false,
        error: sortedNoFacturados.isNotEmpty ? 'Hay Facturas Pendientes' : '',
      );
      return sortedNoFacturados;
    } catch (e) {
      // Manejar errores inesperados
      state = state.copyWith(
        isLoading: false,
        error: 'Error al cargar los datos',
      );
      return [];
    }
  }

  void resetError() {
    state = state.copyWith(error: '');
  }
}

class GenInfoCierreCajaState {
  final bool isLoading;
  final ResponseSumaIEC datos;
  final String fecha;
  final String error;
  final List<NoFacturado> noFacturados;
  final bool deshabilitarPrint;
  GenInfoCierreCajaState({
    this.error = '',
    this.deshabilitarPrint = true,
    this.noFacturados = const [],
    this.isLoading = false,
    this.datos = const ResponseSumaIEC(
      ingreso: 0,
      egreso: 0,
      credito: 0,
      transferencia: 0,
      deposito: 0,
      error: '',
    ),
    this.fecha = '',
  });

  GenInfoCierreCajaState copyWith({
    String? error,
    bool? isLoading,
    ResponseSumaIEC? datos,
    String? fecha,
    List<NoFacturado>? noFacturados,
    bool? deshabilitarPrint,
  }) {
    return GenInfoCierreCajaState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      datos: datos ?? this.datos,
      fecha: fecha ?? this.fecha,
      noFacturados: noFacturados ?? this.noFacturados,
      deshabilitarPrint: deshabilitarPrint ?? this.deshabilitarPrint,
    );
  }
}
