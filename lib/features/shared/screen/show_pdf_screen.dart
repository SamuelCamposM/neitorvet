import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:neitorvet/features/shared/utils/responsive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ShowPdfScreen extends StatefulWidget {
  final String infoPdf;
  final String labelPdf;

  const ShowPdfScreen(
      {super.key, required this.infoPdf, required this.labelPdf});

  @override
  _ShowPdfScreenState createState() => _ShowPdfScreenState();
}

class _ShowPdfScreenState extends State<ShowPdfScreen> {
  bool _isDownloading = false;
  double _progress = 0.0;

  Future<void> downloadPDF(BuildContext context) async {
    Dio dio = Dio();
    try {
      setState(() {
        _isDownloading = true;
        _progress = 0.0;
      });

      // Solicitar permisos de almacenamiento
      var status = await Permission.storage.request();
      if (status.isGranted ||
          await Permission.manageExternalStorage.request().isGranted) {
        var dir = await getExternalStorageDirectory();
        String newPath = "";
        List<String> paths = dir!.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/Download";
        dir = Directory(newPath);

        String filePath = '${dir.path}/documento.pdf';
        await dio.download(
          widget.infoPdf,
          filePath,
          onReceiveProgress: (rec, total) {
            setState(() {
              _progress = (rec / total);
            });
            print('Recibido: $rec de $total');
          },
        );
        print('Descarga completada. Archivo guardado en: $filePath');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Descarga completada: $filePath')),
        );
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permiso de almacenamiento denegado')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al descargar el archivo')),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        appBar: AppBar(
          title: Text('Factura'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.download_outlined,
                size: size.iScreen(3.5),
              ),
              onPressed: () {
                downloadPDF(context);
              },
            ),
          ],
        ),
        body: _isDownloading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(value: _progress),
                    SizedBox(height: 20),
                    Text('${(_progress * 100).toStringAsFixed(0)}%'),
                  ],
                ),
              )
            : Container(
                width: size.wScreen(100),
                height: size.hScreen(100),
                padding: EdgeInsets.symmetric(
                    horizontal: size.iScreen(1.0), vertical: size.iScreen(1.0)),
                color: Colors.grey[300],
                child: const PDF().cachedFromUrl(widget.infoPdf),
              ),
      ),
    );
  }
}
