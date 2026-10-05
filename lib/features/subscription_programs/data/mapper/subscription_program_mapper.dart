import 'package:meal_meat_user/core/entities/paged_entity.dart';
import 'package:meal_meat_user/core/network/mapper/pagination_mapper.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_program_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_programs_page_response_dto.dart';
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

extension SubscriptionProgramsPageResponseDtoMapper
    on SubscriptionProgramsPageResponseDto {
  PagedEntity<SubscriptionProgramEntity> toEntity() {
    return PagedEntity<SubscriptionProgramEntity>(
      items: (items ?? const [])
          .map((dto) => dto.toEntity())
          .where((program) => program.programId.isNotEmpty)
          .toList(),
      pagination: effectivePagination.toEntity(),
    );
  }
}
