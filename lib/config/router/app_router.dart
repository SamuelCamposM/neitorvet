import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/config/router/app_router.notifier.dart';
import 'package:neitorvet/features/auth/auth.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/clientes/presentation/screens/screens.dart';
import 'package:neitorvet/features/shared/screen/show_pdf_screen.dart';

import 'package:neitorvet/features/venta/presentation/screens/ventas_screen.dart';
import 'package:neitorvet/features/venta/presentation/screens/screens.dart';

import 'package:neitorvet/features/products/products.dart';

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
