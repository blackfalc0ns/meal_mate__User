import 'package:meal_meat_user/features/calendar/presentation/manager/flow/calendar_flow_effect.dart';

class CalendarFlowState {
  final CalendarFlowEffect? effect;

  const CalendarFlowState({this.effect});

  CalendarFlowState copyWith({
    CalendarFlowEffect? effect,
    bool clearEffect = false,
  }) {
    return CalendarFlowState(
      effect: clearEffect ? null : (effect ?? this.effect),
    );
  }
}
