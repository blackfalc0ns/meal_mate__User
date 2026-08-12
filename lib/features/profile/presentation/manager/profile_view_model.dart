import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/change_customer_password_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_address_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/upload_file_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/add_customer_address_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/change_customer_password_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/delete_customer_address_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/delete_customer_profile_image_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_customer_addresses_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_customer_profile_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_food_preferences_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/update_customer_address_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/update_customer_profile_image_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/update_customer_profile_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/update_food_preferences_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/upload_file_usecase.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_event.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_state.dart';

@injectable
class ProfileViewModel extends Cubit<ProfileState> {
  ProfileViewModel(
    this._getCustomerProfileUseCase,
    this._updateCustomerProfileUseCase,
    this._uploadFileUseCase,
    this._updateCustomerProfileImageUseCase,
    this._deleteCustomerProfileImageUseCase,
    this._getCustomerAddressesUseCase,
    this._addCustomerAddressUseCase,
    this._updateCustomerAddressUseCase,
    this._deleteCustomerAddressUseCase,
    this._changeCustomerPasswordUseCase,
    this._getFoodPreferencesUseCase,
    this._updateFoodPreferencesUseCase,
  ) : super(const ProfileState());

  final GetCustomerProfileUseCase _getCustomerProfileUseCase;
  final UpdateCustomerProfileUseCase _updateCustomerProfileUseCase;
  final UploadFileUseCase _uploadFileUseCase;
  final UpdateCustomerProfileImageUseCase _updateCustomerProfileImageUseCase;
  final DeleteCustomerProfileImageUseCase _deleteCustomerProfileImageUseCase;
  final GetCustomerAddressesUseCase _getCustomerAddressesUseCase;
  final AddCustomerAddressUseCase _addCustomerAddressUseCase;
  final UpdateCustomerAddressUseCase _updateCustomerAddressUseCase;
  final DeleteCustomerAddressUseCase _deleteCustomerAddressUseCase;
  final ChangeCustomerPasswordUseCase _changeCustomerPasswordUseCase;
  final GetFoodPreferencesUseCase _getFoodPreferencesUseCase;
  final UpdateFoodPreferencesUseCase _updateFoodPreferencesUseCase;

  void doIntent(ProfileEvent event) {
    switch (event) {
      case GetCustomerProfileEvent():
        _getCustomerProfile();
      case UpdateCustomerProfileEvent():
        _updateCustomerProfile(event.request);
      case UploadFileEvent():
        _uploadFile(event.request);
      case UpdateCustomerProfileImageEvent():
        _updateCustomerProfileImage(event.request);
      case DeleteCustomerProfileImageEvent():
        _deleteCustomerProfileImage();
      case GetCustomerAddressesEvent():
        _getCustomerAddresses();
      case AddCustomerAddressEvent():
        _addCustomerAddress(event.request);
      case UpdateCustomerAddressEvent():
        _updateCustomerAddress(event.addressId, event.request);
      case DeleteCustomerAddressEvent():
        _deleteCustomerAddress(event.addressId);
      case ChangeCustomerPasswordEvent():
        _changeCustomerPassword(event.request);
      case GetFoodPreferencesEvent():
        _getFoodPreferences();
      case UpdateFoodPreferencesEvent():
        _updateFoodPreferences(event.preferences);
    }
  }

  Future<void> _getCustomerProfile() async {
    emit(
      state.copyWith(
        profile: state.profile.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    final result = await _getCustomerProfileUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            profile: state.profile.copyWith(
              isLoading: false,
              isSuccess: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            profile: state.profile.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _updateCustomerProfile(
    UpdateCustomerProfileRequestEntity request,
  ) async {
    await _runAction(() => _updateCustomerProfileUseCase(request));
  }

  Future<void> _uploadFile(UploadFileRequestEntity request) async {
    emit(
      state.copyWith(
        upload: state.upload.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
        ),
      ),
    );

    final result = await _uploadFileUseCase(request);

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            upload: state.upload.copyWith(
              isLoading: false,
              isSuccess: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            upload: state.upload.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _updateCustomerProfileImage(
    ProfileImageRequestEntity request,
  ) async {
    await _runAction(() => _updateCustomerProfileImageUseCase(request));
    if (state.action.isSuccess) {
      _getCustomerProfile();
    }
  }

  Future<void> _deleteCustomerProfileImage() async {
    await _runAction(_deleteCustomerProfileImageUseCase.call);
    if (state.action.isSuccess) {
      _getCustomerProfile();
    }
  }

  Future<void> _getCustomerAddresses() async {
    emit(
      state.copyWith(
        addresses: state.addresses.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    final result = await _getCustomerAddressesUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            addresses: state.addresses.copyWith(
              isLoading: false,
              isSuccess: true,
              items: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            addresses: state.addresses.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _addCustomerAddress(CustomerAddressRequestEntity request) async {
    await _runAction(() => _addCustomerAddressUseCase(request));
    if (state.action.isSuccess) {
      _getCustomerAddresses();
    }
  }

  Future<void> _updateCustomerAddress(
    String addressId,
    CustomerAddressRequestEntity request,
  ) async {
    await _runAction(() => _updateCustomerAddressUseCase(addressId, request));
    if (state.action.isSuccess) {
      _getCustomerAddresses();
    }
  }

  Future<void> _deleteCustomerAddress(String addressId) async {
    await _runAction(() => _deleteCustomerAddressUseCase(addressId));
    if (state.action.isSuccess) {
      _getCustomerAddresses();
    }
  }

  Future<void> _changeCustomerPassword(
    ChangeCustomerPasswordRequestEntity request,
  ) async {
    await _runAction(() => _changeCustomerPasswordUseCase(request));
  }

  Future<void> _getFoodPreferences() async {
    emit(
      state.copyWith(
        foodPreferences: state.foodPreferences.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    final result = await _getFoodPreferencesUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            foodPreferences: state.foodPreferences.copyWith(
              isLoading: false,
              isSuccess: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            foodPreferences: state.foodPreferences.copyWith(
              isLoading: false,
              isSuccess: false,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _updateFoodPreferences(FoodPreferencesEntity preferences) async {
    await _runAction(() => _updateFoodPreferencesUseCase(preferences));
    if (state.action.isSuccess) {
      _getFoodPreferences();
    }
  }

  Future<void> _runAction(Future<ApiResult<void>> Function() action) async {
    emit(
      state.copyWith(
        action: state.action.copyWith(
          isLoading: true,
          isSuccess: false,
          clearError: true,
        ),
      ),
    );

    final result = await action();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            action: state.action.copyWith(isLoading: false, isSuccess: true),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            action: state.action.copyWith(
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }
}
