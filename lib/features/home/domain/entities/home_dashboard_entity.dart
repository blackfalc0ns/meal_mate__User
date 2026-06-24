class HomeDashboardEntity {
  const HomeDashboardEntity({
    required this.userName,
    required this.greeting,
    required this.dailyCalories,
    required this.goalCalories,
    required this.progress,
    required this.bannerTitle,
    required this.bannerSubtitle,
    required this.bannerButtonLabel,
    required this.bannerImageAsset,
    required this.categories,
    required this.meals,
  });

  final String userName;
  final String greeting;
  final int dailyCalories;
  final int goalCalories;
  final double progress;
  final String bannerTitle;
  final String bannerSubtitle;
  final String bannerButtonLabel;
  final String bannerImageAsset;
  final List<HomeCategoryEntity> categories;
  final List<HomeMealEntity> meals;
}

class HomeCategoryEntity {
  const HomeCategoryEntity({
    required this.title,
    required this.imageAsset,
  });

  final String title;
  final String imageAsset;
}

class HomeMealEntity {
  const HomeMealEntity({
    required this.categoryTitle,
    required this.timeLabel,
    required this.title,
    required this.subtitle,
    required this.caloriesLabel,
    required this.statusLabel,
    required this.imageAsset,
    required this.accentColor,
    required this.statusColor,
  });

  final String categoryTitle;
  final String timeLabel;
  final String title;
  final String subtitle;
  final String caloriesLabel;
  final String statusLabel;
  final String imageAsset;
  final int accentColor;
  final int statusColor;
}
