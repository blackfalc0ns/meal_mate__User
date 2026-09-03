import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppNavigatorService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  static const Duration _retryDelay = Duration(milliseconds: 200);
  static const int _retryAttempts = 20;

  BuildContext? get currentContext => navigatorKey.currentContext;

  NavigatorState? get navigator => navigatorKey.currentState;

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? showSnackBar(
    SnackBar snackBar,
  ) {
    return scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  Future<T?> pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    final navigatorState = navigator;
    if (navigatorState == null) {
      return Future<T?>.value();
    }

    return navigatorState.pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T?> pushNamedWhenReady<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    for (var attempt = 0; attempt < _retryAttempts; attempt++) {
      final navigatorState = navigator;
      if (navigatorState != null) {
        return navigatorState.pushNamed<T>(routeName, arguments: arguments);
      }

      await WidgetsBinding.instance.endOfFrame;
      await Future<void>.delayed(_retryDelay);
    }

    return null;
  }
}
