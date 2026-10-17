import 'package:meal_meat_user/config/routing/app_routes.dart';

String? familyCheckoutBlockerRoute(String? reason) => switch (reason) {
  'family.allergies_required' => AppRoutes.familyAllergies,
  'family.address_required' => AppRoutes.familyAddresses,
  'family.start_date_required' => AppRoutes.familyPackageDaysSetup,
  'family.min_members' => AppRoutes.familySubscriptionSetup,
  'family.manager_subscription_required' => AppRoutes.familySubscriptionSetup,
  'family.max_members' => AppRoutes.familySubscriptionSetup,
  'family.member_incomplete' => AppRoutes.familyPackageDaysSetup,
  'family.plan_incomplete' => AppRoutes.familyPackageDaysSetup,
  'family.program_required' => AppRoutes.familyProgramSetup,
  'family.already_in_family' => AppRoutes.familySubscriptionSetup,
  'family.duplicate_member' => AppRoutes.familySubscriptionSetup,
  'family.cannot_remove_manager' => AppRoutes.familySubscriptionSetup,
  'restaurant.not_eligible' => AppRoutes.familyProgramSetup,
  'subscription_flow.no_restaurants_for_selection' =>
    AppRoutes.familyPackageDaysSetup,
  'no_restaurants_for_selection' => AppRoutes.familyPackageDaysSetup,
  'subscription_flow.no_prepared_restaurants' =>
    AppRoutes.familyPackageDaysSetup,
  'no_prepared_restaurants' => AppRoutes.familyPackageDaysSetup,
  'subscription_flow.no_restaurants_for_address' => AppRoutes.familyAddresses,
  'no_restaurants_for_address' => AppRoutes.familyAddresses,
  _ => null,
};
