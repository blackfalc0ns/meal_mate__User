import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_confirmation_entity.dart';

class PaymentSuccessMemberArgs {
  const PaymentSuccessMemberArgs({
    required this.memberId,
    required this.displayName,
    this.isManager = false,
    this.packageName,
    this.durationDays,
    this.durationLabel,
    this.restaurantTier,
    this.paymentDate,
    this.startDate,
    this.endDate,
    this.includeFriday = false,
    this.gender = 1,
  });

  final String memberId;
  final String displayName;
  final bool isManager;
  final String? packageName;
  final int? durationDays;
  final String? durationLabel;
  final String? restaurantTier;
  final String? paymentDate;
  final String? startDate;
  final String? endDate;
  final bool includeFriday;
  final int gender;
}

class PaymentSuccessArgs {
  const PaymentSuccessArgs({
    required this.subscriptionId,
    this.packageName,
    this.durationDays,
    this.durationLabel,
    this.restaurantTier,
    this.paymentDate,
    this.startDate,
    this.endDate,
    this.includeFriday = false,
    this.isFamily = false,
    this.familyName,
    this.memberCount,
    this.confirmation,
    this.members = const [],
  });

  final String subscriptionId;
  final String? packageName;
  final int? durationDays;
  final String? durationLabel;
  final String? restaurantTier;
  final String? paymentDate;
  final String? startDate;
  final String? endDate;
  final bool includeFriday;
  final bool isFamily;
  final String? familyName;
  final int? memberCount;
  final SubscriptionConfirmationEntity? confirmation;
  final List<PaymentSuccessMemberArgs> members;

  PaymentSuccessArgs forMember(PaymentSuccessMemberArgs member) {
    return PaymentSuccessArgs(
      subscriptionId: subscriptionId,
      packageName: member.packageName ?? packageName,
      durationDays: member.durationDays ?? durationDays,
      durationLabel: member.durationLabel,
      restaurantTier: member.restaurantTier ?? restaurantTier,
      paymentDate: member.paymentDate ?? paymentDate,
      startDate: member.startDate ?? startDate,
      endDate: member.endDate ?? endDate,
      includeFriday: member.includeFriday,
      isFamily: isFamily,
      familyName: familyName,
      memberCount: memberCount,
      confirmation: confirmation,
      members: members,
    );
  }
}
