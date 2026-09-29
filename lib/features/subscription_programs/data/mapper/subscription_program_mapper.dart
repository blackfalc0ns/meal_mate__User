import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_program_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

extension SubscriptionProgramResponseDtoMapper
    on SubscriptionProgramResponseDto {
  SubscriptionProgramEntity toEntity() {
    final normalizedCode = code ?? '';

    return SubscriptionProgramEntity(
      programId: programId ?? '',
      code: normalizedCode,
      shortCode: shortCode ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      descriptionAr: descriptionAr ?? '',
      descriptionEn: descriptionEn ?? '',
      keywordsAr: keywordsAr ?? const [],
      keywordsEn: keywordsEn ?? const [],
      imageUrl: imageUrl,
      bundleCount: bundleCount ?? 0,
      supportedSlots: supportedSlots ?? const [],
      fallbackImageAsset: '',
    );
  }
}
