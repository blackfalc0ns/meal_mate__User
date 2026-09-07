import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/data/data_source/profile_remote_data_source.dart';
import 'package:meal_meat_user/features/profile/data/mapper/profile_billing_mapper.dart';
import 'package:meal_meat_user/features/profile/data/models/request/profile_billing_action_request_dto.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/domain/repo/profile_uncompleted_subscription_repository.dart';

@Injectable(as: ProfileUncompletedSubscriptionRepository)
class ProfileUncompletedSubscriptionRepositoryImpl
    implements ProfileUncompletedSubscriptionRepository {
  const ProfileUncompletedSubscriptionRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResult<void>> deleteUncompletedSubscription(String subscriptionId) {
    return safeApiCall(
      () => _remoteDataSource.deleteUncompletedCustomerSubscription(
        subscriptionId,
      ),
    );
  }

  @override
  Future<ApiResult<ProfileBillingResumePreviewEntity>> getResumePreview(
    String subscriptionId,
  ) {
    return safeApiCall(() async {
      final response = await _remoteDataSource
          .getCustomerSubscriptionResumePreview(subscriptionId);
      return response.toEntity();
    });
  }

  @override
  Future<ApiResult<ProfileBillingResumeEntity>> resumeSubscription({
    required String subscriptionId,
    String? startDate,
    int? paymentMethodId,
  }) {
    return safeApiCall(() async {
      final response = await _remoteDataSource.resumeCustomerSubscription(
        subscriptionId,
        ProfileBillingResumeRequestDto(
          startDate: startDate,
          paymentMethodId: paymentMethodId,
        ),
      );
      return response.toEntity();
    });
  }
}
