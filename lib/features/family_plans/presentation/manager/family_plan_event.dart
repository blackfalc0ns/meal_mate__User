import 'package:meal_meat_user/features/family_plans/domain/entities/family_size_package_entity.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

sealed class FamilyPlanEvent {
  const FamilyPlanEvent();
}

class GetFamilySizePackagesEvent extends FamilyPlanEvent {
  const GetFamilySizePackagesEvent();
}

class SelectFamilySizePackageEvent extends FamilyPlanEvent {
  const SelectFamilySizePackageEvent(this.package);

  final FamilySizePackageEntity package;
}

class GetFamilySubscriptionCurrentEvent extends FamilyPlanEvent {
  const GetFamilySubscriptionCurrentEvent();
}

class UpdateFamilyGroupEvent extends FamilyPlanEvent {
  const UpdateFamilyGroupEvent({required this.name, this.familyPackageId});

  final String name;
  final String? familyPackageId;
}

class GetFamilyRelationshipsEvent extends FamilyPlanEvent {
  const GetFamilyRelationshipsEvent();
}

class GetFamilyAddressesEvent extends FamilyPlanEvent {
  const GetFamilyAddressesEvent();
}

class AddFamilyMemberEvent extends FamilyPlanEvent {
  const AddFamilyMemberEvent({
    required this.displayName,
    required this.relationshipCode,
    required this.gender,
    required this.ageYears,
    this.deliveryAddressId,
  });

  final String displayName;
  final String relationshipCode;
  final int gender;
  final int ageYears;
  final String? deliveryAddressId;
}

class UpdateFamilyMemberEvent extends FamilyPlanEvent {
  const UpdateFamilyMemberEvent({
    required this.memberId,
    required this.displayName,
    required this.relationshipCode,
    required this.gender,
    required this.ageYears,
    this.deliveryAddressId,
  });

  final String memberId;
  final String displayName;
  final String relationshipCode;
  final int gender;
  final int ageYears;
  final String? deliveryAddressId;
}

class DeleteFamilyMemberEvent extends FamilyPlanEvent {
  const DeleteFamilyMemberEvent(this.memberId);

  final String memberId;
}

class GetFamilyProgramsEvent extends FamilyPlanEvent {
  const GetFamilyProgramsEvent();
}

class SelectFamilyProgramEvent extends FamilyPlanEvent {
  const SelectFamilyProgramEvent(this.programIndex);

  final int programIndex;
}

class GetFamilyBundlesEvent extends FamilyPlanEvent {
  const GetFamilyBundlesEvent(this.programId);

  final String programId;
}

class SelectFamilyBundleEvent extends FamilyPlanEvent {
  const SelectFamilyBundleEvent(this.bundleIndex);

  final int bundleIndex;
}

class GetFamilyDurationsEvent extends FamilyPlanEvent {
  const GetFamilyDurationsEvent({
    required this.programId,
    required this.bundleId,
    required this.includeFriday,
  });

  final String programId;
  final String bundleId;
  final bool includeFriday;
}

class SelectFamilyDurationEvent extends FamilyPlanEvent {
  const SelectFamilyDurationEvent(this.durationIndex);

  final int durationIndex;
}

class UpdateFamilyCustomDurationEvent extends FamilyPlanEvent {
  const UpdateFamilyCustomDurationEvent(this.durationDays);

  final int? durationDays;
}

class ToggleFamilyFridayEvent extends FamilyPlanEvent {
  const ToggleFamilyFridayEvent(this.includeFriday);

  final bool includeFriday;
}

class SelectFamilyTierEvent extends FamilyPlanEvent {
  const SelectFamilyTierEvent(this.tierIndex);

  final int tierIndex;
}

class BrowseFamilyTierRestaurantsEvent extends FamilyPlanEvent {
  const BrowseFamilyTierRestaurantsEvent(this.tierIndex);

  final int tierIndex;
}

class CloseFamilyBrowseRestaurantsEvent extends FamilyPlanEvent {
  const CloseFamilyBrowseRestaurantsEvent();
}

class SelectFamilyMemberEvent extends FamilyPlanEvent {
  const SelectFamilyMemberEvent(this.memberIndex);

  final int memberIndex;
}

class SaveFamilyMemberPlanEvent extends FamilyPlanEvent {
  const SaveFamilyMemberPlanEvent({
    required this.memberId,
    this.programId,
    this.bundleId,
    this.tier,
    this.durationDays,
    this.includeFriday,
  });

  final String memberId;
  final String? programId;
  final String? bundleId;
  final int? tier;
  final int? durationDays;
  final bool? includeFriday;
}

class GetFamilySummaryEvent extends FamilyPlanEvent {
  final String? memberId;
  const GetFamilySummaryEvent({this.memberId});
}

class GetFamilyPaymentMethodsEvent extends FamilyPlanEvent {
  const GetFamilyPaymentMethodsEvent(this.amount);

  final double amount;
}

class SelectFamilyPaymentMethodEvent extends FamilyPlanEvent {
  const SelectFamilyPaymentMethodEvent(this.paymentMethod);

  final PaymentMethodEntity paymentMethod;
}

class CheckoutFamilySubscriptionEvent extends FamilyPlanEvent {
  const CheckoutFamilySubscriptionEvent({
    required this.callbackUrl,
    required this.errorUrl,
    required this.paymentMethodId,
  });

  final String callbackUrl;
  final String errorUrl;
  final int paymentMethodId;
}
