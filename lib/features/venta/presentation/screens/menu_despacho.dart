import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:neitorvet/features/venta/domain/entities/surtidores.dart';

class MenuDespacho extends StatelessWidget {
  const MenuDespacho({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = Responsive.of(context);
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text('Despacho'),
        ),
        body: Container(
          width: size.wScreen(100.0),
          height: size.hScreen(100.0),
          padding: EdgeInsets.only(top: size.iScreen(1.0)),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: _surtidor
                .map((e) => Card(
                    color: Colors.white,
                    elevation: 5.0, // Agrega una elevación para la sombra
                    shadowColor: Colors.grey
                        .withOpacity(0.5), // Color de la sombra (opcional)
                    child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: size.iScreen(1.0),
                            vertical: size.iScreen(1.0)),
                        padding:
                            EdgeInsets.symmetric(horizontal: size.iScreen(0.5)),
                        child: Column(
                          children: [
                            Image(
                              image: AssetImage('assets/images/gas-pump.png'),
                              width: size.iScreen(7.0),
                            ),
                            SizedBox(
                              height: size.iScreen(1.0),
                            ),
                            Text(
                              e.nombre!,
                              style: TextStyle(
                                  fontSize: size.iScreen(2.0),
                                  fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              children: e.lado!
                                  .map((lado) => Container(
                                        // Agregando Padding para mejor apariencia
                                        margin: EdgeInsets.symmetric(
                                            horizontal: size.iScreen(
                                                0.5)), // Ajusta el padding según necesites
                                        padding: const EdgeInsets.all(
                                            2.0), // Ajusta el padding según necesites
                                        child: TextButton(
                                          onPressed: () {
                                            final Map<String, dynamic> data = {
                                              'name': e.nombre,
                                              'lado': lado,
                                            };

                                            _surtidorModal(context, size, data);
                                          },
                                          child: Text(
                                            lado,
                                            style: TextStyle(
                                                fontSize: size.iScreen(3.0),
                                                fontWeight: FontWeight.normal),
                                          ), // Ajusta el tamaño del texto
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),

                                            // Ajusta el padding
                                            padding: EdgeInsets.symmetric(
                                                horizontal: size.iScreen(2.0),
                                                vertical:
                                                    1.0), // Ajusta el padding
                                            minimumSize: Size
                                                .zero, // Elimina el tamaño mínimo predeterminado
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap, // Ajusta el tamaño del área de toque
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            )
                          ],
                        ))))
                .toList(),
          ),
        ));
  }

  void _surtidorModal(
      BuildContext context, Responsive size, Map<String, dynamic> data) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return CupertinoActionSheet(
          title: Text(
            '${data['name'].toString().toUpperCase()}   Lado ${data['lado'].toString().toUpperCase()} ',
            style: TextStyle(
                fontSize: size.iScreen(2.0),
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('Super'),
              onPressed: () {
                Navigator.pop(context, 'Super');
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Extra'),
              onPressed: () {
                Navigator.pop(context, 'Extra');
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Diesel'),
              onPressed: () {
                Navigator.pop(context, 'Diesel');
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancelar'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        data['tipo'] = value;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Seleccionaste: ${data}')),
        );
      }
    });
  }
}

List<Map<String, dynamic>> _datosSurtidor = [
  {
    'id': 1,
    'nombre': 'Surtidor 1',
    'imagen': 'assets/images/producto_a.png',
    'lado': ['A', 'B'],
  },
  {
    'id': 2,
    'nombre': 'Surtidor 2',
    'imagen': 'assets/images/producto_b.png',
    'lado': ['A', 'B'],
  },
  {
    'id': 3,
    'nombre': 'Surtidor 3',
    'imagen': 'assets/images/producto_c.png',
    'lado': ['A', 'B'],
  },
  {
    'id': 4,
    'nombre': 'Surtidor 4',
    'imagen': 'assets/images/producto_d.png',
    'lado': ['A', 'B'],
  },
  {
    'id': 5,
    'nombre': 'Surtidor 5',
    'imagen': 'assets/images/producto_e.png',
    'lado': ['A', 'B'],
  },
  {
    'id': 6,
    'nombre': 'Surtidor 6',
    'imagen': 'assets/images/gas-punp.png',
    'lado': ['A', 'B'],
  },
];
List<Surtidores> _surtidor =
    _datosSurtidor.map((map) => Surtidores.fromJson(map)).toList();
