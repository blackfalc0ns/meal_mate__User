/// ─────────────────────────────────────────────────────────────
/// Consistent spacing & sizing tokens used across the app.
/// ─────────────────────────────────────────────────────────────
class Spacing {
  Spacing._();

  // ── Base unit (4 dp grid) ──
  static const double unit = 4.0;

  // ── Named sizes ──
  static const double xs = 4.0; // unit × 1
  static const double xss = 6.0; // unit × 1.5
  static const double sm = 8.0; // unit × 2
  static const double md = 12.0; // unit × 3
  static const double base = 16.0; // unit × 4  (default)
  static const double lg = 20.0; // unit × 5
  static const double xl = 24.0; // unit × 6
  static const double xxl = 32.0; // unit × 8
  static const double xxxl = 48.0; // unit × 12

  // ── Screen padding ──
  static const double screenH = 16.0; // Horizontal (reduced from 8.0)
  static const double screenV = 16.0; // Vertical

  // ── Card ──
  static const double cardPadding = 16.0;
  static const double cardRadius = 12.0;
  static const double cardElevation = 2.0;

  // ── Button ──
  static const double buttonHeight = 52.0;
  static const double buttonSmallHeight = 40.0;
  static const double buttonRadius = 12.0;
  static const double buttonSmallRadius = 8.0;

  // ── Input field ──
  static const double inputHeight = 52.0;
  static const double inputRadius = 12.0;

  // ── Bottom sheet ──
  static const double bottomSheetRadius = 24.0;

  // ── App bar ──
  static const double appBarHeight = 56.0;

  // ── Bottom nav ──
  static const double bottomNavHeight = 65.0;

  // ── Avatar ──
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 72.0;

  // ── Icon ──
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // Borders
  static const double hairline = 0.5;
  static const double border = 1.0;

  // Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusPill = 99.0;

  // Subscriptions feature sizing
  static const double subscriptionHeroHeight = 130.0;
  static const double subscriptionPlansHeight = 292.0;
  static const double subscriptionPlanCardWidth = 111.0;
  static const double subscriptionPlanImageHeight = 78.0;
  static const double subscriptionChooseButtonWidth = 96.0;
  static const double subscriptionChooseButtonHeight = 29.0;
  static const double subscriptionInfoHeight = 48.0;
  static const double subscriptionProgramsHeroHeight = 218.0;
  static const double subscriptionProgramsHeroImageHeight = 263.0;
  static const double subscriptionProgramsHeroImageTop = -45.0;
  static const double subscriptionProgramsContentTop = 194.0;
  static const double subscriptionProgramsHeaderWidth = 202.0;
  static const double subscriptionProgramsHorizontalPadding = 20.0;
  static const double subscriptionProgramsBottomSpace = 118.0;
  static const double subscriptionProgramCardHeight = 111.0;
  static const double subscriptionProgramCardRadius = 18.0;
  static const double subscriptionProgramImageWidth = 86.0;
  static const double subscriptionProgramImageHeight = 75.0;
  static const double familyMembersStripHeight = 129.0;
  static const double familyMemberCardWidth = 65.0;
  static const double familySummaryHeight = 78.0;
  static const double familyMealsMinHeight = 129.0;
  static const double familyPriceMinHeight = 138.0;
  static const double compactButtonHeight = 39.0;

  // Monthly plan Figma measurements.
  static const double monthlyPlanDesignWidth = 448.43;
  static const double monthlyPlanHeroHeight = 489.0;
  static const double monthlyPlanHeroFadeHeight = 971.0;
  static const double monthlyPlanHeroSummaryTop = 345.0;
  static const double monthlyPlanHeroLogoTop = 36.0;
  static const double monthlyPlanHeroLogoWidth = 67.62;
  static const double monthlyPlanHeroLogoHeight = 78.0;
  static const double monthlyPlanHeroBackTop = 36.0;
  static const double monthlyPlanHeroBackEnd = 24.43;
  static const double monthlyPlanHeroBackSize = 33.0;
  static const double monthlyPlanHeroImageLeft = 93.0;
  static const double monthlyPlanHeroImageTop = 241.0;
  static const double monthlyPlanHeroImageWidth = 635.0;
  static const double monthlyPlanHeroImageHeight = 975.0;
  static const double monthlyPlanHeroTitleSize = 71.48275756835938;
  static const double monthlyPlanHeroTitleLineHeight = 38.27;
  static const double monthlyPlanPromotionGap = 17.0;
  static const double monthlyPlanPromotionHeight = 37.04;
  static const double monthlyPlanPromotionPadding = 10.1;
  static const double monthlyPlanPromotionRadius = 12.628865242004395;
  static const double monthlyPlanPromotionIconSize = 20.21;
  static const double monthlyPlanPromotionTextSize = 13.470789909362793;
  static const double monthlyPlanSubscribeHeight = 70.0;
  static const double monthlyPlanSubscribeRadius = 39.0;
  static const double monthlyPlanSubscribeShadowBlur = 18.0;
  static const double monthlyPlanSubscribeShadowOffset = 8.0;
  static const double monthlyPlanSubscribeTitleSize = 34.916255950927734;
  static const double monthlyPlanSubscribePriceSize = 23.916255950927734;
  static const double monthlyPlanSubscribeCurrencySize = 10.916255950927734;
  static const double monthlyPlanSubscribeDividerWidth = 1.1958128213882446;
  static const double monthlyPlanSubscribeDividerHeight = 28.7;
  static const double monthlyPlanSubscribeCoinSize = 27.0;
  static const double monthlyPlanContentHorizontalPadding = 25.0;
  static const double monthlyPlanDurationHeight = 129.0;
  static const double monthlyPlanDurationPadding = 6.0;
  static const double monthlyPlanDurationOptionHeight = 37.0;
  static const double monthlyPlanDurationOptionWidth = 45.688;
  static const double monthlyPlanCustomDurationWidth = 99.195;
  static const double monthlyPlanDurationControlWidth = 23.688;
  static const double monthlyPlanDurationControlSize = 13.325;
  static const double monthlyPlanDurationOptionRadius = 6.662;
  static const double monthlyPlanDurationStatusIconSize = 9.0;
  static const double monthlyPlanDurationCardWidth = 398.0;
  static const double monthlyPlanDurationCustomEnd = 208.0;
  static const double monthlyPlanDurationCardRadius = 9.0;
  static const double monthlyPlanDurationHeaderTop = 6.0;
  static const double monthlyPlanDurationHeaderEnd = 4.0;
  static const double monthlyPlanDurationOptionTop = 27.0;
  static const double monthlyPlanDurationMonthOptionLeft = 328.0;
  static const double monthlyPlanDurationHalfMonthOptionLeft = 267.0;
  static const double monthlyPlanDurationWeekOptionLeft = 206.0;
  static const double monthlyPlanDurationCustomInputLeft = 53.0;
  static const double monthlyPlanDurationControlTop = 50.0;
  static const double monthlyPlanDurationCustomInputHeight = 22.948;
  static const double monthlyPlanDurationMinusLeft = 23.0;
  static const double monthlyPlanDurationPlusLeft = 159.0;
  static const double monthlyPlanDurationCustomGroupWidth = 159.688;
  static const double monthlyPlanDurationHintTop = 80.0;
  static const double monthlyPlanDurationFridayTop = 100.0;
  static const double monthlyPlanPackagesWidth = 392.0;
  static const double monthlyPlanPackageHeight = 234.0;
  static const double monthlyPlanPackageBasicLeft = 4.0;
  static const double monthlyPlanPackageFeaturedLeft = 130.0;
  static const double monthlyPlanPackagePremiumLeft = 271.0;
  static const double monthlyPlanPackageSideWidth = 121.0;
  static const double monthlyPlanPackageFeaturedWidth = 136.0;
  static const double monthlyPlanPackageGap = 5.0;
  static const double monthlyPlanPackageSideTop = 31.0;
  static const double monthlyPlanPackageFeaturedTop = 12.0;
  static const double monthlyPlanPackageSideHeight = 195.0;
  static const double monthlyPlanPackageFeaturedHeight = 214.0;
  static const double monthlyPlanPackageSideRadius = 13.075;
  static const double monthlyPlanPackageFeaturedRadius = 14.689;
  static const double monthlyPlanPackageIndicatorSize = 22.0;
  static const double monthlyPlanPackageBasicIndicatorLeft = 52.0;
  static const double monthlyPlanPackageBasicIndicatorTop = 22.0;
  static const double monthlyPlanPackageFeaturedIndicatorLeft = 187.0;
  static const double monthlyPlanPackageFeaturedIndicatorTop = 1.0;
  static const double monthlyPlanPackagePremiumIndicatorLeft = 321.0;
  static const double monthlyPlanPackagePremiumIndicatorTop = 20.0;
  static const double monthlyPlanPackageBasicButtonLeft = 21.0;
  static const double monthlyPlanPackageFeaturedButtonLeft = 155.0;
  static const double monthlyPlanPackagePremiumButtonLeft = 289.0;
  static const double monthlyPlanPackageButtonTop = 197.104;
  static const double monthlyPlanPackageButtonWidth = 85.76;
  static const double monthlyPlanPackageButtonHeight = 18.9;
}
