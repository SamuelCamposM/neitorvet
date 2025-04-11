import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BotonTurnoNotifier extends StateNotifier<bool> {
  BotonTurnoNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final botonTurnoProvider = StateNotifierProvider<BotonTurnoNotifier, bool>(
  (ref) => BotonTurnoNotifier(),
);

// class QrScannerNotifier extends StateNotifier<String?> {
//   QrScannerNotifier() : super(null);

//   final MobileScannerController controller = MobileScannerController(
//     autoStart: false,
//     detectionTimeoutMs: 10000,
//   );

//   Future<void> startScanning() async {
//     await controller.start();
//   }

//   Future<void> stopScanning() async {
//     await controller.stop();
//   }

//   void onDetect(BarcodeCapture capture) {
//     final List<Barcode> barcodes = capture.barcodes;
//     if (barcodes.isNotEmpty) {
//       state = barcodes.first.rawValue;
//       stopScanning(); // Detenemos el escaneo después de la primera detección
//     }
//   }

//   void resetQrResult() {
//     state = null;
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }

// final qrScannerProvider =
//     StateNotifierProvider<QrScannerNotifier, String?>((ref) {
//   final notifier = QrScannerNotifier();
//   ref.onDispose(notifier.dispose);
//   return notifier;
// });
class QrScannerNotifier extends StateNotifier<String?> {
  QrScannerNotifier() : super(null);

  Future<void> startScanning(BuildContext context) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Color de la línea del escáner
        'Cancelar', // Texto del botón de cancelar
        true, // Mostrar el flash icon
        ScanMode.QR, // Tipo de código a escanear
      );
      print(barcodeScanRes);
    } catch (e) {
      barcodeScanRes = 'Error al escanear: $e';
    }

    if (barcodeScanRes != '-1') {
      state = barcodeScanRes;
    } else {
      state = null; // El escaneo fue cancelado
    }
  }

  void resetQrResult() {
    state = null;
  }
}

final qrScannerProvider =
    StateNotifierProvider<QrScannerNotifier, String?>((ref) {
  return QrScannerNotifier();
});
