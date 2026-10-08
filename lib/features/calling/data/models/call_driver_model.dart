import 'package:meal_meat_user/features/calling/domain/entities/call_driver_entity.dart';

class CallDriverModel extends CallDriverEntity {
  const CallDriverModel({
    required super.name,
    required super.role,
    required super.avatarAsset,
    required super.addressTitle,
    required super.addressDetails,
  });

  factory CallDriverModel.fromJson(Map<String, dynamic> json) {
    return CallDriverModel(
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      avatarAsset: json['avatarAsset'] as String? ?? '',
      addressTitle: json['addressTitle'] as String? ?? '',
      addressDetails: json['addressDetails'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'avatarAsset': avatarAsset,
      'addressTitle': addressTitle,
      'addressDetails': addressDetails,
    };
  }
}
