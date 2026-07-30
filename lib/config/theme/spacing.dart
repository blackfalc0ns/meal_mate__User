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

  // Search Figma measurements.
  static const double searchScreenHorizontalPadding = 20.0;
  static const double searchPopularCardWidth = 85;
  static const double searchPopularCardHeight = 115.0;
  static const double searchPopularImageSize = 60;
  static const double searchQuickCategoryCardWidth = 77.0;
  static const double searchQuickCategoryCardHeight = 68.0;
  static const double searchQuickCategoryGap = 10.0;
  static const double searchFilterSheetHeight = 439.0;
  static const double searchFilterSheetHandleWidth = 29.0;
  static const double searchFilterSheetHandleHeight = 2.0;
  static const double searchFilterSheetHorizontalPadding = 24.0;
  static const double searchFilterSegmentHeight = 29.0;
  static const double searchFilterOptionHeight = 26.0;
  static const double searchFilterRangeHeight = 24.0;
  static const double searchFilterActionHeight = 33.0;

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
  static const double subscriptionPackageChoiceCardHeight = 100.0;
  static const double subscriptionPackageChoiceFigmaHeight = 135.0;
  static const double subscriptionPackageChoiceImageWidth = 139.0;
  static const double subscriptionPackageChoiceImageHeight = 94.0;
  static const double subscriptionPackageChoiceButtonWidth = 192.0;
  static const double subscriptionPackageChoiceButtonHeight = 24.0;
  static const double subscriptionPackageChoiceCardGap = 15.0;
  static const double subscriptionPackageSelectorHeight = 42.0;
  static const double subscriptionFamilyBannerHeight = 84.0;
  static const double subscriptionFamilyPreviewWidth = 98.32;
  static const double subscriptionFamilyPreviewHeight = 90.54;
  static const double subscriptionFamilyPreviewTopOffset = 32.78;
  static const double subscriptionProgramCardRadius = 18.0;
  static const double subscriptionProgramImageWidth = 86.0;
  static const double subscriptionProgramImageHeight = 75.0;
  static const double familyMembersStripHeight = 129.0;
  static const double familyMemberCardWidth = 65.0;
  static const double familySummaryHeight = 78.0;
  static const double familyMealsMinHeight = 129.0;
  static const double familyPriceMinHeight = 138.0;
  static const double compactButtonHeight = 39.0;

  // Dietary preferences Figma measurements.
  static const double dietaryScreenHorizontalPadding = 24.0;
  static const double dietaryHeroHeight = 168.24;
  static const double dietaryHeroIllustrationWidth = 176.0;
  static const double dietaryHeroIllustrationHeight = 146.0;
  static const double dietaryCardHeight = 87.18;
  static const double dietaryCardRadius = 15.59;
  static const double dietaryCardBorderWidth = 1.2;
  static const double dietarySectionGap = 12.0;
  static const double dietaryHeroRadius = 18.09;
  static const double dietaryChipHeight = 24.28;
  static const double dietaryChipRadius = 12.31;
  static const double dietaryCardInset = 12.0;
  static const double dietaryDietHeaderTopInset = 15.12;
  static const double dietaryDislikesHeaderTopInset = 14.8;
  static const double dietaryAllergiesHeaderTopInset = 15.48;
  static const double dietaryDietChoicesTopInset = 48.56;
  static const double dietaryDislikesChoicesTopInset = 48.56;
  static const double dietaryAllergiesChoicesTopInset = 45.25;
  static const double dietaryDietChoicesSpacing = 8.0;
  static const double dietaryDislikesChoicesSpacing = 17.0;
  static const double dietaryAllergiesChoicesSpacing = 24.0;
  static const double dietaryHeaderIconHeight = 17.18;
  static const double dietaryIconRadius = 2.86;
  static const double dietaryNotesHeaderTopInset = 6.16;
  static const double dietaryNotesFieldTopInset = 35.31;
  static const double dietaryNotesFieldHorizontalInset = 11.04;
  static const double dietaryNotesFieldHeight = 40.0;
  static const double dietaryNoticeHeight = 56.28;
  static const double dietarySaveButtonHeight = 31.51;
  static const double dietarySaveButtonRadius = 17.75;
  static const double dietaryIconSize = 18.13;
  static const double dietarySmallIconSize = 18.0;

  // Add allergy Figma measurements.
  static const double addAllergyScreenHorizontalPadding = 15.66;
  static const double addAllergyContentTopPadding = 12.0;
  static const double addAllergySectionGap = 9.0;
  static const double addAllergySummaryHeight = 77.76;
  static const double addAllergySummaryRadius = 14.51;
  static const double addAllergySummaryCountSize = 48.3;
  static const double addAllergySummaryChipWidth = 83.21;
  static const double addAllergySummaryChipHeight = 28.6;
  static const double addAllergySearchHeight = 36.52;
  static const double addAllergySearchRadius = 14.51;
  static const double addAllergyGridTileHeight = 41.24;
  static const double addAllergyGridTileRadius = 12.96;
  static const double addAllergyGridGap = 10.6;
  static const double addAllergyPopularHeight = 219.14;
  static const double addAllergyPopularRadius = 18.36;
  static const double addAllergyPopularRowHeight = 36.52;
  static const double addAllergyNoticeHeight = 49.0;
  static const double addAllergyNoticeRadius = 18.36;
  static const double addAllergyButtonHeight = 31.51;
  static const double addAllergyButtonRadius = 17.75;

  // Health goals Figma measurements.
  static const double healthGoalsScreenHorizontalPadding = 22.0;
  static const double healthGoalsHeaderTopGap = 12.0;
  static const double healthGoalsHeaderHeight = 32.0;
  static const double healthGoalsContentTopGap = 20.0;
  static const double healthGoalsSectionGap = 12.0;
  static const double healthGoalsGoalCardHeight = 150.63;
  static const double healthGoalsBodyCardHeight = 111.58;
  static const double healthGoalsActivityCardHeight = 99.0;
  static const double healthGoalsActivityCardAdjustedHeight = 107.0;
  static const double healthGoalsWeeklyCardHeight = 120;
  static const double healthGoalsCardRadius = 14.125;
  static const double healthGoalsGoalCardRadius = 11.1576;
  static const double healthGoalsSaveButtonHeight = 31.51;
  static const double healthGoalsSaveButtonRadius = 17.7531;
  static const double healthGoalsActivityOptionHeight = 50.0;
  static const double healthGoalsSelectedActivityOptionWidth = 81.0;
  static const double healthGoalsActivityOptionWidth = 67.0;
  static const double healthGoalsWeeklyMetricIconContainerSize = 30;

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
  static const double monthlyPlanSubscribeHeight = 50.0;
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
  static const double monthlyPlanDurationHeight = 133.0;
  static const double monthlyPlanDurationPadding = 6.0;
  static const double monthlyPlanDurationOptionHeight = 43.0;
  static const double monthlyPlanDurationOptionWidth = 50;
  static const double monthlyPlanCustomDurationWidth = 99.195;
  static const double monthlyPlanDurationControlWidth = 23.688;
  static const double monthlyPlanDurationControlSize = 20;
  static const double monthlyPlanDurationOptionRadius = 6.662;
  static const double monthlyPlanDurationStatusIconSize = 12;
  static const double monthlyPlanDurationCardWidth = 400;
  static const double monthlyPlanDurationCustomEnd = 208.0;
  static const double monthlyPlanDurationCardRadius = 15;
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
  static const double monthlyPlanPackageHeight = 234.0 + lg;
  static const double monthlyPlanPackageBasicLeft = 4.0;
  static const double monthlyPlanPackageFeaturedLeft = 130.0;
  static const double monthlyPlanPackagePremiumLeft = 271.0;
  static const double monthlyPlanPackageSideWidth = 121.0;
  static const double monthlyPlanPackageFeaturedWidth = 136.0;
  static const double monthlyPlanPackageGap = 5.0;
  static const double monthlyPlanPackageSideTop = 31.0;
  static const double monthlyPlanPackageFeaturedTop = 12.0;
  static const double monthlyPlanPackageSideHeight = 195.0 + sm + lg;
  static const double monthlyPlanPackageFeaturedHeight = 214.0 + sm + lg;
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
  static const double monthlyPlanPackageButtonWidth = 85.76 + lg;
  static const double monthlyPlanPackageButtonHeight = 18.9 + xs;
  static const double monthlyRestaurantCardBottomPadding = 7.0;
  static const double monthlyRestaurantCardRadius = 15.7;
  static const double monthlyRestaurantCardBorderWidth = 1.2;
  static const double monthlyRestaurantCardShadowBlur = 10.0;
  static const double monthlyRestaurantCardLogoSize = 47.0;
  static const double monthlyRestaurantCardMetaHeight = 18.0;
  static const double monthlyRestaurantCardTinyGap = 2.0;

  // Subscription summary Figma measurements.
  static const double subscriptionSummaryDesignHeight = 1019.0;
  static const double subscriptionSummaryDetailsLeft = 46.0;
  static const double subscriptionSummaryDetailsTop = 420.0;
  static const double subscriptionSummaryDetailsWidth = 368.0;
  static const double subscriptionSummaryDetailsHeight = 328.0;
  static const double subscriptionSummaryTitleLeft = 118.0;
  static const double subscriptionSummaryTitleTop = 0.0;
  static const double subscriptionSummaryTitleWidth = 132.0;
  static const double subscriptionSummaryTitleHeight = 33.0;
  static const double subscriptionSummaryTopTileTop = 44.0;
  static const double subscriptionSummaryTileWidth = 178.0;
  static const double subscriptionSummaryTopTileHeight = 49.0;
  static const double subscriptionSummaryRightTileLeft = 190.0;
  static const double subscriptionSummaryClassificationTop = 101.0;
  static const double subscriptionSummaryIncludesTop = 157.0;
  static const double subscriptionSummaryIncludesHeight = 99.0;
  static const double subscriptionSummaryPriceTop = 265.0;
  static const double subscriptionSummaryPriceHeight = 63.0;
  static const double subscriptionSummaryCardRadius = 9.0;
  static const double subscriptionSummaryCardBorder = 1.0;
  static const double subscriptionSummaryTileLabelTop = -1.0;
  static const double subscriptionSummaryTileValueTop = 15.0;
  static const double subscriptionSummaryClassificationLabelTop = 0.0;
  static const double subscriptionSummaryClassificationValueTop = 13.0;
  static const double subscriptionSummaryLabelHeight = 30.0;
  static const double subscriptionSummaryValueHeight = 38.0;
  static const double subscriptionSummaryIncludesLabelTop = -1.0;
  static const double subscriptionSummaryBulletRight = 33.0;
  static const double subscriptionSummaryBulletLeft = 20.0;
  static const double subscriptionSummaryBulletSize = 5.0;
  static const double subscriptionSummaryBulletGap = 7.0;
  static const double subscriptionSummaryBulletHeight = 27.0;
  static const double subscriptionSummaryBulletOneTop = 21.0;
  static const double subscriptionSummaryBulletTwoTop = 38.0;
  static const double subscriptionSummaryBulletThreeTop = 53.0;
  static const double subscriptionSummaryBulletFourTop = 70.0;
  static const double subscriptionSummaryPriceLabelTop = -1.0;
  static const double subscriptionSummaryPriceValueTop = 3.0;
  static const double subscriptionSummaryPriceValueHeight = 56.0;
  static const double subscriptionSummaryPriceNumberLeft = 138.0;
  static const double subscriptionSummaryPriceNumberWidth = 55.0;
  static const double subscriptionSummaryCurrencyLeft = 195.0;
  static const double subscriptionSummaryCurrencyTop = 31.0;
  static const double subscriptionSummaryCurrencyWidth = 27.0;
  static const double subscriptionSummarySubscribeLeft = 24.79;
  static const double subscriptionSummarySubscribeTop = 896.0;
  static const double subscriptionSummarySubscribeWidth = 401.0;
  static const double subscriptionSummaryTitleFontSize = 18.0;
  static const double subscriptionSummaryTitleLineHeight = 48.33;
  static const double subscriptionSummaryLabelFontSize = 11.045454978942871;
  static const double subscriptionSummaryLabelLineHeight = 29.65;
  static const double subscriptionSummaryBodyFontSize = 9.940909385681152;
  static const double subscriptionSummaryBodyLineHeight = 26.69;
  static const double subscriptionSummaryValueFontSize = 13.871036529541016;
  static const double subscriptionSummaryValueLineHeight = 37.24;
  static const double subscriptionSummaryPriceFontSize = 28.851757049560547;
  static const double subscriptionSummaryPriceLineHeight = 77.46;

  // Profile Figma measurements.
  static const double profileScreenHorizontalPadding = 18.63;
  static const double profileHeaderHeight = 132.0;
  static const double profileHeaderActionSize = 40.5;
  static const double profileHeaderIconSize = 28.93;
  static const double profileAppBarLogoWidth = 117.0;
  static const double profileAppBarLogoHeight = 29.0;
  static const double profileAvatarSize = 96.03;
  static const double profileAvatarTop = 36.0;
  static const double profileAvatarEditSize = 30.08;
  static const double profileIdentityTop = 56.0;
  static const double profileStatsTopGap = 18.38;
  static const double profileStatsHeight = 96.03;
  static const double profileSettingsTopGap = 11.57;
  static const double profileSettingsHeight = 319.34;
  static const double profileCardRadius = 15.04;
  static const double profileSettingsTileHeight = 52.07;
  static const double profileSettingsIconContainer = 30.08;
  static const double profileSettingsIconSize = 19.83;
  static const double profileSettingsInset = 15.04;
  static const double profileLogoutTopGap = 14.47;
  static const double profileLogoutHeight = 32.4;
  static const double profileLogoutRadius = 11.57;
  static const double profileStatIconSize = 21.98;
  static const double profileTitleFontSize = 15.59;
  static const double profileBodyFontSize = 9.9;
  static const double profileSettingsTitleFontSize = 12.09;

  // Profile billing Figma measurements.
  static const double profileBillingHorizontalPadding = 18.66;
  static const double profileBillingPlanHeight = 315.25;
  static const double profileBillingPaymentHeight = 90.0;
  static const double profileBillingInvoicesHeight = 145.0;
  static const double profileBillingNoticeHeight = 51.0;
  static const double profileBillingButtonHeight = 32.0;
  static const double profileBillingCardRadius = 20.5668;
  static const double profileBillingActionCardHeight = 63.05;

  // Security and privacy Figma measurements.
  static const double profilePrivacyScreenHorizontalPadding = 26.09;
  static const double profilePrivacyContentTopPadding = 24.38;
  static const double profilePrivacyCardRadius = 14.125;
  static const double profilePrivacySectionHeaderHeight = 46.72;
  static const double profilePrivacyPrimaryTileHeight = 52.07;
  static const double profilePrivacySecondaryTileHeight = 48.89;
  static const double profilePrivacySectionGap = 6.52;
  static const double profilePrivacyIconContainerSize = 27.16;
  static const double profilePrivacyIconSize = 17.91;
  static const double profilePrivacyNoticeHeight = 70;
  static const double profilePrivacyReminderHeight = 70;
  static const double profilePrivacyNoticeGap = 13.0;
  static const double profilePrivacyButtonHeight = 31.51;
  static const double profilePrivacyButtonRadius = 17.75;
  static const double profilePrivacyAppBarTitleSize = 15.14;

  // Addresses Figma measurements.
  static const double addressesScreenHorizontalPadding = 25.0;
  static const double addressesContentTopPadding = 22.0;
  static const double addressesCardRadius = 15.35;
  static const double addressesCurrentCardHeight = 145.65;
  static const double addressesMapSize = 133.0;
  static const double addressesSavedTileHeight = 54.35;
  static const double addressesSectionTitleSize = 11.23;
  static const double addressesIconContainerSize = 32.61;
  static const double addressesPreferenceIconContainerSize = 28.26;
  static const double addressesOverflowButtonSize = 27.17;
  static const double addressesPreferenceCardHeight = 89.0;
  static const double addressesAddButtonHeight = 47.0;
  static const double addressesAvailabilityNoticeHeight = 36.0;
  static const double addressesSaveButtonHeight = 31.51;
  static const double addressesSaveButtonRadius = 17.75;
  static const double addressesCardGap = 4.35;
  static const double addressesSectionGap = 14.35;
  static const double addressesCardContentPadding = 17.39;
  static const double addressesIconRadius = 6.11;
  static const double addressesMapRadius = 9.24;

  // Calendar header Figma measurements.
  static const double calendarHeaderHeight = 116.0;
  static const double calendarHeaderRadius = 40.0;
  static const double calendarHeaderTitleTop = 55.0;
  static const double calendarHeaderIconTop = 62.0;
  static const double calendarHeaderHorizontalInset = 22.0;
  static const double calendarHeaderNotificationDotStart = 13.0;
  static const double calendarMealCardVerticalPadding = 4.0;

  // Home Figma measurements.
  static const double homeHorizontalPadding = 20.0;
  static const double homeHeaderHeight = 112.0;
  static const double homeNutritionHeight = 140.0;
  static const double homePromotionHeight = 131.263;
  static const double homeShortcutHeight = 67.12;
  static const double homeMealCardWidth = 106.755;
  static const double homeMealCardHeight = 91.056;
  static const double homeRestaurantCardWidth = 90.887;
  static const double homeRestaurantCardHeight = 109.53;
  static const double homeInfoCardHeight = 78.0;
  static const double homeReminderHeight = 67.777;

  // Offers Figma measurements.
  static const double offersHorizontalPadding = 14.0;
  static const double offersHeroHeight = 150.0;
  static const double offersHeroAspectRatio = 2.651;
  static const double offersHeroRadius = 20.07;
  static const double offersHeroLogoWidth = 95.0;
  static const double offersHeroButtonWidth = 113.0;
  static const double offersHeroButtonHeight = 29.0;
  static const double offersHeroBadgeSize = 78.0;
  static const double offersHeroCopyWidth = 178.0;
  static const double offersHeroImageWidth = 318.0;
  static const double offersIndicatorGap = 10.0;
  static const double offersIndicatorDotSize = 8.0;
  static const double offersIndicatorActiveWidth = 32.0;
  static const double offersFilterHeight = 42.0;
  static const double offersFilterGap = 7.0;
  static const double offersFilterIconSize = 16.0;
  static const double offersFilterHorizontalPadding = 12.0;
  static const double offersDealRowHeight = 170.0;
  static const double offersDealCardWidth = 145.0;
  static const double offersDealCardHeight = 110.0;
  static const double offersDealCardRadius = 14.31;
  static const double offersDealImageHeight = 70.0;
  static const double offersDealFooterHeight = 35.0;
  static const double offersDealBadgeHeight = 25.0;
  static const double offersCouponBannerHeight = 77.0;
  static const double offersCouponBannerRadius = 22.93;
  static const double offersCouponButtonWidth = 117.0;
  static const double offersCouponButtonHeight = 30.0;
  static const double offersInviteBannerHeight = 114.0;
  static const double offersInviteBannerRadius = 27.86;
  static const double offersInvitePeopleWidth = 224.0;
  static const double offersInviteGiftWidth = 112.0;
}
