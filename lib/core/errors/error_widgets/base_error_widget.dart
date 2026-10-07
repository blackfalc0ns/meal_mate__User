import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';

class BaseErrorWidget extends StatelessWidget {
  const BaseErrorWidget({
    super.key,
    required this.title,
    required this.description,
    this.icon,
    this.imageAsset,
    this.onRetry,
    this.onSecondaryAction,
    this.secondaryActionText,
    this.primaryColor,
  });

  final String title;
  final String description;
  final IconData? icon;
  final String? imageAsset;
  final VoidCallback? onRetry;
  final VoidCallback? onSecondaryAction;
  final String? secondaryActionText;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final textTheme = context.textTheme;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageAsset != null)
                Image.asset(
                  imageAsset!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                )
              else if (icon != null)
                Container(
                  padding: const EdgeInsets.all(Spacing.xl),
                  decoration: BoxDecoration(
                    color: (primaryColor ?? color.error).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 64,
                    color: primaryColor ?? color.error,
                  ),
                )
              else
                Image.asset(
                  Assets.errorIllustration,
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              const SizedBox(height: Spacing.xl),
              Text(
                title,
                style: getSemiBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.md),
              Text(
                description,
                style: textTheme.bodyLarge?.copyWith(
                  color: color.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.base),
              if (onRetry != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: onRetry,
                    text: getRetryButtonText(context),
                  ),
                ),
                if (onSecondaryAction != null &&
                    secondaryActionText != null) ...[
                  const SizedBox(height: Spacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: onSecondaryAction,
                      text: secondaryActionText!,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  String getRetryButtonText(BuildContext context) {
    // This should be overridden in concrete implementations
    return AppLocalizations.of(context)?.retry ?? '';
  }
}
