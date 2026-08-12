import 'package:json_annotation/json_annotation.dart';

part 'change_customer_password_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class ChangeCustomerPasswordRequestDto {
  const ChangeCustomerPasswordRequestDto({
    required this.currentPassword,
    required this.newPassword,
  });

  final String currentPassword;
  final String newPassword;

  Map<String, dynamic> toJson() =>
      _$ChangeCustomerPasswordRequestDtoToJson(this);
}
