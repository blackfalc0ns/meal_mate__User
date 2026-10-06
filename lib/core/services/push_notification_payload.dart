import 'package:meal_meat_user/config/routing/app_routes.dart';

class PushNotificationPayload {
  const PushNotificationPayload({
    required this.routeName,
    required this.arguments,
  });

  static const String routeKey = 'route';
  static const String deepLinkKey = 'deepLink';

  static const Set<String> allowedRoutes = {
    AppRoutes.calendar,
    AppRoutes.subscriptions,
    AppRoutes.influencerDashboard,
    AppRoutes.notifications,
    AppRoutes.notificationPreferences,
    AppRoutes.home,
    AppRoutes.offers,
    AppRoutes.profileSettings,
    AppRoutes.wallet,
  };

  static const Map<String, String> _deepLinkHosts = {
    'subscriptions': AppRoutes.subscriptions,
    'calendar': AppRoutes.calendar,
    'orders': AppRoutes.calendar,
    'influencer-portal': AppRoutes.influencerDashboard,
    'notifications': AppRoutes.notifications,
  };

  final String routeName;
  final Map<String, dynamic> arguments;

  static PushNotificationPayload? fromData(Map<String, dynamic> data) {
    final deepLinkValue = data[deepLinkKey]?.toString().trim();
    final routeValue = data[routeKey]?.toString().trim();

    String? targetRoute;
    final parsedArgs = Map<String, dynamic>.from(data)
      ..remove(routeKey)
      ..remove(deepLinkKey);

    if (deepLinkValue != null && deepLinkValue.isNotEmpty) {
      final resolved = _resolveDeepLink(deepLinkValue);
      if (resolved != null) {
        targetRoute = resolved.routeName;
        parsedArgs.addAll(resolved.arguments);
      }
    } else if (routeValue != null && routeValue.isNotEmpty) {
      if (allowedRoutes.contains(routeValue)) {
        targetRoute = routeValue;
      }
    }

    if (targetRoute == null || !allowedRoutes.contains(targetRoute)) {
      return null;
    }

    return PushNotificationPayload(
      routeName: targetRoute,
      arguments: parsedArgs,
    );
  }

  static ({String routeName, Map<String, dynamic> arguments})? _resolveDeepLink(
    String deepLink,
  ) {
    final trimmed = deepLink.trim();
    if (trimmed.isEmpty) return null;

    // 1. Check relative orders pattern: /orders/{dayId}
    final relativeOrdersRegex = RegExp(r'^/orders/([^/?#]+)');
    final relativeMatch = relativeOrdersRegex.firstMatch(trimmed);
    if (relativeMatch != null) {
      final dayId = relativeMatch.group(1);
      final args = <String, dynamic>{};
      if (dayId != null && dayId.isNotEmpty) {
        args['dayId'] = dayId;
      }
      return (routeName: AppRoutes.calendar, arguments: args);
    }

    // 2. Parse URI
    try {
      final uri = Uri.parse(trimmed);
      if (uri.scheme == 'mealmate') {
        final host = uri.host.isNotEmpty ? uri.host : uri.path.replaceAll('/', '');
        final targetRoute = _deepLinkHosts[host];
        if (targetRoute != null) {
          final queryArgs = Map<String, dynamic>.from(uri.queryParameters);
          return (routeName: targetRoute, arguments: queryArgs);
        }
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}
