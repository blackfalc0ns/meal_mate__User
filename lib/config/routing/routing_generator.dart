import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/features/auth/presentation/screens/auth_flow_screen.dart';
import 'package:meal_meat_user/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/presentation/screens/meal_details_screen.dart';
import 'package:meal_meat_user/features/home/presentation/screens/home_nutrition_details_screen.dart';
import 'package:meal_meat_user/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/offers_screen.dart';
import 'package:meal_meat_user/features/offer_details/presentation/screens/offer_details_screen.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/payment_screen.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/payment_success_screen.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/payment_web_view_screen.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/personal_information_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/security_privacy_screen.dart';
import 'package:meal_meat_user/features/search/presentation/screens/search_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/profile_settings_screen.dart';
import 'package:meal_meat_user/features/addresses/presentation/screens/address_choose_location_screen.dart';
import 'package:meal_meat_user/features/addresses/presentation/screens/addresses_screen.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/screens/dietary_preferences_screen.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/screens/add_allergy_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/health_goals_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/profile_billing_screen.dart';
import 'package:meal_meat_user/features/splash/presentation/screens/splash_screen.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';
import 'package:meal_meat_user/features/family_packages/domain/entities/family_size_package_entity.dart';
import 'package:meal_meat_user/features/family_packages/presentation/screens/family_package_selection_screen.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/screens/family_package_days_setup_screen.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/screens/family_payment_setup_screen.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/screens/family_subscription_setup_screen.dart';
import 'package:meal_meat_user/features/family_programs/presentation/screens/family_program_setup_screen.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_plan_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/domain/entities/subscription_restaurant_details_args.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/screens/subscription_plan_details_screen.dart';
import 'package:meal_meat_user/features/monthly_plans/presentation/screens/subscription_restaurant_details_screen.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_args.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/screens/subscription_summary_screen.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/screens/subscription_package_selection_screen.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/screens/subscription_program_selection_screen.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/screens/subscriptions_screen.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/conversion_options_model.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/screens/conversion_options_page.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_subscription_members_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_subscription_settings_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_day_meals_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_member_detail_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_member_permissions_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_restaurants_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/restaurant_tier_upgrade_screen.dart';
import 'package:meal_meat_user/features/wallet/presentation/screens/wallet_refund_screen.dart';
import 'package:meal_meat_user/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:meal_meat_user/features/wallet/presentation/screens/wallet_transactions_screen.dart';

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
      case AppRoutes.conversionOptions:
        final options = settings.arguments is ConversionOptionsModel
            ? settings.arguments! as ConversionOptionsModel
            : const ConversionOptionsModel(
                subscriptionId: '',
                status: '',
                options: [],
              );
        return _buildRoute(
          settings: settings,
          page: ConversionOptionsPage(options: options),
        );
      case AppRoutes.subscriptionProgramSelection:
        return _buildRoute(
          settings: settings,
          page: const SubscriptionProgramSelectionScreen(),
        );
      case AppRoutes.subscriptionPlanDetails:
        final args = settings.arguments is SubscriptionPlanDetailsArgs
            ? settings.arguments! as SubscriptionPlanDetailsArgs
            : null;
        return _buildRoute(
          settings: settings,
          page: SubscriptionPlanDetailsScreen(args: args),
        );
      case AppRoutes.subscriptionPackageSelection:
        final selectedProgram = settings.arguments is SubscriptionProgramEntity
            ? settings.arguments! as SubscriptionProgramEntity
            : null;
        return _buildRoute(
          settings: settings,
          page: SubscriptionPackageSelectionScreen(
            selectedProgram: selectedProgram,
          ),
        );
      case AppRoutes.subscriptionSummary:
        final args = settings.arguments is SubscriptionSummaryArgs
            ? settings.arguments! as SubscriptionSummaryArgs
            : null;
        return _buildRoute(
          settings: settings,
          page: SubscriptionSummaryScreen(args: args),
        );
      case AppRoutes.familyPlanDetails:
      case AppRoutes.familySubscriptionSettings:
        return _buildRoute(
          settings: settings,
          page: const FamilySubscriptionSettingsScreen(),
        );
      case AppRoutes.restaurantTierUpgrade:
        return _buildRoute(
          settings: settings,
          page: const RestaurantTierUpgradeScreen(),
        );
      case AppRoutes.familyPackageSelection:
        return _buildRoute(
          settings: settings,
          page: const FamilyPackageSelectionScreen(),
        );
      case AppRoutes.familySubscriptionSetup:
        final selectedPackage = settings.arguments is FamilySizePackageEntity
            ? settings.arguments! as FamilySizePackageEntity
            : null;
        return _buildRoute(
          settings: settings,
          page: FamilySubscriptionSetupScreen(selectedPackage: selectedPackage),
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
      case AppRoutes.familyRestaurants:
        return _buildRoute(
          settings: settings,
          page: const FamilyRestaurantsScreen(),
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
        final programId = settings.arguments is String
            ? settings.arguments as String
            : null;
        return _buildRoute(
          settings: settings,
          page: FamilyPackageDaysSetupScreen(programId: programId),
        );
      case AppRoutes.familyPaymentSetup:
        return _buildRoute(
          settings: settings,
          page: const FamilyPaymentSetupScreen(),
        );
      case AppRoutes.calendar:
        return _buildRoute(settings: settings, page: const CalendarScreen());
      case AppRoutes.mealDetails:
        final meal = settings.arguments is MealDetailsEntity
            ? settings.arguments! as MealDetailsEntity
            : null;
        return _buildRoute(
          settings: settings,
          page: MealDetailsScreen(meal: meal),
        );
      case AppRoutes.nutritionDetails:
        return _buildRoute(
          settings: settings,
          page: const HomeNutritionDetailsScreen(),
        );
      case AppRoutes.restaurantDetails:
        final args = settings.arguments is SubscriptionRestaurantDetailsArgs
            ? settings.arguments! as SubscriptionRestaurantDetailsArgs
            : null;
        return _buildRoute(
          settings: settings,
          page: SubscriptionRestaurantDetailsScreen(args: args),
        );

      case AppRoutes.offerDetails:
        return _buildRoute(
          settings: settings,
          page: const OfferDetailsScreen(),
        );
      case AppRoutes.payment:
        final args = settings.arguments is PaymentArgs
            ? settings.arguments! as PaymentArgs
            : null;
        return _buildRoute(
          settings: settings,
          page: PaymentScreen(args: args),
        );
      case AppRoutes.paymentWebView:
        final args = settings.arguments is PaymentWebViewArgs
            ? settings.arguments! as PaymentWebViewArgs
            : null;
        return _buildRoute(
          settings: settings,
          page: PaymentWebViewScreen(args: args),
        );
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
      case AppRoutes.personalInformation:
        final profile = settings.arguments! as CustomerProfileEntity;
        return _buildRoute(
          settings: settings,
          page: PersonalInformationScreen(profile: profile),
        );
      case AppRoutes.profileSettings:
        return _buildRoute(
          settings: settings,
          page: const ProfileSettingsScreen(),
        );
      case AppRoutes.addresses:
        return _buildRoute(settings: settings, page: const AddressesScreen());
      case AppRoutes.addressChooseLocation:
        final args = settings.arguments is SubscriptionFlowArgs
            ? settings.arguments! as SubscriptionFlowArgs
            : null;
        return _buildRoute(
          settings: settings,
          page: AddressChooseLocationScreen(args: args),
        );
      case AppRoutes.dietaryPreferences:
        final args = settings.arguments is SubscriptionFlowArgs
            ? settings.arguments! as SubscriptionFlowArgs
            : null;
        return _buildRoute(
          settings: settings,
          page: DietaryPreferencesScreen(args: args),
        );
      case AppRoutes.addAllergy:
        final args = settings.arguments is SubscriptionFlowArgs
            ? settings.arguments! as SubscriptionFlowArgs
            : null;
        return _buildRoute(
          settings: settings,
          page: AddAllergyScreen(args: args),
        );
      case AppRoutes.healthGoals:
        return _buildRoute(settings: settings, page: const HealthGoalsScreen());
      case AppRoutes.profileBilling:
        return _buildRoute(
          settings: settings,
          page: const ProfileBillingScreen(),
        );
      case AppRoutes.wallet:
        return _buildRoute(settings: settings, page: const WalletScreen());
      case AppRoutes.walletRefund:
        return _buildRoute(
          settings: settings,
          page: const WalletRefundScreen(),
        );
      case AppRoutes.walletTransactions:
        return _buildRoute(
          settings: settings,
          page: const WalletTransactionsScreen(),
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
