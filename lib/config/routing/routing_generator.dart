import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/features/auth/presentation/screens/auth_flow_screen.dart';
import 'package:meal_meat_user/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_meal_picker_sheet.dart';
import 'package:meal_meat_user/features/meal_details/presentation/screens/meal_details_screen.dart';
import 'package:meal_meat_user/features/home/presentation/screens/home_nutrition_details_screen.dart';
import 'package:meal_meat_user/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/offers_screen.dart';
import 'package:meal_meat_user/features/offer_details/presentation/screens/offer_details_screen.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/payment_screen.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/payment_success_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/security_privacy_screen.dart';
import 'package:meal_meat_user/features/search/presentation/screens/search_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/profile_settings_screen.dart';
import 'package:meal_meat_user/features/addresses/presentation/screens/addresses_screen.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/screens/dietary_preferences_screen.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/screens/add_allergy_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/health_goals_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/profile_billing_screen.dart';
import 'package:meal_meat_user/features/splash/presentation/screens/splash_screen.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';
import 'package:meal_meat_user/features/family_plans/presentation/screens/family_package_days_setup_screen.dart';
import 'package:meal_meat_user/features/family_plans/presentation/screens/family_payment_setup_screen.dart';
import 'package:meal_meat_user/features/family_plans/presentation/screens/family_program_setup_screen.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/monthly_plan_details_entity.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/screens/subscription_plan_details_screen.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/screens/subscription_summary_screen.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/screens/subscription_package_selection_screen.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/screens/subscription_program_selection_screen.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/screens/subscriptions_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_subscription_members_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_subscription_settings_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_day_meals_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_member_detail_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_member_permissions_screen.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return _buildRoute(settings: settings, page: const AppShellScreen());
      case AppRoutes.search:
        return _buildRoute(settings: settings, page: const SearchScreen());
      case AppRoutes.offers:
        return _buildRoute(settings: settings, page: const OffersScreen());
      case AppRoutes.subscriptions:
        return _buildRoute(
          settings: settings,
          page: const SubscriptionsScreen(),
        );
      case AppRoutes.subscriptionProgramSelection:
        return _buildRoute(
          settings: settings,
          page: const SubscriptionProgramSelectionScreen(),
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
      case AppRoutes.subscriptionSummary:
        final plan = settings.arguments! as MonthlyPlanDetailsEntity;
        return _buildRoute(
          settings: settings,
          page: SubscriptionSummaryScreen(plan: plan),
        );
      case AppRoutes.familyPlanDetails:
      case AppRoutes.familySubscriptionSettings:
        return _buildRoute(
          settings: settings,
          page: const FamilySubscriptionSettingsScreen(),
        );
      case AppRoutes.familySubscriptionMembers:
        return _buildRoute(
          settings: settings,
          page: const FamilySubscriptionMembersScreen(),
        );
      case AppRoutes.familySubscriptionMemberDetails:
        return _buildRoute(
          settings: settings,
          page: const FamilyMemberDetailScreen(),
        );
      case AppRoutes.familyMemberDailyMeals:
        return _buildRoute(
          settings: settings,
          page: const FamilyDayMealsScreen(),
        );
      case AppRoutes.familyMemberPermissions:
        return _buildRoute(
          settings: settings,
          page: const FamilyMemberPermissionsScreen(),
        );
      case AppRoutes.familyProgramSetup:
        return _buildRoute(
          settings: settings,
          page: const FamilyProgramSetupScreen(),
        );
      case AppRoutes.familyPackageDaysSetup:
        return _buildRoute(
          settings: settings,
          page: const FamilyPackageDaysSetupScreen(),
        );
      case AppRoutes.familyPaymentSetup:
        return _buildRoute(
          settings: settings,
          page: const FamilyPaymentSetupScreen(),
        );
      case AppRoutes.calendar:
        return _buildRoute(settings: settings, page: const CalendarScreen());
      case AppRoutes.mealDetails:
        return _buildRoute(settings: settings, page: const MealDetailsScreen());
      case AppRoutes.nutritionDetails:
        return _buildRoute(
          settings: settings,
          page: const HomeNutritionDetailsScreen(),
        );
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
      case AppRoutes.securityPrivacy:
        return _buildRoute(
          settings: settings,
          page: const SecurityPrivacyScreen(),
        );
      case AppRoutes.profileSettings:
        return _buildRoute(
          settings: settings,
          page: const ProfileSettingsScreen(),
        );
      case AppRoutes.addresses:
        return _buildRoute(settings: settings, page: const AddressesScreen());
      case AppRoutes.dietaryPreferences:
        return _buildRoute(
          settings: settings,
          page: const DietaryPreferencesScreen(),
        );
      case AppRoutes.addAllergy:
        return _buildRoute(settings: settings, page: const AddAllergyScreen());
      case AppRoutes.healthGoals:
        return _buildRoute(settings: settings, page: const HealthGoalsScreen());
      case AppRoutes.profileBilling:
        return _buildRoute(
          settings: settings,
          page: const ProfileBillingScreen(),
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
