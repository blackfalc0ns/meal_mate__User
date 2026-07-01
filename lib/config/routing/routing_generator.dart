import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/features/auth/presentation/screens/auth_flow_screen.dart';
import 'package:meal_meat_user/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:meal_meat_user/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/offers_screen.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/screens/subscriptions_screen.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/screens/family_plan_details_screen.dart';
import 'package:meal_meat_user/features/offer_details/presentation/screens/offer_details_screen.dart';
import 'package:meal_meat_user/features/offer_details/presentation/screens/offer_activated_screen.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/payment_screen.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/payment_success_screen.dart';
import 'package:meal_meat_user/features/splash/presentation/screens/splash_screen.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AppShellScreen(),
        );
      case AppRoutes.offers:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OffersScreen(),
        );
      case AppRoutes.subscriptions:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SubscriptionsScreen(),
        );
      case AppRoutes.familyPlanDetails:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const FamilyPlanDetailsScreen(),
        );
      case AppRoutes.calendar:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CalendarScreen(),
        );
      case AppRoutes.offerDetails:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OfferDetailsScreen(),
        );
      case AppRoutes.offerActivated:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OfferActivatedScreen(),
        );
      case AppRoutes.payment:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PaymentScreen(),
        );
      case AppRoutes.paymentSuccess:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PaymentSuccessScreen(),
        );
      case AppRoutes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      case AppRoutes.onboarding:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OnboardingScreen(),
        );
      case AppRoutes.signIn:
      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const AuthFlowScreen(initialPage: AuthPageType.signIn),
        );
      case AppRoutes.signUp:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const AuthFlowScreen(initialPage: AuthPageType.signUp),
        );
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const AuthFlowScreen(initialPage: AuthPageType.forgotPassword),
        );
      case AppRoutes.otp:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AuthFlowScreen(initialPage: AuthPageType.otp),
        );
      case AppRoutes.newPassword:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) =>
              const AuthFlowScreen(initialPage: AuthPageType.newPassword),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
