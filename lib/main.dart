import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadow_game/app/app.dart';
import 'package:shadow_game/app/config/router/app_router.dart';
import 'package:shadow_game/app/config/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shadow_game/di.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Dependency injection (loads SharedPreferences) before the first frame.
  await setup();

  // Step 2: Change the orientation to landscape after 2 seconds
  Future.delayed(const Duration(seconds: 3), () {
    FlutterNativeSplash.remove();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  });

  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Shadow Game',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      routerConfig: AppRouter.getAppRouter(),
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('es')],
      builder: (context, child) {
        return App(
          child: child!,
        );
      },
    );
  }
}
