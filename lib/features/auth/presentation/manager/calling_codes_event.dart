import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';

sealed class CallingCodesEvent {
  const CallingCodesEvent();
}

class LoadCallingCodesEvent extends CallingCodesEvent {
  const LoadCallingCodesEvent();
}

class SelectCallingCodeEvent extends CallingCodesEvent {
  const SelectCallingCodeEvent(this.selected);

  final CallingCodeEntity selected;
}
