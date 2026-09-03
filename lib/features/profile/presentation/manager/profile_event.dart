import 'package:meal_meat_user/core/upload_file/domain/entities/upload_file_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

class GetCustomerProfileEvent extends ProfileEvent {
  const GetCustomerProfileEvent();
}

class GetProfileBillingEvent extends ProfileEvent {
  const GetProfileBillingEvent();
}

class UpdateCustomerProfileEvent extends ProfileEvent {
  const UpdateCustomerProfileEvent(this.request);

  final UpdateCustomerProfileRequestEntity request;
}

class UploadFileEvent extends ProfileEvent {
  const UploadFileEvent(this.request);

  final UploadFileRequestEntity request;
}

class UpdateCustomerProfileImageEvent extends ProfileEvent {
  const UpdateCustomerProfileImageEvent(this.request);

  final ProfileImageRequestEntity request;
}

class DeleteCustomerProfileImageEvent extends ProfileEvent {
  const DeleteCustomerProfileImageEvent();
}

class RenewSubscriptionEvent extends ProfileEvent {
  const RenewSubscriptionEvent(this.subscriptionId);

  final String subscriptionId;
}

class FreezeSubscriptionEvent extends ProfileEvent {
  const FreezeSubscriptionEvent({
    required this.subscriptionId,
    required this.request,
  });

  final String subscriptionId;
  final ProfileBillingFreezeRequestEntity request;
}

class GetCancellationQuoteEvent extends ProfileEvent {
  const GetCancellationQuoteEvent(this.subscriptionId);

  final String subscriptionId;
}

class CancelSubscriptionEvent extends ProfileEvent {
  const CancelSubscriptionEvent({
    required this.subscriptionId,
    required this.request,
  });

  final String subscriptionId;
  final ProfileBillingCancellationRequestEntity request;
}

class ResetBillingActionEvent extends ProfileEvent {
  const ResetBillingActionEvent();
}
