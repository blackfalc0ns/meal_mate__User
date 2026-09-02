import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/influencer/data/influencer_fake_data_source.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_primary_button.dart';
import 'package:meal_meat_user/features/influencer/presentation/widgets/influencer_social_tile.dart';

class InfluencerSocialConnectionsScreen extends StatelessWidget {
  const InfluencerSocialConnectionsScreen({
    super.key,
    this.showScaffold = true,
  });

  final bool showScaffold;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final dashboard = InfluencerFakeDataSource(locale).loadDashboard();

    final body = SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.only(
          start: Spacing.screenH,
          top: Spacing.md,
          end: Spacing.screenH,
          bottom: Spacing.xxxl,
        ),
        child: Column(
          children: [
            Text(
              locale.influencer_social_connections_header,
              textAlign: TextAlign.center,
              style: getBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size18,
                color: color.onSurface,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              locale.influencer_social_connections_body,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: Spacing.base),
            ...dashboard.socialAccounts.map(
              (account) => Padding(
                padding: const EdgeInsets.only(bottom: Spacing.sm),
                child: InfluencerSocialTile(account: account),
              ),
            ),
            const SizedBox(height: Spacing.xl),
            InfluencerPrimaryButton(
              label: locale.influencer_save_continue,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            const SizedBox(height: Spacing.sm),
            InfluencerPrimaryButton(
              label: locale.influencer_skip_now,
              filled: false,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      ),
    );

    if (!showScaffold) {
      return body;
    }

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.influencer_social_connections_title,
        titleFontSize: FontSize.size17,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: body,
    );
  }
}
