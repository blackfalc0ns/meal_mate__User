import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/entities/influencer_dashboard_entity.dart';
import 'package:meal_meat_user/features/influencer/dashboard/presentation/widgets/influencer_share_quick_stats_card.dart';

void main() {
  testWidgets('quick stats card matches rtl figma metric order', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 180));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 350.96,
                child: InfluencerShareQuickStatsCard(
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
                    quickStats: [
                      InfluencerShareQuickStatEntity(
                        label: 'النقرات على الرابط',
                        value: '520',
                        iconAsset: AssetsFake.influencerQuickStatClicks,
                      ),
                      InfluencerShareQuickStatEntity(
                        label: 'الطلبات الناتجة',
                        value: '68',
                        iconAsset: AssetsFake.influencerQuickStatOrders,
                      ),
                      InfluencerShareQuickStatEntity(
                        label: 'التحويلات',
                        value: '35%',
                        iconAsset: AssetsFake.influencerQuickStatConversion,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final clicksCenter = tester.getCenter(find.text('520'));
    final ordersCenter = tester.getCenter(find.text('68'));
    final conversionsCenter = tester.getCenter(find.text('35%'));
    final firstIconCenter = tester.getCenter(find.byType(SvgPicture).first);

    expect(clicksCenter.dx, greaterThan(ordersCenter.dx));
    expect(ordersCenter.dx, greaterThan(conversionsCenter.dx));
    expect(firstIconCenter.dx, greaterThan(clicksCenter.dx));
  });
}
