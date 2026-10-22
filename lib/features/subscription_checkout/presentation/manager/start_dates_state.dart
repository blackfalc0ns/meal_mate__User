import 'package:meal_meat_user/core/errors/failures.dart';
import '../../domain/entities/eligible_start_dates_entity.dart';

class StartDatesState {
  const StartDatesState({this.isLoading = false, this.data, this.failure});
  final bool isLoading;
  final EligibleStartDatesEntity? data;
  final Failure? failure;
}
