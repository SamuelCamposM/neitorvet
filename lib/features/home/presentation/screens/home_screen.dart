import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/config/menu/menu_item.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
// import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/shared/shared.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/ui/custom_app_bar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();
    // final colors = Theme.of(context).colorScheme;
    return Scaffold(
        drawer: SideMenu(scaffoldKey: scaffoldKey),
        appBar: CustomAppBar(
          title: 'Home',
          userName:
              authState.user!.nombre, // Reemplaza con el nombre del usuario
          moduleName: 'Home',
          logoUrl: authState.user!.logo, // Ruta de la imagen del logo
        ),
        body: _HomeView());
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
    final size = Responsive.of(context);
    return GestureDetector(
      onTap: () {
        context.push(menuItem.link);
      },
      child: Card(
        color: Colors.grey.shade200,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              menuItem.icon,
              size: size.iScreen(7.0),
              color: colors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              menuItem.title,
              style: TextStyle(
                fontSize: size.iScreen(2.0),
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Navigation Drawer')),
//       drawer: Drawer(
//         child: Column(
//           children: [
//         ],
//         ),
//       ),
//       body: Center(child: Text('Pantalla principal')),
//     );
//   }
// }
