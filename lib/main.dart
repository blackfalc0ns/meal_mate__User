import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:device_preview/device_preview.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_generator.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/services/app_locale_notifier.dart';
import 'package:meal_meat_user/core/services/language_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  appLocaleNotifier.value = Locale(getIt<LanguageService>().getLanguageCode());
  debugPaintBaselinesEnabled = false;

  runApp(
    DevicePreview(enabled: true, builder: (context) => const MealMateApp()),
  );
}

class MealMateApp extends StatelessWidget {
  const MealMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocaleNotifier,
      builder: (context, appLocale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          builder: DevicePreview.appBuilder,
          locale: appLocale,
          title: 'Meal Mate',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          localeResolutionCallback: (locale, supportedLocales) =>
              locale ?? const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          initialRoute: AppRoutes.home,
          onGenerateRoute: RouteGenerator.getRoute,
        );
      },
    );
  }
}
