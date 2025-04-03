import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final String icon;
  final Color color;

  const MenuItem(
      {required this.title,
      required this.subTitle,
      required this.link,
      required this.color,
      required this.icon});
}

const appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Clientes',
    subTitle: "Nuestros Clientes",
    link: "/clientes",
    icon: 'assets/images/personas.png',
    color: Colors.blue,
  ),
  MenuItem(
    title: 'Facturas',
    subTitle: "Nuestras factura",
    link: "/ventas",
    icon: 'assets/images/factura.png',
    color: Colors.green,
  ),
  MenuItem(
    title: 'Cierre Turno',
    subTitle: "",
    link: "/cierre_turno",
    icon: 'assets/images/factura.png',
    color: Colors.green,
  ),
];


const cierreTurnoItems = <MenuItem>[
  // MenuItem(
  //   title: 'Cierre Surtidor',
  //   subTitle: "",
  //   link: "/cierre_surtidores",
  //   icon: 'assets/images/factura.png',
  //   color: Colors.green,
  // ),
  MenuItem(
    title: 'Caja',
    subTitle: "",
    link: "/cierre_cajas",
    icon: 'assets/images/factura.png',
    color: Colors.green,
  ),
];
