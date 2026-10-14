import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../network/api_services.dart';
import '../services/location_service.dart';
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
import '../../features/auth/presentation/manager/biometric_view_model.dart';
import '../../features/auth/presentation/manager/calling_codes_view_model.dart';
import '../../features/auth/presentation/manager/login_view_model.dart';
import '../../features/auth/presentation/manager/logout_view_model.dart';
import '../../features/auth/presentation/manager/password_recovery_view_model.dart';
import '../../features/auth/presentation/manager/register_view_model.dart';
import '../../features/change_password/domain/usecase/change_customer_password_usecase.dart';
import '../../features/change_password/presentation/manager/change_password_view_model.dart';
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
import '../../features/family_management/overview/data/data_source/family_overview_remote_data_source.dart';
import '../../features/family_management/overview/data/data_source/family_overview_remote_data_source_impl.dart';
import '../../features/family_management/overview/data/repo/family_overview_repository_impl.dart';
import '../../features/family_management/overview/domain/repo/family_overview_repository.dart';
import '../../features/family_management/overview/domain/usecase/get_family_home_usecase.dart';
import '../../features/family_management/overview/domain/usecase/get_family_members_usecase.dart';
import '../../features/family_management/overview/presentation/manager/family_overview_view_model.dart';
import '../../features/family_management/member/data/data_source/family_member_remote_data_source.dart';
import '../../features/family_management/member/data/data_source/family_member_remote_data_source_impl.dart';
import '../../features/family_management/member/data/repo/family_member_repository_impl.dart';
import '../../features/family_management/member/domain/repo/family_member_repository.dart';
import '../../features/family_management/member/domain/usecase/get_family_member_detail_usecase.dart';
import '../../features/family_management/member/domain/usecase/get_family_member_access_usecase.dart';
import '../../features/family_management/member/domain/usecase/update_family_member_access_usecase.dart';
import '../../features/family_management/member/domain/usecase/get_family_member_permissions_usecase.dart';
import '../../features/family_management/member/domain/usecase/update_family_member_permissions_usecase.dart';
import '../../features/family_management/member/domain/usecase/update_family_member_basic_info_usecase.dart';
import '../../features/family_management/member/domain/usecase/renew_family_member_subscription_usecase.dart';
import '../../features/family_management/member/presentation/manager/family_member_view_model.dart';
import '../../features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import '../../features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import '../../features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart';
import '../../features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart';
import '../../features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import '../../features/calendar/domain/usecase/set_calendar_day_restaurant_usecase.dart';
import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: true, // default
)
Future<void> configureDependencies() async {
  await getIt.init();
  if (!getIt.isRegistered<ApiServices>()) {
    getIt.registerLazySingleton<ApiServices>(
      () => ApiServices(getIt<Dio>()),
    );
  }
  if (!getIt.isRegistered<LocationService>()) {
    getIt.registerLazySingleton<LocationService>(() => const LocationService());
  }
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
  if (!getIt.isRegistered<BiometricViewModel>()) {
    getIt.registerFactory<BiometricViewModel>(
      () => BiometricViewModel(getIt<BiometricService>()),
    );
  }
  if (!getIt.isRegistered<ChangePasswordViewModel>()) {
    getIt.registerFactory<ChangePasswordViewModel>(
      () => ChangePasswordViewModel(
        getIt<ChangeCustomerPasswordUseCase>(),
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
  // Family Management - Overview
  if (!getIt.isRegistered<FamilyOverviewRemoteDataSource>()) {
    getIt.registerLazySingleton<FamilyOverviewRemoteDataSource>(
      () => FamilyOverviewRemoteDataSourceImpl(getIt()),
    );
  }
  if (!getIt.isRegistered<FamilyOverviewRepository>()) {
    getIt.registerLazySingleton<FamilyOverviewRepository>(
      () => FamilyOverviewRepositoryImpl(getIt()),
    );
  }
  if (!getIt.isRegistered<GetFamilyHomeUseCase>()) {
    getIt.registerFactory<GetFamilyHomeUseCase>(
      () => GetFamilyHomeUseCase(getIt()),
    );
  }
  if (!getIt.isRegistered<GetFamilyMembersUseCase>()) {
    getIt.registerFactory<GetFamilyMembersUseCase>(
      () => GetFamilyMembersUseCase(getIt()),
    );
  }
  if (!getIt.isRegistered<FamilyOverviewViewModel>()) {
    getIt.registerFactory<FamilyOverviewViewModel>(
      () => FamilyOverviewViewModel(getIt(), getIt()),
    );
  }
  // Family Management - Member
  if (!getIt.isRegistered<FamilyMemberRemoteDataSource>()) {
    getIt.registerLazySingleton<FamilyMemberRemoteDataSource>(
      () => FamilyMemberRemoteDataSourceImpl(getIt()),
    );
  }
  if (!getIt.isRegistered<FamilyMemberRepository>()) {
    getIt.registerLazySingleton<FamilyMemberRepository>(
      () => FamilyMemberRepositoryImpl(getIt()),
    );
  }
  if (!getIt.isRegistered<GetFamilyMemberDetailUseCase>()) {
    getIt.registerFactory<GetFamilyMemberDetailUseCase>(
      () => GetFamilyMemberDetailUseCase(getIt()),
    );
  }
  if (!getIt.isRegistered<GetFamilyMemberAccessUseCase>()) {
    getIt.registerFactory<GetFamilyMemberAccessUseCase>(
      () => GetFamilyMemberAccessUseCase(getIt()),
    );
  }
  if (!getIt.isRegistered<UpdateFamilyMemberAccessUseCase>()) {
    getIt.registerFactory<UpdateFamilyMemberAccessUseCase>(
      () => UpdateFamilyMemberAccessUseCase(getIt()),
    );
  }
  if (!getIt.isRegistered<GetFamilyMemberPermissionsUseCase>()) {
    getIt.registerFactory<GetFamilyMemberPermissionsUseCase>(
      () => GetFamilyMemberPermissionsUseCase(getIt()),
    );
  }
  if (!getIt.isRegistered<UpdateFamilyMemberPermissionsUseCase>()) {
    getIt.registerFactory<UpdateFamilyMemberPermissionsUseCase>(
      () => UpdateFamilyMemberPermissionsUseCase(getIt()),
    );
  }
  if (!getIt.isRegistered<UpdateFamilyMemberBasicInfoUseCase>()) {
    getIt.registerFactory<UpdateFamilyMemberBasicInfoUseCase>(
      () => UpdateFamilyMemberBasicInfoUseCase(getIt()),
    );
  }
  if (!getIt.isRegistered<RenewFamilyMemberSubscriptionUseCase>()) {
    getIt.registerFactory<RenewFamilyMemberSubscriptionUseCase>(
      () => RenewFamilyMemberSubscriptionUseCase(getIt()),
    );
  }
  if (!getIt.isRegistered<FamilyMemberViewModel>()) {
    getIt.registerFactory<FamilyMemberViewModel>(
      () => FamilyMemberViewModel(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
      ),
    );
  }
  // Family Management - Calendar
  if (!getIt.isRegistered<FamilyCalendarViewModel>()) {
    getIt.registerFactory<FamilyCalendarViewModel>(
      () => FamilyCalendarViewModel(
        getIt.isRegistered<GetFamilyMembersUseCase>()
            ? getIt<GetFamilyMembersUseCase>()
            : null,
        getIt.isRegistered<GetCalendarUseCase>()
            ? getIt<GetCalendarUseCase>()
            : null,
        getIt.isRegistered<GetCalendarDayUseCase>()
            ? getIt<GetCalendarDayUseCase>()
            : null,
        getIt.isRegistered<GetCalendarRestaurantsUseCase>()
            ? getIt<GetCalendarRestaurantsUseCase>()
            : null,
        getIt.isRegistered<GetCalendarAvailableMealsUseCase>()
            ? getIt<GetCalendarAvailableMealsUseCase>()
            : null,
        getIt.isRegistered<SaveCalendarDayMealsUseCase>()
            ? getIt<SaveCalendarDayMealsUseCase>()
            : null,
        getIt.isRegistered<SetCalendarDayRestaurantUseCase>()
            ? getIt<SetCalendarDayRestaurantUseCase>()
            : null,
      ),
    );
  }
}
