import 'package:json_annotation/json_annotation.dart';

part 'map_reverse_geocode_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class MapReverseGeocodeRequestDto {
  const MapReverseGeocodeRequestDto({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  Map<String, dynamic> toJson() => _$MapReverseGeocodeRequestDtoToJson(this);
}
