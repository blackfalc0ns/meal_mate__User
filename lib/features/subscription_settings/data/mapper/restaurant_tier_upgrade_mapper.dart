import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/request/subscription_upgrade_request_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_upgrade_options_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_upgrade_request_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/data/models/response/subscription_upgrade_status_response_dto.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_upgrade_entity.dart';

abstract class RestaurantTierUpgradeMapper {
  static SubscriptionUpgradeOptionsEntity toOptionsEntity(
    SubscriptionUpgradeOptionsResponseDto dto,
  ) {
    return SubscriptionUpgradeOptionsEntity(
      canUpgrade: dto.canUpgrade ?? false,
      unavailableReason: dto.unavailableReason,
      currentTier: dto.currentTier ?? 'Basic',
      remainingServiceDays: dto.remainingServiceDays ?? 0,
      totalServiceDays: dto.totalServiceDays ?? 0,
      upgradeEndpoint: dto.upgradeEndpoint ?? '',
      options: (dto.options ?? const [])
          .map((option) => toOptionEntity(option))
          .toList(),
      paymentMethods: (dto.paymentMethods ?? const [])
          .map((method) => toPaymentMethodEntity(method))
          .where((method) => method.id > 0)
          .toList(),
    );
  }

  static SubscriptionUpgradePaymentMethodEntity toPaymentMethodEntity(
    SubscriptionUpgradePaymentMethodResponseDto dto,
  ) {
    return SubscriptionUpgradePaymentMethodEntity(
      id: dto.paymentMethodId ?? dto.id ?? 0,
      code: dto.code ?? '',
      title: dto.nameAr ?? dto.nameEn ?? dto.name ?? '',
      integrationType: dto.integrationType ?? '',
      serviceCharge: dto.serviceCharge ?? 0.0,
      totalAmount: dto.totalAmount ?? 0.0,
      currencyCode: dto.currencyCode ?? 'KWD',
      isAvailable: dto.isAvailable ?? false,
      unavailableReason: dto.unavailableReason,
      imageUrl: dto.imageUrl,
    );
  }

  static SubscriptionUpgradeOptionEntity toOptionEntity(
    SubscriptionUpgradeOptionResponseDto dto,
  ) {
    return SubscriptionUpgradeOptionEntity(
      targetTier: dto.targetTier ?? '',
      tierNameAr: dto.tierNameAr ?? '',
      tierNameEn: dto.tierNameEn ?? '',
      logoUrl: dto.logoUrl,
      isCurrent: dto.isCurrent ?? false,
      selectable: dto.selectable ?? false,
      accessibleRestaurantCount: dto.accessibleRestaurantCount ?? 0,
      currentRemainingCredit: dto.currentRemainingCredit ?? 0.0,
      targetRemainingPrice: dto.targetRemainingPrice ?? 0.0,
      gatewayRecovery: dto.gatewayRecovery ?? 0.0,
      priceDifference: dto.priceDifference ?? 0.0,
      currencyCode: dto.currencyCode ?? 'KWD',
    );
  }

  static SubscriptionUpgradeRequestDto toRequestDto(
    SubscriptionUpgradeRequestEntity entity,
  ) {
    return SubscriptionUpgradeRequestDto(
      targetTier: entity.targetTier,
      callbackUrl: entity.callbackUrl,
      errorUrl: entity.errorUrl,
      paymentMethodId: entity.paymentMethodId,
      reason: entity.reason,
    );
  }

  static SubscriptionUpgradeRequestResultEntity toRequestResultEntity(
    SubscriptionUpgradeRequestResponseDto dto,
  ) {
    return SubscriptionUpgradeRequestResultEntity(
      upgradeId: dto.upgradeId ?? '',
      subscriptionId: dto.subscriptionId ?? '',
      fromTier: dto.fromTier ?? '',
      toTier: dto.toTier ?? '',
      amount: dto.amount ?? 0.0,
      currencyCode: dto.currencyCode ?? 'KWD',
      paymentUrl: dto.paymentUrl,
      isPaid: dto.isPaid ?? false,
      status: dto.status ?? '',
      remainingServiceDays: dto.remainingServiceDays ?? 0,
    );
  }

  static SubscriptionUpgradeStatusEntity toStatusEntity(
    SubscriptionUpgradeStatusResponseDto dto,
  ) {
    return SubscriptionUpgradeStatusEntity(
      upgradeId: dto.upgradeId ?? '',
      subscriptionId: dto.subscriptionId ?? '',
      fromTier: dto.fromTier ?? '',
      toTier: dto.toTier ?? '',
      amount: dto.amount ?? 0.0,
      currencyCode: dto.currencyCode ?? 'KWD',
      status: dto.status ?? '',
      isPaid: dto.isPaid ?? false,
      isFailed: dto.isFailed ?? false,
      effectiveAtUtc: dto.effectiveAtUtc,
      paymentUrl: dto.paymentUrl,
    );
  }

  static String badgeAssetForTier(String tier) {
    switch (tier.toLowerCase()) {
      case 'platinum':
      case 'plus':
        return Assets.restaurantTierPlus;
      case 'elite':
      case 'max':
        return Assets.restaurantTierMax;
      case 'basic':
      case 'select':
      default:
        return Assets.restaurantTierSelect;
    }
  }

  static RestaurantTierOptionType optionTypeForTier(
    String tier,
    bool isCurrent,
  ) {
    if (isCurrent) return RestaurantTierOptionType.current;
    switch (tier.toLowerCase()) {
      case 'platinum':
      case 'plus':
        return RestaurantTierOptionType.plus;
      case 'elite':
      case 'max':
        return RestaurantTierOptionType.max;
      default:
        return RestaurantTierOptionType.plus;
    }
  }

  static RestaurantTierUpgradeEntity toUiEntity({
    required SubscriptionUpgradeOptionsEntity optionsEntity,
    required SubscriptionUpgradeOptionEntity selectedOption,
    String? programName,
    String? bundleName,
  }) {
    final currentOption = optionsEntity.options.firstWhere(
      (opt) => opt.isCurrent,
      orElse: () => optionsEntity.options.isNotEmpty
          ? optionsEntity.options.first
          : selectedOption,
    );

    final tiers = optionsEntity.options.map((opt) {
      final isCurrent = opt.isCurrent;
      return RestaurantTierOptionEntity(
        name: opt.tierNameAr.isNotEmpty ? opt.tierNameAr : opt.targetTier,
        description: isCurrent
            ? 'كل تصنيف يضم مجموعة مختارة من المطاعم المميزة.'
            : 'يشمل كل مطاعم ${currentOption.tierNameAr.isNotEmpty ? currentOption.tierNameAr : currentOption.targetTier} + مطاعم إضافية',
        restaurantCount: '+${opt.accessibleRestaurantCount}',
        buttonLabel: isCurrent
            ? 'تصنيفك الحالي'
            : 'ترقية إلى ${opt.tierNameAr.isNotEmpty ? opt.tierNameAr : opt.targetTier}',
        badgeAsset: badgeAssetForTier(opt.targetTier),
        type: optionTypeForTier(opt.targetTier, isCurrent),
      );
    }).toList();

    final diffRestaurantCount =
        selectedOption.accessibleRestaurantCount -
        currentOption.accessibleRestaurantCount;
    final extraRestaurantsLabel = diffRestaurantCount > 0
        ? '+$diffRestaurantCount مطعم إضافي'
        : '+${selectedOption.accessibleRestaurantCount} مطعم';

    final detailsRows = <RestaurantTierDetailRowEntity>[
      RestaurantTierDetailRowEntity(
        label: 'رصيد الباقة الحالية للأيام المتبقية',
        value:
            '${selectedOption.currentRemainingCredit.toStringAsFixed(3)} ${selectedOption.currencyCode}',
      ),
      RestaurantTierDetailRowEntity(
        label: 'سعر الباقة الجديدة للأيام المتبقية',
        value:
            '${selectedOption.targetRemainingPrice.toStringAsFixed(3)} ${selectedOption.currencyCode}',
      ),
    ];

    if (selectedOption.gatewayRecovery > 0) {
      detailsRows.add(
        RestaurantTierDetailRowEntity(
          label: 'رسوم/استرداد بوابة الدفع',
          value:
              '${selectedOption.gatewayRecovery.toStringAsFixed(3)} ${selectedOption.currencyCode}',
        ),
      );
    }

    detailsRows.add(
      RestaurantTierDetailRowEntity(
        label: 'فرق الترقية',
        value:
            '${selectedOption.priceDifference.toStringAsFixed(3)} ${selectedOption.currencyCode}',
      ),
    );

    final currency = selectedOption.currencyCode.isNotEmpty
        ? selectedOption.currencyCode
        : 'KWD';
    final currencyText = currency == 'KWD' ? 'د.ك' : currency;

    return RestaurantTierUpgradeEntity(
      title: 'ترقية تصنيف المطاعم',
      packagePrefix: 'باقة',
      mealsCount: bundleName ?? '',
      mealsSuffix: '',
      remainingPrefix: 'متبقي',
      remainingDays: optionsEntity.remainingServiceDays.toString(),
      remainingSuffix: 'يوم',
      activeLabel: 'نشط',
      currentLabel: 'التصنيف الحالي:',
      currentTierName: currentOption.tierNameAr.isNotEmpty
          ? currentOption.tierNameAr
          : currentOption.targetTier,
      note: 'يمكنك ترقية التصنيف حتى نهاية مدة الاشتراك الحالية.',
      chooseTitle: 'اختر التصنيف الذي تريد الترقية إليه',
      chooseSubtitle: 'كلما ارتفع التصنيف، كلما شملت خيارات مطاعم أكثر وأفضل.',
      price:
          '${selectedOption.priceDifference.toStringAsFixed(3)} $currencyText',
      pricePeriod: 'حتى نهاية الاشتراك',
      continuePlusLabel: 'متابعة الترقية إلى بلس',
      continueMaxLabel: 'متابعة الترقية إلى ماكس',
      tiers: tiers,
      currentPackageLabel: programName ?? 'الباقة الحالية',
      currentTier: RestaurantTierPreviewEntity(
        name: currentOption.tierNameAr.isNotEmpty
            ? currentOption.tierNameAr
            : currentOption.targetTier,
        badgeAsset: badgeAssetForTier(currentOption.targetTier),
      ),
      newTier: RestaurantTierPreviewEntity(
        name: selectedOption.tierNameAr.isNotEmpty
            ? selectedOption.tierNameAr
            : selectedOption.targetTier,
        badgeAsset: badgeAssetForTier(selectedOption.targetTier),
      ),
      features: [
        RestaurantTierFeatureEntity(
          label: extraRestaurantsLabel,
          icon: RestaurantTierFeatureIcon.restaurant,
        ),
        const RestaurantTierFeatureEntity(
          label: 'مطاعم مميزة أكثر',
          icon: RestaurantTierFeatureIcon.reward,
        ),
        const RestaurantTierFeatureEntity(
          label: 'خيارات أوسع',
          icon: RestaurantTierFeatureIcon.food,
        ),
      ],
      quickComparisonTitle: 'مقارنة سريعة',
      quickComparisonRows: [
        RestaurantTierComparisonRowEntity(
          packageLabel: 'الباقة الحالية:',
          tierName: currentOption.tierNameAr.isNotEmpty
              ? currentOption.tierNameAr
              : currentOption.targetTier,
          badgeAsset: badgeAssetForTier(currentOption.targetTier),
          restaurantCountPrefix: 'حوالي',
          restaurantCount: '${currentOption.accessibleRestaurantCount}+',
          restaurantCountSuffix: 'مطعم',
          caption: 'التصنيف الحالي',
        ),
        RestaurantTierComparisonRowEntity(
          packageLabel: 'الباقة الجديدة:',
          tierName: selectedOption.tierNameAr.isNotEmpty
              ? selectedOption.tierNameAr
              : selectedOption.targetTier,
          badgeAsset: badgeAssetForTier(selectedOption.targetTier),
          restaurantCountPrefix: 'حوالي',
          restaurantCount: '${selectedOption.accessibleRestaurantCount}+',
          restaurantCountSuffix: 'مطعم',
          caption:
              'يشمل كل مطاعم ${currentOption.tierNameAr.isNotEmpty ? currentOption.tierNameAr : currentOption.targetTier} + مطاعم إضافية',
        ),
      ],
      detailsTitle: 'تفاصيل الترقية',
      detailsRows: detailsRows,
      totalLabel: 'المبلغ المستحق الآن',
      totalValue:
          '${selectedOption.priceDifference.toStringAsFixed(3)} $currencyText',
      applyNote: 'يتم تطبيق الترقية فوراً وتلقائياً بعد الدفع الناجح',
      paymentTitle: 'طريقة الدفع',
      paymentMethod: const RestaurantTierPaymentMethodEntity(
        brand: 'MyFatoorah',
        cardText: 'الدفع الإلكتروني (MyFatoorah)',
        subtitle: 'كي نت / فيزا / ماستركارد',
        changeLabel: '',
      ),
      confirmLabel: 'تأكيد الترقية والدفع',
      backLabel: 'الرجوع',
    );
  }
}
