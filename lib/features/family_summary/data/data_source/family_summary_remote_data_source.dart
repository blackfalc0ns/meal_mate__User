import 'package:meal_meat_user/features/family_summary/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_summary/data/models/request/family_renewal_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_summary/data/models/response/family_checkout_selection_response_dto.dart';
import 'package:meal_meat_user/features/family_summary/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_checkout_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_method_response_dto.dart';

abstract class FamilySummaryRemoteDataSource {
  Future<FamilyCheckoutSelectionResponseDto> selectFamilyMemberForCheckout({
    required String memberId,
    required bool subscribeNow,
  });
  Future<void> saveFamilyMemberStartDate({
    required String memberId,
    required String startDate,
  });
  Future<FamilySummaryResponseDto> getFamilySummary({
    String? memberId,
    String? promoCode,
  });
  Future<List<PaymentMethodResponseDto>> getFamilyPaymentMethods(double amount);
  Future<PaymentCheckoutResponseDto> checkoutFamilySubscription(
    FamilyCheckoutRequestDto request,
  );
  Future<PaymentCheckoutResponseDto> retryFamilySubscriptionPayment(
    FamilyCheckoutRequestDto request,
  );
  Future<PaymentCheckoutResponseDto> checkoutFamilyRenewal({
    required String renewalRequestId,
    required FamilyRenewalCheckoutRequestDto request,
  });
}

typedef FamilyCheckoutRemoteDataSource = FamilySummaryRemoteDataSource;
