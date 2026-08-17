import 'package:meal_meat_user/core/upload_file/domain/entities/upload_file_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
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
