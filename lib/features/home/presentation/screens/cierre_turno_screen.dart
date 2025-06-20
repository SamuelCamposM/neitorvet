import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/config/menu/menu_item.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/home/presentation/widgets/item_menu.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/shared/widgets/ui/custom_app_bar.dart';

class CierreTurnoScreen extends ConsumerWidget {
  const CierreTurnoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    // final colors = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Cierre turno',
          userName:
              authState.user!.nombre, // Reemplaza con el nombre del usuario
          moduleName: 'Cierre turno',
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
                children: cierreTurnoItems.map((menuItem) {
                  return ItemMenu(
                    size: size,
                    menuItem: menuItem,
                    turnoActivo: true,
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
                      'Ver: 2.050',
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
