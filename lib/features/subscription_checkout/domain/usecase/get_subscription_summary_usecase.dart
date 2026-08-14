import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_summary_repository.dart';

@injectable
class GetSubscriptionSummaryUseCase {
  GetSubscriptionSummaryUseCase(this._repository);

  final SubscriptionSummaryRepository _repository;

  Future<ApiResult<SubscriptionSummaryEntity>> call(
    SubscriptionSummaryRequestEntity request,
  ) {
    return _repository.getSummary(request);
  }
}
