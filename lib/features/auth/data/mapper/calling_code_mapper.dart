import 'package:meal_meat_user/features/auth/data/models/response/calling_code_response_dto.dart';
import 'package:meal_meat_user/features/auth/domain/entities/calling_code_entity.dart';

extension CallingCodeResponseDtoMapper on CallingCodeResponseDto {
  CallingCodeEntity toEntity() {
    return CallingCodeEntity(
      countryCode: countryCode ?? '',
      nameAr: nameAr ?? '',
      nameEn: nameEn ?? '',
      dialCode: dialCode ?? '',
      flagEmoji: flagEmoji ?? '',
    );
  }
}
