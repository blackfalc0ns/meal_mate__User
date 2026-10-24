import 'package:meal_meat_user/features/customer_orders/domain/entities/delivered_box_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/customer_support/domain/entities/customer_support_entity.dart';
import 'package:meal_meat_user/features/customer_support/domain/repo/customer_support_repository.dart';
import 'package:meal_meat_user/features/customer_support/domain/usecase/create_customer_issue_usecase.dart';
import 'package:meal_meat_user/features/customer_support/domain/usecase/get_customer_issue_options_usecase.dart';
import 'package:meal_meat_user/features/customer_support/domain/usecase/get_customer_issue_usecase.dart';
import 'package:meal_meat_user/features/customer_support/domain/usecase/get_customer_issues_usecase.dart';
import 'package:meal_meat_user/features/customer_orders/domain/usecase/get_delivered_boxes_usecase.dart';
import 'package:meal_meat_user/features/customer_orders/domain/repo/customer_orders_repository.dart';
import 'package:meal_meat_user/features/customer_orders/presentation/manager/customer_orders_view_model.dart';
import 'package:meal_meat_user/features/customer_support/domain/usecase/reply_customer_issue_usecase.dart';
import 'package:meal_meat_user/features/customer_support/presentation/manager/customer_support_view_model.dart';
import 'package:meal_meat_user/features/customer_orders/presentation/screens/delivered_orders_screen.dart';
import 'package:meal_meat_user/features/profile/presentation/support/screens/profile_complaints_screen.dart';

class _FakeCustomerSupportRepository
    implements CustomerSupportRepository, CustomerOrdersRepository {
  String? createdTypeCode;
  String? createdResourceType;
  String? createdResourceId;
  final List<String> createKeys = [];
  bool failFirstCreate = false;

  @override
  Future<ApiResult<List<CustomerSupportOptionEntity>>>
  getIssueOptions() async => const ApiSuccessResult(
    data: [
      CustomerSupportOptionEntity(value: 'box_problem', label: 'Box problem'),
    ],
  );

  @override
  Future<ApiResult<DeliveredBoxesPageEntity>> getDeliveredBoxes({
    required int pageNumber,
    required int pageSize,
    String? fromDate,
    String? toDate,
    String? subscriptionId,
  }) async => const ApiSuccessResult(
    data: DeliveredBoxesPageEntity(
      items: [
        DeliveredBoxEntity(
          subscriptionId: 'subscription-1',
          subscriptionDayId: 'day-1',
          serviceDate: '2026-10-24',
          relatedResourceType: 'RestaurantDailyOrder',
          relatedResourceId: 'order-1',
          orderCode: 'BX-1258',
        ),
      ],
      totalCount: 1,
      pageNumber: 1,
      pageSize: 20,
    ),
  );

  @override
  Future<ApiResult<CustomerIssueEntity>> createIssue({
    required String typeCode,
    required String subject,
    required String description,
    required String idempotencyKey,
    String? relatedResourceType,
    String? relatedResourceId,
  }) async {
    createKeys.add(idempotencyKey);
    createdTypeCode = typeCode;
    createdResourceType = relatedResourceType;
    createdResourceId = relatedResourceId;
    if (failFirstCreate && createKeys.length == 1) {
      return ApiErrorResult(failure: Failure(errorMessage: 'Timeout'));
    }
    return const ApiSuccessResult(
      data: CustomerIssueEntity(id: 'case-1', status: 'Open', version: 1),
    );
  }

  @override
  Future<ApiResult<CustomerIssuesPageEntity>> getIssues({
    required int pageNumber,
    required int pageSize,
    String? status,
    String? typeCode,
  }) async => const ApiSuccessResult(
    data: CustomerIssuesPageEntity(
      items: [],
      totalCount: 0,
      pageNumber: 1,
      pageSize: 20,
    ),
  );

  @override
  Future<ApiResult<CustomerIssueEntity>> getIssue(String caseId) async =>
      const ApiSuccessResult(
        data: CustomerIssueEntity(id: 'case-1', status: 'Open', version: 1),
      );

  @override
  Future<ApiResult<CustomerIssueEntity>> reply({
    required String caseId,
    required String body,
    required int expectedVersion,
    required String idempotencyKey,
    List<String>? attachmentKeys,
  }) async => const ApiSuccessResult(
    data: CustomerIssueEntity(id: 'case-1', status: 'Open', version: 2),
  );
}

void main() {
  testWidgets('my orders opens complaint for selected delivered box', (
    tester,
  ) async {
    final repository = _FakeCustomerSupportRepository();
    getIt.registerFactory<CustomerOrdersViewModel>(
      () => CustomerOrdersViewModel(GetDeliveredBoxesUseCase(repository)),
    );
    addTearDown(() => getIt.unregister<CustomerOrdersViewModel>());
    getIt.registerFactory<CustomerSupportViewModel>(
      () => CustomerSupportViewModel(
        GetCustomerIssueOptionsUseCase(repository),
        GetDeliveredBoxesUseCase(repository),
        CreateCustomerIssueUseCase(repository),
        GetCustomerIssuesUseCase(repository),
        GetCustomerIssueUseCase(repository),
        ReplyCustomerIssueUseCase(repository),
      ),
    );
    addTearDown(() => getIt.unregister<CustomerSupportViewModel>());
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: DeliveredOrdersScreen(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('BX-1258'), findsOneWidget);
    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    expect(find.text('Box problem'), findsOneWidget);
    final fields = find.byType(TextField);
    await tester.tap(find.text('Box problem'));
    await tester.enterText(fields.at(0), 'Damaged box');
    await tester.enterText(fields.at(1), 'The box arrived damaged');
    await tester.ensureVisible(find.text('Submit'));
    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(repository.createdResourceId, 'order-1');
  });

  testWidgets('order entry preselects its exact resource for the complaint', (
    tester,
  ) async {
    final repository = _FakeCustomerSupportRepository();
    getIt.registerFactory<CustomerSupportViewModel>(
      () => CustomerSupportViewModel(
        GetCustomerIssueOptionsUseCase(repository),
        GetDeliveredBoxesUseCase(repository),
        CreateCustomerIssueUseCase(repository),
        GetCustomerIssuesUseCase(repository),
        GetCustomerIssueUseCase(repository),
        ReplyCustomerIssueUseCase(repository),
      ),
    );
    addTearDown(() => getIt.unregister<CustomerSupportViewModel>());
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ProfileComplaintsScreen(
          initialBox: DeliveredBoxEntity(
            subscriptionId: 'subscription-1',
            subscriptionDayId: 'day-1',
            serviceDate: '2026-10-24',
            relatedResourceType: 'RestaurantDailyOrder',
            relatedResourceId: 'order-1',
            orderCode: 'BX-1258',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Box problem'));
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Damaged box');
    await tester.enterText(fields.at(1), 'The box arrived damaged');
    await tester.ensureVisible(find.text('Submit'));
    await tester.tap(find.text('Submit'));
    await tester.pump();
    expect(repository.createdResourceType, 'RestaurantDailyOrder');
    expect(repository.createdResourceId, 'order-1');
  });

  test('uncertain create retry keeps the same operation key', () async {
    final repository = _FakeCustomerSupportRepository()..failFirstCreate = true;
    final viewModel = CustomerSupportViewModel(
      GetCustomerIssueOptionsUseCase(repository),
      GetDeliveredBoxesUseCase(repository),
      CreateCustomerIssueUseCase(repository),
      GetCustomerIssuesUseCase(repository),
      GetCustomerIssueUseCase(repository),
      ReplyCustomerIssueUseCase(repository),
    );
    await viewModel.createIssue(
      typeCode: 'box_problem',
      subject: 'Damaged',
      description: 'Damaged box',
    );
    await viewModel.createIssue(
      typeCode: 'box_problem',
      subject: 'Damaged',
      description: 'Damaged box',
    );
    expect(repository.createKeys, hasLength(2));
    expect(repository.createKeys.first, repository.createKeys.last);
    await viewModel.close();
  });

  testWidgets('complaint form sends selected server code and resource pair', (
    tester,
  ) async {
    final repository = _FakeCustomerSupportRepository();
    getIt.registerFactory<CustomerSupportViewModel>(
      () => CustomerSupportViewModel(
        GetCustomerIssueOptionsUseCase(repository),
        GetDeliveredBoxesUseCase(repository),
        CreateCustomerIssueUseCase(repository),
        GetCustomerIssuesUseCase(repository),
        GetCustomerIssueUseCase(repository),
        ReplyCustomerIssueUseCase(repository),
      ),
    );
    addTearDown(() => getIt.unregister<CustomerSupportViewModel>());

    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ProfileComplaintsScreen(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Box problem'));
    await tester.ensureVisible(find.text('General complaint'));
    await tester.tap(find.text('General complaint'));
    await tester.pumpAndSettle();
    expect(find.textContaining('BX-1258'), findsWidgets);
    await tester.tap(find.textContaining('BX-1258').last);
    await tester.pumpAndSettle();
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Damaged box');
    await tester.enterText(fields.at(1), 'The box arrived damaged');
    await tester.tap(find.text('Submit'));
    await tester.pump();

    expect(repository.createdTypeCode, 'box_problem');
    expect(repository.createdResourceType, 'RestaurantDailyOrder');
    expect(repository.createdResourceId, 'order-1');
  });
}
