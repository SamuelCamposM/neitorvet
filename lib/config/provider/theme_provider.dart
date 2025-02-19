import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neitorvet/config/config.dart';
import 'package:neitorvet/features/auth/presentation/providers/auth_provider.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  final user = ref.watch(authProvider).user;
  final colorPrimario =
      user?.colorSecundario ?? '#6200EE'; // Flutter Primary (Material 3)
  final colorSecundario =
      user?.colorPrimario ?? '#03DAC6'; // Flutter Secondary (Material 3)

  return ThemeNotifier(
    colorPrimario: colorPrimario,
    colorSecundario: colorSecundario,
  );
});

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier(
      {required String colorPrimario, required String colorSecundario})
      : super(AppTheme(primary: colorPrimario, secondary: colorSecundario));

  void updateTheme(String primary, String secondary) {
    state = state.copyWith(primary: primary, secondary: secondary);
  }
}
