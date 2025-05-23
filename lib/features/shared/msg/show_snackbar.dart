import 'package:flutter/material.dart';

enum SnackbarCategory { success, warning, error }

class NotificationsService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show(
      BuildContext? context, String message, SnackbarCategory category) {
    if (context == null) {
      return;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: _getSnackbarColor(category),

      // duration: const Duration(seconds: 2),
    ));
  }

  static Color _getSnackbarColor(SnackbarCategory category) {
    switch (category) {
      case SnackbarCategory.success:
        return Colors.green.shade900;
      case SnackbarCategory.warning:
        return Colors.yellow;
      case SnackbarCategory.error:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
// import 'package:flutter/material.dart';

// enum SnackbarCategory { success, warning, error }

// class AlertMessage {
//   String message;
//   SnackbarCategory category;
//   AlertMessage({
//     required this.message,
//     required this.category,
//   });
// }

// class NotificationsService {
//   static final GlobalKey<ScaffoldMessengerState> messengerKey =
//       GlobalKey<ScaffoldMessengerState>();

//   static void show(BuildContext context, AlertMessage alertmessage) {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(
//         alertmessage.message,
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       backgroundColor: _getSnackbarColor(alertmessage.category),

//       // duration: const Duration(seconds: 2),
//     ));
//   }

//   static Color _getSnackbarColor(SnackbarCategory category) {
//     switch (category) {
//       case SnackbarCategory.success:
//         return Colors.green.shade900;
//       case SnackbarCategory.warning:
//         return Colors.yellow;
//       case SnackbarCategory.error:
//         return Colors.red;
//       default:
//         return Colors.blue;
//     }
//   }
// }
