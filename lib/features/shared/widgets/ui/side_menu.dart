import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/config/menu/menu_item.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/cierre_caja/presentation/provider/cierre_cajas_repository_provider.dart';
import 'package:neitorvet/features/cuentas_por_cobrar/presentation/provider/cuentas_por_cobrar_provider.dart';
import 'package:neitorvet/features/cuentas_por_cobrar/presentation/provider/cuentas_por_cobrar_repository_provider.dart';
import 'package:neitorvet/features/home/presentation/provider/turno_provider.dart';
import 'package:neitorvet/features/shared/helpers/get_date.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/venta/presentation/widgets/prit_Sunmi.dart';

class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({super.key, required this.scaffoldKey});

  @override
  ConsumerState<SideMenu> createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> {
  int navDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final turnoActivo =
        ref.watch(turnoProvider).turnoActivo || authState.isAdmin;
    final size = Responsive.of(context);
    return Drawer(
      // backgroundColor: Color(Colors.red),
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                CircleAvatar(
                  radius: size.hScreen(3),
                  child: ClipOval(
                    child: Image.network(
                      authState.user?.foto ?? "",
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/no-image.jpg',
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.hScreen(.5),
                ),
                Text(authState.user!.nombre
                    // style: TextStyle(color: Colors.white, fontSize: 18)
                    ),
                Text(authState.user!.rucempresa
                    // style: TextStyle(color: Colors.white70)
                    ),
              ],
            ),
          ),
          Expanded(
              child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ...[
                ...appMenuItems,
                const MenuItem(
                  title: 'Horarios',
                  subTitle: "Horarios del mes",
                  link: "/horarios",
                  icon: 'assets/images/horario_mes.png',
                  color: Colors.blue,
                ),
              ].map(
                (e) {
                  if (!authState.isAdmin && e.title == 'Gestión') {
                    return const SizedBox.shrink(); // Ocultar el elemento
                  }
                  return Column(
                    children: [
                      ListTile(
                        leading: Image.asset(
                          e.icon,
                          height: size.iScreen(4),
                          color: turnoActivo
                              ? null
                              : Colors
                                  .grey, // Cambiar color del ícono si está deshabilitado
                        ),
                        title: Text(
                          e.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: turnoActivo
                                ? Colors.black
                                : Colors
                                    .grey, // Cambiar color del texto si está deshabilitado
                          ),
                        ),
                        subtitle: Text(
                          e.subTitle,
                          style: TextStyle(
                            color: turnoActivo
                                ? Colors.black54
                                : Colors
                                    .grey, // Cambiar color del subtítulo si está deshabilitado
                          ),
                        ),
                        onTap: turnoActivo
                            ? () {
                                context.push(e.link);
                              }
                            : null, // Deshabilitar interacción si turnoActivo es false
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: turnoActivo
                              ? Colors.black
                              : Colors
                                  .grey, // Cambiar color del ícono si está deshabilitado
                        ),
                      ),
                      const Divider()
                    ],
                  );
                },
              )
            ],
          )),
          Column(
            children: [
              const Divider(),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Compartir'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Cerrar sesión'),
                onTap: () async {
                  // Leer los proveedores al inicio
                  final auth = ref.read(authProvider);

                  if (auth.isAdmin) {
                    ref.read(authProvider.notifier).logout();
                  } else {
                    // final res = await ref
                    //     .read(cuentasPorCobrarRepositoryProvider)
                    //     .getCuentasPorCobrarPendientes();
                    // if (res.saldoAPagar > 0 && context.mounted) {
                    //   NotificationsService.show(
                    //       context,
                    //       'Hay cuentas por cobrar pendientes: \$${res.saldoAPagar}',
                    //       SnackbarCategory.error);
                    //   return Navigator.of(context).pop(); // Cerrar el drawer
                    // }
                    final cierreCajasRepository =
                        ref.read(cierreCajasRepositoryProvider);
                    final turnoActivo = ref.read(turnoProvider).turnoActivo;

                    if (turnoActivo && context.mounted) {
                      NotificationsService.show(
                          context, 'Debe cerrar turno', SnackbarCategory.error);
                      return Navigator.of(context).pop(); // Cerrar el drawer
                    }

                    final suma = await cierreCajasRepository.getSumaIEC(
                      fecha: GetDate.today,
                      search: auth.user!.usuario,
                    );
                    if (suma.error.isNotEmpty && context.mounted) {
                      NotificationsService.show(
                          context, suma.error, SnackbarCategory.error);
                      return Navigator.of(context).pop(); // Cerrar el drawer
                    }
                    final response = await ref
                        .read(cierreCajasRepositoryProvider)
                        .getEgresos(documento: auth.user!.usuario);
                    if (response.error.isNotEmpty && context.mounted) {
                      NotificationsService.show(
                          context, response.error, SnackbarCategory.error);
                      return;
                    }
                    printTicketBusqueda(
                        suma, auth.user, GetDate.today, response.resultado);
                    ref.read(authProvider.notifier).logout();
                  }
                },
              ),
              const SizedBox(
                  height:
                      10), // Espacio para evitar que toque el borde inferior
            ],
          ),
        ],
      ),
    );
  }
}
