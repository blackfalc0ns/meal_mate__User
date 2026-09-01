class PushNotificationPayload {
  const PushNotificationPayload({
    required this.routeName,
    required this.arguments,
  });

  static const String routeKey = 'route';

  final String routeName;
  final Map<String, dynamic> arguments;

  static PushNotificationPayload? fromData(Map<String, dynamic> data) {
    final route = data[routeKey]?.toString().trim();
    if (route == null || route.isEmpty) {
      return null;
    }

    return PushNotificationPayload(
      routeName: route,
      arguments: Map<String, dynamic>.from(data)..remove(routeKey),
    );
  }
}
