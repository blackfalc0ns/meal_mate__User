import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';

class InfluencerWalletTransactionRow extends StatelessWidget {
  const InfluencerWalletTransactionRow({super.key, required this.transaction});

  final InfluencerTransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: Spacing.influencerWalletTransactionRowHeight,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.amount,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size9,
                  color: transaction.isDebit ? color.error : color.primary,
                ),
              ),
              //   const SizedBox(height: Spacing.xs),
              Text(
                transaction.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getMediumStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSurfaceVariant,
                ),
              ),
              Text(
                transaction.date,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size10,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: Spacing.influencerWalletTransactionIconSize,
            height: Spacing.influencerWalletTransactionIconSize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: transaction.isDebit
                  ? color.errorContainer
                  : color.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              transaction.isDebit
                  ? AssetsFake.influencerWalletTxWithdraw
                  : AssetsFake.influencerWalletTxReferral,
              width: Spacing.md,
              height: Spacing.md,
            ),
          ),
        ],
      ),
    );
  }
}
