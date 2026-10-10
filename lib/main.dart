import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:device_preview/device_preview.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_generator.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/services/app_locale_notifier.dart';
import 'package:meal_meat_user/core/services/app_navigator_service.dart';
import 'package:meal_meat_user/core/services/language_service.dart';
import 'package:meal_meat_user/core/payment/payment_deep_link_coordinator.dart';
import 'package:meal_meat_user/core/services/push_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meal_meat_user/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await getIt<PushNotificationService>().initialize();
  getIt<PaymentDeepLinkCoordinator>().initialize();
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
          navigatorKey: getIt<AppNavigatorService>().navigatorKey,
          scaffoldMessengerKey:
              getIt<AppNavigatorService>().scaffoldMessengerKey,
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
          initialRoute: AppRoutes.splash,
          onGenerateRoute: RouteGenerator.getRoute,
        );
      },
    );
  }
}
