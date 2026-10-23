import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../features/calendar/domain/usecase/get_calendar_usecase.dart';
import '../../features/notifications/domain/usecase/get_notifications_usecase.dart';
import '../../features/notifications/domain/usecase/mark_all_notifications_read_usecase.dart';
import '../../features/notifications/domain/usecase/mark_notification_read_usecase.dart';
import '../../features/notifications/presentation/manager/notification_badge_view_model.dart';
import '../../features/addresses/domain/usecase/add_customer_address_usecase.dart';
import '../../features/addresses/domain/usecase/confirm_set_default_address_usecase.dart';
import '../../features/addresses/domain/usecase/customer_address_editor_operations.dart';
import '../../features/addresses/domain/usecase/preview_existing_address_coverage_usecase.dart';
import '../../features/addresses/domain/usecase/preview_new_address_coverage_usecase.dart';
import '../../features/addresses/domain/usecase/update_customer_address_usecase.dart';
import '../../features/auth/domain/usecase/forgot_password_usecase.dart';
import '../../features/auth/domain/usecase/get_calling_codes_usecase.dart';
import '../../features/auth/domain/usecase/login_usecase.dart';
import '../../features/auth/domain/usecase/refresh_token_usecase.dart';
import '../../features/auth/domain/usecase/logout_usecase.dart';
import '../../features/auth/domain/usecase/register_usecase.dart';
import '../../features/auth/domain/usecase/resend_password_otp_usecase.dart';
import '../../features/auth/domain/usecase/resend_phone_otp_usecase.dart';
import '../../features/auth/domain/usecase/reset_password_usecase.dart';
import '../../features/auth/domain/usecase/verify_phone_usecase.dart';
import '../../features/auth/presentation/manager/calling_codes_view_model.dart';
import '../../features/auth/presentation/manager/login_view_model.dart';
import '../../features/auth/presentation/manager/logout_view_model.dart';
import '../../features/auth/presentation/manager/password_recovery_view_model.dart';
import '../../features/auth/presentation/manager/register_view_model.dart';
import '../../features/notifications/presentation/manager/notifications_view_model.dart';
import '../../features/subscription_settings/domain/usecase/get_current_customer_subscription_usecase.dart';
import '../../features/subscription_settings/domain/usecase/get_subscription_billing_usecase.dart';
import '../../features/payment/domain/usecase/checkout_subscription_usecase.dart';
import '../../features/payment/domain/usecase/get_payment_methods_usecase.dart';
import '../../features/payment/domain/usecase/get_subscription_calendar_usecase.dart';
import '../../features/payment/domain/usecase/get_subscription_payment_status_usecase.dart';
import '../../features/payment/presentation/manager/payment_view_model.dart';
import '../biometric/biometric_service.dart';
import '../helpers/shared_pref.dart';
import '../payment/payment_attempt_store.dart';
import '../payment/payment_deep_link_coordinator.dart';
import '../services/app_navigator_service.dart';
import '../services/auth_refresh_service.dart';
import '../services/token_service.dart';
import '../../features/calling/service/voice_call_signalr_service.dart';
import '../../features/calling/service/voice_navigation_coordinator.dart';
import '../../features/calling/domain/repo/native_voice_repository.dart';
import '../../features/calling/data/data_source/native_voice_data_source.dart';
import '../../features/calling/data/data_source/native_voice_data_source_impl.dart';
import '../../features/calling/data/repo/native_voice_repository_impl.dart';
import '../../features/calling/domain/usecase/answer_native_call_usecase.dart';
import '../../features/calling/domain/usecase/reject_native_call_usecase.dart';
import '../../features/calling/domain/usecase/end_native_call_usecase.dart';
import '../../features/calling/domain/usecase/set_native_call_muted_usecase.dart';
import '../../features/calling/domain/usecase/set_native_call_audio_route_usecase.dart';
import '../../features/calling/presentation/manager/calling_view_model.dart';
import '../../features/calling/presentation/manager/voice_permission_setup_view_model.dart';
import '../services/native_voice_session_bridge.dart';
import '../services/native_voice_provisioner.dart';
import '../../features/calling/data/data_source/voice_device_session_storage.dart';
import '../../features/calling/domain/usecase/register_voice_device_usecase.dart';
import '../../features/calling/domain/usecase/revoke_voice_device_usecase.dart';
import '../../features/calling/domain/usecase/get_voice_call_display_usecase.dart';
import '../services/voice_permission_service.dart';
import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: true, // default
)
Future<void> configureDependencies() async {
  if (!getIt.isRegistered<HubConnectionFactory>()) {
    getIt.registerLazySingleton<HubConnectionFactory>(
      () => VoiceCallSignalRService.defaultHubConnectionFactory,
    );
  }
  await getIt.init();
  if (!getIt.isRegistered<NotificationBadgeViewModel>()) {
    getIt.registerLazySingleton<NotificationBadgeViewModel>(
      () => NotificationBadgeViewModel(getIt<GetCalendarUseCase>()),
    );
  }
  if (!getIt.isRegistered<NotificationsViewModel>()) {
    getIt.registerFactory<NotificationsViewModel>(
      () => NotificationsViewModel(
        getIt<GetNotificationsUseCase>(),
        getIt<MarkNotificationReadUseCase>(),
        getIt<MarkAllNotificationsReadUseCase>(),
        getIt.isRegistered<NotificationBadgeViewModel>()
            ? getIt<NotificationBadgeViewModel>()
            : null,
      ),
    );
  }
  if (!getIt.isRegistered<CustomerAddressEditorOperations>()) {
    getIt.registerFactory<CustomerAddressEditorOperations>(
      () => CustomerAddressEditorOperations(
        previewNewAddressCoverageUseCase:
            getIt<PreviewNewAddressCoverageUseCase>(),
        previewExistingAddressCoverageUseCase:
            getIt<PreviewExistingAddressCoverageUseCase>(),
        addCustomerAddressUseCase: getIt<AddCustomerAddressUseCase>(),
        updateCustomerAddressUseCase: getIt<UpdateCustomerAddressUseCase>(),
        confirmSetDefaultAddressUseCase:
            getIt<ConfirmSetDefaultAddressUseCase>(),
      ),
    );
  }
  if (!getIt.isRegistered<AuthRefreshService>()) {
    getIt.registerLazySingleton<AuthRefreshService>(
      () => AuthRefreshService(
        tokenService: getIt<TokenService>(),
        refreshTokenUseCaseProvider: getIt.call<RefreshTokenUseCase>,
      ),
    );
  }
  if (!getIt.isRegistered<CallingCodesViewModel>()) {
    getIt.registerFactory<CallingCodesViewModel>(
      () => CallingCodesViewModel(getIt<GetCallingCodesUseCase>()),
    );
  }
  if (!getIt.isRegistered<LoginViewModel>()) {
    getIt.registerFactory<LoginViewModel>(
      () => LoginViewModel(
        getIt<LoginUseCase>(),
        getIt<BiometricService>(),
        getCurrentCustomerSubscriptionUseCase:
            getIt.isRegistered<GetCurrentCustomerSubscriptionUseCase>()
            ? getIt<GetCurrentCustomerSubscriptionUseCase>()
            : null,
        sharedPrefHelper: getIt.isRegistered<SharedPrefHelper>()
            ? getIt<SharedPrefHelper>()
            : null,
      ),
    );
  }
  if (!getIt.isRegistered<RegisterViewModel>()) {
    getIt.registerFactory<RegisterViewModel>(
      () => RegisterViewModel(
        getIt<RegisterUseCase>(),
        getIt<VerifyPhoneUseCase>(),
        getIt<ResendPhoneOtpUseCase>(),
      ),
    );
  }
  if (!getIt.isRegistered<PasswordRecoveryViewModel>()) {
    getIt.registerFactory<PasswordRecoveryViewModel>(
      () => PasswordRecoveryViewModel(
        getIt<ForgotPasswordUseCase>(),
        getIt<ResendPasswordOtpUseCase>(),
        getIt<ResetPasswordUseCase>(),
        getIt<TokenService>(),
      ),
    );
  }
  if (!getIt.isRegistered<LogoutViewModel>()) {
    getIt.registerFactory<LogoutViewModel>(
      () => LogoutViewModel(
        getIt<LogoutUseCase>(),
        getIt<TokenService>(),
        getIt<BiometricService>(),
      ),
    );
  }
  if (!getIt.isRegistered<PaymentViewModel>()) {
    getIt.registerFactory<PaymentViewModel>(
      () => PaymentViewModel(
        getIt<GetPaymentMethodsUseCase>(),
        getIt<CheckoutSubscriptionUseCase>(),
        getIt<GetSubscriptionPaymentStatusUseCase>(),
        getIt<GetSubscriptionCalendarUseCase>(),
        getIt<GetCurrentCustomerSubscriptionUseCase>(),
        getIt<SharedPrefHelper>(),
        paymentAttemptStore: getIt.isRegistered<PaymentAttemptStore>()
            ? getIt<PaymentAttemptStore>()
            : null,
        tokenService: getIt.isRegistered<TokenService>()
            ? getIt<TokenService>()
            : null,
        getSubscriptionBillingUseCase:
            getIt.isRegistered<GetSubscriptionBillingUseCase>()
            ? getIt<GetSubscriptionBillingUseCase>()
            : null,
      ),
    );
  }
  if (!getIt.isRegistered<PaymentDeepLinkCoordinator>()) {
    getIt.registerLazySingleton<PaymentDeepLinkCoordinator>(
      () => PaymentDeepLinkCoordinator(
        tokenService: getIt<TokenService>(),
        paymentAttemptStore: getIt<PaymentAttemptStore>(),
        navigatorService: getIt<AppNavigatorService>(),
      ),
    );
  }

  // 🔹 Native Voice Calling Registrations
  if (!getIt.isRegistered<NativeVoiceDataSource>()) {
    getIt.registerLazySingleton<NativeVoiceDataSource>(
      NativeVoiceDataSourceImpl.create,
    );
  }
  if (!getIt.isRegistered<NativeVoiceRepository>()) {
    getIt.registerLazySingleton<NativeVoiceRepository>(
      () => NativeVoiceRepositoryImpl(getIt<NativeVoiceDataSource>()),
    );
  }
  if (!getIt.isRegistered<NativeVoiceSessionBridge>()) {
    getIt.registerLazySingleton<NativeVoiceSessionBridge>(
      NativeVoiceSessionBridge.create,
    );
  }
  if (!getIt.isRegistered<VoicePermissionService>()) {
    getIt.registerLazySingleton<VoicePermissionService>(
      () => const VoicePermissionService.create(),
    );
  }
  if (!getIt.isRegistered<NativeVoiceProvisioner>()) {
    getIt.registerLazySingleton<NativeVoiceProvisioner>(
      () => NativeVoiceProvisioner(
        getIt<RegisterVoiceDeviceUseCase>(),
        getIt<RevokeVoiceDeviceUseCase>(),
        getIt<TokenService>(),
        getIt<VoiceDeviceSessionStorage>(),
        getIt<NativeVoiceSessionBridge>(),
        getIt<NativeVoiceRepository>(),
      ),
    );
  }
  if (!getIt.isRegistered<AnswerNativeCallUseCase>()) {
    getIt.registerFactory<AnswerNativeCallUseCase>(
      () => AnswerNativeCallUseCase(getIt<NativeVoiceRepository>()),
    );
  }
  if (!getIt.isRegistered<RejectNativeCallUseCase>()) {
    getIt.registerFactory<RejectNativeCallUseCase>(
      () => RejectNativeCallUseCase(getIt<NativeVoiceRepository>()),
    );
  }
  if (!getIt.isRegistered<EndNativeCallUseCase>()) {
    getIt.registerFactory<EndNativeCallUseCase>(
      () => EndNativeCallUseCase(getIt<NativeVoiceRepository>()),
    );
  }
  if (!getIt.isRegistered<SetNativeCallMutedUseCase>()) {
    getIt.registerFactory<SetNativeCallMutedUseCase>(
      () => SetNativeCallMutedUseCase(getIt<NativeVoiceRepository>()),
    );
  }
  if (!getIt.isRegistered<SetNativeCallAudioRouteUseCase>()) {
    getIt.registerFactory<SetNativeCallAudioRouteUseCase>(
      () => SetNativeCallAudioRouteUseCase(getIt<NativeVoiceRepository>()),
    );
  }
  if (!getIt.isRegistered<VoiceNavigationCoordinator>()) {
    getIt.registerLazySingleton<VoiceNavigationCoordinator>(
      () => VoiceNavigationCoordinator(
        getIt<NativeVoiceRepository>(),
        getIt<AppNavigatorService>(),
      ),
    );
  }
  if (!getIt.isRegistered<VoicePermissionSetupViewModel>()) {
    getIt.registerFactory<VoicePermissionSetupViewModel>(
      () => VoicePermissionSetupViewModel(getIt<NativeVoiceRepository>()),
    );
  }
  if (!getIt.isRegistered<CallingViewModel>()) {
    getIt.registerFactory<CallingViewModel>(
      () => CallingViewModel(
        getIt<AnswerNativeCallUseCase>(),
        getIt<RejectNativeCallUseCase>(),
        getIt<EndNativeCallUseCase>(),
        getIt<SetNativeCallMutedUseCase>(),
        getIt<SetNativeCallAudioRouteUseCase>(),
        getIt<NativeVoiceRepository>(),
        getIt<GetVoiceCallDisplayUseCase>(),
      ),
    );
  }
}
