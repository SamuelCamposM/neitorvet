import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/config/menu/menu_item.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
// import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/widgets/custom_app_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: CustomAppBar(
        title: 'Home',
        userName: authState.user!.nombre, // Reemplaza con el nombre del usuario
        moduleName: 'Home',
        logoUrl: authState.user!.logo, // Ruta de la imagen del logo
      ),
      body: _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),
        itemCount: appMenuItems.length,
        itemBuilder: (context, index) {
          final menuItem = appMenuItems[index];
          return _CustomCard(menuItem: menuItem);
        },
      ),
    );
  }
}

class _CustomCard extends StatelessWidget {
  const _CustomCard({
    required this.menuItem,
  });

  final MenuItem menuItem;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        context.push(menuItem.link);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                menuItem.icon,
                size: 48,
                color: colors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                menuItem.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                menuItem.subTitle,
                style: TextStyle(
                  fontSize: 14,
                  color: colors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
