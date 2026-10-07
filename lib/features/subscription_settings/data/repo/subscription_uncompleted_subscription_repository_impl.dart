import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_settings/data/data_source/subscription_billing_remote_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/subscription_billing_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/subscription_billing_action_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_billing_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/repo/subscription_uncompleted_subscription_repository.dart';

@Injectable(as: SubscriptionUncompletedSubscriptionRepository)
class SubscriptionUncompletedSubscriptionRepositoryImpl
    implements SubscriptionUncompletedSubscriptionRepository {
  const SubscriptionUncompletedSubscriptionRepositoryImpl(
    this._remoteDataSource,
  );

  final SubscriptionBillingRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<void>> deleteUncompletedSubscription(String subscriptionId) {
    return safeApiCall(
      () => _remoteDataSource.deleteUncompletedCustomerSubscription(
        subscriptionId,
      ),
    );
  }

  @override
  Future<ApiResult<SubscriptionBillingResumePreviewEntity>> getResumePreview(
    String subscriptionId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource
          .getCustomerSubscriptionResumePreview(subscriptionId);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<SubscriptionBillingResumeEntity>> resumeSubscription({
    required String subscriptionId,
    String? startDate,
    int? paymentMethodId,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.resumeCustomerSubscription(
        subscriptionId,
        SubscriptionBillingResumeRequestDto(
          startDate: startDate,
          paymentMethodId: paymentMethodId,
        ),
      );
      return response.toEntity();
    });
  }
}
