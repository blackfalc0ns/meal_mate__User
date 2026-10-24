import 'package:meal_meat_user/features/customer_orders/domain/entities/delivered_box_entity.dart';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/customer_support/domain/usecase/create_customer_issue_usecase.dart';
import 'package:meal_meat_user/features/customer_support/domain/usecase/get_customer_issue_options_usecase.dart';
import 'package:meal_meat_user/features/customer_support/domain/usecase/get_customer_issue_usecase.dart';
import 'package:meal_meat_user/features/customer_support/domain/usecase/get_customer_issues_usecase.dart';
import 'package:meal_meat_user/features/customer_orders/domain/usecase/get_delivered_boxes_usecase.dart';
import 'package:meal_meat_user/features/customer_support/domain/usecase/reply_customer_issue_usecase.dart';
import 'package:meal_meat_user/features/customer_support/presentation/manager/customer_support_state.dart';

@injectable
class CustomerSupportViewModel extends Cubit<CustomerSupportState> {
  CustomerSupportViewModel(
    this._options,
    this._boxes,
    this._create,
    this._issues,
    this._issue,
    this._reply,
  ) : super(const CustomerSupportState());

  final GetCustomerIssueOptionsUseCase _options;
  final GetDeliveredBoxesUseCase _boxes;
  final CreateCustomerIssueUseCase _create;
  final GetCustomerIssuesUseCase _issues;
  final GetCustomerIssueUseCase _issue;
  final ReplyCustomerIssueUseCase _reply;
  static String _newKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  String? _pendingCreateKey;
  String? _pendingCreateSignature;
  String? _pendingReplyKey;
  String? _pendingReplySignature;

  Future<void> loadOptions() async {
    emit(state.copyWith(loading: true, clearError: true));
    final result = await _options();
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(loading: false, options: data));
      case ApiErrorResult(:final failure):
        emit(
          state.copyWith(loading: false, errorMessage: failure.errorMessage),
        );
    }
  }

  Future<void> loadBoxes({bool next = false}) async {
    if (state.loading) return;
    final page = next ? state.boxesPage + 1 : 1;
    if (next && state.boxes.length >= state.boxesTotal) return;
    emit(state.copyWith(loading: true, clearError: true));
    final result = await _boxes(pageNumber: page, pageSize: 20);
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(
          state.copyWith(
            loading: false,
            boxes: next ? [...state.boxes, ...data.items] : data.items,
            boxesPage: page,
            boxesTotal: data.totalCount,
          ),
        );
      case ApiErrorResult(:final failure):
        emit(
          state.copyWith(
            loading: false,
            boxes: failure.statusCode == 403 || failure.statusCode == 404
                ? const []
                : null,
            boxesTotal: failure.statusCode == 403 || failure.statusCode == 404
                ? 0
                : null,
            errorMessage: failure.errorMessage,
          ),
        );
    }
  }

  Future<void> createIssue({
    required String typeCode,
    required String subject,
    required String description,
    DeliveredBoxEntity? box,
  }) async {
    if (state.submitting) return;
    final signature =
        '$typeCode\u0000$subject\u0000$description\u0000${box?.relatedResourceType}\u0000${box?.relatedResourceId}';
    if (_pendingCreateSignature != signature) {
      _pendingCreateSignature = signature;
      _pendingCreateKey = _newKey();
    }
    emit(
      state.copyWith(
        submitting: true,
        clearCreatedIssue: true,
        clearError: true,
      ),
    );
    final result = await _create(
      typeCode: typeCode,
      subject: subject,
      description: description,
      idempotencyKey: _pendingCreateKey!,
      relatedResourceType: box?.relatedResourceType,
      relatedResourceId: box?.relatedResourceId,
    );
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult(:final data):
        _pendingCreateKey = null;
        _pendingCreateSignature = null;
        emit(state.copyWith(submitting: false, createdIssue: data));
      case ApiErrorResult(:final failure):
        if (failure.statusCode case final int status
            when status >= 400 && status < 500) {
          _pendingCreateKey = null;
          _pendingCreateSignature = null;
        }
        emit(
          state.copyWith(submitting: false, errorMessage: failure.errorMessage),
        );
    }
  }

  Future<void> loadIssues({bool next = false}) async {
    if (state.loading) return;
    final page = next ? state.issuesPage + 1 : 1;
    if (next && state.issues.length >= state.issuesTotal) return;
    emit(state.copyWith(loading: true, clearError: true));
    final result = await _issues(pageNumber: page, pageSize: 20);
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(
          state.copyWith(
            loading: false,
            issues: next ? [...state.issues, ...data.items] : data.items,
            issuesPage: page,
            issuesTotal: data.totalCount,
          ),
        );
      case ApiErrorResult(:final failure):
        emit(
          state.copyWith(
            loading: false,
            issues: failure.statusCode == 403 || failure.statusCode == 404
                ? const []
                : null,
            issuesTotal: failure.statusCode == 403 || failure.statusCode == 404
                ? 0
                : null,
            errorMessage: failure.errorMessage,
          ),
        );
    }
  }

  Future<void> loadIssue(String caseId) async {
    emit(
      state.copyWith(loading: true, clearCurrentIssue: true, clearError: true),
    );
    final result = await _issue(caseId);
    if (isClosed) return;
    switch (result) {
      case ApiSuccessResult(:final data):
        emit(state.copyWith(loading: false, currentIssue: data));
      case ApiErrorResult(:final failure):
        emit(
          state.copyWith(loading: false, errorMessage: failure.errorMessage),
        );
    }
  }

  Future<bool> reply(String body) async {
    final current = state.currentIssue;
    if (current == null || state.submitting) return false;
    final signature = '${current.id}\u0000${current.version}\u0000$body';
    if (_pendingReplySignature != signature) {
      _pendingReplySignature = signature;
      _pendingReplyKey = _newKey();
    }
    emit(state.copyWith(submitting: true, clearError: true));
    final result = await _reply(
      caseId: current.id,
      body: body,
      expectedVersion: current.version,
      idempotencyKey: _pendingReplyKey!,
    );
    if (isClosed) return false;
    switch (result) {
      case ApiSuccessResult(:final data):
        _pendingReplyKey = null;
        _pendingReplySignature = null;
        emit(state.copyWith(submitting: false, currentIssue: data));
        return true;
      case ApiErrorResult(:final failure):
        if (failure.statusCode == 409) {
          _pendingReplyKey = null;
          _pendingReplySignature = null;
          await loadIssue(current.id);
          if (isClosed) return false;
        }
        emit(
          state.copyWith(submitting: false, errorMessage: failure.errorMessage),
        );
        return false;
    }
  }
}
