import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_support_message_entity.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/submit_profile_support_message_usecase.dart';
import 'package:meal_meat_user/features/profile/presentation/support/manager/profile_support_form_state.dart';

class ProfileSupportFormViewModel extends Cubit<ProfileSupportFormState> {
  ProfileSupportFormViewModel(this._submitUseCase)
    : super(const ProfileSupportFormState());

  final SubmitProfileSupportMessageUseCase _submitUseCase;

  Future<void> submit(ProfileSupportMessageEntity message) async {
    if (state.isSubmitting) return;

    if (message.subject.trim().isEmpty || message.message.trim().isEmpty) {
      if (!isClosed) {
        emit(state.copyWith(errorMessage: 'Empty fields'));
      }
      return;
    }

    if (!isClosed) {
      emit(
        state.copyWith(isSubmitting: true, clearResult: true, clearError: true),
      );
    }

    final response = await _submitUseCase(message);

    if (isClosed) return;

    switch (response) {
      case ApiSuccessResult(:final data):
        emit(
          state.copyWith(isSubmitting: false, result: data, clearError: true),
        );
      case ApiErrorResult(:final failure):
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: failure.errorMessage,
            clearResult: true,
          ),
        );
    }
  }

  void consumeResult() {
    if (!isClosed) {
      emit(state.copyWith(clearResult: true));
    }
  }

  void reset() {
    if (!isClosed) {
      emit(const ProfileSupportFormState());
    }
  }
}
