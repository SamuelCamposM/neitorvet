import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/config/config.dart';
import 'package:neitorvet/config/local_notifications/local_notifications.dart';
import 'package:neitorvet/config/provider/device_type_provider.dart';
import 'package:neitorvet/config/provider/theme_provider.dart';
import 'package:neitorvet/features/shared/msg/show_snackbar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Environment.initEnvironment();
  await LocalNotifications.requestPermisionLocalNotification();
  await LocalNotifications.initializeLocalNotifications();
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
    const Brightness brightness =
        Brightness.dark; // Cambia a Brightness.dark para el tema oscuro
    final AppTheme appTheme = ref.watch(themeNotifierProvider);
    return MaterialApp.router(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // Inglés
        Locale('es'), // Español
      ],
      scaffoldMessengerKey: NotificationsService.messengerKey,
      routerConfig: appRouter,
      theme: appTheme.getTheme(brightness),
      debugShowCheckedModeBanner: false,
    );
  }
}
