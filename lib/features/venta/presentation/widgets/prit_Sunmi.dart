//================================================IMPRESORA =================================================//

import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show NetworkAssetBundle, Uint8List;
import 'package:neitorvet/features/cierre_caja/domain/datasources/cierre_cajas_datasource.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/egreso_usuario.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';

import 'package:neitorvet/features/venta/domain/entities/venta.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import '../../../auth/domain/domain.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

// String? _fechaLocal;

// String convertirFechaLocal(String fechaIso) {
//   DateTime fecha = DateTime.parse(fechaIso);
//   return DateFormat('dd/MM/yyyy HH:mm:ss').format(fecha);
// }

Future<void> printTicket(
  Venta info,
  User? user,
  String nombreUsuario,
) async {
  final profile = await CapabilityProfile.load();
  final printer = NetworkPrinter(PaperSize.mm80, profile);

  // Cambia la IP y puerto por los de tu impresora
  final result = await printer.connect(
    '192.168.1.91',
    port: 9100,
  );
  if (result == PosPrintResult.success) {
    // LOGO
    if (user != null && user.logo.isNotEmpty) {
      try {
        Uint8List byte =
            (await NetworkAssetBundle(Uri.parse(user.logo)).load(user.logo))
                .buffer
                .asUint8List();
        img.Image? originalImage = img.decodeImage(byte);
        if (originalImage != null) {
          img.Image resizedImage =
              img.copyResize(originalImage, width: 150, height: 150);
          printer.image(resizedImage);
          printer.feed(2);
        }
      } catch (e) {
        printer.text('NO LOGO');
        printer.feed(1);
      }
    } else {
      printer.text('NO LOGO');
      printer.feed(1);
    }

    printer.text('FACTURA',
        styles: PosStyles(
            align: PosAlign.center, bold: true, height: PosTextSize.size2));
    printer.text('Ruc: ${info.venEmpRuc}');
    printer.text('Dir: ${info.venEmpDireccion}');
    printer.text('Tel: ${info.venEmpTelefono}');
    printer.text('Email: ${info.venEmpEmail}');
    printer.hr();
    printer.text('Cliente: ${info.venNomCliente}');
    printer.text('Ruc: ${info.venRucCliente}');
    printer.text('Factura: ${info.venNumFactura}');
    printer.text('Fecha: ${Format.formatFechaHora(info.venFecReg)}');
    printer.text('Placa: ${info.venOtrosDetalles}');
    printer.text(info.venEmailCliente.isNotEmpty
        ? 'Email: ${info.venEmailCliente[0]}'
        : 'Email:');
    printer.text('F. de Pago: ${info.venFormaPago}');
    printer.hr();

    // Encabezado productos
    printer.row([
      PosColumn(
          text: 'Descripción',
          width: 6,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Cant',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'vU',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
      PosColumn(
          text: 'TOT',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);

    final productos = info.venProductos as List<dynamic>?;

    if (productos != null) {
      for (var item in productos) {
        printer.row([
          PosColumn(text: item.descripcion.toString(), width: 6),
          PosColumn(text: item.cantidad.toString(), width: 2),
          PosColumn(text: item.valorUnitario.toString(), width: 2),
          PosColumn(text: item.precioSubTotalProducto.toString(), width: 2),
        ]);
      }
    } else {
      printer.text('No hay productos para mostrar.');
    }

    printer.hr();
    printer.row([
      PosColumn(text: 'SubTotal', width: 8),
      PosColumn(
          text: info.venSubTotal.toString(),
          width: 4,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.row([
      PosColumn(text: 'Iva', width: 8),
      PosColumn(
          text: info.venTotalIva.toString(),
          width: 4,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.row([
      PosColumn(text: 'TOTAL', width: 8),
      PosColumn(
          text: info.venTotal.toString(),
          width: 4,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    printer.hr();
    printer.text('Autorización: ${validarCampo(info.venAutorizacion)}');
    printer.text('\$0.81 : Monto equivalente al subsidio');
    printer.text('\$0.81 : valor total sin subsidio');
    printer.text('Manguera: ${info.manguera}');
    printer.text(nombreUsuario.split(' ')[0]);
    printer.feed(4);
    printer.cut();
    printer.disconnect();
  } else {
    // Maneja el error de conexión aquí
    print('No se pudo conectar a la impresora');
  }
}

//=================================================================================================//
//======================================IMPRIME INFORMACION DE LA BUSQUEDA===========================================================//

Future<void> printEgresos(
  User? user,
  String fecha,
  List<EgresoUsuario>? egresos,
) async {
  if (user == null) return;

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
  await SunmiPrinter.line();
// Imprime el resto de la información
  await SunmiPrinter.setAlignment(SunmiPrintAlign.LEFT);
  await SunmiPrinter.printText('Usuario: ${validarCampo(user.usuario)}');

  await SunmiPrinter.printText(
      'Fecha: ${Format.formatFechaHora(fecha)}'); // O utiliza formattedDate si corresponde
  await SunmiPrinter.line();
  egresos?.forEach((egreso) async {
    await SunmiPrinter.printText(
        '#: ${egreso.numero}  Egreso: ${egreso.egreso} Fecha: ${Format.formatFechaHora(egreso.cajaFecReg)}');
    // #: 123 Egreso: 123. Fecha: 123
  });
  if (egresos != null && egresos.isNotEmpty) {
    final totalEgresos = egresos.fold<num>(
        0, (sum, e) => sum + (num.tryParse(e.egreso.toString()) ?? 0));
    await SunmiPrinter.printText('Total ${totalEgresos.toString()}');
  }
  await SunmiPrinter.lineWrap(2);
  await SunmiPrinter.exitTransactionPrint(true);
}

Future<void> printTicketBusqueda(
  ResponseSumaIEC info,
  User? user,
  String fecha,
  List<EgresoUsuario>? egresos,
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
      'Fecha: ${Format.formatFechaHora(fecha)}'); // O utiliza formattedDate si corresponde
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
  await SunmiPrinter.printText(
      'Tar. Crédito: ${validarCampo(info.tarjetaCredito.toString())}');
  await SunmiPrinter.printText(
      'Tar. Débito: ${validarCampo(info.tarjetaDebito.toString())}');
  await SunmiPrinter.printText(
      'Tar. Prepago: ${validarCampo(info.tarjetaPrepago.toString())}');

// Suma total de todos los valores
  final suma = (info.transferencia) +
      (info.credito) +
      (info.deposito) +
      (info.tarjetaCredito) +
      (info.tarjetaDebito) +
      (info.tarjetaPrepago);

  await SunmiPrinter.printText('Total CxC: $suma');
  await SunmiPrinter.printText('Usuario: ${user.usuario}');

  await SunmiPrinter.line();

  egresos?.forEach((egreso) async {
    await SunmiPrinter.printText(
        '#: ${egreso.numero}  Egreso: ${egreso.egreso} Fecha: ${Format.formatFechaHora(egreso.cajaFecReg)}');
    // #: 123 Egreso: 123. Fecha: 123
  });
  if (egresos != null && egresos.isNotEmpty) {
    final totalEgresos = egresos.fold<num>(
        0, (sum, e) => sum + (num.tryParse(e.egreso.toString()) ?? 0));
    await SunmiPrinter.printText('Total ${totalEgresos.toString()}');
  }
  await SunmiPrinter.lineWrap(2);
  await SunmiPrinter.exitTransactionPrint(true);
}
//======================================IMPRIME INFORMACION DESDE LA LISTA===========================================================//

Future<void> printTicketDesdeLista(
  CierreCaja info,
  User user,
  String nombreUsuario,
) async {
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
  await SunmiPrinter.printText('Id: ${validarCampo(info.cajaId)}');
  await SunmiPrinter.printText('Número: ${validarCampo(info.cajaNumero)}');
  await SunmiPrinter.printText('Tipo: ${validarCampo(info.cajaTipoCaja)}');
  await SunmiPrinter.printText(
      'Documento: ${validarCampo(info.cajaTipoDocumento)}');
  await SunmiPrinter.line();
  await SunmiPrinter.printText(
      'Fecha: ${Format.formatFechaHora(info.cajaFecReg)}'); // O utiliza formattedDate si corresponde
  await SunmiPrinter.line();
  await SunmiPrinter.printText('Ingreso: ${validarCampo(info.cajaIngreso)}');
  await SunmiPrinter.printText('Egreso: ${validarCampo(info.cajaEgreso)}');
  await SunmiPrinter.printText('Crédito: ${validarCampo(info.cajaCredito)}');
  await SunmiPrinter.printText('Monto: ${validarCampo(info.cajaMonto)}');
  await SunmiPrinter.line();
  await SunmiPrinter.printText(
      'Autorización: ${validarCampo(info.cajaAutorizacion)}');
  await SunmiPrinter.printText('Detalle: ${validarCampo(info.cajaDetalle)}');
  await SunmiPrinter.printText('Usuario: ${user.usuario}');
  await SunmiPrinter.printText(nombreUsuario);
  await SunmiPrinter.line();
  await SunmiPrinter.lineWrap(2);
  await SunmiPrinter.exitTransactionPrint(true);
}

// Función para validar si una propiedad es null
String validarCampo(dynamic valor) {
  return valor == null || valor.toString().isEmpty
      ? '--- --- ---'
      : valor.toString();
}
