import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/customer_profile_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/food_preferences_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/upload_file_entity.dart';

class ProfileState {
  const ProfileState({
    this.profile = const CustomerProfileState(),
    this.addresses = const CustomerAddressesState(),
    this.foodPreferences = const FoodPreferencesState(),
    this.action = const ProfileActionState(),
    this.upload = const UploadFileState(),
  });

  final CustomerProfileState profile;
  final CustomerAddressesState addresses;
  final FoodPreferencesState foodPreferences;
  final ProfileActionState action;
  final UploadFileState upload;

  ProfileState copyWith({
    CustomerProfileState? profile,
    CustomerAddressesState? addresses,
    FoodPreferencesState? foodPreferences,
    ProfileActionState? action,
    UploadFileState? upload,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      addresses: addresses ?? this.addresses,
      foodPreferences: foodPreferences ?? this.foodPreferences,
      action: action ?? this.action,
      upload: upload ?? this.upload,
    );
  }
}

class CustomerProfileState {
  const CustomerProfileState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final CustomerProfileEntity? data;
  final Failure? failure;

  CustomerProfileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    CustomerProfileEntity? data,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return CustomerProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}

class CustomerAddressesState {
  const CustomerAddressesState({
    this.isLoading = false,
    this.isSuccess = false,
    this.items = const [],
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final List<CustomerAddressEntity> items;
  final Failure? failure;

  CustomerAddressEntity? get defaultAddress {
    for (final item in items) {
      if (item.isDefault) return item;
    }
    return items.isEmpty ? null : items.first;
  }

  CustomerAddressesState copyWith({
    bool? isLoading,
    bool? isSuccess,
    List<CustomerAddressEntity>? items,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return CustomerAddressesState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      items: items ?? this.items,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}

class FoodPreferencesState {
  const FoodPreferencesState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final FoodPreferencesEntity? data;
  final Failure? failure;

  FoodPreferencesState copyWith({
    bool? isLoading,
    bool? isSuccess,
    FoodPreferencesEntity? data,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return FoodPreferencesState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }
}

class ProfileActionState {
  const ProfileActionState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final Failure? failure;

  ProfileActionState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
  }) {
    return ProfileActionState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}

class UploadFileState {
  const UploadFileState({
    this.isLoading = false,
    this.isSuccess = false,
    this.data,
    this.errorMessage,
    this.failure,
  });

  final bool isLoading;
  final bool isSuccess;
  final UploadFileEntity? data;
  final String? errorMessage;
  final Failure? failure;

  UploadFileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    UploadFileEntity? data,
    String? errorMessage,
    Failure? failure,
    bool clearError = false,
  }) {
    return UploadFileState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      data: data ?? this.data,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      failure: clearError ? null : failure ?? this.failure,
    );
  }
}
