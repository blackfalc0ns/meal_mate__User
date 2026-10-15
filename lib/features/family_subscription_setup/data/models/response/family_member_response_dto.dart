import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/core/address/data/models/response/customer_address_response_dto.dart';
import 'package:meal_meat_user/features/food_preferences/data/models/response/food_preferences_response_dto.dart';

part 'family_member_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilyMemberResponseDto {
  const FamilyMemberResponseDto({
    this.memberId,
    this.memberSubscriptionId,
    this.currentSubscriptionId,
    this.upcomingSubscriptionId,
    this.customerUserId,
    this.phoneNumber,
    this.occupation,
    this.startDate,
    this.role,
    this.displayName,
    this.relationshipCode,
    this.gender,
    this.ageYears,
    this.deliveryAddressId,
    this.setupStatus,
    this.readinessBlocker,
    this.programId,
    this.bundleId,
    this.selectedTier,
    this.durationDays,
    this.includeFriday,
    this.isCurrentUser,
    this.deliveryAddress,
    this.allergies,
    this.allergiesCompleted,
    this.dislikedFoods,
    this.dietaryPreferences,
    this.dietaryCompleted,
    this.hasNoAllergies,
    this.hasNoDietaryRestriction,
    this.subscribeNow,
    this.lifecycle,
  });

  final String? memberId;
  final String? memberSubscriptionId;
  final String? currentSubscriptionId;
  final String? upcomingSubscriptionId;
  final String? customerUserId;
  final String? phoneNumber;
  final String? occupation;
  final String? startDate;
  @JsonKey(fromJson: _roleFromJson)
  final int? role;
  final String? displayName;
  final String? relationshipCode;
  @JsonKey(fromJson: _genderFromJson)
  final int? gender;
  final int? ageYears;
  final String? deliveryAddressId;
  @JsonKey(fromJson: _setupStatusFromJson)
  final int? setupStatus;
  final String? readinessBlocker;
  final String? programId;
  final String? bundleId;
  @JsonKey(fromJson: _tierFromJson)
  final int? selectedTier;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? durationDays;
  final bool? includeFriday;
  final bool? isCurrentUser;
  final CustomerAddressResponseDto? deliveryAddress;
  final List<FoodPreferenceItemResponseDto>? allergies;
  final bool? allergiesCompleted;
  final List<FoodPreferenceItemResponseDto>? dislikedFoods;
  final List<FoodPreferenceItemResponseDto>? dietaryPreferences;
  final bool? dietaryCompleted;
  final bool? hasNoAllergies;
  final bool? hasNoDietaryRestriction;
  final bool? subscribeNow;
  final FamilyMemberLifecycleResponseDto? lifecycle;

  factory FamilyMemberResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyMemberLifecycleResponseDto {
  const FamilyMemberLifecycleResponseDto({
    this.status,
    this.checkoutSelected,
    this.paymentStatus,
    this.fulfillmentStatus,
    this.serviceStatus,
    this.accessStatus,
    this.displayStatus,
  });

  final String? status;
  final bool? checkoutSelected;
  final String? paymentStatus;
  final String? fulfillmentStatus;
  final String? serviceStatus;
  final String? accessStatus;
  final String? displayStatus;

  factory FamilyMemberLifecycleResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FamilyMemberLifecycleResponseDtoFromJson(json);
}

int? _roleFromJson(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) {
    if (value.toLowerCase() == 'manager') return 1;
    return int.tryParse(value) ?? 2;
  }
  return null;
}

int? _genderFromJson(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) {
    if (value.toLowerCase() == 'female' || value == '2') return 2;
    return int.tryParse(value) ?? 1;
  }
  return null;
}

int? _setupStatusFromJson(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) {
    final lower = value.toLowerCase();
    if (lower == 'ready' || lower == 'completed') return 2;
    if (lower == 'inprogress') return 1;
    if (lower == 'notstarted') return 0;
    return int.tryParse(value);
  }
  return null;
}

int? _tierFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) {
    final lower = value.toLowerCase().trim();
    if (lower == 'basic' || lower == 'select' || lower == '1') return 1;
    if (lower == 'platinum' ||
        lower == 'plat' ||
        lower == 'plus' ||
        lower == '2') {
      return 2;
    }
    if (lower == 'elite' || lower == 'max' || lower == '3') return 3;
    return int.tryParse(value);
  }
  return null;
}

int? _nullableIntFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
