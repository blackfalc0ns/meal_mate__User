import 'package:meal_meat_user/features/subscription_types/data/models/response/subscription_conversion_options_response_dto.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/conversion_options_model.dart';

extension SubscriptionConversionOptionsResponseDtoMapper
    on SubscriptionConversionOptionsResponseDto {
  ConversionOptionsModel toEntity() {
    return ConversionOptionsModel(
      subscriptionId: subscriptionId ?? '',
      status: status ?? '',
      options: options?.map((option) => option.toEntity()).toList() ?? const [],
    );
  }
}

extension SubscriptionConversionOptionResponseDtoMapper
    on SubscriptionConversionOptionResponseDto {
  ConversionOptionModel toEntity() {
    return ConversionOptionModel(
      code: code ?? '',
      available: available ?? false,
      titleAr: titleAr ?? '',
      titleEn: titleEn ?? '',
      action: action,
      disabledReason: disabledReason,
    );
  }
}
