import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/entities/influencer_dashboard_entity.dart';
import 'package:meal_meat_user/features/influencer/analytics/presentation/widgets/influencer_top_product_card.dart';

void main() {
  testWidgets('top product card lays out without overflow', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 240));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(
            child: SizedBox(
              width: 359,
              child: InfluencerTopProductCard(
                title: 'أفضل المنتجات أداء',
                actionLabel: 'عرض الكل',
                product: InfluencerTopProductEntity(
                  rank: '1',
                  name: 'بوكس دايت متكامل',
                  orders: '124',
                  ordersLabel: 'طلب',
                  revenueLabel: 'الأرباح',
                  revenue: 'KWD 245',
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
