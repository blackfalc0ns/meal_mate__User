import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/entities/influencer_dashboard_entity.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_share_discount_card.dart';

void main() {
  testWidgets('discount card matches figma horizontal composition', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 220));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 359,
                child: InfluencerShareDiscountCard(
                  shareLinks: InfluencerShareLinksEntity(
                    title: 'روابط المشاركة',
                    subtitle: 'شارك رابطك وكودك واحصل على عمولات أكثر',
                    bannerTitle: 'كل ما تشارك أكثر',
                    bannerHighlight: 'تكسب أكثر!',
                    bannerSubtitle: 'شارك رابطك مع اصدقائك',
                    bannerFooter: 'واحصل على عمولات من كل طلب',
                    discountCodeTitle: 'كود الخصم الخاص بك',
                    discountCode: 'Mealmate20',
                    discountBadgePrefix: 'خصم ',
                    discountBadgeValue: '20%',
                    discountBadgeSuffix: ' للعملاء الجدد',
                    copyCodeLabel: 'نسخ الكود',
                    qrLabel: 'امسح للمشاركة',
                    referralLinkTitle: 'رابط الإحالة الخاص بك',
                    referralLink: 'https://mealmate.com/ref/Mealmate20',
                    copyLinkLabel: 'نسخ الرابط',
                    shareNowTitle: 'شارك الآن',
                    shareNowSubtitle: 'شارك يسهولة عبر منصات التواصل',
                    quickStatsTitle: 'مشاركة سريعة',
                    quickStatsSubtitle: 'أداؤك في مشاركة الروابط',
                    socialPlatforms: [],
                    quickStats: [],
                  ),
                  qrAsset: AssetsFake.influencerQr,
                  copyIconAsset: AssetsFake.influencerCopyIcon,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final qrCenter = tester.getCenter(find.byType(Image));
    final copyIconCenter = tester.getCenter(find.byType(SvgPicture));
    final codeCenter = tester.getCenter(find.text('Mealmate20'));
    final labelCenter = tester.getCenter(find.text('نسخ الكود'));
    final cardTop = tester
        .getTopLeft(find.byType(InfluencerShareDiscountCard))
        .dy;
    final qrLabelTop = tester.getTopLeft(find.text('امسح للمشاركة')).dy;
    final qrSize = tester.getSize(find.byType(Image));

    expect(qrCenter.dx, lessThan(copyIconCenter.dx));
    expect(copyIconCenter.dx, lessThan(codeCenter.dx));
    expect((copyIconCenter.dy - codeCenter.dy).abs(), lessThan(Spacing.sm));
    expect(labelCenter.dy, greaterThan(copyIconCenter.dy));
    expect(qrLabelTop - cardTop, lessThan(Spacing.xxl));
    expect(qrSize.width, greaterThan(Spacing.avatarLg));
  });
}
