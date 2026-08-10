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
    return this;
  }
}

class _$ExternalModules extends _i576.ExternalModules {}
