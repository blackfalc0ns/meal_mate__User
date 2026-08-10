import 'package:meal_meat_user/features/auth/data/models/request/register_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/register_response_dto.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/register_request_entity.dart';

extension RegisterRequestEntityMapper on RegisterRequestEntity {
  RegisterRequestDto toDto() {
    return RegisterRequestDto(
      fullName: fullName,
      phone: phone,
      password: password,
      countryCode: countryCode,
    );
  }
}

extension RegisterResponseDtoMapper on RegisterResponseDto {
  RegisterEntity toEntity() {
    return RegisterEntity(
      userId: userId ?? '',
      phone: phone ?? '',
      otpSent: otpSent ?? false,
      nextStep: nextStep ?? '',
    );
  }
}
