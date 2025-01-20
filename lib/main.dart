import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/config/config.dart';
import 'package:neitorvet/config/provider/device_type_provider.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';

void main() async {
  await Environment.initEnvironment();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(contextProvider.notifier).state = context;
    });
    final appRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      scaffoldMessengerKey: NotificationsService.messengerKey,
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
