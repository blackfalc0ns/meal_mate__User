import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_customer_delivery_details_usecase.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/delivery/calendar_delivery_details_state.dart';

@injectable
class CalendarDeliveryDetailsViewModel extends Cubit<CalendarDeliveryDetailsState> {
  CalendarDeliveryDetailsViewModel(this._getDeliveryDetailsUseCase)
      : super(const CalendarDeliveryDetailsState());

  final GetCustomerDeliveryDetailsUseCase _getDeliveryDetailsUseCase;

  Future<void> loadDetails(String subscriptionDayId) async {
    if (subscriptionDayId.isEmpty) return;
    emit(state.copyWith(
      subscriptionDayId: subscriptionDayId,
      isLoading: true,
      clearFailure: true,
    ));

    final result = await _getDeliveryDetailsUseCase(
      subscriptionDayId: subscriptionDayId,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(state.copyWith(
          deliveryDetails: result.data,
          isLoading: false,
          clearFailure: true,
        ));
      case ApiErrorResult():
        emit(state.copyWith(
          failure: result.failure,
          isLoading: false,
        ));
    }
  }
}
