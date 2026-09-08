import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';

class FamilyFlowRouteObserver extends NavigatorObserver {
  FamilyFlowRouteObserver(this.currentStep);

  final ValueNotifier<int> currentStep;

  static int? stepFor(String? routeName) => switch (routeName) {
    AppRoutes.familySubscriptionSetup => 0,
    AppRoutes.familyProgramSetup => 1,
    AppRoutes.familyAddresses => 2,
    AppRoutes.familyAllergies => 3,
    AppRoutes.familyPackageDaysSetup => 4,
    AppRoutes.familyPaymentSetup => 5,
    _ => null,
  };

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _sync(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) _sync(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _sync(newRoute);
  }

  void _sync(Route<dynamic> route) {
    final nextStep = stepFor(route.settings.name);
    if (nextStep != null && currentStep.value != nextStep) {
      currentStep.value = nextStep;
    }
  }
}
