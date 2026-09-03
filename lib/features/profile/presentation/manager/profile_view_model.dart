import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/upload_file/domain/entities/upload_file_request_entity.dart';
import 'package:meal_meat_user/core/upload_file/domain/usecase/upload_file_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_billing_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/entities/update_customer_profile_request_entity.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/create_subscription_cancellation_request_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/create_subscription_freeze_request_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/create_subscription_renewal_request_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/delete_customer_profile_image_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_customer_profile_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_profile_billing_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/get_subscription_cancellation_quote_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/update_customer_profile_image_usecase.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/update_customer_profile_usecase.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_event.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_state.dart';

@injectable
class ProfileViewModel extends Cubit<ProfileState> {
  ProfileViewModel(
    this._getCustomerProfileUseCase,
    this._getProfileBillingUseCase,
    this._createSubscriptionRenewalRequestUseCase,
    this._createSubscriptionFreezeRequestUseCase,
    this._getSubscriptionCancellationQuoteUseCase,
    this._createSubscriptionCancellationRequestUseCase,
    this._updateCustomerProfileUseCase,
    this._uploadFileUseCase,
    this._updateCustomerProfileImageUseCase,
    this._deleteCustomerProfileImageUseCase,
  ) : super(const ProfileState());

  final GetCustomerProfileUseCase _getCustomerProfileUseCase;
  final GetProfileBillingUseCase _getProfileBillingUseCase;
  final CreateSubscriptionRenewalRequestUseCase
  _createSubscriptionRenewalRequestUseCase;
  final CreateSubscriptionFreezeRequestUseCase
  _createSubscriptionFreezeRequestUseCase;
  final GetSubscriptionCancellationQuoteUseCase
  _getSubscriptionCancellationQuoteUseCase;
  final CreateSubscriptionCancellationRequestUseCase
  _createSubscriptionCancellationRequestUseCase;
  final UpdateCustomerProfileUseCase _updateCustomerProfileUseCase;
  final UploadFileUseCase _uploadFileUseCase;
  final UpdateCustomerProfileImageUseCase _updateCustomerProfileImageUseCase;
  final DeleteCustomerProfileImageUseCase _deleteCustomerProfileImageUseCase;

  void doIntent(ProfileEvent event) {
    switch (event) {
      case GetCustomerProfileEvent():
        _getCustomerProfile();
      case GetProfileBillingEvent():
        _getProfileBilling();
      case UpdateCustomerProfileEvent():
        _updateCustomerProfile(event.request);
      case UploadFileEvent():
        _uploadFile(event.request);
      case UpdateCustomerProfileImageEvent():
        _updateCustomerProfileImage(event.request);
      case DeleteCustomerProfileImageEvent():
        _deleteCustomerProfileImage();
      case RenewSubscriptionEvent():
        _renewSubscription(event.subscriptionId);
      case FreezeSubscriptionEvent():
        _freezeSubscription(
          subscriptionId: event.subscriptionId,
          request: event.request,
        );
      case GetCancellationQuoteEvent():
        _getCancellationQuote(event.subscriptionId);
      case CancelSubscriptionEvent():
        _cancelSubscription(
          subscriptionId: event.subscriptionId,
          request: event.request,
        );
      case ResetBillingActionEvent():
        emit(state.copyWith(billingAction: const ProfileBillingActionState()));
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

  Future<void> _getProfileBilling() async {
    emit(
      state.copyWith(
        billing: state.billing.copyWith(
          isLoading: true,
          isSuccess: false,
          clearFailure: true,
        ),
      ),
    );

    final result = await _getProfileBillingUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            billing: state.billing.copyWith(
              isLoading: false,
              isSuccess: true,
              data: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            billing: state.billing.copyWith(
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

  Future<void> _renewSubscription(String subscriptionId) async {
    await _runBillingAction(
      type: 'renew',
      action: () => _createSubscriptionRenewalRequestUseCase(subscriptionId),
    );
    if (state.billingAction.isSuccess) {
      _getProfileBilling();
    }
  }

  Future<void> _freezeSubscription({
    required String subscriptionId,
    required ProfileBillingFreezeRequestEntity request,
  }) async {
    emit(
      state.copyWith(
        billingAction: state.billingAction.copyWith(
          type: 'freeze',
          isLoading: true,
          isSuccess: false,
          clearError: true,
          clearFreezeResult: true,
          pendingFreezeRequest: request,
          pendingFreezeSubscriptionId: subscriptionId,
        ),
      ),
    );

    final result = await _createSubscriptionFreezeRequestUseCase(
      subscriptionId: subscriptionId,
      request: request,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: 'freeze',
              isLoading: false,
              isSuccess: true,
              freezeResult: result.data,
              clearPendingFreeze: true,
            ),
          ),
        );
        _getProfileBilling();
      case ApiErrorResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: 'freeze',
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _getCancellationQuote(String subscriptionId) async {
    emit(
      state.copyWith(
        billingAction: state.billingAction.copyWith(
          type: 'quote',
          isLoading: true,
          isSuccess: false,
          clearError: true,
          clearQuote: true,
          clearResult: true,
        ),
      ),
    );

    final result = await _getSubscriptionCancellationQuoteUseCase(
      subscriptionId,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: 'quote',
              isLoading: false,
              isSuccess: true,
              cancellationQuote: result.data,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: 'quote',
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _cancelSubscription({
    required String subscriptionId,
    required ProfileBillingCancellationRequestEntity request,
  }) async {
    emit(
      state.copyWith(
        billingAction: state.billingAction.copyWith(
          type: 'cancel',
          isLoading: true,
          isSuccess: false,
          clearError: true,
          clearResult: true,
        ),
      ),
    );

    final result = await _createSubscriptionCancellationRequestUseCase(
      subscriptionId: subscriptionId,
      request: request,
    );

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: 'cancel',
              isLoading: false,
              isSuccess: true,
              cancellationResult: result.data,
            ),
          ),
        );
        _getProfileBilling();
      case ApiErrorResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: 'cancel',
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
    }
  }

  Future<void> _runBillingAction({
    required String type,
    required Future<ApiResult<void>> Function() action,
  }) async {
    emit(
      state.copyWith(
        billingAction: state.billingAction.copyWith(
          type: type,
          isLoading: true,
          isSuccess: false,
          clearError: true,
          clearQuote: true,
          clearResult: true,
        ),
      ),
    );

    final result = await action();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: type,
              isLoading: false,
              isSuccess: true,
            ),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            billingAction: state.billingAction.copyWith(
              type: type,
              isLoading: false,
              isSuccess: false,
              errorMessage: result.failure.errorMessage,
              failure: result.failure,
            ),
          ),
        );
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
