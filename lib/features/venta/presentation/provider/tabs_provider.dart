import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/features/cierre_surtidores/domain/datasources/cierre_surtidores_datasource.dart';
import 'package:neitorvet/features/cierre_surtidores/presentation/provider/cierre_surtidores_repository_provider.dart';

final tabsProvider =
    StateNotifierProvider.autoDispose<TabsNotifier, TabsState>((ref) {
  final setModoManguera =
      ref.read(cierreSurtidoresRepositoryProvider).setModoManguera;
  return TabsNotifier(setModoManguera: setModoManguera);
});

class TabsNotifier extends StateNotifier<TabsState> {
  Future<ResponseModoManguera> Function(
      {required String manguera, required String modo}) setModoManguera;
  TabsNotifier({
    required this.setModoManguera,
  }) : super(TabsState(
          selectedIndex: 0,
          tabs: [const TabItem(id: 0, label: 'Factura 1')],
        ));

  void onPageChanged(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  void addTab(PageController pageController) {
    // Generar un nuevo ID único basado en el ID más alto actual
    final newId = state.tabs.isNotEmpty
        ? state.tabs.map((tab) => tab.id).reduce((a, b) => a > b ? a : b) + 1
        : 0;

    final newTab = TabItem(id: newId, label: 'Factura ${newId + 1}');

    // Actualizar el estado con el nuevo tab y seleccionar el nuevo tab
    state = state.copyWith(
      tabs: [...state.tabs, newTab],
      selectedIndex: state.tabs.length, // Seleccionar el nuevo tab
    );

    // Animar al nuevo tab
    pageController.animateToPage(
      state.tabs.length - 1, // Ir al índice del nuevo tab
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void removeTab() async {
    if (state.tabs.length > 1) {
      // Obtener el tab seleccionado
      final tabToRemove = state.tabs[state.selectedIndex];

      // Verificar si el tab tiene una manguera asignada
      if (tabToRemove.manguera.isNotEmpty) {
        try {
          // Bloquear la manguera antes de eliminar el tab
          await setModoManguera(
            manguera: tabToRemove.manguera,
            modo: '03', // Modo para bloquear la manguera
          );
        } catch (e) {
          e;
        }
      }

      // Crear una nueva lista sin el tab seleccionado
      final updatedTabs = [...state.tabs]..removeAt(state.selectedIndex);

      // Ajustar el índice seleccionado
      final newIndex = state.selectedIndex >= updatedTabs.length
          ? updatedTabs.length - 1
          : state.selectedIndex;

      // Actualizar el estado con los tabs modificados y el nuevo índice seleccionado
      state = state.copyWith(tabs: updatedTabs, selectedIndex: newIndex);
    }
  }

  void removeTabById(int id) {
    if (state.tabs.length > 1) {
      // Crear una nueva lista sin el tab con el id especificado
      final updatedTabs = state.tabs.where((tab) => tab.id != id).toList();

      // Ajustar el índice seleccionado si el tab eliminado era el seleccionado
      final newIndex = state.selectedIndex >= updatedTabs.length
          ? updatedTabs.length - 1
          : state.selectedIndex;

      // Actualizar el estado con los tabs modificados y el nuevo índice seleccionado
      state = state.copyWith(tabs: updatedTabs, selectedIndex: newIndex);
    }
  }

  void updateTabManguera(
    int id, {
    String? manguera,
    String? nombreCombustible,
    double? monto,
  }) {
    final tabExists = state.tabs.any((tab) => tab.id == id);

    if (!tabExists) {
      print('Error: No se encontró un TabItem con id $id');
      return;
    }

    final updatedTabs = state.tabs.map((tab) {
      if (tab.id == id) {
        return tab.copyWith(
          manguera: manguera,
          nombreCombustible: nombreCombustible,
          monto: monto,
        );
      }
      return tab;
    }).toList();

    state = state.copyWith(tabs: updatedTabs);
  }
}

class TabsState {
  final List<TabItem> tabs;
  final int selectedIndex;

  TabsState({
    required this.tabs,
    required this.selectedIndex,
  });

  TabsState copyWith({
    List<TabItem>? tabs,
    int? selectedIndex,
  }) {
    return TabsState(
      tabs: tabs ?? this.tabs,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class TabItem {
  final int id;
  final String label;
  final String manguera;
  final String nombreCombustible;
  final double monto;

  const TabItem({
    required this.id,
    required this.label,
    this.manguera = '',
    this.nombreCombustible = '',
    this.monto = 0.0,
  });

  TabItem copyWith({
    int? id,
    String? label,
    String? manguera,
    String? nombreCombustible,
    double? monto,
  }) {
    return TabItem(
      id: id ?? this.id,
      label: label ?? this.label,
      manguera: manguera ?? this.manguera,
      nombreCombustible: nombreCombustible ?? this.nombreCombustible,
      monto: monto ?? this.monto,
    );
  }
}
