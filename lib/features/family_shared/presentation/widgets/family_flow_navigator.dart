import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/features/family_shared/presentation/manager/family_subscription_flow_view_model.dart';
import 'package:meal_meat_user/features/family_shared/presentation/navigation/family_flow_route_observer.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scaffold.dart';

class FamilyFlowNavigator extends StatefulWidget {
  const FamilyFlowNavigator({
    super.key,
    required this.initialRoute,
    required this.routeFactory,
  });

  final String initialRoute;
  final RouteFactory routeFactory;

  @override
  State<FamilyFlowNavigator> createState() => _FamilyFlowNavigatorState();
}

class _FamilyFlowNavigatorState extends State<FamilyFlowNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final ValueNotifier<int> _currentStep;
  late final FamilyFlowRouteObserver _routeObserver;

  @override
  void initState() {
    super.initState();
    final initialStep =
        FamilyFlowRouteObserver.stepFor(widget.initialRoute) ?? 0;
    _currentStep = ValueNotifier<int>(initialStep);
    _routeObserver = FamilyFlowRouteObserver(
      _currentStep,
      onStepChanged: (step) {
        if (mounted) {
          try {
            context.read<FamilySubscriptionFlowViewModel>().setStep(step);
          } catch (_) {}
        }
      },
    );
  }

  @override
  void dispose() {
    _currentStep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return FamilyFlowScaffold(
      currentStepListenable: _currentStep,
      onBackPressed: _onBackPressed,
      body: ColoredBox(
        color: color.surface,
        child: Navigator(
          key: _navigatorKey,
          initialRoute: widget.initialRoute,
          onGenerateRoute: widget.routeFactory,
          observers: [_routeObserver],
        ),
      ),
    );
  }

  Future<void> _onBackPressed() async {
    final nestedNavigator = _navigatorKey.currentState;
    if (nestedNavigator != null && await nestedNavigator.maybePop()) return;
    if (mounted) Navigator.of(context).maybePop();
  }
}
