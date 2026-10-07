import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'base_error_widget.dart';

class ServerErrorWidget extends BaseErrorWidget {
  // رسالة الـ server المخصصة

  const ServerErrorWidget({
    super.key,
    required this.serverErrorType,
    this.statusCode,
    this.serverMessage,
    super.onRetry,
    VoidCallback? onContactSupport,
  }) : super(
         title: '',
         description: '',
         imageAsset: Assets.errorIllustration,
         onSecondaryAction: onContactSupport,
         secondaryActionText: '',
         primaryColor: Colors.red,
       );
  final ApiErrorType serverErrorType;
  final int? statusCode;
  final String? serverMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    String title;
    String description;
    IconData iconData = Icons.error_outline;

    switch (serverErrorType) {
      case ApiErrorType.internalServerError:
        title = l10n?.error_internal_server_error ?? '';
        description = l10n?.error_internal_server_error_desc ?? '';
        iconData = Icons.dns;
        break;
      case ApiErrorType.badGateway:
        title = l10n?.error_bad_gateway ?? '';
        description = l10n?.error_bad_gateway_desc ?? '';
        iconData = Icons.router;
        break;
      case ApiErrorType.serviceUnavailable:
        title = l10n?.error_service_unavailable ?? '';
        description = l10n?.error_service_unavailable_desc ?? '';
        iconData = Icons.cloud_off;
        break;
      case ApiErrorType.gatewayTimeout:
        title = l10n?.error_gateway_timeout ?? '';
        description = l10n?.error_gateway_timeout_desc ?? '';
        iconData = Icons.access_time;
        break;
      default:
        title = l10n?.error_server_error ?? '';
        description = l10n?.error_server_error_desc ?? '';
        iconData = Icons.error_outline;
    }

    // لا تعرض رسالة الـ server إذا كانت تحتوي على تفاصيل تقنية
    // استخدم الوصف المترجم فقط
    final finalDescription = serverMessage ?? description;

    return BaseErrorWidget(
      title: title, // لا تعرض status code للمستخدم
      description: finalDescription,
      imageAsset: Assets.errorIllustration,
      icon: iconData,
      onRetry: onRetry,
      onSecondaryAction: onSecondaryAction,
      secondaryActionText: l10n?.contact_support ?? '',
      primaryColor: Colors.red,
    );
  }

  @override
  String getRetryButtonText(BuildContext context) {
    return AppLocalizations.of(context)?.retry ?? '';
  }
}
