import 'package:meal_meat_user/features/customer_orders/domain/entities/delivered_box_entity.dart';
import 'package:meal_meat_user/features/customer_support/domain/entities/customer_support_entity.dart';

class CustomerSupportState {
  const CustomerSupportState({
    this.loading = false,
    this.submitting = false,
    this.options = const [],
    this.boxes = const [],
    this.boxesPage = 0,
    this.boxesTotal = 0,
    this.issues = const [],
    this.issuesPage = 0,
    this.issuesTotal = 0,
    this.currentIssue,
    this.errorMessage,
    this.createdIssue,
  });

  final bool loading;
  final bool submitting;
  final List<CustomerSupportOptionEntity> options;
  final List<DeliveredBoxEntity> boxes;
  final int boxesPage;
  final int boxesTotal;
  final List<CustomerIssueEntity> issues;
  final int issuesPage;
  final int issuesTotal;
  final CustomerIssueEntity? currentIssue;
  final String? errorMessage;
  final CustomerIssueEntity? createdIssue;

  CustomerSupportState copyWith({
    bool? loading,
    bool? submitting,
    List<CustomerSupportOptionEntity>? options,
    List<DeliveredBoxEntity>? boxes,
    int? boxesPage,
    int? boxesTotal,
    List<CustomerIssueEntity>? issues,
    int? issuesPage,
    int? issuesTotal,
    CustomerIssueEntity? currentIssue,
    bool clearCurrentIssue = false,
    String? errorMessage,
    bool clearError = false,
    CustomerIssueEntity? createdIssue,
    bool clearCreatedIssue = false,
  }) => CustomerSupportState(
    loading: loading ?? this.loading,
    submitting: submitting ?? this.submitting,
    options: options ?? this.options,
    boxes: boxes ?? this.boxes,
    boxesPage: boxesPage ?? this.boxesPage,
    boxesTotal: boxesTotal ?? this.boxesTotal,
    issues: issues ?? this.issues,
    issuesPage: issuesPage ?? this.issuesPage,
    issuesTotal: issuesTotal ?? this.issuesTotal,
    currentIssue: clearCurrentIssue ? null : currentIssue ?? this.currentIssue,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    createdIssue: clearCreatedIssue ? null : createdIssue ?? this.createdIssue,
  );
}
