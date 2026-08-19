import 'package:meal_meat_user/features/family_plans/domain/entities/family_checkout_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_group_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_member_plan_request_entity.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_member_request_entity.dart';

sealed class FamilyPlansEvent {
  const FamilyPlansEvent();
}

class GetFamilyMetadataEvent extends FamilyPlansEvent {
  const GetFamilyMetadataEvent();
}

class GetCurrentFamilyGroupEvent extends FamilyPlansEvent {
  const GetCurrentFamilyGroupEvent();
}

class UpdateFamilyGroupNameEvent extends FamilyPlansEvent {
  const UpdateFamilyGroupNameEvent(this.request);

  final FamilyGroupRequestEntity request;
}

class AddFamilyMemberEvent extends FamilyPlansEvent {
  const AddFamilyMemberEvent(this.request);

  final FamilyMemberRequestEntity request;
}

class UpdateFamilyMemberEvent extends FamilyPlansEvent {
  const UpdateFamilyMemberEvent({
    required this.memberId,
    required this.request,
  });

  final String memberId;
  final FamilyMemberRequestEntity request;
}

class DeleteFamilyMemberEvent extends FamilyPlansEvent {
  const DeleteFamilyMemberEvent(this.memberId);

  final String memberId;
}

class UpdateFamilyMemberPlanEvent extends FamilyPlansEvent {
  const UpdateFamilyMemberPlanEvent({
    required this.memberId,
    required this.request,
  });

  final String memberId;
  final FamilyMemberPlanRequestEntity request;
}

class GetFamilySummaryEvent extends FamilyPlansEvent {
  const GetFamilySummaryEvent({this.memberId});

  final String? memberId;
}

class GetFamilyPaymentMethodsEvent extends FamilyPlansEvent {
  const GetFamilyPaymentMethodsEvent(this.amount);

  final double amount;
}

class CheckoutFamilySubscriptionEvent extends FamilyPlansEvent {
  const CheckoutFamilySubscriptionEvent(this.request);

  final FamilyCheckoutRequestEntity request;
}

class ClearFamilyFeedbackEvent extends FamilyPlansEvent {
  const ClearFamilyFeedbackEvent();
}

class GetFamilySubscriptionProgramsEvent extends FamilyPlansEvent {
  const GetFamilySubscriptionProgramsEvent();
}

class GetFamilySubscriptionBundlesEvent extends FamilyPlansEvent {
  const GetFamilySubscriptionBundlesEvent(this.programId);

  final String programId;
}

class GetFamilySubscriptionDurationsEvent extends FamilyPlansEvent {
  const GetFamilySubscriptionDurationsEvent({
    required this.programId,
    required this.bundleId,
    required this.includeFriday,
  });

  final String programId;
  final String bundleId;
  final bool includeFriday;
}

class GetFamilySubscriptionTiersEvent extends FamilyPlansEvent {
  const GetFamilySubscriptionTiersEvent({
    required this.programId,
    required this.bundleId,
    required this.durationDays,
    required this.includeFriday,
  });

  final String programId;
  final String bundleId;
  final int? durationDays;
  final bool includeFriday;
}

class GetFamilySubscriptionTierRestaurantsEvent extends FamilyPlansEvent {
  const GetFamilySubscriptionTierRestaurantsEvent({
    required this.programId,
    required this.bundleId,
    required this.tier,
    this.restaurantIds = const [],
  });

  final String programId;
  final String bundleId;
  final String tier;
  final List<String> restaurantIds;
}
