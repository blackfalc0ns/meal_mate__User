import 'package:meal_meat_user/features/family_programs/data/models/response/subscription_program_response_dto.dart';
import 'package:meal_meat_user/features/family_programs/domain/entities/subscription_program_entity.dart';

extension FamilyProgramResponseDtoMapper on FamilyProgramResponseDto {
  SubscriptionProgramEntity toEntity() {
    return SubscriptionProgramEntity(
      programId: programId ?? '',
      code: code ?? '',
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
