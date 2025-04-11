import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:neitorvet/config/menu/menu_item.dart';
import 'package:neitorvet/features/administracion/presentation/provider/boton_turno.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/home/presentation/widgets/item_menu.dart';
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

class _HomeView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBotonActivo = ref.watch(botonTurnoProvider);

    final size = Responsive.of(context);
    final colors = Theme.of(context).colorScheme;
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BotonTurno(
                      size: size, isBotonActivo: isBotonActivo, colors: colors),
                  const SizedBox(height: 8.0),
                  Consumer(
                    builder: (context, ref, child) {
                      final qrResult = ref.watch(qrScannerProvider);
                      return Text(
                        qrResult != null
                            ? 'Resultado: $qrResult'
                            : '--- ---- ---',
                        style: TextStyle(
                          fontSize: size.iScreen(1.7),
                          fontWeight: FontWeight.bold,
                          color: qrResult != null
                              ? Colors.green
                              : Colors.grey[700],
                        ),
                      );
                    },
                  ),
                  Wrap(
                    alignment: WrapAlignment.center, // Centrar los elementos
                    spacing: size
                        .iScreen(1.0), // Espacio horizontal entre los elementos
                    runSpacing:
                        size.iScreen(1.0), // Espacio vertical entre las filas
                    children: appMenuItems.map((menuItem) {
                      return ItemMenu(
                        size: size,
                        menuItem: menuItem,
                      );
                    }).toList(),
                  ),
                ],
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
                      'Ver: 1.0.4',
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

class BotonTurno extends ConsumerWidget {
  const BotonTurno({
    super.key,
    required this.size,
    required this.isBotonActivo,
    required this.colors,
  });

  final Responsive size;
  final bool isBotonActivo;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // Cambiar el estado del botón de turno
        ref.read(botonTurnoProvider.notifier).toggle();
        // Aquí puedes agregar la lógica para manejar el turno activo
        // mostrarModalTurno(
        //     context, isBotonActivo ? 'Finalizar' : 'Iniciar', size);
      },
      child: Container(
        width: size.wScreen(46.0),
        padding: EdgeInsets.symmetric(
            horizontal: size.iScreen(2.0), vertical: size.iScreen(1.0)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: isBotonActivo ? colors.primary : Colors.white,
          border: Border.all(
            color: Colors.blue, // Color del borde
            width: 1.0, // Ancho del borde (opcional)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.2 * 255).toInt()),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              isBotonActivo ? 'Turno Activo' : 'Turno Inactivo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.iScreen(1.8),
                fontWeight: FontWeight.bold,
                color: isBotonActivo ? Colors.white : Colors.black,
              ), // Opcional: darle estilo al texto
            ),
            Icon(
              isBotonActivo ? Icons.check_circle : Icons.block_outlined,
              color: isBotonActivo ? Colors.amber : Colors.red.shade900,
              size: size.iScreen(3.5),
            ), // Icono de verificación al lado del texto.
          ],
        ),
      ),
    );
  }

  void mostrarModalTurno(BuildContext context, String title, Responsive size) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('$title Turno'),
          content: Consumer(
            builder: (context, ref, child) {
              final qrResult = ref.watch(qrScannerProvider);
              return Text(
                  'Resultado del escaneo: ${qrResult ?? "Presiona escanear"}');
            },
          ),
          actions: <Widget>[
            Consumer(
              builder: (context, ref, child) {
                return TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await ref
                        .read(qrScannerProvider.notifier)
                        .startScanning(dialogContext);
                  },
                  child: SizedBox(
                    width: size.wScreen(25.0),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Escanear'),
                        Icon(Icons.qr_code_scanner),
                      ],
                    ),
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
