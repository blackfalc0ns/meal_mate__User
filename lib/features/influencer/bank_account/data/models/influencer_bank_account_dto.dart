import 'package:json_annotation/json_annotation.dart';

part 'influencer_bank_account_dto.g.dart';

@JsonSerializable(createToJson: false)
class InfluencerBankDto {
  const InfluencerBankDto({
    this.id,
    this.code,
    this.nameAr,
    this.nameEn,
    this.isActive,
  });
  factory InfluencerBankDto.fromJson(Map<String, dynamic> json) =>
      _$InfluencerBankDtoFromJson(json);
  final String? id, code, nameAr, nameEn;
  final bool? isActive;
}

@JsonSerializable(createToJson: false)
class InfluencerBankAccountResponseDto {
  const InfluencerBankAccountResponseDto({
    this.bankName,
    this.accountHolderName,
    this.iban,
    this.maskedIban,
    this.isConfigured,
  });
  factory InfluencerBankAccountResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$InfluencerBankAccountResponseDtoFromJson(json);
  final String? bankName, accountHolderName, iban, maskedIban;
  final bool? isConfigured;
}

@JsonSerializable(createFactory: false)
class InfluencerBankAccountRequestDto {
  const InfluencerBankAccountRequestDto({
    required this.bankName,
    required this.accountHolderName,
    required this.iban,
  });
  final String bankName, accountHolderName, iban;
  Map<String, dynamic> toJson() =>
      _$InfluencerBankAccountRequestDtoToJson(this);
}

@JsonSerializable(createToJson: false)
class InfluencerBankAccountDeleteResponseDto {
  const InfluencerBankAccountDeleteResponseDto({this.isSuccess});
  factory InfluencerBankAccountDeleteResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$InfluencerBankAccountDeleteResponseDtoFromJson(json);
  final bool? isSuccess;
}
