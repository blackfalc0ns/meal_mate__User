import 'package:meal_meat_user/config/routing/app_routes.dart';

class PushNotificationPayload {
  const PushNotificationPayload({
    required this.routeName,
    required this.arguments,
  });

  static const String routeKey = 'route';
  static const String deepLinkKey = 'deepLink';

  static const Map<String, String> _deepLinkRoutes = {
    'mealmate://subscriptions': AppRoutes.subscriptions,
    'mealmate://calendar': AppRoutes.calendar,
    'mealmate://orders': AppRoutes.calendar,
  };

  final String routeName;
  final Map<String, dynamic> arguments;

  static PushNotificationPayload? fromData(Map<String, dynamic> data) {
    final routeValue = data[routeKey]?.toString().trim();
    final route = routeValue == null || routeValue.isEmpty
        ? _routeFromDeepLink(data[deepLinkKey]?.toString())
        : routeValue;
    if (route == null || route.isEmpty) {
      return null;
    }

    return PushNotificationPayload(
      routeName: route,
      arguments: Map<String, dynamic>.from(data)..remove(routeKey),
    );
  }

  static String? _routeFromDeepLink(String? deepLink) {
    final normalized = deepLink?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return _deepLinkRoutes[normalized];
  }
}
