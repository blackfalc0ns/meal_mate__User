import 'package:json_annotation/json_annotation.dart';
import 'package:meal_meat_user/core/network/models/response/pagination_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_availability_response_dto.dart';
import 'package:meal_meat_user/features/subscription_checkout/data/models/response/subscription_coupon_response_dto.dart';

part 'subscription_summary_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionSummaryResponseDto {
  const SubscriptionSummaryResponseDto({
    this.programId,
    this.programNameAr,
    this.programNameEn,
    this.programImageUrl,
    this.bundleId,
    this.bundleNameAr,
    this.bundleNameEn,
    this.imageUrl,
    this.restaurantId,
    this.restaurantNameAr,
    this.restaurantNameEn,
    this.restaurantCount,
    this.tier,
    this.tierNameAr,
    this.tierNameEn,
    this.durationDays,
    this.chosenStartDate,
    this.startDate,
    this.endDate,
    this.serviceDates,
    this.restaurantRepetition,
    this.slotRequirements,
    this.basePrice,
    this.campaignDiscount,
    this.promoDiscount,
    this.walletCredit,
    this.gatewayFee,
    this.finalPrice,
    this.currencyCode,
    this.canCheckout,
    this.checkoutBlockReason,
    this.address,
    this.restaurants,
    this.termsAcceptanceRequired,
    this.checkoutEndpoint,
    this.includeFriday,
    this.fridayDays,
    this.totalServiceDays,
    this.includes,
    this.coupon,
    this.restaurantsPagination,
    this.availability,
    this.programName,
    this.bundleName,
    this.tierName,
    this.subtotal,
    this.discount,
    this.moneyScale,
    this.summaryExpiresAtUtc,
    this.serverNowUtc,
    this.blockingReasons,
    this.blockingReasonDetails,
    this.quoteId,
    this.paymentDate,
  });

  final String? programId;
  final String? programNameAr;
  final String? programNameEn;
  final String? programName;
  final String? programImageUrl;
  final String? bundleId;
  final String? bundleNameAr;
  final String? bundleNameEn;
  final String? bundleName;
  final String? imageUrl;
  final String? restaurantId;
  final String? restaurantNameAr;
  final String? restaurantNameEn;
  final int? restaurantCount;
  final String? tier;
  final String? tierNameAr;
  final String? tierNameEn;
  final String? tierName;
  final int? durationDays;
  final String? chosenStartDate;
  final String? startDate;
  final String? endDate;
  @JsonKey(fromJson: _parseStringList)
  final List<String>? serviceDates;
  final SubscriptionSummaryRestaurantRepetitionResponseDto?
  restaurantRepetition;
  final List<SubscriptionSummarySlotRequirementResponseDto>? slotRequirements;
  final double? basePrice;
  final double? campaignDiscount;
  final double? promoDiscount;
  final double? walletCredit;
  final double? gatewayFee;
  final double? finalPrice;
  final String? currencyCode;
  final bool? canCheckout;
  final String? checkoutBlockReason;
  final SubscriptionSummaryAddressResponseDto? address;
  final List<SubscriptionSummaryRestaurantResponseDto>? restaurants;
  final bool? termsAcceptanceRequired;
  final String? checkoutEndpoint;
  final bool? includeFriday;
  final int? fridayDays;
  final int? totalServiceDays;
  final SubscriptionSummaryIncludesResponseDto? includes;
  final SubscriptionCouponResponseDto? coupon;
  final PaginationResponseDto? restaurantsPagination;
  final SubscriptionAvailabilityResponseDto? availability;
  final double? subtotal;
  final double? discount;
  final int? moneyScale;
  final String? summaryExpiresAtUtc;
  final String? serverNowUtc;
  final String? quoteId;
  final String? paymentDate;
  @JsonKey(fromJson: _parseStringList)
  final List<String>? blockingReasons;
  @JsonKey(includeFromJson: false)
  final List<SubscriptionSummaryBlockingReasonDto>? blockingReasonDetails;

  static List<String>? _parseStringList(dynamic value) {
    if (value is List) {
      return value
          .map((e) {
            if (e is String) return e;
            if (e is Map && e['code'] is String) return e['code'] as String;
            return null;
          })
          .whereType<String>()
          .toList();
    }
    return null;
  }

  factory SubscriptionSummaryResponseDto.fromJson(Map<String, dynamic> json) {
    final dto = _$SubscriptionSummaryResponseDtoFromJson(json);
    return SubscriptionSummaryResponseDto(
      programId: dto.programId,
      programNameAr: dto.programNameAr,
      programNameEn: dto.programNameEn,
      programName: dto.programName,
      programImageUrl: dto.programImageUrl,
      bundleId: dto.bundleId,
      bundleNameAr: dto.bundleNameAr,
      bundleNameEn: dto.bundleNameEn,
      bundleName: dto.bundleName,
      imageUrl: dto.imageUrl,
      restaurantId: dto.restaurantId,
      restaurantNameAr: dto.restaurantNameAr,
      restaurantNameEn: dto.restaurantNameEn,
      restaurantCount: dto.restaurantCount,
      tier: dto.tier,
      tierNameAr: dto.tierNameAr,
      tierNameEn: dto.tierNameEn,
      tierName: dto.tierName,
      durationDays: dto.durationDays,
      chosenStartDate: dto.chosenStartDate,
      startDate: dto.startDate,
      endDate: dto.endDate,
      serviceDates: dto.serviceDates,
      restaurantRepetition: dto.restaurantRepetition,
      slotRequirements: dto.slotRequirements,
      basePrice: dto.basePrice,
      campaignDiscount: dto.campaignDiscount,
      promoDiscount: dto.promoDiscount,
      walletCredit: dto.walletCredit,
      gatewayFee: dto.gatewayFee,
      finalPrice: dto.finalPrice,
      currencyCode: dto.currencyCode,
      canCheckout: dto.canCheckout,
      checkoutBlockReason: dto.checkoutBlockReason,
      address: dto.address,
      restaurants: dto.restaurants,
      termsAcceptanceRequired: dto.termsAcceptanceRequired,
      checkoutEndpoint: dto.checkoutEndpoint,
      includeFriday: dto.includeFriday,
      fridayDays: dto.fridayDays,
      totalServiceDays: dto.totalServiceDays,
      includes: dto.includes,
      coupon: dto.coupon,
      restaurantsPagination: dto.restaurantsPagination,
      availability: dto.availability,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? dto.basePrice,
      discount: (json['discount'] as num?)?.toDouble(),
      moneyScale: (json['moneyScale'] as num?)?.toInt() ?? 3,
      summaryExpiresAtUtc: json['summaryExpiresAtUtc'] as String?,
      serverNowUtc: json['serverNowUtc'] as String?,
      quoteId: json['quoteId'] as String?,
      paymentDate: json['paymentDate'] as String?,
      blockingReasons:
          _parseStringList(json['blockingReasons']) ??
          (dto.checkoutBlockReason != null ? [dto.checkoutBlockReason!] : null),
      blockingReasonDetails: (json['blockingReasons'] as List?)
          ?.whereType<Map>()
          .map(
            (value) => SubscriptionSummaryBlockingReasonDto(
              code: value['code'] as String? ?? '',
              messageAr: value['messageAr'] as String?,
              messageEn: value['messageEn'] as String?,
            ),
          )
          .toList(),
    );
  }
}

class SubscriptionSummaryBlockingReasonDto {
  const SubscriptionSummaryBlockingReasonDto({
    required this.code,
    this.messageAr,
    this.messageEn,
  });

  final String code;
  final String? messageAr;
  final String? messageEn;
}

@JsonSerializable(createToJson: false)
class SubscriptionSummaryRestaurantRepetitionResponseDto {
  const SubscriptionSummaryRestaurantRepetitionResponseDto({
    this.limit,
    this.restaurantCount,
    this.durationDays,
  });

  final int? limit;
  final int? restaurantCount;
  final int? durationDays;

  factory SubscriptionSummaryRestaurantRepetitionResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionSummaryRestaurantRepetitionResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionSummaryAddressResponseDto {
  const SubscriptionSummaryAddressResponseDto({
    this.id,
    this.label,
    this.addressLine,
    this.governorate,
    this.area,
    this.block,
    this.regionId,
    this.governorateNameAr,
    this.governorateNameEn,
    this.governorateName,
    this.areaNameAr,
    this.areaNameEn,
    this.areaName,
    this.blockNameAr,
    this.blockNameEn,
    this.blockName,
  });

  final String? id;
  final String? label;
  final String? addressLine;
  final String? governorate;
  final String? area;
  final String? block;
  final String? regionId;
  final String? governorateNameAr;
  final String? governorateNameEn;
  final String? governorateName;
  final String? areaNameAr;
  final String? areaNameEn;
  final String? areaName;
  final String? blockNameAr;
  final String? blockNameEn;
  final String? blockName;

  factory SubscriptionSummaryAddressResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionSummaryAddressResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionSummaryRestaurantResponseDto {
  const SubscriptionSummaryRestaurantResponseDto({
    this.restaurantId,
    this.nameAr,
    this.nameEn,
    this.name,
    this.logoUrl,
    this.tier,
  });

  final String? restaurantId;
  final String? nameAr;
  final String? nameEn;
  final String? name;
  final String? logoUrl;
  final String? tier;

  factory SubscriptionSummaryRestaurantResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionSummaryRestaurantResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionSummarySlotRequirementResponseDto {
  const SubscriptionSummarySlotRequirementResponseDto({
    this.slot,
    this.nameAr,
    this.nameEn,
    this.name,
    this.count,
  });

  final String? slot;
  final String? nameAr;
  final String? nameEn;
  final String? name;
  final int? count;

  factory SubscriptionSummarySlotRequirementResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionSummarySlotRequirementResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionSummaryIncludesResponseDto {
  const SubscriptionSummaryIncludesResponseDto({
    this.titleAr,
    this.titleEn,
    this.title,
    this.items,
  });

  final String? titleAr;
  final String? titleEn;
  final String? title;
  final List<SubscriptionSummaryIncludeItemResponseDto>? items;

  factory SubscriptionSummaryIncludesResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionSummaryIncludesResponseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionSummaryIncludeItemResponseDto {
  const SubscriptionSummaryIncludeItemResponseDto({
    this.code,
    this.textAr,
    this.textEn,
    this.text,
  });

  final String? code;
  final String? textAr;
  final String? textEn;
  final String? text;

  factory SubscriptionSummaryIncludeItemResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$SubscriptionSummaryIncludeItemResponseDtoFromJson(json);
}
