import 'package:meal_meat_user/features/payment/data/models/request/payment_checkout_request_dto.dart';
import 'package:meal_meat_user/features/calendar/data/models/response/calendar_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_checkout_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_method_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_status_response_dto.dart';

abstract interface class PaymentRemoteDataSource {
  Future<List<PaymentMethodResponseDto>> getPaymentMethods({
    required double amount,
  });

  Future<PaymentCheckoutResponseDto> checkout(
    PaymentCheckoutRequestDto request,
  );

  Future<PaymentStatusResponseDto> getSubscriptionPaymentStatus(
    String subscriptionId,
  );

  Future<CalendarResponseDto> getSubscriptionCalendar(String subscriptionId);
}
