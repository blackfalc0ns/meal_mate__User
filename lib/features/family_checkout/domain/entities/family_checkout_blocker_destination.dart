import 'package:meal_meat_user/config/routing/app_routes.dart';

String? familyCheckoutBlockerRoute(String? reason) => switch (reason) {
  'family.allergies_required' => AppRoutes.familyAllergies,
  'family.address_required' => AppRoutes.familyAddresses,
  'family.member_incomplete' => AppRoutes.familyPackageDaysSetup,
  _ => null,
};
