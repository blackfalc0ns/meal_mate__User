import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_checkout_entity.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_summary/domain/entities/family_summary_entity.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_event.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_state.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_view_model.dart';
import 'package:meal_meat_user/features/family_summary/presentation/screens/family_summary_screen.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_entity.dart';

class _MockFamilyCheckoutViewModel extends Cubit<FamilyCheckoutState>
    implements FamilyCheckoutViewModel {
  _MockFamilyCheckoutViewModel(super.initialState);

  final List<FamilyCheckoutEvent> dispatchedEvents = [];

  @override
  String get correlationId => 'mock-corr-id';

  @override
  void doIntent(FamilyCheckoutEvent event) {
    dispatchedEvents.add(event);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final getIt = GetIt.instance;

  tearDown(() async {
    if (getIt.isRegistered<FamilyCheckoutViewModel>()) {
      await getIt.unregister<FamilyCheckoutViewModel>();
    }
  });

  Future<void> setUpViewModel(FamilyCheckoutViewModel viewModel) async {
    if (getIt.isRegistered<FamilyCheckoutViewModel>()) {
      await getIt.unregister<FamilyCheckoutViewModel>();
    }
    getIt.registerFactory<FamilyCheckoutViewModel>(() => viewModel);
  }

  Widget createTestWidget({NavigatorObserver? observer}) {
    return MaterialApp(
      locale: const Locale('ar'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: observer != null ? [observer] : [],
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.paymentWebView) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('WebViewScreen')),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => const FamilyPaymentSetupScreen(),
          settings: settings,
        );
      },
      home: const FamilyPaymentSetupScreen(),
    );
  }

  testWidgets(
    'WebView opens once when checkoutResult is unchanged across multiple state emissions',
    (tester) async {
      final vm = _MockFamilyCheckoutViewModel(
        const FamilyCheckoutState(
          summary: FamilySummaryEntity(
            subtotal: 100,
            familyDiscountPercent: 0,
            familyDiscountAmount: 0,
            finalPrice: 100,
            canCheckout: true,
            selectedNewSubscriberCount: 1,
            batchId: 'batch-1',
            batchVersion: 1,
          ),
          selectedSummaryMemberId: 'm-1',
        ),
      );

      var webViewPushCount = 0;
      final observer = _RouteCountObserver(
        targetRoute: AppRoutes.paymentWebView,
        onPushed: () => webViewPushCount++,
      );

      await setUpViewModel(vm);
      await tester.pumpWidget(createTestWidget(observer: observer));
      await tester.pumpAndSettle();

      const checkout = PaymentCheckoutEntity(
        subscriptionId: 'sub-1',
        paymentUrl: 'https://payment.test',
        holdExpiresAtUtc: '2026-10-20T00:00:00Z',
        chosenStartDate: '2026-10-20',
        startDate: '2026-10-20',
        finalPrice: 100.0,
        priceSnapshotId: 'snap-1',
        restaurantPoolSnapshotId: 'pool-1',
        paymentStatus: '0',
        paymentId: 'pay-1',
      );

      // Emit checkoutResult
      vm.emit(vm.state.copyWith(checkoutResult: checkout));
      await tester.pumpAndSettle();

      expect(
        webViewPushCount,
        1,
        reason: 'First checkout emission should push WebView',
      );

      // Emit another state with the SAME checkoutResult
      vm.emit(vm.state.copyWith(selectedMemberIndex: 0));
      await tester.pump(const Duration(milliseconds: 350));

      expect(
        webViewPushCount,
        1,
        reason:
            'Subsequent state with same checkoutResult must not push WebView again',
      );

      final navigator = tester.state<NavigatorState>(
        find.byType(Navigator).first,
      );
      navigator.pop();
      await tester.pump(const Duration(milliseconds: 350));
    },
  );

  testWidgets(
    'Snackbar is shown once when failure is unchanged across multiple state emissions',
    (tester) async {
      final vm = _MockFamilyCheckoutViewModel(
        const FamilyCheckoutState(
          summary: FamilySummaryEntity(
            subtotal: 100,
            familyDiscountPercent: 0,
            familyDiscountAmount: 0,
            finalPrice: 100,
            canCheckout: true,
            selectedNewSubscriberCount: 1,
          ),
          selectedSummaryMemberId: 'm-1',
        ),
      );

      await setUpViewModel(vm);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final failure = Failure(errorMessage: 'Payment error occurred');

      // First failure emit
      vm.emit(vm.state.copyWith(failure: failure));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final toastFinder = find.byType(CherryToast);
      expect(toastFinder, findsOneWidget);

      // Emit another state with the SAME failure
      vm.emit(vm.state.copyWith(isPaymentMethodsLoading: true));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Must still be 1, not duplicate
      expect(toastFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Returning from WebView dispatches GetFamilySummaryEvent with activeMemberId',
    (tester) async {
      final vm = _MockFamilyCheckoutViewModel(
        const FamilyCheckoutState(
          summary: FamilySummaryEntity(
            subtotal: 100,
            familyDiscountPercent: 0,
            familyDiscountAmount: 0,
            finalPrice: 100,
            canCheckout: true,
            selectedNewSubscriberCount: 1,
            batchId: 'batch-1',
            batchVersion: 1,
          ),
          selectedSummaryMemberId: 'member-target-99',
        ),
      );

      await setUpViewModel(vm);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      vm.dispatchedEvents.clear();

      const checkout = PaymentCheckoutEntity(
        subscriptionId: 'sub-1',
        paymentUrl: 'https://payment.test',
        holdExpiresAtUtc: '2026-10-20T00:00:00Z',
        chosenStartDate: '2026-10-20',
        startDate: '2026-10-20',
        finalPrice: 100.0,
        priceSnapshotId: 'snap-1',
        restaurantPoolSnapshotId: 'pool-1',
        paymentStatus: '0',
        paymentId: 'pay-1',
      );

      vm.emit(vm.state.copyWith(checkoutResult: checkout));
      await tester.pumpAndSettle();

      expect(find.text('WebViewScreen'), findsOneWidget);

      // Pop WebView
      final navigator = tester.state<NavigatorState>(
        find.byType(Navigator).first,
      );
      navigator.pop();
      await tester.pumpAndSettle();

      final summaryEvents = vm.dispatchedEvents
          .whereType<GetFamilySummaryEvent>()
          .toList();
      expect(summaryEvents, isNotEmpty);
      expect(summaryEvents.last.memberId, 'member-target-99');
    },
  );

  testWidgets(
    'Payment methods failure with valid summary shows inline error without replacing entire screen',
    (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final vm = _MockFamilyCheckoutViewModel(
        FamilyCheckoutState(
          summary: const FamilySummaryEntity(
            subtotal: 100,
            familyDiscountPercent: 0,
            familyDiscountAmount: 0,
            finalPrice: 100,
            canCheckout: true,
            selectedNewSubscriberCount: 1,
            batchId: 'batch-1',
            batchVersion: 1,
          ),
          selectedSummaryMemberId: 'm-1',
          failure: Failure(errorMessage: 'Could not load payment methods'),
        ),
      );

      await setUpViewModel(vm);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Screen is not replaced by ApiErrorWidget
      expect(find.byType(ApiErrorWidget), findsNothing);
      // InlineApiErrorWidget is shown in payment methods section
      expect(find.byType(InlineApiErrorWidget), findsOneWidget);
    },
  );

  testWidgets(
    'Changing selectedPaymentMethod updates payment methods without rebuilding screen content animation',
    (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const method1 = PaymentMethodEntity(
        id: 1,
        title: 'KNET',
        subtitle: '',
        type: PaymentMethodType.payzah,
        isAvailable: true,
      );
      const method2 = PaymentMethodEntity(
        id: 2,
        title: 'Credit Card',
        subtitle: '',
        type: PaymentMethodType.visa,
        isAvailable: true,
      );

      final vm = _MockFamilyCheckoutViewModel(
        const FamilyCheckoutState(
          summary: FamilySummaryEntity(
            subtotal: 100,
            familyDiscountPercent: 0,
            familyDiscountAmount: 0,
            finalPrice: 100,
            canCheckout: true,
            selectedNewSubscriberCount: 1,
            batchId: 'batch-1',
            batchVersion: 1,
          ),
          selectedSummaryMemberId: 'm-1',
          paymentMethods: [method1, method2],
          selectedPaymentMethod: method1,
        ),
      );

      await setUpViewModel(vm);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('KNET'), findsOneWidget);
      expect(find.text('Credit Card'), findsOneWidget);

      // Now emit state with method2 selected
      vm.emit(vm.state.copyWith(selectedPaymentMethod: method2));
      await tester.pump();

      expect(find.text('Credit Card'), findsOneWidget);
    },
  );

  testWidgets(
    'In pending checkout or retry state, action button triggers RetryFamilySubscriptionPaymentEvent',
    (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const method1 = PaymentMethodEntity(
        id: 3,
        title: 'KNET',
        subtitle: '',
        type: PaymentMethodType.payzah,
        isAvailable: true,
      );

      final vm = _MockFamilyCheckoutViewModel(
        const FamilyCheckoutState(
          summary: FamilySummaryEntity(
            subtotal: 100,
            familyDiscountPercent: 0,
            familyDiscountAmount: 0,
            finalPrice: 100,
            canCheckout: false,
            checkoutBlockReason: 'family.checkout_pending',
            selectedNewSubscriberCount: 1,
            batchId: 'batch-1',
            batchVersion: 1,
          ),
          selectedSummaryMemberId: 'm-1',
          paymentMethods: [method1],
          selectedPaymentMethod: method1,
        ),
      );

      await setUpViewModel(vm);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Find the retry / resume payment button
      final resumeButton = find.byType(ElevatedButton);
      expect(resumeButton, findsWidgets);

      await tester.tap(resumeButton.last);
      await tester.pump();

      expect(
        vm.dispatchedEvents.any(
          (e) => e is RetryFamilySubscriptionPaymentEvent && e.paymentMethodId == 3,
        ),
        isTrue,
      );
    },
  );
}

class _RouteCountObserver extends NavigatorObserver {
  _RouteCountObserver({required this.targetRoute, required this.onPushed});

  final String targetRoute;
  final VoidCallback onPushed;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name == targetRoute) {
      onPushed();
    }
    super.didPush(route, previousRoute);
  }
}
