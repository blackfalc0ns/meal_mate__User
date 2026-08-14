import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_services.dart';
import 'package:meal_meat_user/features/payment/data/data_source/payment_remote_data_source.dart';
import 'package:meal_meat_user/features/payment/data/models/request/payment_checkout_request_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_checkout_response_dto.dart';
import 'package:meal_meat_user/features/payment/data/models/response/payment_method_response_dto.dart';

@Injectable(as: PaymentRemoteDataSource)
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  PaymentRemoteDataSourceImpl(this._apiServices);

  final ApiServices _apiServices;

  @override
  Future<List<PaymentMethodResponseDto>> getPaymentMethods({
    required double amount,
  }) {
    return _apiServices.getPaymentMethods(amount);
  }

  @override
  Future<PaymentCheckoutResponseDto> checkout(
    PaymentCheckoutRequestDto request,
  ) {
    return _apiServices.checkoutSubscription(request);
  }

  @override
  Future<void> getSubscriptionCalendar(String subscriptionId) {
    return _apiServices.getSubscriptionCalendar(subscriptionId);
  }
}
