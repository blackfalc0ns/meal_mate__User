import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/features/auth/presentation/screens/auth_flow_screen.dart';
import 'package:meal_meat_user/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_picker_sheet.dart';
import 'package:meal_meat_user/features/meal_details/presentation/screens/meal_details_screen.dart';
import 'package:meal_meat_user/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/offers_screen.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/screens/subscriptions_screen.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/screens/family_plan_details_screen.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/screens/subscription_plan_details_screen.dart';
import 'package:meal_meat_user/features/subscriptions/presentation/screens/subscription_package_selection_screen.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/offer_details/presentation/screens/offer_details_screen.dart';
import 'package:meal_meat_user/features/offer_details/presentation/screens/offer_activated_screen.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/payment_screen.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/payment_success_screen.dart';
import 'package:meal_meat_user/features/splash/presentation/screens/splash_screen.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return _buildRoute(settings: settings, page: const AppShellScreen());
      case AppRoutes.offers:
        return _buildRoute(settings: settings, page: const OffersScreen());
      case AppRoutes.subscriptions:
        return _buildRoute(
          settings: settings,
          page: const SubscriptionsScreen(),
        );
      case AppRoutes.subscriptionPlanDetails:
        final initialPage = settings.arguments is int
            ? settings.arguments! as int
            : 0;
        return _buildRoute(
          settings: settings,
          page: SubscriptionPlanDetailsScreen(initialPage: initialPage),
        );
      case AppRoutes.subscriptionPackageSelection:
        final programIndex = settings.arguments is int
            ? settings.arguments! as int
            : 0;
        return _buildRoute(
          settings: settings,
          page: SubscriptionPackageSelectionScreen(programIndex: programIndex),
        );
      case AppRoutes.familyPlanDetails:
        return _buildRoute(
          settings: settings,
          page: const FamilyPlanDetailsScreen(),
        );
      case AppRoutes.calendar:
        return _buildRoute(settings: settings, page: const CalendarScreen());
      case AppRoutes.mealDetails:
        return _buildRoute(settings: settings, page: const MealDetailsScreen());
      case AppRoutes.restaurantDetails:
        final restaurant = settings.arguments! as MonthlyRestaurantPlanEntity;
        return _buildRoute(
          settings: settings,
          page: CalendarMealPickerSheet(
            restaurantName: restaurant.name,
            restaurantLogoAsset: restaurant.logoAsset,
            restaurantInitials: restaurant.initials,
          ),
        );

      case AppRoutes.offerDetails:
        return _buildRoute(
          settings: settings,
          page: const OfferDetailsScreen(),
        );
      case AppRoutes.offerActivated:
        return _buildRoute(
          settings: settings,
          page: const OfferActivatedScreen(),
        );
      case AppRoutes.payment:
        return _buildRoute(settings: settings, page: const PaymentScreen());
      case AppRoutes.paymentSuccess:
        return _buildRoute(
          settings: settings,
          page: const PaymentSuccessScreen(),
        );
      case AppRoutes.splash:
        return _buildRoute(settings: settings, page: const SplashScreen());
      case AppRoutes.onboarding:
        return _buildRoute(settings: settings, page: const OnboardingScreen());
      case AppRoutes.signIn:
      case AppRoutes.login:
        return _buildRoute(
          settings: settings,
          page: const AuthFlowScreen(initialPage: AuthPageType.signIn),
        );
      case AppRoutes.signUp:
        return _buildRoute(
          settings: settings,
          page: const AuthFlowScreen(initialPage: AuthPageType.signUp),
        );
      case AppRoutes.forgotPassword:
        return _buildRoute(
          settings: settings,
          page: const AuthFlowScreen(initialPage: AuthPageType.forgotPassword),
        );
      case AppRoutes.otp:
        return _buildRoute(
          settings: settings,
          page: const AuthFlowScreen(initialPage: AuthPageType.otp),
        );
      case AppRoutes.newPassword:
        return _buildRoute(
          settings: settings,
          page: const AuthFlowScreen(initialPage: AuthPageType.newPassword),
        );
      default:
        return _buildRoute(
          settings: settings,
          page: Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static PageRouteBuilder<dynamic> _buildRoute({
    required RouteSettings settings,
    required Widget page,
  }) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 360),
      reverseTransitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}
