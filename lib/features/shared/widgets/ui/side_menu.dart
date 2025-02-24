import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:neitorvet/config/menu/menu_item.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';

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
    final size = Responsive.of(context);
    return Drawer(
      // backgroundColor: Color(Colors.red),
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                CircleAvatar(
                  radius: size.hScreen(4.5),
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
              ...appMenuItems.map(
                (e) => Column(
                  children: [
                    ListTile(
                      leading: Icon(e.icon),
                      title: Text(
                        e.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(e.subTitle),
                      onTap: () {
                        context.push(e.link);
                      },
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    const Divider()
                  ],
                ),
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
                onTap: () {
                  ref.read(authProvider.notifier).logout();
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
