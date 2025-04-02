//================================================IMPRESORA =================================================//

import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show NetworkAssetBundle, Uint8List;
import 'package:neitorvet/features/cierre_caja/domain/datasources/cierre_cajas_datasource.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';

import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import '../../../auth/domain/domain.dart';

// String? _fechaLocal;

// String convertirFechaLocal(String fechaIso) {
//   DateTime fecha = DateTime.parse(fechaIso);
//   return DateFormat('dd/MM/yyyy HH:mm:ss').format(fecha);
// }

Future<void> printTicket(
  Venta info,
  User? user,
) async {
  await SunmiPrinter.initPrinter();
  await SunmiPrinter.startTransactionPrint(true);

  if (user!.logo.isNotEmpty) {
    try {
      Uint8List byte =
          (await NetworkAssetBundle(Uri.parse(user.logo)).load(user.logo))
              .buffer
              .asUint8List();

      img.Image? originalImage = img.decodeImage(byte);

      if (originalImage != null) {
        img.Image resizedImage =
            img.copyResize(originalImage, width: 150, height: 150);
        Uint8List resizedByte = Uint8List.fromList(img.encodePng(resizedImage));

        await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
        await SunmiPrinter.printImage(resizedByte);
        await SunmiPrinter.lineWrap(2);
      }
    } catch (e) {
      await SunmiPrinter.printText('NO LOGO');
      await SunmiPrinter.lineWrap(1);
    }
  } else {
    await SunmiPrinter.printText('NO LOGO');
    await SunmiPrinter.lineWrap(1);
  }

  await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
  await SunmiPrinter.printText('Ruc: ${info.venEmpRuc}');
  await SunmiPrinter.printText('Dir: ${info.venEmpDireccion}');
  await SunmiPrinter.printText('Tel: ${info.venEmpTelefono}');
  await SunmiPrinter.printText('Email: ${info.venEmpEmail}');

  await SunmiPrinter.line();
  await SunmiPrinter.printText('Cliente: ${info.venNomCliente}');
  await SunmiPrinter.printText('Ruc: ${info.venRucCliente}');
  await SunmiPrinter.printText('Factura: ${info.venNumFactura}');
  await SunmiPrinter.printText('Fecha: ${info.venFechaFactura}');
  await SunmiPrinter.printText('Placa: ${info.venOtrosDetalles}');
  await SunmiPrinter.printText(info.venEmailCliente.isNotEmpty
      ? 'Email: ${info.venEmailCliente[0]}'
      : 'Email:');

  await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
  await SunmiPrinter.line();
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(text: 'Descripción', width: 12, align: SunmiPrintAlign.LEFT),
    ColumnMaker(text: 'Cant', width: 6, align: SunmiPrintAlign.CENTER),
    ColumnMaker(text: 'vU', width: 6, align: SunmiPrintAlign.RIGHT),
    ColumnMaker(text: 'TOT', width: 6, align: SunmiPrintAlign.RIGHT),
  ]);

  final productos = info.venProductos as List<dynamic>?;

  if (productos != null) {
    for (var item in productos) {
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
            text: item.descripcion.toString(),
            width: 12,
            align: SunmiPrintAlign.LEFT),
        ColumnMaker(
            text: item.cantidad.toString(),
            width: 6,
            align: SunmiPrintAlign.CENTER),
        ColumnMaker(
            text: item.valorUnitario.toString(),
            width: 6,
            align: SunmiPrintAlign.RIGHT),
        ColumnMaker(
            text: item.precioSubTotalProducto.toString(),
            width: 6,
            align: SunmiPrintAlign.RIGHT),
      ]);
    }
  } else {
    await SunmiPrinter.printText('No hay productos para mostrar.');
  }

  await SunmiPrinter.line();
  await SunmiPrinter.printRow(cols: [
    ColumnMaker(text: 'SubTotal', width: 20, align: SunmiPrintAlign.LEFT),
    ColumnMaker(
        text: info.venSubTotal.toString(),
        width: 10,
        align: SunmiPrintAlign.RIGHT),
  ]);

  await SunmiPrinter.printRow(cols: [
    ColumnMaker(text: 'Iva', width: 20, align: SunmiPrintAlign.LEFT),
    ColumnMaker(
        text: info.venTotalIva.toString(),
        width: 10,
        align: SunmiPrintAlign.RIGHT),
  ]);

  await SunmiPrinter.printRow(cols: [
    ColumnMaker(text: 'TOTAL', width: 20, align: SunmiPrintAlign.LEFT),
    ColumnMaker(
        text: info.venTotal.toString(),
        width: 10,
        align: SunmiPrintAlign.RIGHT),
  ]);

  await SunmiPrinter.line();

  await SunmiPrinter.printText('\$0.81 : Monto equivalente al subsidio',
      style: SunmiStyle(fontSize: SunmiFontSize.SM));
  await SunmiPrinter.printText('\$0.81 : valor total sin subsidio',
      style: SunmiStyle(fontSize: SunmiFontSize.SM));
  await SunmiPrinter.lineWrap(4);
  await SunmiPrinter.exitTransactionPrint(true);
}

//=================================================================================================//
//======================================IMPRIME INFORMACION DE LA BUSQUEDA===========================================================//

Future<void> printTicketBusqueda(
  ResponseSumaIEC info,
  User? user,
  String fecha,
) async {
  if (user == null) return;

// Función principal de impresión
  final totalEfctivo = info.egreso.toDouble() + info.ingreso.toDouble();

  // Imprime el logo (si existe)
  if (user.logo.isNotEmpty) {
    String url = user.logo;

    // Convertir la imagen a formato Uint8List
    Uint8List byte = (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();

    // Decodificar la imagen
    img.Image? originalImage = img.decodeImage(byte);

    if (originalImage != null) {
      // Redimensionar la imagen (ajusta width y height según tus necesidades)
      img.Image resizedImage =
          img.copyResize(originalImage, width: 150, height: 150);

      // Convertir la imagen redimensionada de vuelta a Uint8List
      Uint8List resizedByte = Uint8List.fromList(img.encodePng(resizedImage));

      // Alinear la imagen y comenzar la transacción de impresión
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printImage(resizedByte);

      // Agregar un salto de línea para asegurar que el texto se imprima debajo
      await SunmiPrinter.lineWrap(
          2); // Esto asegura que haya espacio debajo del logo
    }
  } else {
    // Si no hay logo, imprimir el texto "NO LOGO"
    await SunmiPrinter.printText('NO LOGO');
    await SunmiPrinter.lineWrap(1); // Saltar una línea para separación
  }

// Imprime el resto de la información
  await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
  await SunmiPrinter.printText('Usuario: ${validarCampo(user.usuario)}');

  await SunmiPrinter.line();
  await SunmiPrinter.printText(
      'Fecha: $fecha'); // O utiliza formattedDate si corresponde
  await SunmiPrinter.line();
  await SunmiPrinter.printText('Ingreso: ${validarCampo(info.egreso)}');
  await SunmiPrinter.printText('Egreso: ${validarCampo(info.egreso)}');
  await SunmiPrinter.printText('Total Efectivo: ${totalEfctivo.toString()}');
  await SunmiPrinter.lineWrap(2);
  await SunmiPrinter.printText(
      'Transferencia: ${validarCampo(info.transferencia.toString())}');
  await SunmiPrinter.printText(
      'Crédito: ${validarCampo(info.credito.toString())}');
  await SunmiPrinter.printText(
      'Depósito: ${validarCampo(info.deposito.toString())}');

  await SunmiPrinter.line();

  await SunmiPrinter.lineWrap(2);
  await SunmiPrinter.exitTransactionPrint(true);
}
//======================================IMPRIME INFORMACION DESDE LA LISTA===========================================================//

Future<void> printTicketDesdeLista(
  CierreCaja info,
  User user,
) async {
  if (user == null) return;

// // Función principal de impresión
//   final totalEfctivo = info.egreso.toDouble() + info.ingreso.toDouble();

//   // Imprime el logo (si existe)
//   if (user.logo.isNotEmpty) {
//     String url = user.logo;

//     // Convertir la imagen a formato Uint8List
//     Uint8List byte = (await NetworkAssetBundle(Uri.parse(url)).load(url))
//         .buffer
//         .asUint8List();

//     // Decodificar la imagen
//     img.Image? originalImage = img.decodeImage(byte);

//     if (originalImage != null) {
//       // Redimensionar la imagen (ajusta width y height según tus necesidades)
//       img.Image resizedImage =
//           img.copyResize(originalImage, width: 150, height: 150);

//       // Convertir la imagen redimensionada de vuelta a Uint8List
//       Uint8List resizedByte = Uint8List.fromList(img.encodePng(resizedImage));

//       // Alinear la imagen y comenzar la transacción de impresión
//       await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
//       await SunmiPrinter.printImage(resizedByte);

//       // Agregar un salto de línea para asegurar que el texto se imprima debajo
//       await SunmiPrinter.lineWrap(
//           2); // Esto asegura que haya espacio debajo del logo
//     }
//   } else {
//     // Si no hay logo, imprimir el texto "NO LOGO"
//     await SunmiPrinter.printText('NO LOGO');
//     await SunmiPrinter.lineWrap(1); // Saltar una línea para separación
//   }

// // Imprime el resto de la información
//   await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
//   await SunmiPrinter.printText('Usuario: ${validarCampo(user.usuario)}');

//   await SunmiPrinter.line();
//   await SunmiPrinter.printText(
//       'Fecha: $fecha'); // O utiliza formattedDate si corresponde
//   await SunmiPrinter.line();
//   await SunmiPrinter.printText('Ingreso: ${validarCampo(info.egreso)}');
//   await SunmiPrinter.printText('Egreso: ${validarCampo(info.egreso)}');
//   await SunmiPrinter.printText('Total Efectivo: ${totalEfctivo.toString()}');
//   await SunmiPrinter.lineWrap(2);
//   await SunmiPrinter.printText(
//       'Transferencia: ${validarCampo(info.transferencia.toString())}');
//   await SunmiPrinter.printText(
//       'Crédito: ${validarCampo(info.credito.toString())}');
//   await SunmiPrinter.printText(
//       'Depósito: ${validarCampo(info.deposito.toString())}');

//   await SunmiPrinter.line();

//   await SunmiPrinter.lineWrap(2);
//   await SunmiPrinter.exitTransactionPrint(true);
}

// Función para validar si una propiedad es null
String validarCampo(dynamic valor) {
  return valor == null || valor.toString().isEmpty
      ? '--- --- ---'
      : valor.toString();
}
