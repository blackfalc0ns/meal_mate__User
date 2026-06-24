import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/home/domain/entities/home_dashboard_entity.dart';

class HomeFakeDataSource {
  const HomeFakeDataSource();

  HomeDashboardEntity getDashboard() {
    return const HomeDashboardEntity(
      userName: 'أحمد محمد',
      greeting: 'مرحباً بك ،',
      dailyCalories: 1350,
      goalCalories: 2000,
      progress: 0.85,
      bannerTitle: 'وجبات صحية تناسب أهدافك',
      bannerSubtitle: 'اكتشف باقات جديدة مصممة لأهدافك الغذائية!',
      bannerButtonLabel: 'اكتشف الآن',
      bannerImageAsset: Assets.homeBanner,
      categories: [
        HomeCategoryEntity(
          title: 'إفطار',
          imageAsset: Assets.homeBreakfast,
        ),
        HomeCategoryEntity(
          title: 'غداء',
          imageAsset: Assets.homeLunch,
        ),
        HomeCategoryEntity(
          title: 'عشاء',
          imageAsset: Assets.homeDinner,
        ),
        HomeCategoryEntity(
          title: 'سناك',
          imageAsset: Assets.homeSnack,
        ),
      ],
      meals: [
        HomeMealEntity(
          categoryTitle: 'إفطار',
          timeLabel: '07:30 ص',
          title: 'شوفان بالفواكه والعسل',
          subtitle: '450 سعرة حرارية',
          caloriesLabel: '450',
          statusLabel: 'مكتملة',
          imageAsset: Assets.homeBreakfast,
          accentColor: 0xFF2DA55D,
          statusColor: 0xFFB9ECCA,
        ),
        HomeMealEntity(
          categoryTitle: 'غداء',
          timeLabel: '01:00 م',
          title: 'برجر دجاج مع البطاطس',
          subtitle: '610 سعرة حرارية',
          caloriesLabel: '610',
          statusLabel: 'الحالية',
          imageAsset: Assets.homeLunch,
          accentColor: 0xFF0A7A35,
          statusColor: 0xFFDFF4E6,
        ),
        HomeMealEntity(
          categoryTitle: 'سناك',
          timeLabel: '04:30 م',
          title: 'دونات فواكه طازجة',
          subtitle: '290 سعرة حرارية',
          caloriesLabel: '290',
          statusLabel: 'مقترحة',
          imageAsset: Assets.homeSnack,
          accentColor: 0xFFF67E15,
          statusColor: 0xFFFFE7CF,
        ),
      ],
    );
  }
}
