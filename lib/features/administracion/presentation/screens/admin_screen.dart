import 'package:flutter/material.dart';
import 'package:neitorvet/features/administracion/domain/entities/tanque.dart';
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
      print('Índice seleccionado (BottomNavigationBar): $index');
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  List tanquesJson = [
    {
      "idTanque": 2,
      "numeroTanque": "02",
      "volumenTotal": 5200,
      "codigoCombustible": "92",
      "fechaHora": "2025-04-04T20:30:15.000Z",
      "estado": "0000",
      "volumen": 3450.65,
      "volumenTemperatura": 3450.65,
      "vacio": 1749.35,
      "altura": 1250.38,
      "agua": 12.5,
      "temperatura": 26.18,
      "volumenAgua": 15.3,
      "columnaExtra": "08"
    },
    {
      "idTanque": 3,
      "numeroTanque": "03",
      "volumenTotal": 3800,
      "codigoCombustible": "95",
      "fechaHora": "2025-04-04T20:28:45.000Z",
      "estado": "0000",
      "volumen": 2100.22,
      "volumenTemperatura": 2100.22,
      "vacio": 1699.78,
      "altura": 950.75,
      "agua": 0,
      "temperatura": 25.89,
      "volumenAgua": 0,
      "columnaExtra": "10"
    },
    {
      "idTanque": 4,
      "numeroTanque": "04",
      "volumenTotal": 6000,
      "codigoCombustible": "98",
      "fechaHora": "2025-04-04T20:31:30.000Z",
      "estado": "0001",
      "volumen": 5800.91,
      "volumenTemperatura": 5800.91,
      "vacio": 199.09,
      "altura": 1845.62,
      "agua": 0,
      "temperatura": 28.05,
      "volumenAgua": 0,
      "columnaExtra": "14"
    },
    {
      "idTanque": 5,
      "numeroTanque": "05",
      "volumenTotal": 4500,
      "codigoCombustible": "94",
      "fechaHora": "2025-04-04T20:27:20.000Z",
      "estado": "0002",
      "volumen": 250.33,
      "volumenTemperatura": 250.33,
      "vacio": 4249.67,
      "altura": 180.15,
      "agua": 5.2,
      "temperatura": 26.75,
      "volumenAgua": 8.7,
      "columnaExtra": "09"
    },
    {
      "idTanque": 6,
      "numeroTanque": "06",
      "volumenTotal": 3500,
      "codigoCombustible": "90",
      "fechaHora": "2025-04-04T20:32:50.000Z",
      "estado": "0000",
      "volumen": 1750.48,
      "volumenTemperatura": 1750.48,
      "vacio": 1749.52,
      "altura": 820.36,
      "agua": 0,
      "temperatura": 27.93,
      "volumenAgua": 0,
      "columnaExtra": "11"
    }
  ];
  List<Tanque> listaDeTanques = [];
  void _onPageViewChanged(int index) {
    setState(() {
      print('Índice cambiado (PageView): $index');

      if (index == 0) {
        listaDeTanques = [];
        listaDeTanques =
            tanquesJson.map((json) => Tanque.fromJson(json)).toList();
      }

      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;
  final List<Widget> _pages = [
    ListaTanqueScreen(),
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
        children: _pages,
        onPageChanged: _onPageViewChanged,
        physics:
            const NeverScrollableScrollPhysics(), // Para evitar el desplazamiento manual
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
