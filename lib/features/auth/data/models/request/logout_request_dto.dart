import 'package:json_annotation/json_annotation.dart';

part 'logout_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class LogoutRequestDto {
  const LogoutRequestDto({required this.refreshToken});

  final String refreshToken;

  Map<String, dynamic> toJson() => _$LogoutRequestDtoToJson(this);
}
