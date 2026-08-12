import 'package:json_annotation/json_annotation.dart';

part 'update_customer_profile_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class UpdateCustomerProfileRequestDto {
  const UpdateCustomerProfileRequestDto({
    required this.fullName,
    this.phoneNumber,
    required this.preferredLanguage,
    this.defaultRegionId,
    this.deliveryAddressLine,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.dateOfBirth,
  });

  final String fullName;
  final String? phoneNumber;
  final String preferredLanguage;
  final String? defaultRegionId;
  final String? deliveryAddressLine;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final String? dateOfBirth;

  Map<String, dynamic> toJson() =>
      _$UpdateCustomerProfileRequestDtoToJson(this);
}
