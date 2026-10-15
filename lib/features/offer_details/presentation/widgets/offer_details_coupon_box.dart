import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_data.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_coupon_border_painter.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_icon.dart';

class OfferDetailsCouponBox extends StatelessWidget {
  const OfferDetailsCouponBox({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return CustomPaint(
      painter: OfferDetailsCouponBorderPainter(color: color.primaryContainer),
      child: Container(
        height: Spacing.offerDetailsCouponHeight,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.base),
        decoration: BoxDecoration(
          color: color.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(Spacing.md),
        ),
        child: Row(
          children: [
            TextButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: code));
                if (context.mounted) {
                  CustomSnackbar.showSuccess(
                    context: context,
                    message: locale.offer_details_info_copy_code,
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: color.surface,
                foregroundColor: color.tertiary,
                padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                minimumSize: const Size(
                  Spacing.offerDetailsCouponButtonWidth,
                  Spacing.offerDetailsCouponButtonHeight,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Spacing.md),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    locale.offer_details_info_copy_code,
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.tertiary,
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  OfferDetailsIcon(
                    type: OfferDetailsIconType.copy,
                    size: Spacing.iconSm,
                    tint: color.tertiary,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              code,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size20,
                color: color.tertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
