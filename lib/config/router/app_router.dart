import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/config/router/app_router.notifier.dart';
import 'package:neitorvet/features/administracion/presentation/screens/info_manguera.dart';
import 'package:neitorvet/features/administracion/presentation/screens/info_tanque.dart';

import 'package:neitorvet/features/auth/auth.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/screens/cierre_caja_screen.dart';
import 'package:neitorvet/features/cierre_caja/presentation/screens/cierre_cajas_screen.dart';
import 'package:neitorvet/features/cierre_caja/presentation/screens/get_info_cierre_cajas_screen.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/screens/cierre_surtidor_screen.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/screens/cierre_surtidores_screen.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/screens/menu_despacho.dart';
import 'package:neitorvet/features/clientes/presentation/screens/screens.dart';
import 'package:neitorvet/features/cuentas_por_cobrar/presentation/screens/cuenta_por_cobrar.dart';
import 'package:neitorvet/features/cuentas_por_cobrar/presentation/screens/cuentas_por_cobrar.dart';
import 'package:neitorvet/features/cuentas_por_cobrar/presentation/screens/pago_screen.dart';
import 'package:neitorvet/features/home/presentation/screens/cierre_turno_screen.dart';
import 'package:neitorvet/features/home/presentation/screens/horarios_screen.dart';
import 'package:neitorvet/features/shared/provider/send_email/send_email_provider.dart';
import 'package:neitorvet/features/shared/screen/send_email.dart';
import 'package:neitorvet/features/shared/screen/show_pdf_screen.dart';
import 'package:neitorvet/features/venta/presentation/screens/full_screen_loader_venta.dart';

import 'package:neitorvet/features/venta/presentation/screens/screens.dart';

import 'package:neitorvet/features/home/home.dart';

import '../../features/administracion/presentation/screens/screens.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      //* Primera Pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Home Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/clientes',
        builder: (context, state) => const ClientesScreen(),
      ),
      GoRoute(
        path: '/cliente/:id',
        builder: (context, state) => ClienteScreen(
          clienteId: int.tryParse(state.params['id'].toString()) ?? 0,
          ventaTab: state.queryParams['ventaTab'],
          search: state.queryParams['search'] ?? '',
        ),
      ),
      GoRoute(
        path: '/ventas',
        builder: (context, state) => const VentasScreen(),
      ),
      GoRoute(
        path: '/venta/:id',
        builder: (context, state) => const VentaTabsScreen(),
      ),
      GoRoute(
        path: '/cierre_turno',
        builder: (context, state) => const CierreTurnoScreen(),
      ),
      GoRoute(
        path: '/get_info_cierre_cajas',
        builder: (context, state) => const GetInfoCierreCajasScreen(),
      ),
      GoRoute(
        path: '/cierre_cajas',
        builder: (context, state) => const CierreCajasScreen(),
      ),
      GoRoute(
        path: '/cierre_cajas/:id',
        builder: (context, state) => CierreCajaScreen(
          cajaId: int.tryParse(state.params['id'].toString()) ?? 0,
        ),
      ),
      GoRoute(
        path: '/cuenta_cobrar',
        builder: (context, state) => CuentasPorCobrarScreen(
          search: state.queryParams['search'] ?? '',
        ),
      ),
      GoRoute(
        path: '/cuenta_cobrar/:id',
        builder: (context, state) => CuentaPorCobrar(
          ccId: int.tryParse(state.params['id'].toString()) ?? 0,
        ),
      ),

      GoRoute(
        path: '/pago/:id',
        builder: (context, state) => PagoScreen(
          ccId: int.tryParse(state.params['id'].toString()) ?? 0,
        ),
      ),

      GoRoute(
        path: '/cierre_surtidores',
        builder: (context, state) => const CierreSurtidoresScreen(),
      ),
      GoRoute(
        path: '/cierre_surtidores/:id',
        builder: (context, state) => CierreSurtidorScreen(
          cierreSurtidorUuid: state.params['id'].toString(),
        ),
      ),

      GoRoute(
        path: '/seleccionSurtidor/:id',
        builder: (context, state) => MenuDespacho(
          ventaId: int.tryParse(state.params['id'].toString()) ?? 0,
        ),
      ),
      GoRoute(
        path: '/horarios',
        builder: (context, state) => const HorariosScreen(),
      ),
      // GoRoute(
      //   path: '/surtidores',
      //   builder: (context, state) => const BodyMenuDespacho(
      //     ventaState: null,
      //   ),
      // ),
      GoRoute(
        path: '/PDF/:label/:url',
        builder: (context, state) {
          final String label = state.params['label'] ?? '';
          final String encodedUrl = state.params['url'] ?? '';
          final String url =
              Uri.decodeComponent(encodedUrl); // Decodifica la URL para usarla
          return ShowPdfScreen(
            labelPdf: label,
            infoPdf: url,
          );
        },
      ),
      GoRoute(
        path: '/send-email',
        builder: (context, state) {
          final emails = state.queryParams['emails']?.split(',') ?? [];
          final labels = state.queryParams['labels']?.split(',').map((label) {
                final parts = label.split(':');
                return Labels(label: parts[0], value: parts[1]);
              }).toList() ??
              [];
          final idRegistro =
              int.tryParse(state.queryParams['idRegistro'] ?? '0') ?? 0;
          return SendEmail(
              emailsAndLabelsDefault:
                  EmailAndLabels(emails: emails, labels: labels),
              idRegistro: idRegistro);
        },
      ),

      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminScreens(),
      ),
      GoRoute(
        path: '/info_tanque/:codigoCombustible',
        builder: (context, state) => InfoTanque(
          combustible: state.params['codigoCombustible'] ?? '',
        ),
      ),
      GoRoute(
        path: '/info_manguera',
        builder: (context, state) => InfoManguera(
          manguera: state.queryParams['manguera'] ?? '',
          codigoProducto: state.queryParams['codigoProducto'] ?? '',
        ),
      ),
      GoRoute(
        path: '/cargando/venta',
        builder: (context, state) {
          final numeroPistola = state.queryParams['numeroPistola'] ?? '';
          final venId = state.queryParams['venId'] ?? '';
          return FullScreenLoaderVenta(manguera: numeroPistola, venId: venId);
        },
      ),
      // GoRoute(
      //   path: '/product/:id',
      //   builder: (context, state) {
      //     return ProductScreen(productId: state.params['id'] ?? "no-id");
      //   },
      // ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.subloc;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) {
        return null;
      }

      if (authStatus == AuthStatus.noAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') {
          return null;
        } else {
          return '/login';
        }
      }
      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/';
        }
      }

      return null;
    },
  );
});
