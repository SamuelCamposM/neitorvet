import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:neitorvet/config/menu/menu_item.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_repository_provider.dart';
import 'package:neitorvet/features/home/presentation/provider/turno_provider.dart';
import 'package:neitorvet/features/home/presentation/widgets/item_menu.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:neitorvet/features/shared/helpers/get_date.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
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
    final turnoState = ref.watch(turnoProvider);
    final authState = ref.watch(authProvider);

    final size = Responsive.of(context);
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: size.wScreen(100),
      height: size.hScreen(100),
      // color: Colors.red,
      child: Stack(
        children: [
          if (turnoState.turno != null &&
              turnoState.turno!.regDatosTurno.isNotEmpty &&
              turnoState.turno!.regDatosTurno.first.fechasIso.isNotEmpty &&
              !authState.isAdmin &&
              !authState.isDemo)
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Turno de hoy:',
                    style: TextStyle(
                      fontSize: size.iScreen(2.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Desde: ${Format.formatFechaHora(turnoState.turno!.regDatosTurno.first.fechasIso.first.desde)}',
                    style: TextStyle(
                      fontSize: size.iScreen(1.7),
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Hasta: ${Format.formatFechaHora(turnoState.turno!.regDatosTurno.first.fechasIso.first.hasta)}',
                    style: TextStyle(
                      fontSize: size.iScreen(1.7),
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(4.0), // Reducir el padding
            child: Center(
              // Centrar el contenido en la pantalla
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (authState.isAdmin || authState.isDemo) const SizedBox(),
                  Column(
                    children: [
                      // IconButton(
                      //     onPressed: () async {
                      //       final profile = await CapabilityProfile.load();
                      //       final printer =
                      //           NetworkPrinter(PaperSize.mm80, profile);

                      //       // Cambia la IP y puerto por los de tu impresora
                      //       final result = await printer.connect(
                      //         '192.168.1.91',
                      //         port: 9100,
                      //       );

                      //       if (result == PosPrintResult.success) {
                      //         printer.text('¡Hola desde Flutter!');
                      //         printer.cut();
                      //         printer.disconnect();
                      //       } else {
                      //         NotificationsService.show(
                      //             context,
                      //             'No se pudo conectar a la impresora',
                      //             SnackbarCategory.error);
                      //       }
                      //     },
                      //     icon: Icon(Icons.print)),
                      if (!authState.isAdmin && !authState.isDemo)
                        BotonTurno(
                          size: size,
                          isBotonActivo: turnoState.turnoActivo,
                          colors: colors,
                          fechaHoraEntrada: turnoState
                              .turno?.regDatosTurno.first.fechasIso.first.desde,
                        ),
                      const SizedBox(height: 12),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: size.iScreen(1.0),
                        runSpacing: size.iScreen(1.0),
                        children: appMenuItems.map((menuItem) {
                          if (!authState.isAdmin &&
                              menuItem.title == 'Gestión' &&
                              !authState.isDemo) {
                            return const SizedBox.shrink();
                          }
                          if (authState.isDemo && menuItem.link == '/admin') {
                            return ItemMenu(
                                size: size,
                                menuItem: menuItem,
                                turnoActivo: true);
                          }
                          return ItemMenu(
                              size: size,
                              menuItem: menuItem,
                              turnoActivo:
                                  turnoState.turnoActivo || authState.isAdmin);
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
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

class BotonTurno extends ConsumerWidget {
  const BotonTurno({
    super.key,
    required this.size,
    required this.isBotonActivo,
    required this.colors,
    this.fechaHoraEntrada,
  });

  final Responsive size;
  final bool isBotonActivo;
  final ColorScheme colors;
  final String? fechaHoraEntrada;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      turnoProvider,
      (_, next) {
        if (next.errorMessage.isNotEmpty) {
          NotificationsService.show(
              context, next.errorMessage, SnackbarCategory.error);
          ref.read(turnoProvider.notifier).resetErrorMessage();
        }
        if (next.successMessage.isNotEmpty) {
          NotificationsService.show(
              context, next.successMessage, SnackbarCategory.success);
          ref.read(turnoProvider.notifier).resetSuccessMessage();
        }
      },
    );
    return GestureDetector(
      onTap: () async {
        // Aquí puedes agregar la lógica para manejar el turno activo
        final res =
            await ref.read(cierreCajasRepositoryProvider).getNoFacturados();
        if (res.resultado.isNotEmpty && context.mounted && isBotonActivo) {
          NotificationsService.show(
              context, 'Hay Facturas Pendientes', SnackbarCategory.error);
          return;
        }
        if (isBotonActivo && context.mounted) {
          if (fechaHoraEntrada == null || fechaHoraEntrada!.isEmpty) {
            NotificationsService.show(
                context,
                'Fecha y hora de entrada no disponible',
                SnackbarCategory.error);
            return;
          }
          final noPuedeIniciarTurno =
              GetDate.noEsHoraDeIniciarTurno("2025-06-16 15:20:00");
          if (noPuedeIniciarTurno) {
            NotificationsService.show(
                context, 'No es hora de iniciar turno', SnackbarCategory.error);
            return;
          }
        }
        if (context.mounted) {
          mostrarModalTurno(
              context, isBotonActivo ? 'Finalizar' : 'Iniciar', size);
        }
      },
      child: Container(
        width: size.wScreen(50),
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
              final qrResult = ref.watch(turnoProvider).qrUbicacion;
              return Text('Resultado del escaneo: $qrResult');
            },
          ),
          actions: <Widget>[
            Consumer(
              builder: (context, ref, child) {
                return TextButton(
                  onPressed: () async {
                    Navigator.pop(dialogContext); // Cierra el modal actual
                    await ref
                        .read(turnoProvider.notifier)
                        .startScanning(context); // Usa el contexto principal
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
