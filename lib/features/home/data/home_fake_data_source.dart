import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/features/home/domain/entities/home_dashboard_entity.dart';

class HomeFakeDataSource {
  const HomeFakeDataSource();

  HomeDashboardEntity getDashboard() {
    return const HomeDashboardEntity(
      userName: 'أحمد محمد 👋',
      greeting: 'مرحباً بك ,',
      dailyCalories: 1350,
      goalCalories: 2000,
      progress: 0.85,
      bannerTitle: 'وجبات صحية تناسب أهدافك',
      bannerSubtitle: 'اكتشف باقات جديدة مصممة لأهدافك الغذائية!',
      bannerButtonLabel: 'اكتشف الان',
      bannerImageAsset: AssetsFake.homeSpecialsMeal,
      categories: [
        HomeCategoryEntity(title: 'إفطار', imageAsset: AssetsFake.homeOatmeal),
        HomeCategoryEntity(title: 'عشاء', imageAsset: AssetsFake.homeHotdog),
        HomeCategoryEntity(title: 'غداء', imageAsset: AssetsFake.homeBurger),
        HomeCategoryEntity(title: 'سناك', imageAsset: AssetsFake.homeDonut),
      ],
      meals: [
        HomeMealEntity(
          categoryTitle: 'إفطار',
          timeLabel: '07:30 ص',
          title: 'شوفان بالفواكه والعسل',
          subtitle: '450 سعرة حرارية',
          caloriesLabel: '450',
          statusLabel: 'مكتملة',
          imageAsset: AssetsFake.homeOatmeal,
          accentColor: 0xFF2DA55D,
          statusColor: 0xFFB9ECCA,
        ),
        HomeMealEntity(
          categoryTitle: 'غداء',
          timeLabel: '01:00 م',
          title: 'دجاج مشوي مع أرز بني',
          subtitle: '32g بروتين',
          caloriesLabel: '550',
          statusLabel: 'الحالية',
          imageAsset: AssetsFake.homeBurger,
          accentColor: 0xFF0A7A35,
          statusColor: 0xFFDFF4E6,
        ),
      ],
    );
  }
}
