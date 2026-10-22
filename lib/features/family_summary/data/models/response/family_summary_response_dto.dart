import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_coupon_response_dto.dart';

part 'family_summary_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class FamilySummaryMemberDto {
  const FamilySummaryMemberDto({
    this.memberId,
    this.displayName,
    this.isManager,
    this.setupStatus,
    this.isReady,
    this.roleAr,
    this.gender,
    this.durationDays,
    this.selectedTier,
    this.includeFriday,
    this.startDate,
  });

  @JsonKey(readValue: _readMemberId)
  final String? memberId;
  final String? displayName;
  @JsonKey(readValue: _readIsManager)
  final bool? isManager;
  @JsonKey(fromJson: _setupStatusFromJson)
  final int? setupStatus;
  @JsonKey(readValue: _readIsReady)
  final bool? isReady;
  final String? roleAr;
  final int? gender;
  final int? durationDays;
  final String? selectedTier;
  final bool? includeFriday;
  final String? startDate;

  factory FamilySummaryMemberDto.fromJson(Map<String, dynamic> json) {
    final generated = _$FamilySummaryMemberDtoFromJson(json);
    final genderRaw = json['gender'];
    final gender = genderRaw is int
        ? genderRaw
        : (genderRaw == 'Female' ? 2 : 1);
    return FamilySummaryMemberDto(
      memberId: generated.memberId,
      displayName: generated.displayName,
      isManager: generated.isManager,
      setupStatus: generated.setupStatus,
      isReady: generated.isReady,
      roleAr: generated.roleAr,
      gender: gender,
      durationDays: _nullableIntFromJson(json['durationDays']),
      selectedTier: json['selectedTier'] as String?,
      includeFriday: json['includeFriday'] as bool?,
      startDate: json['startDate'] as String?,
    );
  }
}

@JsonSerializable(createToJson: false)
class FamilySelectedMemberSummaryDto {
  const FamilySelectedMemberSummaryDto({
    this.memberId,
    this.displayName,
    this.isManager,
    this.roleAr,
    this.setupStatus,
    this.isReady,
    this.programNameAr,
    this.programNameEn,
    this.bundleNameAr,
    this.bundleNameEn,
    this.durationDays,
    this.durationLabelAr,
    this.durationLabelEn,
    this.selectedTier,
    this.tierNameAr,
    this.tierNameEn,
    this.includeFriday,
    this.breakfast,
    this.lunch,
    this.snack,
    this.dinner,
    this.mealsPerDay,
    this.memberPrice,
    this.startDate,
    this.addressLine,
  });

  @JsonKey(readValue: _readMemberId)
  final String? memberId;
  final String? displayName;
  @JsonKey(readValue: _readIsManager)
  final bool? isManager;
  final String? roleAr;
  @JsonKey(fromJson: _setupStatusFromJson)
  final int? setupStatus;
  @JsonKey(readValue: _readIsReady)
  final bool? isReady;
  @JsonKey(readValue: _readProgramNameAr)
  final String? programNameAr;
  final String? programNameEn;
  @JsonKey(readValue: _readBundleNameAr)
  final String? bundleNameAr;
  final String? bundleNameEn;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? durationDays;
  @JsonKey(readValue: _readDurationLabelAr)
  final String? durationLabelAr;
  final String? durationLabelEn;
  @JsonKey(readValue: _readSelectedTier, fromJson: _tierFromJson)
  final int? selectedTier;
  @JsonKey(readValue: _readTierNameAr)
  final String? tierNameAr;
  final String? tierNameEn;
  final bool? includeFriday;
  final bool? breakfast;
  final bool? lunch;
  final bool? snack;
  final bool? dinner;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? mealsPerDay;
  @JsonKey(readValue: _readMemberPrice)
  final double? memberPrice;
  final String? startDate;
  final String? addressLine;

  factory FamilySelectedMemberSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$FamilySelectedMemberSummaryDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyMealOverviewDto {
  const FamilyMealOverviewDto({
    this.memberId,
    this.displayName,
    this.breakfast,
    this.lunch,
    this.snack,
    this.dinner,
    this.mealsPerDay,
    this.isReady,
    this.isManager,
  });

  @JsonKey(readValue: _readMemberId)
  final String? memberId;
  final String? displayName;
  final bool? breakfast;
  final bool? lunch;
  final bool? snack;
  final bool? dinner;
  @JsonKey(fromJson: _mealCountFromJson)
  final int? mealsPerDay;
  @JsonKey(readValue: _readIsReady)
  final bool? isReady;
  @JsonKey(readValue: _readIsManager)
  final bool? isManager;

  factory FamilyMealOverviewDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMealOverviewDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyMemberRestaurantDto {
  const FamilyMemberRestaurantDto({
    this.restaurantId,
    this.logoUrl,
    this.name,
    this.nameAr,
    this.occurrenceCount,
  });

  @JsonKey(readValue: _readRestaurantId)
  final String? restaurantId;
  final String? logoUrl;
  final String? name;
  final String? nameAr;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? occurrenceCount;

  factory FamilyMemberRestaurantDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberRestaurantDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyMemberRestaurantRepetitionDto {
  const FamilyMemberRestaurantRepetitionDto({
    this.limit,
    this.restaurantCount,
    this.durationDays,
  });

  @JsonKey(fromJson: _nullableIntFromJson)
  final int? limit;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? restaurantCount;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? durationDays;

  factory FamilyMemberRestaurantRepetitionDto.fromJson(
    Map<String, dynamic> json,
  ) => _$FamilyMemberRestaurantRepetitionDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilyMemberScheduleDto {
  const FamilyMemberScheduleDto({
    this.memberId,
    this.paymentDate,
    this.firstDeliveryDate,
    this.endDate,
    this.deliveryDaysCount,
    this.mealsPerDay,
    this.totalMeals,
    this.restaurants,
    this.restaurantRepetition,
    this.addressLine,
  });

  @JsonKey(readValue: _readMemberId)
  final String? memberId;
  final String? paymentDate;
  final String? firstDeliveryDate;
  final String? endDate;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? deliveryDaysCount;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? mealsPerDay;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? totalMeals;
  @JsonKey(fromJson: _restaurantsFromJson)
  final List<FamilyMemberRestaurantDto>? restaurants;
  final FamilyMemberRestaurantRepetitionDto? restaurantRepetition;
  final String? addressLine;

  factory FamilyMemberScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$FamilyMemberScheduleDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilySummaryAvailabilityDto {
  const FamilySummaryAvailabilityDto({
    this.status,
    this.coveredRestaurantCount,
    this.eligibleRestaurantCount,
    this.checkedAtUtc,
    this.effectiveStartDate,
    this.messageCode,
    this.failureReasons,
  });

  final String? status;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? coveredRestaurantCount;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? eligibleRestaurantCount;
  final String? checkedAtUtc;
  final String? effectiveStartDate;
  final String? messageCode;
  final Map<String, dynamic>? failureReasons;

  factory FamilySummaryAvailabilityDto.fromJson(Map<String, dynamic> json) =>
      _$FamilySummaryAvailabilityDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class FamilySummaryResponseDto {
  const FamilySummaryResponseDto({
    this.familyGroupId,
    this.familyName,
    this.selectedMemberId,
    this.subtotal,
    this.familyDiscountPercent,
    this.familyDiscountAmount,
    this.finalPrice,
    this.currencyCode,
    this.canCheckout,
    this.checkoutBlockReason,
    this.managerPrepaid,
    this.managerSubscriptionId,
    this.newMembersCount,
    this.newMembersSubtotal,
    this.members,
    this.selectedMember,
    this.mealOverview,
    this.memberSchedules,
    this.participantCount,
    this.checkoutEndpoint,
    this.batchId,
    this.batchVersion,
    this.rosterCount,
    this.selectedNewSubscriberCount,
    this.eligibleExistingSubscriberCount,
    this.unsubscribedCount,
    this.lockedQuote,
    this.selectedFamilyPackageId,
    this.effectiveFamilyPackageId,
    this.effectiveFamilyPackageMinMembers,
    this.effectiveFamilyPackageMaxMembers,
    this.packageSelectionMode,
    this.occupiedSeatCount,
    this.availableSeatCount,
    this.maxSeats,
    this.deferredMemberCount,
    this.currentPurchaseCount,
    this.managerSeatExempt,
    this.managerIndividualIsLive,
    this.isInitialPurchaseOrReactivation,
    this.availability,
    this.restaurantRepetition,
    this.discount,
    this.walletCredit,
    this.gatewayFee,
    this.blockingReasons,
    this.expiry,
    this.summaryExpiresAtUtc,
    this.serverNow,
    this.serverNowUtc,
    this.coupon,
    this.promoCode,
  });

  final String? familyGroupId;
  final String? familyName;
  final String? selectedMemberId;

  @JsonKey(fromJson: _nullableDoubleFromJson)
  final double? subtotal;
  @JsonKey(fromJson: _nullableDoubleFromJson)
  final double? familyDiscountPercent;
  @JsonKey(fromJson: _nullableDoubleFromJson)
  final double? familyDiscountAmount;
  @JsonKey(fromJson: _nullableDoubleFromJson)
  final double? finalPrice;
  final String? currencyCode;
  final bool? canCheckout;
  final String? checkoutBlockReason;
  final bool? managerPrepaid;
  final String? managerSubscriptionId;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? newMembersCount;
  @JsonKey(fromJson: _nullableDoubleFromJson)
  final double? newMembersSubtotal;
  final List<FamilySummaryMemberDto>? members;
  final FamilySelectedMemberSummaryDto? selectedMember;
  final List<FamilyMealOverviewDto>? mealOverview;
  final List<FamilyMemberScheduleDto>? memberSchedules;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? participantCount;
  final String? checkoutEndpoint;
  final String? batchId;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? batchVersion;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? rosterCount;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? selectedNewSubscriberCount;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? eligibleExistingSubscriberCount;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? unsubscribedCount;
  final bool? lockedQuote;
  final String? selectedFamilyPackageId;
  final String? effectiveFamilyPackageId;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? effectiveFamilyPackageMinMembers;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? effectiveFamilyPackageMaxMembers;
  final String? packageSelectionMode;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? occupiedSeatCount;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? availableSeatCount;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? maxSeats;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? deferredMemberCount;
  @JsonKey(fromJson: _nullableIntFromJson)
  final int? currentPurchaseCount;
  final bool? managerSeatExempt;
  final bool? managerIndividualIsLive;
  final bool? isInitialPurchaseOrReactivation;
  final FamilySummaryAvailabilityDto? availability;
  final FamilyMemberRestaurantRepetitionDto? restaurantRepetition;
  final double? discount;
  final double? walletCredit;
  final double? gatewayFee;
  @JsonKey(fromJson: _blockingReasonCodesFromJson)
  final List<String>? blockingReasons;
  final String? expiry;
  final String? summaryExpiresAtUtc;
  final String? serverNow;
  final String? serverNowUtc;
  final SubscriptionCouponResponseDto? coupon;
  final String? promoCode;

  factory FamilySummaryResponseDto.fromJson(Map<String, dynamic> json) {
    final dto = _$FamilySummaryResponseDtoFromJson(json);
    final blocking =
        dto.blockingReasons ??
        (dto.checkoutBlockReason == null ? null : [dto.checkoutBlockReason!]);

    SubscriptionCouponResponseDto? couponDto;
    if (json['coupon'] is Map<String, dynamic>) {
      couponDto = SubscriptionCouponResponseDto.fromJson(
        json['coupon'] as Map<String, dynamic>,
      );
    } else if (json['coupon'] is Map) {
      couponDto = SubscriptionCouponResponseDto.fromJson(
        Map<String, dynamic>.from(json['coupon'] as Map),
      );
    }

    return FamilySummaryResponseDto(
      familyGroupId: dto.familyGroupId,
      familyName: dto.familyName,
      selectedMemberId: dto.selectedMemberId,
      subtotal: dto.subtotal,
      familyDiscountPercent: dto.familyDiscountPercent,
      familyDiscountAmount: dto.familyDiscountAmount,
      finalPrice: dto.finalPrice,
      currencyCode: dto.currencyCode,
      canCheckout: dto.canCheckout,
      checkoutBlockReason: dto.checkoutBlockReason,
      managerPrepaid: dto.managerPrepaid,
      managerSubscriptionId: dto.managerSubscriptionId,
      newMembersCount: dto.newMembersCount,
      newMembersSubtotal: dto.newMembersSubtotal,
      members: dto.members,
      selectedMember: dto.selectedMember,
      mealOverview: dto.mealOverview,
      memberSchedules: dto.memberSchedules,
      participantCount: dto.participantCount,
      checkoutEndpoint: dto.checkoutEndpoint,
      batchId: dto.batchId,
      batchVersion: dto.batchVersion,
      rosterCount: dto.rosterCount,
      selectedNewSubscriberCount: dto.selectedNewSubscriberCount,
      eligibleExistingSubscriberCount: dto.eligibleExistingSubscriberCount,
      unsubscribedCount: dto.unsubscribedCount,
      lockedQuote: dto.lockedQuote,
      selectedFamilyPackageId: dto.selectedFamilyPackageId,
      effectiveFamilyPackageId: dto.effectiveFamilyPackageId,
      effectiveFamilyPackageMinMembers: dto.effectiveFamilyPackageMinMembers,
      effectiveFamilyPackageMaxMembers: dto.effectiveFamilyPackageMaxMembers,
      packageSelectionMode: dto.packageSelectionMode,
      occupiedSeatCount: dto.occupiedSeatCount,
      availableSeatCount: dto.availableSeatCount,
      maxSeats: dto.maxSeats,
      deferredMemberCount: dto.deferredMemberCount,
      currentPurchaseCount: dto.currentPurchaseCount,
      managerSeatExempt: dto.managerSeatExempt,
      managerIndividualIsLive: dto.managerIndividualIsLive,
      isInitialPurchaseOrReactivation: dto.isInitialPurchaseOrReactivation,
      availability: dto.availability,
      restaurantRepetition: dto.restaurantRepetition,
      discount:
          _nullableDoubleFromJson(json['discount']) ?? dto.familyDiscountAmount,
      walletCredit: _nullableDoubleFromJson(json['walletCredit']) ?? 0.0,
      gatewayFee: _nullableDoubleFromJson(json['gatewayFee']) ?? 0.0,
      blockingReasons: blocking,
      expiry: json['expiry']?.toString(),
      summaryExpiresAtUtc: (json['summaryExpiresAtUtc'] ?? json['expiry'])
          ?.toString(),
      serverNow: json['serverNow']?.toString(),
      serverNowUtc: (json['serverNowUtc'] ?? json['serverNow'])?.toString(),
      coupon: couponDto,
      promoCode: json['promoCode']?.toString(),
    );
  }
}

Object? _readRestaurantId(Map<dynamic, dynamic> json, String key) {
  final val = json[key] ?? json['restaurantId'] ?? json['id'];
  return val?.toString();
}

List<FamilyMemberRestaurantDto>? _restaurantsFromJson(dynamic value) {
  if (value == null) return null;
  if (value is! List) return null;
  final list = <FamilyMemberRestaurantDto>[];
  for (final item in value) {
    if (item is Map<String, dynamic>) {
      list.add(FamilyMemberRestaurantDto.fromJson(item));
    } else if (item is Map) {
      list.add(
        FamilyMemberRestaurantDto.fromJson(Map<String, dynamic>.from(item)),
      );
    } else if (item is String) {
      list.add(
        FamilyMemberRestaurantDto(
          restaurantId: item,
          name: item,
          nameAr: item,
          occurrenceCount: 1,
        ),
      );
    }
  }
  return list;
}

Object? _readMemberId(Map<dynamic, dynamic> json, String key) {
  return json[key] ?? json['id'];
}

Object? _readSelectedTier(Map<dynamic, dynamic> json, String key) {
  return json[key] ?? json['tier'];
}

Object? _readMemberPrice(Map<dynamic, dynamic> json, String key) {
  return json[key] ?? json['price'];
}

Object? _readProgramNameAr(Map<dynamic, dynamic> json, String key) {
  return json['programNameAr'] ?? json['programName'];
}

Object? _readBundleNameAr(Map<dynamic, dynamic> json, String key) {
  return json['bundleNameAr'] ?? json['bundleName'];
}

Object? _readTierNameAr(Map<dynamic, dynamic> json, String key) {
  return json['tierNameAr'] ?? json['tierName'];
}

Object? _readDurationLabelAr(Map<dynamic, dynamic> json, String key) {
  return json['durationLabelAr'] ?? json['durationLabel'];
}

Object? _readIsManager(Map<dynamic, dynamic> json, String key) {
  if (json.containsKey('isManager') && json['isManager'] != null) {
    return json['isManager'];
  }
  final role = json['role'];
  if (role is String && role.toLowerCase() == 'manager') return true;
  if (role == 1) return true;
  if (json['isCurrentUser'] == true) return true;
  return false;
}

Object? _readIsReady(Map<dynamic, dynamic> json, String key) {
  if (json.containsKey('isReady') && json['isReady'] != null) {
    return json['isReady'];
  }
  final status = json['setupStatus'];
  if (status is String &&
      (status.toLowerCase() == 'ready' ||
          status.toLowerCase() == 'completed')) {
    return true;
  }
  if (status == 2) return true;
  return false;
}

int? _nullableIntFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

List<String>? _blockingReasonCodesFromJson(dynamic value) {
  if (value is! List) return null;
  return value
      .map((item) {
        if (item is String) return item;
        if (item is Map) {
          final code = item['code'];
          if (code is String) return code;
        }
        return null;
      })
      .whereType<String>()
      .toList();
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

int? _setupStatusFromJson(dynamic value) {
  if (value is String) {
    return switch (value.trim().toLowerCase()) {
      'notstarted' => 0,
      'inprogress' => 1,
      'ready' => 2,
      _ => int.tryParse(value),
    };
  }
  return _nullableIntFromJson(value);
}

double? _nullableDoubleFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

int? _mealCountFromJson(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  if (value is String) {
    final matches = RegExp(r'\d+').allMatches(value);
    if (matches.isNotEmpty) {
      return int.tryParse(matches.first.group(0)!);
    }
  }
  return null;
}
