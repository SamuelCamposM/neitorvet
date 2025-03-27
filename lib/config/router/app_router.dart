import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/config/router/app_router.notifier.dart';
import 'package:neitorvet/features/auth/auth.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/screens/cierre_surtidor_screen.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/screens/cierre_surtidores_screen.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/screens/menu_despacho.dart';
import 'package:neitorvet/features/clientes/presentation/screens/screens.dart';
import 'package:neitorvet/features/home/presentation/screens/cierre_turno_screen.dart';
import 'package:neitorvet/features/shared/provider/send_email/send_email_provider.dart';
import 'package:neitorvet/features/shared/screen/send_email.dart';
import 'package:neitorvet/features/shared/screen/show_pdf_screen.dart';

import 'package:neitorvet/features/venta/presentation/screens/screens.dart';

import 'package:neitorvet/features/home/home.dart';

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
        ),
      ),
      GoRoute(
        path: '/ventas',
        builder: (context, state) => const VentasScreen(),
      ),
      GoRoute(
        path: '/venta/:id',
        builder: (context, state) => VentaScreen(
          ventaId: int.tryParse(state.params['id'].toString()) ?? 0,
        ),
      ),
      GoRoute(
        path: '/cierre_turno',
        builder: (context, state) => const CierreTurnoScreen(),
      ),
      GoRoute(
        path: '/cierre_cajas',
        builder: (context, state) => const CierreSurtidoresScreen(),
      ),
      GoRoute(
        path: '/cierre_cajas/:id',
        builder: (context, state) => CierreSurtidorScreen(
          cierreSurtidorUuid: state.params['id'].toString(),
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
        path: '/surtidores',
        builder: (context, state) => const BodyMenuDespacho(
          ventaState: null,
        ),
      ),
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
        path: '/seleccionSurtidor/:id',
        builder: (context, state) => MenuDespacho(
          ventaId: int.tryParse(state.params['id'].toString()) ?? 0,
        ),
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
