import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

import 'base_error_widget.dart';

class ClientErrorWidget extends BaseErrorWidget {
  // رسالة الـ server المخصصة

  const ClientErrorWidget({
    super.key,
    required this.clientErrorType,
    this.statusCode,
    this.serverMessage,
    super.onRetry,
    VoidCallback? onGoBack,
  }) : super(
         title: '',
         description: '',
         icon: Icons.warning,
         onSecondaryAction: onGoBack,
         secondaryActionText: '',
         primaryColor: Colors.orange,
       );
  final ApiErrorType clientErrorType;
  final int? statusCode;
  final String? serverMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    String title;
    String description;
    IconData iconData = Icons.warning;
    Color color = Colors.orange;
    bool showRetry = true;

    switch (clientErrorType) {
      case ApiErrorType.badRequest:
        title = l10n?.error_bad_request ?? '';
        description = l10n?.error_bad_request_desc ?? '';
        iconData = Icons.error_outline;
        showRetry = false;
        break;
      case ApiErrorType.unauthorized:
        title = l10n?.error_unauthorized ?? '';
        description = l10n?.error_unauthorized_desc ?? '';
        iconData = Icons.lock;
        color = Colors.red;
        showRetry = false;
        break;
      case ApiErrorType.forbidden:
        title = l10n?.error_forbidden ?? '';
        description = l10n?.error_forbidden_desc ?? '';
        iconData = Icons.block;
        color = Colors.red;
        showRetry = false;
        break;
      case ApiErrorType.notFound:
        title = l10n?.error_not_found ?? '';
        description = l10n?.error_not_found_desc ?? '';
        iconData = Icons.search_off;
        showRetry = false;
        break;
      case ApiErrorType.methodNotAllowed:
        title = l10n?.error_method_not_allowed ?? '';
        description = l10n?.error_method_not_allowed_desc ?? '';
        iconData = Icons.block;
        showRetry = false;
        break;
      case ApiErrorType.notAcceptable:
        title = l10n?.error_not_acceptable ?? '';
        description = l10n?.error_not_acceptable_desc ?? '';
        iconData = Icons.cancel;
        showRetry = false;
        break;
      case ApiErrorType.conflict:
        title = l10n?.error_conflict ?? '';
        description = l10n?.error_conflict_desc ?? '';
        iconData = Icons.merge_type;
        break;
      case ApiErrorType.validationError:
        title = l10n?.error_validation ?? '';
        description = l10n?.error_validation ?? '';
        iconData = Icons.rule_folder_outlined;
        showRetry = false;
        break;
      case ApiErrorType.gone:
        title = l10n?.error_gone ?? '';
        description = l10n?.error_gone_desc ?? '';
        iconData = Icons.delete_forever;
        showRetry = false;
        break;
      case ApiErrorType.lengthRequired:
        title = l10n?.error_length_required ?? '';
        description = l10n?.error_length_required_desc ?? '';
        iconData = Icons.straighten;
        showRetry = false;
        break;
      case ApiErrorType.preconditionFailed:
        title = l10n?.error_precondition_failed ?? '';
        description = l10n?.error_precondition_failed_desc ?? '';
        iconData = Icons.rule;
        showRetry = false;
        break;
      case ApiErrorType.payloadTooLarge:
        title = l10n?.error_payload_too_large ?? '';
        description = l10n?.error_payload_too_large_desc ?? '';
        iconData = Icons.file_upload;
        showRetry = false;
        break;
      case ApiErrorType.uriTooLong:
        title = l10n?.error_uri_too_long ?? '';
        description = l10n?.error_uri_too_long_desc ?? '';
        iconData = Icons.link_off;
        showRetry = false;
        break;
      case ApiErrorType.unsupportedMediaType:
        title = l10n?.error_unsupported_media_type ?? '';
        description = l10n?.error_unsupported_media_type_desc ?? '';
        iconData = Icons.file_present;
        showRetry = false;
        break;
      case ApiErrorType.rangeNotSatisfiable:
        title = l10n?.error_range_not_satisfiable ?? '';
        description = l10n?.error_range_not_satisfiable_desc ?? '';
        iconData = Icons.straighten;
        showRetry = false;
        break;
      case ApiErrorType.expectationFailed:
        title = l10n?.error_expectation_failed ?? '';
        description = l10n?.error_expectation_failed_desc ?? '';
        iconData = Icons.error_outline;
        showRetry = false;
        break;
      case ApiErrorType.tooManyRequests:
        title = l10n?.error_too_many_requests ?? '';
        description = l10n?.error_too_many_requests_desc ?? '';
        iconData = Icons.speed;
        color = Colors.amber;
        break;
      default:
        title = l10n?.error_unknown ?? '';
        description = l10n?.error_unknown_desc ?? '';
        iconData = Icons.help_outline;
    }

    // لا تعرض رسالة الـ server إذا كانت تحتوي على تفاصيل تقنية
    final finalDescription = serverMessage ?? description;

    return BaseErrorWidget(
      title: title, // لا تعرض status code للمستخدم
      description: finalDescription,
      icon: iconData,
      onRetry: showRetry ? onRetry : null,
      onSecondaryAction: onSecondaryAction,
      secondaryActionText: l10n?.go_back ?? '',
      primaryColor: color,
    );
  }

  @override
  String getRetryButtonText(BuildContext context) {
    return AppLocalizations.of(context)?.retry ?? '';
  }
}
