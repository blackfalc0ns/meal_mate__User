import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'base_error_widget.dart';

class NoInternetErrorWidget extends BaseErrorWidget {
  const NoInternetErrorWidget({
    super.key,
    super.onRetry,
    VoidCallback? onCheckConnection,
  }) : super(
         title: '',
         description: '',
         imageAsset: Assets.noInternetIllustration,
         icon: Icons.wifi_off,
         onSecondaryAction: onCheckConnection,
         secondaryActionText: '',
         primaryColor: Colors.orange,
       );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BaseErrorWidget(
      title: l10n?.error_no_internet_connection ?? '',
      description: l10n?.error_no_internet_connection_desc ?? '',
      imageAsset: Assets.noInternetIllustration,
      icon: Icons.wifi_off,
      onRetry: onRetry,
      onSecondaryAction: onSecondaryAction,
      secondaryActionText: l10n?.check_connection ?? '',
      primaryColor: Colors.orange,
    );
  }

  @override
  String getRetryButtonText(BuildContext context) {
    return AppLocalizations.of(context)?.retry ?? '';
  }
}
