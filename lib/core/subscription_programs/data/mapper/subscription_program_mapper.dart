import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/subscription_programs/data/models/response/subscription_program_response_dto.dart';
import 'package:meal_meat_user/core/subscription_programs/domain/entities/subscription_program_entity.dart';

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
      fallbackImageAsset: _fallbackImageAssetForCode(normalizedCode),
    );
  }

  String _fallbackImageAssetForCode(String code) {
    return switch (code) {
      'PROG_WEIGHT_LOSS' => AssetsFake.subscriptionProgramWeightLoss,
      'PROG_MUSCLE_GAIN' => AssetsFake.subscriptionProgramMuscleGain,
      'PROG_BALANCED' => AssetsFake.subscriptionProgramBalanced,
      _ => AssetsFake.subscriptionProgramCutting,
    };
  }
}
