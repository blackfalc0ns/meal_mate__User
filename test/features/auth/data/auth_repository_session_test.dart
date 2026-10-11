import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/helpers/shared_pref.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/services/push_notification_service.dart';
import 'package:meal_meat_user/core/services/session_persistence.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:meal_meat_user/features/auth/data/models/request/login_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/request/verify_phone_request_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/login_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/models/response/verify_phone_response_dto.dart';
import 'package:meal_meat_user/features/auth/data/repo/auth_repository_impl.dart';
import 'package:meal_meat_user/features/auth/domain/entities/login_request_entity.dart';
import 'package:meal_meat_user/features/auth/domain/entities/verify_phone_request_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart';

class _FakeAuthRemoteDataSource extends Fake implements AuthRemoteDataSource {
  LoginResponseDto? loginResponse;
  VerifyPhoneResponseDto? verifyPhoneResponse;

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    return loginResponse!;
  }

  @override
  Future<VerifyPhoneResponseDto> verifyPhone(
    VerifyPhoneRequestDto request,
  ) async {
    return verifyPhoneResponse!;
  }
}

class _RecordingTokenService extends Fake implements TokenService {
  String? savedUserId;
  String? savedAccessToken;
  String? savedRefreshToken;
  DateTime? savedAccessExpiresAtUtc;
  DateTime? savedRefreshExpiresAtUtc;
  SessionPersistence? savedPersistence;
  int saveSessionCallCount = 0;
  bool isRemembered = false;

  @override
  Future<void> saveSession({
    required String userId,
    required String accessToken,
    required String refreshToken,
    required DateTime? accessExpiresAtUtc,
    required DateTime? refreshExpiresAtUtc,
    required SessionPersistence persistence,
  }) async {
    saveSessionCallCount++;
    savedUserId = userId;
    savedAccessToken = accessToken;
    savedRefreshToken = refreshToken;
    savedAccessExpiresAtUtc = accessExpiresAtUtc;
    savedRefreshExpiresAtUtc = refreshExpiresAtUtc;
    savedPersistence = persistence;
    isRemembered = persistence == SessionPersistence.remembered;
  }

  @override
  Future<bool> isRememberedSession() async => isRemembered;
}

class _FakeSharedPrefHelper extends Fake implements SharedPrefHelper {
  @override
  Future<bool> removeData({required String key}) async => true;
}

class _FakePushNotificationService extends Fake
    implements PushNotificationService {
  @override
  Future<void> registerCurrentToken({String? token}) async {}

  @override
  Future<void> unregisterCurrentToken() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeAuthRemoteDataSource remoteDataSource;
  late _RecordingTokenService tokenService;
  late _FakeSharedPrefHelper sharedPrefHelper;
  late _FakePushNotificationService pushNotificationService;
  late FamilyFlowSnapshotStore familyFlowSnapshotStore;
  late AuthRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _FakeAuthRemoteDataSource();
    tokenService = _RecordingTokenService();
    sharedPrefHelper = _FakeSharedPrefHelper();
    pushNotificationService = _FakePushNotificationService();
    familyFlowSnapshotStore = FamilyFlowSnapshotStore();

    repository = AuthRepositoryImpl(
      remoteDataSource,
      tokenService,
      sharedPrefHelper,
      pushNotificationService,
      familyFlowSnapshotStore,
    );
  });

  group('AuthRepositoryImpl - Session & remember persistence', () {
    test(
      'successful authenticated login saves session with specified persistence',
      () async {
        remoteDataSource.loginResponse = const LoginResponseDto(
          userId: 'user_1',
          accessToken: 'access_1',
          refreshToken: 'refresh_1',
          accessTokenExpiresAtUtc: '2026-12-01T10:00:00.000Z',
          refreshTokenExpiresAtUtc: '2026-12-15T10:00:00.000Z',
          isAuthenticated: true,
        );

        final result = await repository.login(
          const LoginRequestEntity(
            phone: '12345678',
            password: 'secret_password',
            countryCode: '+965',
          ),
          persistence: SessionPersistence.remembered,
        );

        expect(result, isA<ApiSuccessResult>());
        expect(tokenService.saveSessionCallCount, 1);
        expect(tokenService.savedUserId, 'user_1');
        expect(tokenService.savedAccessToken, 'access_1');
        expect(tokenService.savedRefreshToken, 'refresh_1');
        expect(tokenService.savedPersistence, SessionPersistence.remembered);
        expect(
          tokenService.savedAccessExpiresAtUtc,
          DateTime.utc(2026, 12, 1, 10, 0),
        );
      },
    );

    test(
      'login with isAuthenticated=false (challenge) does NOT save session',
      () async {
        remoteDataSource.loginResponse = const LoginResponseDto(
          userId: 'user_1',
          accessToken: '',
          refreshToken: '',
          nextStep: 'otp_verification',
          loginChallengeToken: 'challenge_token',
          isAuthenticated: false,
        );

        final result = await repository.login(
          const LoginRequestEntity(
            phone: '12345678',
            password: 'secret_password',
            countryCode: '+965',
          ),
          persistence: SessionPersistence.remembered,
        );

        expect(result, isA<ApiSuccessResult>());
        expect(tokenService.saveSessionCallCount, 0);
      },
    );

    test(
      'login with empty tokens does NOT save session even if isAuthenticated is true',
      () async {
        remoteDataSource.loginResponse = const LoginResponseDto(
          userId: 'user_1',
          accessToken: '',
          refreshToken: '',
          isAuthenticated: true,
        );

        final result = await repository.login(
          const LoginRequestEntity(
            phone: '12345678',
            password: 'secret_password',
            countryCode: '+965',
          ),
          persistence: SessionPersistence.remembered,
        );

        expect(result, isA<ApiSuccessResult>());
        expect(tokenService.saveSessionCallCount, 0);
      },
    );

    test('verifyPhone saves session with currentRun persistence', () async {
      remoteDataSource.verifyPhoneResponse = const VerifyPhoneResponseDto(
        userId: 'user_2',
        accessToken: 'access_2',
        refreshToken: 'refresh_2',
        accessTokenExpiresAtUtc: '2026-12-01T10:00:00.000Z',
        refreshTokenExpiresAtUtc: '2026-12-15T10:00:00.000Z',
      );

      final result = await repository.verifyPhone(
        const VerifyPhoneRequestEntity(
          phone: '12345678',
          code: '123456',
          countryCode: '+965',
        ),
      );

      expect(result, isA<ApiSuccessResult>());
      expect(tokenService.saveSessionCallCount, 1);
      expect(tokenService.savedUserId, 'user_2');
      expect(tokenService.savedPersistence, SessionPersistence.currentRun);
    });
  });
}
