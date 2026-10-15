import 'package:meal_meat_user/core/errors/failures.dart';

class FamilyManagementFailure extends Failure {
  FamilyManagementFailure({
    required super.errorMessage,
    required super.code,
    super.exception,
    this.statusCode,
    this.currentVersion,
    this.batchVersion,
    this.requiresManager = false,
    this.isPausedMember = false,
    this.isPermissionConflict = false,
    this.isQuoteChanged = false,
    this.isAuthForbidden = false,
    this.isFulfillmentNotReady = false,
    this.isNetworkError = false,
    this.isPasswordAlreadyIssued = false,
  });

  final int? statusCode;
  final int? currentVersion;
  final int? batchVersion;
  final bool requiresManager;
  final bool isPausedMember;
  final bool isPermissionConflict;
  final bool isQuoteChanged;
  final bool isAuthForbidden;
  final bool isFulfillmentNotReady;
  final bool isNetworkError;
  final bool isPasswordAlreadyIssued;

  bool get isUnknown => code == 'unknown' || code == 'UNKNOWN_ERROR';

  @override
  String toString() =>
      'FamilyManagementFailure(code: $code, message: $errorMessage, status: $statusCode, currentVersion: $currentVersion)';
}
