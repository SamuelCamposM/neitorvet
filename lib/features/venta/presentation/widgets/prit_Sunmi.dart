//================================================IMPRESORA =================================================//

import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show NetworkAssetBundle, Uint8List;

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