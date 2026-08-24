import 'package:meal_meat_user/features/family_checkout/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_checkout_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_method_response_dto.dart';

abstract class FamilyCheckoutRemoteDataSource {
  Future<FamilySummaryResponseDto> getFamilySummary({String? memberId});
  Future<List<PaymentMethodResponseDto>> getFamilyPaymentMethods(double amount);
  Future<PaymentCheckoutResponseDto> checkoutFamilySubscription(
    FamilyCheckoutRequestDto request,
  );
}
