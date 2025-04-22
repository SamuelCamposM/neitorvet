import 'package:flutter/material.dart';
import 'package:neitorvet/features/administracion/presentation/screens/dispensadores_screen.dart';
import 'package:neitorvet/features/administracion/presentation/screens/lista_tanques_screen.dart';

class AdminScreens extends StatefulWidget {
  const AdminScreens({Key? key}) : super(key: key);

  @override
  State<AdminScreens> createState() => _AdminScreensState();
}

class _AdminScreensState extends State<AdminScreens> {
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageViewChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const ListaTanqueScreen(),
    const DispensadoresScreen(),
  ];

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageViewChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages, // Para evitar el desplazamiento manual
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onPageChanged,
        backgroundColor: Colors.white,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF38B6FF),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Tanques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_gas_station_outlined),
            label: 'Dispensadores',
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:neitorvet/features/administracion/domain/entities/tanque.dart';
// import 'package:neitorvet/features/administracion/presentation/screens/dispensadores_screen.dart';
// import 'package:neitorvet/features/administracion/presentation/screens/lista_tanques_screen.dart';

// class AdminScreens extends StatefulWidget {
//   const AdminScreens({Key? key}) : super(key: key);

//   @override
//   State<AdminScreens> createState() => _AdminScreensState();
// }

// class _AdminScreensState extends State<AdminScreens> {
//   int _selectedIndex = 0;
//   final PageController _pageController = PageController(initialPage: 0);

//   // Lista dinámica de tabs
//   final List<Map<String, dynamic>> _tabs = [
//     {'id': 'Tab 1', 'label': 'Tanques'},
//     {'id': 'Tab 2', 'label': 'Dispensadores'},
//   ];

//   void _onPageChanged(int index) {
//     setState(() {
//       _selectedIndex = index;
//       _pageController.animateToPage(
//         index,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     });
//   }

//   void _onPageViewChanged(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   void _addTab() {
//     setState(() {
//       final newIndex = _tabs.length + 1;
//       _tabs.add({'id': 'Tab $newIndex', 'label': 'Tab $newIndex'});
//     });
//   }

//   void _removeTab() {
//     if (_tabs.length > 1) {
//       setState(() {
//         _tabs.removeLast();
//         if (_selectedIndex >= _tabs.length) {
//           _selectedIndex = _tabs.length - 1;
//           _pageController.jumpToPage(_selectedIndex);
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin Screens'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: _addTab,
//           ),
//           IconButton(
//             icon: const Icon(Icons.remove),
//             onPressed: _removeTab,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: PageView.builder(
//               controller: _pageController,
//               onPageChanged: _onPageViewChanged,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: _tabs.length,
//               itemBuilder: (context, index) {
//                 final tab = _tabs[index];
//                 return Center(
//                   child: Text(
//                     'Tab ID: ${tab['id']}',
//                     style: const TextStyle(fontSize: 24),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onPageChanged,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: const Color(0xFF38B6FF),
//         items: _tabs
//             .map(
//               (tab) => BottomNavigationBarItem(
//                 icon: const Icon(Icons.circle),
//                 label: tab['label'],
//               ),
//             )
//             .toList(),
//       ),
//     );
//   }
// }
