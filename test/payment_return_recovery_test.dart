import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/payment/payment_attempt.dart';
import 'package:meal_meat_user/core/payment/payment_attempt_store.dart';
import 'package:meal_meat_user/core/payment/payment_deep_link_coordinator.dart';
import 'package:meal_meat_user/core/payment/payment_return.dart';
import 'package:meal_meat_user/core/services/app_navigator_service.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/offers/domain/entities/campaign_payment_screen_args.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';

class _FakeTokenService implements TokenService {
  bool hasTokens = true;
  String? userId = 'cust-123';

  @override
  Future<bool> hasValidSessionTokens() async => hasTokens;

  @override
  Future<String?> getCurrentUserId() async => userId;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakePaymentAttemptStore implements PaymentAttemptStore {
  PaymentAttempt? attempt;

  @override
  Future<PaymentAttempt?> readForCustomer(String customerId) async {
    if (attempt?.ownerCustomerId == customerId) {
      return attempt;
    }
    return null;
  }

  @override
  Future<void> save(PaymentAttempt attempt) async {
    this.attempt = attempt;
  }

  @override
  Future<void> removeForCustomer(String customerId) async {
    if (attempt?.ownerCustomerId == customerId) {
      attempt = null;
    }
  }
}

class _FakeNavigatorService extends AppNavigatorService {
  String? lastPushedRoute;
  Object? lastArguments;
  int pushCount = 0;

  @override
  Future<T?> pushNamedWhenReady<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) async {
    lastPushedRoute = routeName;
    lastArguments = arguments;
    pushCount++;
    return null;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeTokenService fakeTokenService;
  late _FakePaymentAttemptStore fakeStore;
  late _FakeNavigatorService fakeNavigator;
  late PaymentDeepLinkCoordinator coordinator;

  setUp(() {
    fakeTokenService = _FakeTokenService();
    fakeStore = _FakePaymentAttemptStore();
    fakeNavigator = _FakeNavigatorService();
    coordinator = PaymentDeepLinkCoordinator(
      tokenService: fakeTokenService,
      paymentAttemptStore: fakeStore,
      navigatorService: fakeNavigator,
    );
  });

  group('PaymentDeepLinkCoordinator & Return Recovery Tests', () {
    test(
      'warm start didPushRouteInformation parses link and dispatches to webview',
      () async {
        fakeStore.attempt = PaymentAttempt(
          schemaVersion: 1,
          ownerCustomerId: 'cust-123',
          subscriptionId: 'sub-matched-42',
          paymentId: 'pz-track-123',
          createdAtUtc: DateTime.now().toUtc(),
        );

        final handled = await coordinator.didPushRouteInformation(
          RouteInformation(
            uri: Uri.parse(
              'mealmate://checkout/success?paymentId=pz-track-123',
            ),
          ),
        );

        expect(handled, isTrue);
        expect(fakeNavigator.lastPushedRoute, equals(AppRoutes.paymentWebView));
        expect(fakeNavigator.lastArguments, isA<PaymentWebViewArgs>());
        final args = fakeNavigator.lastArguments as PaymentWebViewArgs;
        expect(args.checkout.subscriptionId, equals('sub-matched-42'));
        expect(args.checkout.paymentId, equals('pz-track-123'));
      },
    );

    test(
      'cold start / unauthenticated queues link until user logs in',
      () async {
        fakeTokenService.hasTokens = false;

        const returnItem = PaymentReturn(
          destination: PaymentReturnDestination.success,
          paymentId: 'pz-deferred-99',
        );

        await coordinator.handleReturn(returnItem);

        // Should NOT have navigated while unauthenticated
        expect(fakeNavigator.pushCount, equals(0));

        // User completes authentication
        fakeTokenService.hasTokens = true;
        fakeTokenService.userId = 'cust-123';
        fakeStore.attempt = PaymentAttempt(
          schemaVersion: 1,
          ownerCustomerId: 'cust-123',
          subscriptionId: 'sub-after-auth',
          paymentId: 'pz-deferred-99',
          createdAtUtc: DateTime.now().toUtc(),
        );

        await coordinator.onUserAuthenticated();

        expect(fakeNavigator.pushCount, equals(1));
        expect(fakeNavigator.lastPushedRoute, equals(AppRoutes.paymentWebView));
        final args = fakeNavigator.lastArguments as PaymentWebViewArgs;
        expect(args.checkout.subscriptionId, equals('sub-after-auth'));
        expect(args.checkout.paymentId, equals('pz-deferred-99'));
      },
    );

    test('deduplicates rapid return links for the same paymentId', () async {
      const returnItem = PaymentReturn(
        destination: PaymentReturnDestination.pending,
        paymentId: 'pz-dup-check',
      );

      await coordinator.handleReturn(returnItem);
      expect(fakeNavigator.pushCount, equals(1));

      // Immediate second link within 3s window is deduplicated
      await coordinator.handleReturn(returnItem);
      expect(fakeNavigator.pushCount, equals(1));
    });

    test(
      'review destination persists conservative review lock in attempt store',
      () async {
        fakeStore.attempt = PaymentAttempt(
          schemaVersion: 1,
          ownerCustomerId: 'cust-123',
          subscriptionId: 'sub-review-test',
          paymentId: 'pz-review-attempt',
          createdAtUtc: DateTime.now().toUtc(),
          reviewRequired: false,
        );

        const returnItem = PaymentReturn(
          destination: PaymentReturnDestination.review,
          paymentId: 'pz-review-attempt',
        );

        await coordinator.handleReturn(returnItem);

        expect(fakeStore.attempt?.reviewRequired, isTrue);
        expect(fakeNavigator.pushCount, equals(1));
      },
    );

    test(
      'unknown or mismatched paymentId forwards empty subscriptionId for fallback resolution',
      () async {
        // Stored attempt belongs to a different paymentId
        fakeStore.attempt = PaymentAttempt(
          schemaVersion: 1,
          ownerCustomerId: 'cust-123',
          subscriptionId: 'sub-current-active',
          paymentId: 'pz-older-attempt',
          createdAtUtc: DateTime.now().toUtc(),
        );

        const returnItem = PaymentReturn(
          destination: PaymentReturnDestination.success,
          paymentId: 'pz-unknown-or-different',
        );

        await coordinator.handleReturn(returnItem);

        expect(fakeNavigator.pushCount, equals(1));
        final args = fakeNavigator.lastArguments as PaymentWebViewArgs;
        // Does not wrongly claim the older subscriptionId
        expect(args.checkout.subscriptionId, isEmpty);
        expect(args.checkout.paymentId, equals('pz-unknown-or-different'));
      },
    );

    test(
      'campaign payment callback routes to campaignPayment with CampaignPaymentScreenArgs',
      () async {
        final handled = await coordinator.didPushRouteInformation(
          RouteInformation(
            uri: Uri.parse(
              'mealmate://campaign-payment/callback?sessionId=sess-cmp-1&paymentId=pz-cmp-1&status=Paid',
            ),
          ),
        );

        expect(handled, isTrue);
        expect(fakeNavigator.lastPushedRoute, AppRoutes.campaignPayment);
        expect(fakeNavigator.lastArguments, isA<CampaignPaymentScreenArgs>());
        final args = fakeNavigator.lastArguments as CampaignPaymentScreenArgs;
        expect(args.sessionId, 'sess-cmp-1');
        expect(args.paymentId, 'pz-cmp-1');
        expect(args.callbackStatus, 'Paid');
      },
    );
  });
}
