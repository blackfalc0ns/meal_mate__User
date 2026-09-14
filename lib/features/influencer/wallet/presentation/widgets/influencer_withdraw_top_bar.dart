import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class InfluencerWithdrawTopBar extends StatelessWidget {
  const InfluencerWithdrawTopBar({
    super.key,
    required this.userName,
    required this.partnerLabel,
    required this.avatarAsset,
    this.onBackTap,
  });

  final String userName;
  final String partnerLabel;
  final String avatarAsset;
  final VoidCallback? onBackTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            avatarAsset,
            width: Spacing.avatarMd,
            height: Spacing.avatarMd,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.xss),
            Text(
              partnerLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size9,
                color: color.primary,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: color.onSurface,
            size: Spacing.iconMd,
          ),
        ),
      ],
    );
  }
}
