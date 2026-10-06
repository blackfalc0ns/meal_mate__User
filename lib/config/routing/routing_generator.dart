import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/screens/loading_preview_screen.dart';
import 'package:meal_meat_user/features/auth/presentation/screens/auth_flow_screen.dart';
import 'package:meal_meat_user/features/app_shell/presentation/screens/app_shell_screen.dart';
import 'package:meal_meat_user/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/meal_details_entity.dart';
import 'package:meal_meat_user/features/meal_details/domain/entities/subscription_meal_details_args.dart';
import 'package:meal_meat_user/features/meal_details/presentation/screens/meal_details_screen.dart';
import 'package:meal_meat_user/features/home/presentation/screens/home_nutrition_details_screen.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/screens/influencer_dashboard_screen.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/screens/influencer_share_links_screen.dart';
import 'package:meal_meat_user/features/influencer/social_links/presentation/screens/influencer_social_connections_screen.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/screens/influencer_wallet_screen.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/screens/influencer_withdraw_history_screen.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/screens/influencer_withdraw_review_screen.dart';
import 'package:meal_meat_user/features/influencer/wallet/presentation/screens/influencer_withdraw_screen.dart';
import 'package:meal_meat_user/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/offers_screen.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/browse_offers_screen.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/promo_code_input_screen.dart';
import 'package:meal_meat_user/features/offers/presentation/screens/redeem_package_screen.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offer_details/presentation/screens/offer_details_screen.dart';
import 'package:meal_meat_user/features/payment/domain/entities/offer_checkout_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/activation_success_args.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/promo_applied_checkout_screen.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/activation_success_screen.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_success_args.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/payment_screen.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/payment_success_screen.dart';
import 'package:meal_meat_user/features/payment/presentation/screens/payment_web_view_screen.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/personal_information_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/profile_settings_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/security_privacy_screen.dart';
import 'package:meal_meat_user/features/search/presentation/screens/search_screen.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/features/addresses/domain/usecase/customer_address_editor_operations.dart';
import 'package:meal_meat_user/features/addresses/presentation/screens/address_choose_location_screen.dart';
import 'package:meal_meat_user/features/addresses/presentation/screens/addresses_screen.dart';
import 'package:meal_meat_user/features/family_addresses/domain/usecase/family_address_editor_operations.dart';
import 'package:meal_meat_user/features/family_addresses/domain/usecase/family_addresses_usecases.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/screens/dietary_preferences_screen.dart';
import 'package:meal_meat_user/features/food_preferences/presentation/screens/add_allergy_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/health_goals_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/screens/profile_billing_screen.dart';
import 'package:meal_meat_user/features/splash/presentation/screens/splash_screen.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_page_type.dart';
import 'package:meal_meat_user/features/family_packages/presentation/screens/family_package_selection_screen.dart';
import 'package:meal_meat_user/features/family_shared/presentation/screens/family_subscription_flow_screen.dart';
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
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_member_detail_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_member_permissions_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_member_access_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_review_member_meals_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_day_meals_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_member_calendar_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_restaurants_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/screens/family_meal_selection_screen.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_member_calendar_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_day_meals_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_restaurants_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_meal_selection_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_review_member_meals_args.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/restaurant_tier_upgrade_args.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/screens/restaurant_tier_upgrade_screen.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/screens/restaurant_tier_upgrade_confirmation_screen.dart';
import 'package:meal_meat_user/features/subscription_upgrade/presentation/screens/restaurant_tier_upgrade_web_view_screen.dart';
import 'package:meal_meat_user/features/wallet/presentation/screens/wallet_refund_screen.dart';
import 'package:meal_meat_user/features/wallet/presentation/screens/wallet_screen.dart';
import 'package:meal_meat_user/features/wallet/presentation/screens/wallet_transactions_screen.dart';
import 'package:meal_meat_user/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:meal_meat_user/features/notifications/presentation/screens/notification_preferences_screen.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.loadingPreview:
        return _buildRoute(
          settings: settings,
          page: const LoadingPreviewScreen(),
        );
      case AppRoutes.home:
        final initialTabIndex = settings.arguments is int
            ? settings.arguments! as int
            : 0;
        return _buildRoute(
          settings: settings,
          page: AppShellScreen(initialTabIndex: initialTabIndex),
        );
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
        final args = settings.arguments is RestaurantTierUpgradeArgs
            ? settings.arguments! as RestaurantTierUpgradeArgs
            : null;
        return _buildRoute(
          settings: settings,
          page: RestaurantTierUpgradeScreen(args: args),
        );
      case AppRoutes.restaurantTierUpgradeConfirmation:
        final args = settings.arguments is RestaurantTierUpgradeConfirmationArgs
            ? settings.arguments! as RestaurantTierUpgradeConfirmationArgs
            : null;
        return _buildRoute(
          settings: settings,
          page: RestaurantTierUpgradeConfirmationScreen(args: args),
        );
      case AppRoutes.restaurantTierUpgradeWebView:
        final args = settings.arguments is RestaurantTierUpgradeWebViewArgs
            ? settings.arguments! as RestaurantTierUpgradeWebViewArgs
            : null;
        return _buildRoute(
          settings: settings,
          page: RestaurantTierUpgradeWebViewScreen(args: args),
        );
      case AppRoutes.familyPackageSelection:
        return _buildRoute(
          settings: settings,
          page: const FamilyPackageSelectionScreen(),
        );
      case AppRoutes.familySubscriptionSetup:
        return _buildRoute(
          settings: settings,
          page: FamilySubscriptionFlowScreen(
            initialRoute: settings.name!,
            initialArguments: settings.arguments,
          ),
        );
      case AppRoutes.familySubscriptionMembers:
        return _buildRoute(
          settings: settings,
          page: const FamilySubscriptionMembersScreen(),
        );
      case AppRoutes.familySubscriptionMemberDetails:
        final member = settings.arguments is FamilyMemberSummaryEntity
            ? settings.arguments! as FamilyMemberSummaryEntity
            : null;
        if (member == null) {
          return _buildRoute(
            settings: settings,
            page: const FamilySubscriptionMembersScreen(),
          );
        }
        return _buildRoute(
          settings: settings,
          page: FamilyMemberDetailScreen(member: member),
        );
      case AppRoutes.familyMemberDailyMeals:
        final calendarArgs = switch (settings.arguments) {
          final FamilyMemberCalendarArgs args => args,
          final FamilyMemberDetailEntity detail => FamilyMemberCalendarArgs(
            memberId: detail.memberId,
            displayName: detail.displayName,
            subscriptionId: detail.subscriptionId,
            isManager: detail.isManager,
          ),
          final FamilyMemberSummaryEntity summary => FamilyMemberCalendarArgs(
            memberId: summary.memberId,
            displayName: summary.displayName,
            subscriptionId: summary.subscriptionId,
            isManager: summary.isManager,
          ),
          final String subscriptionId => FamilyMemberCalendarArgs(
            subscriptionId: subscriptionId,
          ),
          _ => null,
        };
        return _buildRoute(
          settings: settings,
          page: FamilyMemberCalendarScreen(args: calendarArgs),
        );
      case AppRoutes.familyMemberDayDetails:
        final dayMealsArgs = switch (settings.arguments) {
          final FamilyDayMealsArgs args => args,
          (final String subId, final DateTime date) => FamilyDayMealsArgs(
            subscriptionId: subId,
            date: date,
          ),
          final String subId => FamilyDayMealsArgs(
            subscriptionId: subId,
            date: DateTime.now(),
          ),
          _ => null,
        };
        return _buildRoute(
          settings: settings,
          page: FamilyDayMealsScreen(args: dayMealsArgs),
        );
      case AppRoutes.familyRestaurants:
        final restaurantArgs = settings.arguments is FamilyRestaurantsArgs
            ? settings.arguments! as FamilyRestaurantsArgs
            : (settings.arguments is String
                  ? FamilyRestaurantsArgs(
                      subscriptionId: settings.arguments! as String,
                      date: DateTime.now(),
                      memberName: '',
                    )
                  : null);
        return _buildRoute(
          settings: settings,
          page: FamilyRestaurantsScreen(args: restaurantArgs),
        );
      case AppRoutes.familyMealSelection:
        final mealArgs = settings.arguments is FamilyMealSelectionArgs
            ? settings.arguments! as FamilyMealSelectionArgs
            : (settings.arguments is String
                  ? FamilyMealSelectionArgs(
                      subscriptionId: settings.arguments! as String,
                      date: DateTime.now(),
                      memberName: '',
                    )
                  : null);
        return _buildRoute(
          settings: settings,
          page: FamilyMealSelectionScreen(args: mealArgs),
        );
      case AppRoutes.familyReviewMemberMeals:
        final reviewArgs = settings.arguments is FamilyReviewMemberMealsArgs
            ? settings.arguments! as FamilyReviewMemberMealsArgs
            : (settings.arguments is String
                  ? FamilyReviewMemberMealsArgs(
                      subscriptionId: settings.arguments! as String,
                      date: DateTime.now(),
                      memberName: '',
                    )
                  : null);
        return _buildRoute(
          settings: settings,
          page: FamilyReviewMemberMealsScreen(args: reviewArgs),
        );
      case AppRoutes.familyMemberPermissions:
        final permissionArgs = settings.arguments is (String, bool, String)
            ? settings.arguments! as (String, bool, String)
            : ('', false, '');
        return _buildRoute(
          settings: settings,
          page: FamilyMemberPermissionsScreen(
            memberId: permissionArgs.$1,
            isManager: permissionArgs.$2,
            memberName: permissionArgs.$3,
          ),
        );
      case AppRoutes.familyMemberAccess:
        final accessArgs = settings.arguments is (String, bool, String)
            ? settings.arguments! as (String, bool, String)
            : ('', false, '');
        return _buildRoute(
          settings: settings,
          page: FamilyMemberAccessScreen(
            memberId: accessArgs.$1,
            isManager: accessArgs.$2,
            memberName: accessArgs.$3,
          ),
        );
      case AppRoutes.familyProgramSetup:
      case AppRoutes.familyPackageDaysSetup:
      case AppRoutes.familyPaymentSetup:
      case AppRoutes.familyAllergies:
      case AppRoutes.familyAddresses:
        return _buildRoute(
          settings: settings,
          page: FamilySubscriptionFlowScreen(
            initialRoute: settings.name!,
            initialArguments: settings.arguments,
          ),
        );
      case AppRoutes.calendar:
        String? subscriptionId;
        if (settings.arguments is String) {
          subscriptionId = settings.arguments as String;
        } else if (settings.arguments is Map) {
          final map = settings.arguments as Map;
          subscriptionId = map['subscriptionId']?.toString();
        }
        return _buildRoute(
          settings: settings,
          page: CalendarScreen(subscriptionId: subscriptionId),
        );
      case AppRoutes.mealDetails:
        final meal = settings.arguments is MealDetailsEntity
            ? settings.arguments! as MealDetailsEntity
            : null;
        final args = settings.arguments is SubscriptionMealDetailsArgs
            ? settings.arguments! as SubscriptionMealDetailsArgs
            : null;
        return _buildRoute(
          settings: settings,
          page: MealDetailsScreen(meal: meal, args: args),
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
        final offerId = settings.arguments is String
            ? settings.arguments! as String
            : '';
        return _buildRoute(
          settings: settings,
          page: OfferDetailsScreen(offerId: offerId),
        );
      case AppRoutes.browseOffers:
        return _buildRoute(
          settings: settings,
          page: const BrowseOffersScreen(),
        );
      case AppRoutes.promoCodeInput:
        return _buildRoute(
          settings: settings,
          page: const PromoCodeInputScreen(),
        );
      case AppRoutes.redeemPackage:
        final offer = settings.arguments is OfferEntity
            ? settings.arguments! as OfferEntity
            : const OfferEntity(
                id: 'default-offer',
                nameAr: 'عرض خاص',
                nameEn: 'Special Offer',
                descriptionAr: 'خصم مميز على باقات الوجبات',
                descriptionEn: 'Special meal package discount',
                discountRate: 0.20,
              );
        return _buildRoute(
          settings: settings,
          page: RedeemPackageScreen(offer: offer),
        );
      case AppRoutes.promoCheckout:
        final args = settings.arguments is OfferCheckoutArgs
            ? settings.arguments! as OfferCheckoutArgs
            : null;
        if (args == null) {
          return _buildRoute(settings: settings, page: const OffersScreen());
        }
        return _buildRoute(
          settings: settings,
          page: PromoAppliedCheckoutScreen(args: args),
        );
      case AppRoutes.activationSuccess:
        final args = settings.arguments is ActivationSuccessArgs
            ? settings.arguments! as ActivationSuccessArgs
            : null;
        if (args == null) {
          return _buildRoute(settings: settings, page: const OffersScreen());
        }
        return _buildRoute(
          settings: settings,
          page: ActivationSuccessScreen(args: args),
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
        final args = settings.arguments is PaymentSuccessArgs
            ? settings.arguments! as PaymentSuccessArgs
            : null;
        return _buildRoute(
          settings: settings,
          page: PaymentSuccessScreen(args: args),
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
        final args = switch (settings.arguments) {
          final AddressChooseLocationArgs args => args,
          final SubscriptionFlowArgs args => AddressChooseLocationArgs(
            subscriptionFlowArgs: args,
          ),
          _ => null,
        };
        final operations = args?.familyMemberId != null
            ? FamilyAddressEditorOperations(
                memberId: args!.familyMemberId!,
                previewFamilyMemberAddressUseCase:
                    getIt<PreviewFamilyMemberAddressUseCase>(),
                addFamilyMemberAddressUseCase:
                    getIt<AddFamilyMemberAddressUseCase>(),
              )
            : getIt<CustomerAddressEditorOperations>();
        return _buildRoute(
          settings: settings,
          page: AddressChooseLocationScreen(args: args, operations: operations),
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
      case AppRoutes.influencerDashboard:
        return _buildRoute(
          settings: settings,
          page: const InfluencerDashboardScreen(),
        );
      case AppRoutes.influencerShareLinks:
        return _buildRoute(
          settings: settings,
          page: const InfluencerShareLinksScreen(),
        );
      case AppRoutes.influencerSocialConnections:
        return _buildRoute(
          settings: settings,
          page: const InfluencerSocialConnectionsScreen(),
        );
      case AppRoutes.influencerWallet:
        return _buildRoute(
          settings: settings,
          page: const InfluencerWalletScreen(),
        );
      case AppRoutes.influencerWithdraw:
        return _buildRoute(
          settings: settings,
          page: const InfluencerWithdrawScreen(),
        );
      case AppRoutes.influencerWithdrawReview:
        return _buildRoute(
          settings: settings,
          page: const InfluencerWithdrawReviewScreen(),
        );
      case AppRoutes.influencerWithdrawHistory:
        return _buildRoute(
          settings: settings,
          page: const InfluencerWithdrawHistoryScreen(),
        );
      case AppRoutes.notifications:
        return _buildRoute(
          settings: settings,
          page: const NotificationsScreen(),
        );
      case AppRoutes.notificationPreferences:
        return _buildRoute(
          settings: settings,
          page: const NotificationPreferencesScreen(),
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
