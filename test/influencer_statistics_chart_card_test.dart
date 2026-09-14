import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/entities/influencer_dashboard_entity.dart';
import 'package:meal_meat_user/features/influencer/analytics/presentation/widgets/influencer_statistics_chart_card.dart';

void main() {
  testWidgets('statistics chart card shows bar values', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: InfluencerStatisticsChartCard(
            title: 'Revenue Growth',
            legendLabel: 'Earnings',
            filterLabel: 'Daily',
            bars: const [
              InfluencerChartPointEntity(label: 'Apr 20', value: 120),
              InfluencerChartPointEntity(label: 'Apr 27', value: 150),
            ],
          ),
        ),
      ),
    );

    expect(find.text('120'), findsOneWidget);
    expect(find.text('150'), findsOneWidget);
  });
}
