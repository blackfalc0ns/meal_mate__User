import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_pricing_preview_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_summary_request_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/repo/subscription_summary_repository.dart';

@injectable
class GetSubscriptionPricingPreviewUseCase {
  const GetSubscriptionPricingPreviewUseCase(this._repository);

  final SubscriptionSummaryRepository _repository;

  Future<ApiResult<SubscriptionPricingPreviewResponseDto>> call(
    SubscriptionSummaryRequestEntity request,
  ) {
    return _repository.getPricingPreview(request);
  }
}
