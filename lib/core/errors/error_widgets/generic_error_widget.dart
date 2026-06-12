import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';

import 'base_error_widget.dart';

class GenericErrorWidget extends BaseErrorWidget {
  // رسالة الـ server المخصصة

  const GenericErrorWidget({
    super.key,
    required this.errorType,
    this.serverMessage,
    super.onRetry,
    VoidCallback? onGoBack,
  }) : super(
         title: '',
         description: '',
         icon: Icons.error,
         onSecondaryAction: onGoBack,
         secondaryActionText: '',
       );
  final ApiErrorType errorType;
  final String? serverMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    String title;
    String description;
    IconData iconData = Icons.error;
    Color color = Colors.red;

    switch (errorType) {
      case ApiErrorType.locationServiceDisabled:
        title = l10n?.location_service_disabled ?? '';
        description = l10n?.location_service_disabled_message ?? '';
        iconData = Icons.location_off_rounded;
        color = Colors.red;
        break;
      case ApiErrorType.locationPermissionDenied:
        title = l10n?.location_permission_denied ?? '';
        description = l10n?.location_permission_denied_message ?? '';
        iconData = Icons.location_disabled_rounded;
        color = Colors.red;
        break;
      case ApiErrorType.locationPermissionDeniedForever:
        title = l10n?.location_permission_denied_forever ?? '';
        description = l10n?.location_permission_denied_forever_message ?? '';
        iconData = Icons.location_off_outlined;
        color = Colors.red;
        break;
      case ApiErrorType.cancelled:
        title = l10n?.error_cancelled ?? '';
        description = l10n?.error_cancelled_desc ?? '';
        iconData = Icons.cancel;
        color = Colors.grey;
        break;
      case ApiErrorType.unknown:
        title = l10n?.error_unknown ?? '';
        description = l10n?.error_unknown_desc ?? '';
        iconData = Icons.help_outline;
        color = Colors.grey;
        break;
      case ApiErrorType.other:
        title = l10n?.error_other ?? '';
        description = l10n?.error_other_desc ?? '';
        iconData = Icons.error_outline;
        break;
      default:
        title = l10n?.error_unknown ?? '';
        description = l10n?.error_unknown_desc ?? '';
        iconData = Icons.help_outline;
        color = Colors.grey;
    }

    // لا تعرض رسالة الـ server إذا كانت تحتوي على تفاصيل تقنية
    final finalDescription = serverMessage ?? description;

    return BaseErrorWidget(
      title: title,
      description: finalDescription,
      icon: iconData,
      onRetry: onRetry,
      onSecondaryAction: onSecondaryAction,
      secondaryActionText: onSecondaryAction == null
          ? null
          : l10n?.go_back ?? '',
      primaryColor: color,
    );
  }

  @override
  String getRetryButtonText(BuildContext context) {
    return AppLocalizations.of(context)?.retry ?? '';
  }
}
