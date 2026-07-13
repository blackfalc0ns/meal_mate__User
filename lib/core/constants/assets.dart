/// Centralized asset paths to avoid typos and ease autocomplete.
class Assets {
  Assets._();

  static const String _root = 'assets';
  static const String _images = 'assets/images';
  static const String _icons = 'assets/icons';
  static const String _fonts = 'assets/fonts';
  static const String _lottie = 'assets/lottie_animation';
  static const String _svg = "assets/images/svg";

  // Images
  static const String banner = '$_root/banner.png';

  static const String appLogoLight = '$_images/app_logo_removebg-preview 1.png';

  static const String blackFalconsLogo = '$_images/black_falcons_logo.png';

  static const String placeholder = '$_images/placeholder.png';
  static const String noInternet = '$_images/no_internet.png';

  static const String error = '$_images/error.png';

  static const String splashPageBackground =
      '$_images/splash_page_background.gif';
  static const String successOrderAnimation =
      '$_images/success_order_animation.gif';
  static const String notFound = '$_images/image_not_found.png';
  static const String bgRegister = '$_images/bg_register.png';
  static const String onboardingOne = '$_images/on_boarding1.png';
  static const String onboardingTwo = '$_images/on_boarding2.png';
  static const String onboardingThree = '$_images/on_boarding3.png';
  static const String loginIcon = '$_images/login_icon.svg';
  static const String fireIcon = '$_images/fire_icon.svg';
  static const String foodIcon = '$_images/food_icon.svg';
  static const String offerIcon = '$_images/offer_icon.svg';
  static const String homeBanner = '$_images/home_oatmeal.png';
  static const String homeBreakfast = '$_images/home_oatmeal.png';
  static const String homeLunch = '$_images/home_burger.png';
  static const String homeDinner = '$_images/home_hotdog.png';
  static const String homeSnack = '$_images/home_donut.png';
  static const String homeHook = '$_images/home_hook.png';
  static const String homeFigmaAvatar = '$_images/home/figma/home_avatar.png';
  static const String homeFigmaSpecialsMeal =
      '$_images/home/figma/home_specials_meal.png';
  static const String homeFigmaBackgroundDoodle =
      '$_images/home/figma/home_background_doodle.svg';
  static const String homeFigmaHeaderDoodle =
      '$_images/home/figma/home_header_doodle.svg';

  // Calendar
  static const String calendarBreakfast = '$_images/home_oatmeal.png';
  static const String calendarLunch = '$_images/offers/grilled_plate.png';
  static const String calendarDinner = '$_images/home_hotdog.png';
  static const String calendarSnack = '$_images/home_donut.png';
  static const String calendarFigmaMealBowl =
      '$_images/calendar/figma/calendar_meal_bowl.png';
  static const String calendarMealPickerHero =
      '$_images/calendar/figma/meal_picker_hero-47a8dd.png';
  static const String calendarMealPickerBreakfast =
      '$_images/calendar/figma/meal_picker_breakfast.png';

  // Meal details
  static const String mealDetailsHero =
      '$_images/meal_details/figma/meal_details_hero.png';
  static const String mealDetailsPlateCrop =
      '$_images/meal_details/figma/meal_details_plate_crop-49e47e.png';
  static const String mealDetailsIngredientChicken =
      '$_images/meal_details/figma/ingredient_chicken.png';
  static const String mealDetailsIngredientRice =
      '$_images/meal_details/figma/ingredient_rice.png';
  static const String mealDetailsIngredientCarrot =
      '$_images/meal_details/figma/ingredient_carrot.png';
  static const String mealDetailsIngredientBroccoli =
      '$_images/meal_details/figma/ingredient_broccoli.png';
  static const String mealDetailsIngredientLettuce =
      '$_images/meal_details/figma/ingredient_lettuce.png';
  static const String mealDetailsIngredientLemon =
      '$_images/meal_details/figma/ingredient_lemon.png';

  // Offers / promotions
  static const String offerGiftBox = '$_images/offers/gift_box.png';
  static const String offerSaladBowl = '$_images/offers/salad_bowl.png';
  static const String offerMealBoxes = '$_images/offers/meal_boxes.png';
  static const String offerGrilledPlate = '$_images/offers/grilled_plate.png';
  static const String offerBurgerKingLogo =
      '$_images/offers/burger_king_logo.png';
  static const String offerMcdonaldsLogo = '$_images/offers/mcdonalds_logo.png';
  static const String offerStarbucksLogo = '$_images/offers/starbucks_logo.png';
  static const String offerCalendar = '$_images/offers/calendar.png';

  // Subscriptions
  static const String subscriptionHeroMeal =
      '$_images/subscriptions/subscription_hero_meal.png';
  static const String subscriptionWeekPlan =
      '$_images/subscriptions/subscription_week_plan.png';
  static const String subscriptionHalfMonthPlan =
      '$_images/subscriptions/subscription_hero_meal.png';
  static const String subscriptionMonthPlan =
      '$_images/subscriptions/subscription_month_plan.png';
  static const String subscriptionNoteMeal =
      '$_images/subscriptions/subscription_note_meal.png';
  static const String monthlyPlanHero =
      '$_images/subscriptions/figma/monthly_plan_hero.png';
  static const String monthlyPackageBox =
      '$_images/subscriptions/monthly_package_box.png';
  static const String familyBanner = '$_images/subscriptions/family_banner.png';
  static const String familyPlanHero =
      '$_images/subscriptions/family_plan_hero.png';
  static const String familyMemberSarah =
      '$_images/subscriptions/family_member_sarah-40a2f0.png';
  static const String familyMemberYousef =
      '$_images/subscriptions/family_member_yousef-42a7a0.png';
  static const String familyMemberMariam =
      '$_images/subscriptions/family_member_mariam-40a2f0.png';
  static const String familyMemberAhmed =
      '$_images/subscriptions/family_member_ahmed-42a7a0.png';

  // Lottie
  static const String emptyCart = '$_lottie/empty_cart.json';

  static const String loading = '$_lottie/loading_animation.json';
  static const String successPayment = '$_lottie/success_payment.json';
  static const String errorPayment = '$_lottie/failed_payment.json';
  static const String fireAnimation = 'assets/animations/fire_animation.json';

  // Icons (SVG)
  static const String icHome = '$_icons/ic_home.svg';
  static const String icProfile = '$_icons/ic_profile.svg';
  static const String icSettings = '$_icons/ic_settings.svg';
  static const String icNotification = '$_icons/ic_notification.svg';
  static const String icSearch = '$_icons/ic_search.svg';
  static const String icBack = '$_icons/ic_back.svg';
  static const String icClose = '$_icons/ic_close.svg';
  static const String icMenu = '$_icons/ic_menu.svg';
  static const String icLocation = '$_icons/ic_location.svg';
  static const String icWallet = '$_icons/ic_wallet.svg';
  static const String buttonSmall = "$_svg/button_small.svg";
  static const String buttonLarge = "$_svg/button_large.svg";
  static const String logoWhite = '$_svg/logo_white.svg';
  static const String notificationBold = '$_svg/notification_bold.svg';
  // Other assets
  static const String searchNormal = '$_images/search-normal.svg';

  // Fonts
  static const String cairoRegular = '$_fonts/Cairo-Regular.ttf';
  static const String cairoMedium = '$_fonts/Cairo-Medium.ttf';
  static const String cairoSemiBold = '$_fonts/Cairo-SemiBold.ttf';
  static const String cairoBold = '$_fonts/Cairo-Bold.ttf';
}
