import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/family_checkout/data/data_source/family_checkout_remote_data_source.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/request/family_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/request/family_renewal_checkout_request_dto.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/response/family_summary_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_checkout_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_method_response_dto.dart';

import 'package:meal_meat_user/features/family_checkout/data/models/request/family_checkout_selection_request_dto.dart';
import 'package:meal_meat_user/features/family_checkout/data/models/response/family_checkout_selection_response_dto.dart';

@Injectable(as: FamilyCheckoutRemoteDataSource)
class FamilyCheckoutRemoteDataSourceImpl
    implements FamilyCheckoutRemoteDataSource {
  FamilyCheckoutRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<FamilyCheckoutSelectionResponseDto> selectFamilyMemberForCheckout({
    required String memberId,
    required bool subscribeNow,
  }) {
    return _apiServices.selectFamilyMemberForCheckout(
      memberId,
      FamilyCheckoutSelectionRequestDto(subscribeNow: subscribeNow),
    );
  }

  @override
  Future<void> saveFamilyMemberStartDate({
    required String memberId,
    required String startDate,
  }) {
    return _apiServices.saveFamilyMemberStartDate(
      memberId,
      {'startDate': startDate},
    );
  }

  @override
  Future<FamilySummaryResponseDto> getFamilySummary({String? memberId}) {
    return _apiServices.getFamilySummary(memberId: memberId);
  }

  @override
  Future<List<PaymentMethodResponseDto>> getFamilyPaymentMethods(
    double amount,
  ) {
    return _apiServices.getFamilyPaymentMethods(amount);
  }

  @override
  Future<PaymentCheckoutResponseDto> checkoutFamilySubscription(
    FamilyCheckoutRequestDto request,
  ) {
    return _apiServices.checkoutFamilySubscription(request);
  }

  @override
  Future<PaymentCheckoutResponseDto> retryFamilySubscriptionPayment(
    FamilyCheckoutRequestDto request,
  ) {
    return _apiServices.retryFamilySubscriptionPayment(request);
  }

  @override
  Future<PaymentCheckoutResponseDto> checkoutFamilyRenewal({
    required String renewalRequestId,
    required FamilyRenewalCheckoutRequestDto request,
  }) {
    return _apiServices.checkoutFamilyRenewal(renewalRequestId, request);
  }
}
