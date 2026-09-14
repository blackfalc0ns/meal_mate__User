import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/entities/influencer_dashboard_entity.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_share_social_tile.dart';

void main() {
  testWidgets('more social tile draws three dots without image asset', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(
            child: InfluencerShareSocialTile(
              platform: InfluencerShareSocialPlatformEntity(
                label: 'المزيد',
                iconAsset: AssetsFake.influencerSocialMore,
                drawDotsIcon: true,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(SvgPicture), findsNothing);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget.key is ValueKey<String> &&
            (widget.key as ValueKey<String>).value.startsWith(
              'influencer-more-dot-',
            ),
      ),
      findsNWidgets(3),
    );
    expect(find.text('المزيد'), findsOneWidget);
  });
}
