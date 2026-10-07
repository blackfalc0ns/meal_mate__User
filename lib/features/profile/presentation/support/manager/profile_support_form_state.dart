import 'package:meal_meat_user/features/profile/domain/entities/profile_support_content_entity.dart';

class ProfileSupportFormState {
  const ProfileSupportFormState({
    this.isSubmitting = false,
    this.result,
    this.errorMessage,
  });

  final bool isSubmitting;
  final ProfileSupportSubmitResultEntity? result;
  final String? errorMessage;

  ProfileSupportFormState copyWith({
    bool? isSubmitting,
    ProfileSupportSubmitResultEntity? result,
    bool clearResult = false,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileSupportFormState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
