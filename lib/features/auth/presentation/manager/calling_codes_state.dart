import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';

class CallingCodesState {
  const CallingCodesState({
    this.items = const [],
    this.selected,
    this.isLoading = false,
    this.failure,
  });

  final List<CallingCodeEntity> items;
  final CallingCodeEntity? selected;
  final bool isLoading;
  final Failure? failure;

  CallingCodesState copyWith({
    List<CallingCodeEntity>? items,
    CallingCodeEntity? Function()? selected,
    bool? isLoading,
    Failure? Function()? failure,
  }) {
    return CallingCodesState(
      items: items ?? this.items,
      selected: selected != null ? selected() : this.selected,
      isLoading: isLoading ?? this.isLoading,
      failure: failure != null ? failure() : this.failure,
    );
  }
}
