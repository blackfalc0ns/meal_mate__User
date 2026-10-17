import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/data/services/customer_delivery_realtime_service.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_customer_delivery_details_usecase.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/delivery/calendar_delivery_details_state.dart';

@injectable
class CalendarDeliveryDetailsViewModel
    extends Cubit<CalendarDeliveryDetailsState> {
  CalendarDeliveryDetailsViewModel(
    this._getDeliveryDetailsUseCase, [
    this._realtimeService,
  ]) : super(const CalendarDeliveryDetailsState()) {
    _listenToRealtimeDelivery();
  }

  final GetCustomerDeliveryDetailsUseCase _getDeliveryDetailsUseCase;
  final CustomerDeliveryRealtimeService? _realtimeService;

  StreamSubscription<String>? _realtimeSubscription;
  Timer? _reconciliationTimer;

  void _listenToRealtimeDelivery() {
    unawaited(_realtimeService?.connect());
    _realtimeSubscription = _realtimeService?.onDeliveryChanged.listen((dayId) {
      if (isClosed) return;
      if (dayId.isEmpty || dayId == state.subscriptionDayId) {
        final currentDayId = state.subscriptionDayId;
        if (currentDayId.isNotEmpty) {
          unawaited(loadDetails(currentDayId));
        }
      }
    });
  }

  void _scheduleReconciliation(int seconds) {
    _reconciliationTimer?.cancel();
    if (isClosed || seconds <= 0) return;
    _reconciliationTimer = Timer(Duration(seconds: seconds), () {
      if (isClosed) return;
      final currentDayId = state.subscriptionDayId;
      if (currentDayId.isNotEmpty) {
        unawaited(loadDetails(currentDayId));
      }
    });
  }

  Future<void> loadDetails(String subscriptionDayId) async {
    if (subscriptionDayId.isEmpty) return;
    emit(
      state.copyWith(
        subscriptionDayId: subscriptionDayId,
        isLoading: true,
        clearFailure: true,
      ),
    );

    final result = await _getDeliveryDetailsUseCase(
      subscriptionDayId: subscriptionDayId,
    );

    if (isClosed) return;

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            deliveryDetails: result.data,
            isLoading: false,
            clearFailure: true,
          ),
        );
        _scheduleReconciliation(result.data.refreshAfterSeconds ?? 30);
      case ApiErrorResult():
        emit(
          state.copyWith(
            failure: result.failure,
            isLoading: false,
          ),
        );
    }
  }

  @override
  Future<void> close() async {
    _reconciliationTimer?.cancel();
    await _realtimeSubscription?.cancel();
    return super.close();
  }
}
