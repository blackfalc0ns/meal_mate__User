import 'package:json_annotation/json_annotation.dart';

part 'map_geocode_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class MapGeocodeRequestDto {
  const MapGeocodeRequestDto({required this.address, this.countryCode = 'KW'});

  final String address;
  final String countryCode;

  Map<String, dynamic> toJson() => _$MapGeocodeRequestDtoToJson(this);
}
