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
    final size = Responsive.of(context);
    return SizedBox(
      width: size.wScreen(100),
      height: size.hScreen(100),
      // color: Colors.red,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0), // Reducir el padding
            child: Center(
              // Centrar el contenido en la pantalla
              child: Wrap(
                alignment: WrapAlignment.center, // Centrar los elementos
                spacing:
                    size.iScreen(1.0), // Espacio horizontal entre los elementos
                runSpacing:
                    size.iScreen(1.0), // Espacio vertical entre las filas
                children: appMenuItems.map((menuItem) {
                  return ItemMenu(
                    size: size,
                    menuItem: menuItem,
                  );
                }).toList(),
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.iScreen(1.0), vertical: size.iScreen(1.0)),
                width: size.wScreen(100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ver: 1.0.0',
                      style: TextStyle(
                        fontSize: size.iScreen(1.7),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    Image.asset(
                      'assets/images/logoNeitor.png',
                      height: size.iScreen(6.0),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class ItemMenu extends StatelessWidget {
  final MenuItem menuItem;

  const ItemMenu({
    super.key,
    required this.size,
    required this.menuItem,
  });

  final Responsive size;

  @override
  Widget build(BuildContext context) {
    final colorSecundario = Theme.of(context).colorScheme;
    final colorPrimario = Theme.of(context).appBarTheme.backgroundColor;
    return SizedBox(
      width: size.iScreen(14.0), // Ajustar el ancho de los elementos
      height: size.iScreen(14.0), // Ajustar el ancho de los elementos
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 4.0), // Espacio entre los elementos
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(10.0), // Reducir el radio de los bordes
          child: Material(
            color: Colors.transparent, // Color de fondo transparente
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  10.0), // Radio de los bordes redondeados
            ),
            child: InkWell(
              onTap: () {
                // Acción al presionar el botón
                context.push(menuItem.link);
              },
              splashColor: colorPrimario!.withAlpha((0.7 * 255).toInt()), // Color del splash
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      color: colorSecundario.secondary,
                      width: 2.0), // Borde gris
                ),
                child: Center(
                  // Centrar el contenido
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        menuItem.icon,
                        height: size.iScreen(7.0),
                        color: colorSecundario
                            .secondary, // Reducir el tamaño de la imagen
                      ),
                      const SizedBox(height: 4), // Reducir el espacio
                      Text(
                        menuItem.title,
                        style: TextStyle(
                          fontSize:
                              size.iScreen(1.8), // Reducir el tamaño del texto
                          fontWeight: FontWeight.bold,
                          color: colorSecundario.secondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2), // Reducir el espacio
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class _CustomCard extends StatelessWidget {
//   const _CustomCard({
//     required this.menuItem,
//   });

//   final MenuItem menuItem;

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final size = Responsive.of(context);
//     return GestureDetector(
//       onTap: () {
//         context.push(menuItem.link);
//       },
//       child: Card(
//         color: Colors.grey.shade200,
//         elevation: 4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               menuItem.icon,
//               height: size.iScreen(6.0),
//             ),
//             // Icon(
//             //   menuItem.icon,
//             //   size: size.iScreen(7.0),
//             //   color: colors.primary,
//             // ),
//             const SizedBox(height: 16),
//             Text(
//               menuItem.title,
//               style: TextStyle(
//                 fontSize: size.iScreen(2.0),
//                 fontWeight: FontWeight.bold,
//                 color: colors.primary,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
