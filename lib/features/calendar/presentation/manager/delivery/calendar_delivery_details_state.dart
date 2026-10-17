import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/customer_delivery_entity.dart';

class CalendarDeliveryDetailsState {
  const CalendarDeliveryDetailsState({
    this.subscriptionDayId = '',
    this.deliveryDetails,
    this.isLoading = false,
    this.failure,
  });

  final String subscriptionDayId;
  final CustomerDeliveryDetailsEntity? deliveryDetails;
  final bool isLoading;
  final Failure? failure;

  CustomerDeliveryItemEntity? get deliveryItem => deliveryDetails?.delivery;

  CalendarDeliveryDetailsState copyWith({
    String? subscriptionDayId,
    CustomerDeliveryDetailsEntity? deliveryDetails,
    bool? isLoading,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return CalendarDeliveryDetailsState(
      subscriptionDayId: subscriptionDayId ?? this.subscriptionDayId,
      deliveryDetails: deliveryDetails ?? this.deliveryDetails,
      isLoading: isLoading ?? this.isLoading,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}
