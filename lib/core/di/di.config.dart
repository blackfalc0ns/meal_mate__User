// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pretty_dio_logger/pretty_dio_logger.dart' as _i528;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/auth/data/data_source/auth_remote_data_source.dart'
    as _i182;
import '../../features/auth/data/data_source/auth_remote_data_source_impl.dart'
    as _i508;
import '../../features/auth/data/repo/auth_repository_impl.dart' as _i607;
import '../../features/auth/domain/repo/auth_repository.dart' as _i2;
import '../../features/auth/domain/usecase/forgot_password_usecase.dart'
    as _i749;
import '../../features/auth/domain/usecase/get_calling_codes_usecase.dart'
    as _i171;
import '../../features/auth/domain/usecase/login_usecase.dart' as _i911;
import '../../features/auth/domain/usecase/logout_usecase.dart' as _i757;
import '../../features/auth/domain/usecase/refresh_token_usecase.dart' as _i501;
import '../../features/auth/domain/usecase/register_usecase.dart' as _i769;
import '../../features/auth/domain/usecase/resend_password_otp_usecase.dart'
    as _i610;
import '../../features/auth/domain/usecase/resend_phone_otp_usecase.dart'
    as _i621;
import '../../features/auth/domain/usecase/reset_password_usecase.dart'
    as _i1029;
import '../../features/auth/domain/usecase/verify_phone_usecase.dart' as _i918;
import '../../features/auth/presentation/manager/auth_view_model.dart' as _i892;
import '../../features/profile/data/data_source/profile_remote_data_source.dart'
    as _i998;
import '../../features/profile/data/data_source/profile_remote_data_source_impl.dart'
    as _i531;
import '../../features/profile/data/repo/profile_repository_impl.dart'
    as _i1015;
import '../../features/profile/domain/repo/profile_repository.dart' as _i311;
import '../../features/profile/domain/usecase/add_customer_address_usecase.dart'
    as _i121;
import '../../features/profile/domain/usecase/change_customer_password_usecase.dart'
    as _i655;
import '../../features/profile/domain/usecase/delete_customer_address_usecase.dart'
    as _i322;
import '../../features/profile/domain/usecase/delete_customer_profile_image_usecase.dart'
    as _i186;
import '../../features/profile/domain/usecase/get_customer_addresses_usecase.dart'
    as _i650;
import '../../features/profile/domain/usecase/get_customer_profile_usecase.dart'
    as _i994;
import '../../features/profile/domain/usecase/get_food_preferences_usecase.dart'
    as _i1014;
import '../../features/profile/domain/usecase/update_customer_address_usecase.dart'
    as _i624;
import '../../features/profile/domain/usecase/update_customer_profile_image_usecase.dart'
    as _i399;
import '../../features/profile/domain/usecase/update_customer_profile_usecase.dart'
    as _i857;
import '../../features/profile/domain/usecase/update_food_preferences_usecase.dart'
    as _i88;
import '../../features/profile/domain/usecase/upload_file_usecase.dart'
    as _i237;
import '../../features/profile/presentation/manager/profile_view_model.dart'
    as _i446;
import '../helpers/shared_pref.dart' as _i42;
import '../network/api_services.dart' as _i804;
import '../network/external_modules.dart' as _i576;
import '../services/app_navigator_service.dart' as _i179;
import '../services/device_id_service.dart' as _i148;
import '../services/language_interceptor.dart' as _i32;
import '../services/language_service.dart' as _i819;
import '../services/retry_interceptor.dart' as _i844;
import '../services/token_interceptor.dart' as _i1056;
import '../services/token_service.dart' as _i227;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final externalModules = _$ExternalModules();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => externalModules.provideSharedPreferences,
      preResolve: true,
    );
    gh.factory<_i844.RetryInterceptor>(() => _i844.RetryInterceptor());
    gh.lazySingleton<_i528.PrettyDioLogger>(
      () => externalModules.providePrettyDioLogger(),
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => externalModules.flutterSecureStorage(),
    );
    gh.lazySingleton<_i179.AppNavigatorService>(
      () => _i179.AppNavigatorService(),
    );
    gh.lazySingleton<_i1056.TokenInterceptor>(() => _i1056.TokenInterceptor());
    gh.factory<_i42.SharedPrefHelper>(
      () => _i42.SharedPrefHelper(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i227.TokenService>(
      () => _i227.TokenService(
        prefs: gh<_i558.FlutterSecureStorage>(),
        sharedPreferences: gh<_i460.SharedPreferences>(),
      ),
    );
    gh.factory<_i819.LanguageService>(
      () => _i819.LanguageService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i148.DeviceIdService>(
      () => _i148.DeviceIdService(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i32.LanguageInterceptor>(
      () => _i32.LanguageInterceptor(gh<_i819.LanguageService>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => externalModules.provideDio(
        gh<_i528.PrettyDioLogger>(),
        gh<_i1056.TokenInterceptor>(),
        gh<_i32.LanguageInterceptor>(),
      ),
    );
    gh.factory<_i804.ApiServices>(() => _i804.ApiServices(gh<_i361.Dio>()));
    gh.factory<_i182.AuthRemoteDataSource>(
      () => _i508.AuthRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i2.AuthRepository>(
      () => _i607.AuthRepositoryImpl(
        gh<_i182.AuthRemoteDataSource>(),
        gh<_i227.TokenService>(),
      ),
    );
    gh.factory<_i749.ForgotPasswordUseCase>(
      () => _i749.ForgotPasswordUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i171.GetCallingCodesUseCase>(
      () => _i171.GetCallingCodesUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i911.LoginUseCase>(
      () => _i911.LoginUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i757.LogoutUseCase>(
      () => _i757.LogoutUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i501.RefreshTokenUseCase>(
      () => _i501.RefreshTokenUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i769.RegisterUseCase>(
      () => _i769.RegisterUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i610.ResendPasswordOtpUseCase>(
      () => _i610.ResendPasswordOtpUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i621.ResendPhoneOtpUseCase>(
      () => _i621.ResendPhoneOtpUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i1029.ResetPasswordUseCase>(
      () => _i1029.ResetPasswordUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i918.VerifyPhoneUseCase>(
      () => _i918.VerifyPhoneUseCase(gh<_i2.AuthRepository>()),
    );
    gh.factory<_i998.ProfileRemoteDataSource>(
      () => _i531.ProfileRemoteDataSourceImpl(gh<_i804.ApiServices>()),
    );
    gh.factory<_i892.AuthViewModel>(
      () => _i892.AuthViewModel(
        gh<_i911.LoginUseCase>(),
        gh<_i769.RegisterUseCase>(),
        gh<_i171.GetCallingCodesUseCase>(),
        gh<_i918.VerifyPhoneUseCase>(),
        gh<_i621.ResendPhoneOtpUseCase>(),
        gh<_i749.ForgotPasswordUseCase>(),
        gh<_i1029.ResetPasswordUseCase>(),
        gh<_i610.ResendPasswordOtpUseCase>(),
        gh<_i501.RefreshTokenUseCase>(),
        gh<_i757.LogoutUseCase>(),
      ),
    );
    gh.factory<_i311.ProfileRepository>(
      () => _i1015.ProfileRepositoryImpl(gh<_i998.ProfileRemoteDataSource>()),
    );
    gh.factory<_i121.AddCustomerAddressUseCase>(
      () => _i121.AddCustomerAddressUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i655.ChangeCustomerPasswordUseCase>(
      () => _i655.ChangeCustomerPasswordUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i322.DeleteCustomerAddressUseCase>(
      () => _i322.DeleteCustomerAddressUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i186.DeleteCustomerProfileImageUseCase>(
      () => _i186.DeleteCustomerProfileImageUseCase(
        gh<_i311.ProfileRepository>(),
      ),
    );
    gh.factory<_i650.GetCustomerAddressesUseCase>(
      () => _i650.GetCustomerAddressesUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i994.GetCustomerProfileUseCase>(
      () => _i994.GetCustomerProfileUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i1014.GetFoodPreferencesUseCase>(
      () => _i1014.GetFoodPreferencesUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i624.UpdateCustomerAddressUseCase>(
      () => _i624.UpdateCustomerAddressUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i399.UpdateCustomerProfileImageUseCase>(
      () => _i399.UpdateCustomerProfileImageUseCase(
        gh<_i311.ProfileRepository>(),
      ),
    );
    gh.factory<_i857.UpdateCustomerProfileUseCase>(
      () => _i857.UpdateCustomerProfileUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i88.UpdateFoodPreferencesUseCase>(
      () => _i88.UpdateFoodPreferencesUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i237.UploadFileUseCase>(
      () => _i237.UploadFileUseCase(gh<_i311.ProfileRepository>()),
    );
    gh.factory<_i446.ProfileViewModel>(
      () => _i446.ProfileViewModel(
        gh<_i994.GetCustomerProfileUseCase>(),
        gh<_i857.UpdateCustomerProfileUseCase>(),
        gh<_i237.UploadFileUseCase>(),
        gh<_i399.UpdateCustomerProfileImageUseCase>(),
        gh<_i186.DeleteCustomerProfileImageUseCase>(),
        gh<_i650.GetCustomerAddressesUseCase>(),
        gh<_i121.AddCustomerAddressUseCase>(),
        gh<_i624.UpdateCustomerAddressUseCase>(),
        gh<_i322.DeleteCustomerAddressUseCase>(),
        gh<_i655.ChangeCustomerPasswordUseCase>(),
        gh<_i1014.GetFoodPreferencesUseCase>(),
        gh<_i88.UpdateFoodPreferencesUseCase>(),
      ),
    );
    return this;
  }
}

class _$ExternalModules extends _i576.ExternalModules {}
