import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';

String? familyCheckoutBlockerRoute(String? reason) => switch (reason) {
  SubscriptionErrorCodes.familyAllergiesRequired => AppRoutes.familyAllergies,
  SubscriptionErrorCodes.familyAddressRequired => AppRoutes.familyAddresses,
  SubscriptionErrorCodes.familyStartDateRequired =>
    AppRoutes.familyPackageDaysSetup,
  SubscriptionErrorCodes.familyMinMembers => AppRoutes.familySubscriptionSetup,
  SubscriptionErrorCodes.familyManagerSubscriptionRequired =>
    AppRoutes.familySubscriptionSetup,
  SubscriptionErrorCodes.familyMaxMembers => AppRoutes.familySubscriptionSetup,
  SubscriptionErrorCodes.familyMemberIncomplete =>
    AppRoutes.familyPackageDaysSetup,
  SubscriptionErrorCodes.familyPlanIncomplete =>
    AppRoutes.familyPackageDaysSetup,
  SubscriptionErrorCodes.familyProgramRequired => AppRoutes.familyProgramSetup,
  SubscriptionErrorCodes.familyAlreadyInFamily =>
    AppRoutes.familySubscriptionSetup,
  SubscriptionErrorCodes.familyDuplicateMember =>
    AppRoutes.familySubscriptionSetup,
  SubscriptionErrorCodes.familyCannotRemoveManager =>
    AppRoutes.familySubscriptionSetup,
  SubscriptionErrorCodes.restaurantNotEligible => AppRoutes.familyProgramSetup,
  SubscriptionErrorCodes.periodUnavailable => AppRoutes.familyPackageDaysSetup,
  SubscriptionErrorCodes.periodUnavailableLegacy =>
    AppRoutes.familyPackageDaysSetup,
  SubscriptionErrorCodes.noPreparedRestaurants =>
    AppRoutes.familyPackageDaysSetup,
  SubscriptionErrorCodes.noPreparedRestaurantsBare =>
    AppRoutes.familyPackageDaysSetup,
  SubscriptionErrorCodes.noRestaurantsForAddress => AppRoutes.familyAddresses,
  SubscriptionErrorCodes.optionUncovered => AppRoutes.familyAddresses,
  _ => null,
};

String? familySummaryBlockerRoute(String? reason) =>
    familyCheckoutBlockerRoute(reason);
