import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/config/config.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

final socketProvider = Provider<io.Socket>((ref) {
  final socket = io.io(Environment.socketUrl, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });

  socket.connect();

  ref.onDispose(() {
    socket.dispose();
  });

  return socket;
});