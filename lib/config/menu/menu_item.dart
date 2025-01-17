import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem(
      {required this.title,
      required this.subTitle,
      required this.link,
      required this.icon});
}

const appMenuItems = <MenuItem>[
  MenuItem(
      title: 'Clientes',
      subTitle: "Nuestros Clientes",
      link: "/clientes",
      icon: Icons.person),
  MenuItem(
      title: 'Factura',
      subTitle: "Nuestros factura",
      link: "/factura",
      icon: Icons.receipt),
  // MenuItem(
  //     title: 'Botones',
  //     subTitle: "Varios botones en Flutter",
  //     link: "/buttons",
  //     icon: Icons.smart_button_outlined),
  // MenuItem(
  //     title: 'Tarjetas',
  //     subTitle: "Un contenedor estilizado",
  //     link: "/cards",
  //     icon: Icons.credit_card),
  // MenuItem(
  //     title: 'Progress Indicators',
  //     subTitle: "Generales y controlados",
  //     link: "/progress",
  //     icon: Icons.refresh),
  // MenuItem(
  //     title: 'Snackbars y dialogs',
  //     subTitle: "Indicadores en pantalla",
  //     link: "/snackbars",
  //     icon: Icons.info_outline),
  // MenuItem(
  //     title: 'Animated container',
  //     subTitle: "Staful widget animado",
  //     link: "/animated",
  //     icon: Icons.check_box),
  // MenuItem(
  //     title: 'UI Controls + Tiles',
  //     subTitle: "Una serie de controles de flutter",
  //     link: "/ui-controls",
  //     icon: Icons.car_rental),
  // MenuItem(
  //     title: 'Introducción a la aplicación',
  //     subTitle: "Pequeño tutorial introductorio",
  //     link: "/tutorial",
  //     icon: Icons.accessibility),
  // MenuItem(
  //     title: 'Theme Changer',
  //     subTitle: "Cambia el tema",
  //     link: "/theme_changer",
  //     icon: Icons.list_alt),
];
