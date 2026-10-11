import 'package:meal_meat_user/core/entities/paged_entity.dart';
import 'package:meal_meat_user/core/network/mapper/pagination_mapper.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/mapper/subscription_availability_mapper.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_program_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/data/models/response/subscription_programs_page_response_dto.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_programs_page_entity.dart';

extension SubscriptionProgramResponseDtoMapper
    on SubscriptionProgramResponseDto {
  SubscriptionProgramEntity toEntity() {
    final base = option ?? this;
    final normalizedCode = base.code ?? '';

    return SubscriptionProgramEntity(
      programId: base.programId ?? '',
      code: normalizedCode,
      shortCode: base.shortCode ?? '',
      nameAr: base.nameAr ?? '',
      nameEn: base.nameEn ?? '',
      descriptionAr: base.descriptionAr ?? '',
      descriptionEn: base.descriptionEn ?? '',
      keywordsAr: base.keywordsAr ?? const [],
      keywordsEn: base.keywordsEn ?? const [],
      imageUrl: base.imageUrl,
      bundleCount: base.bundleCount ?? 0,
      supportedSlots: base.supportedSlots ?? const [],
      fallbackImageAsset: '',
      isAvailable: isAvailable ?? option?.isAvailable ?? true,
      disabledReason: disabledReason ?? option?.disabledReason,
      availability: (availability ?? option?.availability)?.toEntity(),
    );
  }
}

extension SubscriptionProgramsPageResponseDtoMapper
    on SubscriptionProgramsPageResponseDto {
  PagedEntity<SubscriptionProgramEntity> toEntity() {
    return SubscriptionProgramsPageEntity(
      items: effectiveItems
          .map((dto) => dto.toEntity())
          .where((program) => program.programId.isNotEmpty)
          .toList(),
      pagination: effectivePagination.toEntity(),
      addressCoverage: addressCoverage?.status,
      hasDeliveryAddress: hasDeliveryAddress,
    );
  }
}
