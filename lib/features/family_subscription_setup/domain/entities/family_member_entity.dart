import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/food_preferences/domain/entities/food_preferences_entity.dart';

class FamilyMemberEntity {
  final String memberId;
  final String? memberSubscriptionId;
  final String? currentSubscriptionId;
  final String? upcomingSubscriptionId;
  final String? customerUserId;
  final String? phoneNumber;
  final String? occupation;
  final String? startDate;
  final int role;
  final String displayName;
  final String relationshipCode;
  final int gender;
  final int ageYears;
  final String? deliveryAddressId;
  final int setupStatus;
  final String? readinessBlocker;
  final String? programId;
  final String? bundleId;
  final int? selectedTier;
  final int? durationDays;
  final bool includeFriday;
  final bool isCurrentUser;
  final CustomerAddressEntity? deliveryAddress;
  final List<FoodPreferenceItemEntity> allergies;
  final bool allergiesCompleted;
  final List<FoodPreferenceItemEntity> dislikedFoods;
  final List<FoodPreferenceItemEntity> dietaryPreferences;
  final bool dietaryCompleted;
  final bool hasNoAllergies;
  final bool hasNoDietaryRestriction;
  final bool subscribeNow;
  final String? lifecycleStatus;
  final bool checkoutSelected;

  const FamilyMemberEntity({
    required this.memberId,
    this.memberSubscriptionId,
    this.currentSubscriptionId,
    this.upcomingSubscriptionId,
    this.customerUserId,
    this.phoneNumber,
    this.occupation,
    this.startDate,
    required this.role,
    required this.displayName,
    required this.relationshipCode,
    required this.gender,
    required this.ageYears,
    this.deliveryAddressId,
    required this.setupStatus,
    this.readinessBlocker,
    this.programId,
    this.bundleId,
    this.selectedTier,
    this.durationDays,
    required this.includeFriday,
    required this.isCurrentUser,
    this.deliveryAddress,
    this.allergies = const [],
    this.allergiesCompleted = false,
    this.dislikedFoods = const [],
    this.dietaryPreferences = const [],
    this.dietaryCompleted = false,
    this.hasNoAllergies = false,
    this.hasNoDietaryRestriction = false,
    this.subscribeNow = true,
    this.lifecycleStatus,
    this.checkoutSelected = false,
  });

  bool get isManager => role == 1 || isCurrentUser;
  bool get hasProgram => programId != null && programId!.isNotEmpty;
  bool get isPlanCompleted =>
      hasProgram &&
      (bundleId != null && bundleId!.isNotEmpty) &&
      selectedTier != null &&
      (durationDays != null && durationDays! > 0);

  bool get isReady => setupStatus == 2;
  bool get hasLinkedAccount =>
      (customerUserId != null && customerUserId!.isNotEmpty) ||
      (phoneNumber != null && phoneNumber!.trim().isNotEmpty);

  bool get isUnsubscribed =>
      (lifecycleStatus?.toLowerCase() == 'unsubscribed') ||
      (memberSubscriptionId == null && !isPlanCompleted && !subscribeNow);

  bool get isSetupIncomplete =>
      (lifecycleStatus?.toLowerCase() == 'setupincomplete') ||
      (memberSubscriptionId == null && !isPlanCompleted);

  bool get isReadyToPay =>
      (lifecycleStatus?.toLowerCase() == 'readytopay') ||
      (memberSubscriptionId == null && isPlanCompleted);

  bool get canDeleteFromSetupFlow =>
      !isManager &&
      !isReady &&
      !isPlanCompleted &&
      (memberSubscriptionId == null || memberSubscriptionId!.isEmpty);

  bool get isInCheckoutBasket =>
      (memberSubscriptionId == null || memberSubscriptionId!.isEmpty) &&
      isPlanCompleted &&
      subscribeNow;

  FamilyMemberEntity copyWith({
    String? memberId,
    String? memberSubscriptionId,
    String? currentSubscriptionId,
    String? upcomingSubscriptionId,
    String? customerUserId,
    String? phoneNumber,
    String? occupation,
    String? startDate,
    int? role,
    String? displayName,
    String? relationshipCode,
    int? gender,
    int? ageYears,
    String? deliveryAddressId,
    int? setupStatus,
    String? readinessBlocker,
    String? programId,
    String? bundleId,
    int? selectedTier,
    int? durationDays,
    bool? includeFriday,
    bool? isCurrentUser,
    CustomerAddressEntity? deliveryAddress,
    List<FoodPreferenceItemEntity>? allergies,
    bool? allergiesCompleted,
    List<FoodPreferenceItemEntity>? dislikedFoods,
    List<FoodPreferenceItemEntity>? dietaryPreferences,
    bool? dietaryCompleted,
    bool? hasNoAllergies,
    bool? hasNoDietaryRestriction,
    bool? subscribeNow,
    String? lifecycleStatus,
    bool? checkoutSelected,
    bool clearProgramId = false,
    bool clearBundleId = false,
    bool clearSelectedTier = false,
    bool clearDurationDays = false,
    bool clearDeliveryAddress = false,
  }) {
    return FamilyMemberEntity(
      memberId: memberId ?? this.memberId,
      memberSubscriptionId: memberSubscriptionId ?? this.memberSubscriptionId,
      currentSubscriptionId:
          currentSubscriptionId ?? this.currentSubscriptionId,
      upcomingSubscriptionId:
          upcomingSubscriptionId ?? this.upcomingSubscriptionId,
      customerUserId: customerUserId ?? this.customerUserId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      occupation: occupation ?? this.occupation,
      startDate: startDate ?? this.startDate,
      role: role ?? this.role,
      displayName: displayName ?? this.displayName,
      relationshipCode: relationshipCode ?? this.relationshipCode,
      gender: gender ?? this.gender,
      ageYears: ageYears ?? this.ageYears,
      deliveryAddressId: clearDeliveryAddress
          ? null
          : (deliveryAddressId ?? this.deliveryAddressId),
      setupStatus: setupStatus ?? this.setupStatus,
      readinessBlocker: readinessBlocker ?? this.readinessBlocker,
      programId: clearProgramId ? null : (programId ?? this.programId),
      bundleId: clearBundleId ? null : (bundleId ?? this.bundleId),
      selectedTier: clearSelectedTier
          ? null
          : (selectedTier ?? this.selectedTier),
      durationDays: clearDurationDays
          ? null
          : (durationDays ?? this.durationDays),
      includeFriday: includeFriday ?? this.includeFriday,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      deliveryAddress: clearDeliveryAddress
          ? null
          : (deliveryAddress ?? this.deliveryAddress),
      allergies: allergies ?? this.allergies,
      allergiesCompleted: allergiesCompleted ?? this.allergiesCompleted,
      dislikedFoods: dislikedFoods ?? this.dislikedFoods,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      dietaryCompleted: dietaryCompleted ?? this.dietaryCompleted,
      hasNoAllergies: hasNoAllergies ?? this.hasNoAllergies,
      hasNoDietaryRestriction:
          hasNoDietaryRestriction ?? this.hasNoDietaryRestriction,
      subscribeNow: subscribeNow ?? this.subscribeNow,
      lifecycleStatus: lifecycleStatus ?? this.lifecycleStatus,
      checkoutSelected: checkoutSelected ?? this.checkoutSelected,
    );
  }
}
