import 'package:meal_meat_user/features/profile/domain/entities/change_customer_password_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/upload_file_request_entity.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

class GetCustomerProfileEvent extends ProfileEvent {
  const GetCustomerProfileEvent();
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

class GetCustomerAddressesEvent extends ProfileEvent {
  const GetCustomerAddressesEvent();
}

class AddCustomerAddressEvent extends ProfileEvent {
  const AddCustomerAddressEvent(this.request);

  final CustomerAddressRequestEntity request;
}

class UpdateCustomerAddressEvent extends ProfileEvent {
  const UpdateCustomerAddressEvent({
    required this.addressId,
    required this.request,
  });

  final String addressId;
  final CustomerAddressRequestEntity request;
}

class DeleteCustomerAddressEvent extends ProfileEvent {
  const DeleteCustomerAddressEvent(this.addressId);

  final String addressId;
}

class ChangeCustomerPasswordEvent extends ProfileEvent {
  const ChangeCustomerPasswordEvent(this.request);

  final ChangeCustomerPasswordRequestEntity request;
}

class GetFoodPreferencesEvent extends ProfileEvent {
  const GetFoodPreferencesEvent();
}

class UpdateFoodPreferencesEvent extends ProfileEvent {
  const UpdateFoodPreferencesEvent(this.preferences);

  final FoodPreferencesEntity preferences;
}
