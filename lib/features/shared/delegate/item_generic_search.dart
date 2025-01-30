import 'package:flutter/material.dart';
import 'package:neitorvet/features/venta/domain/entities/inventario.dart';

class ItemGenericSearch<T extends Inventario> extends StatelessWidget {
  final T item;
  final String title;
  final void Function(BuildContext context, T item) onItemSelected;

  const ItemGenericSearch(
      {super.key,
      required this.item,
      required this.onItemSelected,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title), // Customize this as needed
      onTap: () => onItemSelected(context, item),
    );
  }
}
