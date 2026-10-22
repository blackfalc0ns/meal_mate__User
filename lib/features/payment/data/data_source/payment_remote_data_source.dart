import 'package:meal_meat_user/features/calendar/data/models/response/calendar_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_status_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_confirmation_response_dto.dart';

abstract interface class PaymentRemoteDataSource {
  Future<PaymentStatusResponseDto> getSubscriptionPaymentStatus(
    String subscriptionId,
  );

  Future<CalendarResponseDto> getSubscriptionCalendar(String subscriptionId);

  Future<SubscriptionConfirmationResponseDto> getSubscriptionConfirmation(
    String subscriptionId,
  );
}
