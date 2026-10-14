import 'package:meal_meat_user/config/routing/app_routes.dart';

String? familyCheckoutBlockerRoute(String? reason) => switch (reason) {
  'family.allergies_required' => AppRoutes.familyAllergies,
  'family.address_required' => AppRoutes.familyAddresses,
  'family.start_date_required' => AppRoutes.familyPackageDaysSetup,
  'family.min_members' => AppRoutes.familySubscriptionSetup,
  'family.manager_subscription_required' => AppRoutes.familySubscriptionSetup,
  'family.max_members' => AppRoutes.familySubscriptionSetup,
  'family.member_incomplete' => AppRoutes.familyPackageDaysSetup,
  'restaurant.not_eligible' => AppRoutes.familyProgramSetup,
  _ => null,
};
