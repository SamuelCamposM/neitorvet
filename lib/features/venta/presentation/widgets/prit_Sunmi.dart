//================================================IMPRESORA =================================================//

import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show NetworkAssetBundle, Uint8List;
import 'package:neitorvet/features/cierre_caja/domain/datasources/cierre_cajas_datasource.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/cierre_caja.dart';
import 'package:neitorvet/features/cierre_caja/domain/entities/egreso_usuario.dart';
import 'package:neitorvet/features/shared/helpers/format.dart';
import 'package:neitorvet/features/shared/helpers/parse.dart';

import 'package:neitorvet/features/venta/domain/entities/venta.dart';
// import 'package:sunmi_printer_plus/enums.dart';
// import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

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
  final numero = Parse.parseDynamicToInt(info.manguera);
  // Cambia la IP y puerto por los de tu impresora
  final result = await printer.connect(
    numero <= 12 ? '192.168.1.91' : '192.168.1.90',
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

  final profile = await CapabilityProfile.load();
  final printer = NetworkPrinter(PaperSize.mm80, profile);

  // Cambia la IP y puerto por los de tu impresora
  final result = await printer.connect('192.168.1.91', port: 9100);

  if (result == PosPrintResult.success) {
    // Imprime el logo (si existe)
    if (user.logo.isNotEmpty) {
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

    printer.hr();
    printer.text('Usuario: ${validarCampo(user.usuario)}');
    printer.text('Fecha: ${Format.formatFechaHora(fecha)}');
    printer.hr();

    if (egresos != null && egresos.isNotEmpty) {
      for (final egreso in egresos) {
        printer.text(
            '#: ${egreso.numero}  Egreso: ${egreso.egreso} Fecha: ${Format.formatFechaHora(egreso.cajaFecReg)}');
      }
      final totalEgresos = egresos.fold<num>(
          0, (sum, e) => sum + (num.tryParse(e.egreso.toString()) ?? 0));
      printer.text('Total ${totalEgresos.toString()}');
    } else {
      printer.text('No hay egresos para mostrar.');
    }

    printer.feed(2);
    printer.cut();
    printer.disconnect();
  } else {
    // Maneja el error de conexión aquí
    print('No se pudo conectar a la impresora');
  }
}

// ===================== printTicketBusqueda =====================
Future<void> printTicketBusqueda(
  ResponseSumaIEC info,
  User? user,
  String fecha,
  List<EgresoUsuario>? egresos,
) async {
  if (user == null) return;

  final profile = await CapabilityProfile.load();
  final printer = NetworkPrinter(PaperSize.mm80, profile);

  // Cambia la IP y puerto por los de tu impresora
  final result = await printer.connect('192.168.1.91', port: 9100);

  if (result == PosPrintResult.success) {
    // Logo
    if (user.logo.isNotEmpty) {
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

    final totalEfctivo = info.egreso.toDouble() + info.ingreso.toDouble();

    printer.text('Usuario: ${validarCampo(user.usuario)}');
    printer.text('Fecha: ${Format.formatFechaHora(fecha)}');
    printer.hr();
    printer.text('Ingreso: ${validarCampo(info.egreso)}');
    printer.text('Egreso: ${validarCampo(info.egreso)}');
    printer.text('Total Efectivo: ${totalEfctivo.toString()}');
    printer.feed(2);

    printer
        .text('Transferencia: ${validarCampo(info.transferencia.toString())}');
    printer.text('Crédito: ${validarCampo(info.credito.toString())}');
    printer.text('Depósito: ${validarCampo(info.deposito.toString())}');
    printer
        .text('Tar. Crédito: ${validarCampo(info.tarjetaCredito.toString())}');
    printer.text('Tar. Débito: ${validarCampo(info.tarjetaDebito.toString())}');
    printer
        .text('Tar. Prepago: ${validarCampo(info.tarjetaPrepago.toString())}');

    final suma = (info.transferencia) +
        (info.credito) +
        (info.deposito) +
        (info.tarjetaCredito) +
        (info.tarjetaDebito) +
        (info.tarjetaPrepago);

    printer.text('Total CxC: $suma');
    printer.text('Usuario: ${user.usuario}');
    printer.hr();

    if (egresos != null && egresos.isNotEmpty) {
      for (final egreso in egresos) {
        printer.text(
            '#: ${egreso.numero}  Egreso: ${egreso.egreso} Fecha: ${Format.formatFechaHora(egreso.cajaFecReg)}');
      }
      final totalEgresos = egresos.fold<num>(
          0, (sum, e) => sum + (num.tryParse(e.egreso.toString()) ?? 0));
      printer.text('Total ${totalEgresos.toString()}');
    }

    printer.feed(2);
    printer.cut();
    printer.disconnect();
  } else {
    print('No se pudo conectar a la impresora');
  }
}

// ===================== printTicketDesdeLista =====================
Future<void> printTicketDesdeLista(
  CierreCaja info,
  User user,
  String nombreUsuario,
) async {
  final profile = await CapabilityProfile.load();
  final printer = NetworkPrinter(PaperSize.mm80, profile);

  // Cambia la IP y puerto por los de tu impresora
  final result = await printer.connect('192.168.1.91', port: 9100);

  if (result == PosPrintResult.success) {
    // Logo
    if (user.logo.isNotEmpty) {
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

    printer.text('Id: ${validarCampo(info.cajaId)}');
    printer.text('Número: ${validarCampo(info.cajaNumero)}');
    printer.text('Tipo: ${validarCampo(info.cajaTipoCaja)}');
    printer.text('Documento: ${validarCampo(info.cajaTipoDocumento)}');
    printer.hr();
    printer.text('Fecha: ${Format.formatFechaHora(info.cajaFecReg)}');
    printer.hr();
    printer.text('Ingreso: ${validarCampo(info.cajaIngreso)}');
    printer.text('Egreso: ${validarCampo(info.cajaEgreso)}');
    printer.text('Crédito: ${validarCampo(info.cajaCredito)}');
    printer.text('Monto: ${validarCampo(info.cajaMonto)}');
    printer.hr();
    printer.text('Autorización: ${validarCampo(info.cajaAutorizacion)}');
    printer.text('Detalle: ${validarCampo(info.cajaDetalle)}');
    printer.text('Usuario: ${user.usuario}');
    printer.text(nombreUsuario);
    printer.hr();

    printer.feed(2);
    printer.cut();
    printer.disconnect();
  } else {
    print('No se pudo conectar a la impresora');
  }
}

// Función para validar si una propiedad es null
String validarCampo(dynamic valor) {
  return valor == null || valor.toString().isEmpty
      ? '--- --- ---'
      : valor.toString();
}
