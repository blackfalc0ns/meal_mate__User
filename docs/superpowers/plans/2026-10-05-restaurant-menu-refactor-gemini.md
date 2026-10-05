# Restaurant Menu Refactor — Gemini Implementation Plan

> **For agentic workers:** استخدم `superpowers:executing-plans` لتنفيذ الخطة خطوة بخطوة. المطلوب هنا تنفيذ داخل المشروع الحالي، مع مراجعة ونتيجة تحقق لكل مهمة.

**Goal:** تحسين عرض الوجبات والبناء الكسول وتقليل نطاق إعادة البناء، واستخدام `flutter_animate: ^4.5.2` لأنيميشن دخول الوجبات، مع الحفاظ على التصميم وسلوك الاختيار والتفاصيل.

**Architecture:** المنيو يظل مكون عرض مشتركًا بين Calendar والاشتراكات. حالة التاب داخل أصغر مكون يجمع التابات والقائمة؛ اختيار الوجبات يبقى مصدره MealSelectionViewModel الحالي. استخدم SliverList لبناء العناصر حسب ظهورها، وافصل البيانات الثابتة عن حالة الاختيار والتحميل.

**Tech Stack:** Flutter، flutter_bloc الموجود، flutter_animate 4.5.2 الموجودة بالفعل، Lottie الحالي.

**Spec:** طلب المستخدم ومراجعة الكود موثقان في هذه الخطة؛ لا تعتمد على خطة individual-subscription لتوسيع النطاق.

## تعليمات لجيميناي قبل التنفيذ

- اقرأ `AGENTS.md` و`rules/ui_rules.md`، وافحص الملفات الحالية قبل تعديلها.
- `rules/backend_rules.md` غير موجود وقت إعداد الخطة. قبل أي تعديل في ViewModel/State/DTO/API/DI اطلب الملف أو تعليمات بديلة. نفذ مهام العرض المستقلة ولا تخترع قواعد بديلة. الخطة لا تحتاج تعديل API أو ViewModel أو State.
- لا تعدل pubspec.yaml أو pubspec.lock؛ flutter_animate مثبتة ومستخدمة في المشروع بالفعل.
- احتفظ بالتصميم والألوان والمقاسات وترتيب المحتوى، واستخدم theme/styles/spacing/localization الموجودة. لا تحتاج إعادة تصميم أو مقاسات من Figma لتنفيذ تغييرات البناء والحالة.
- الأنيميشن الجديد مطلوب صراحة. القيم أدناه قرار حركة لهذه المهمة، وليست قياسات مستخرجة من Figma.
- لا تغير منطق toggleMeal أو شروط الحفظ أو pagination أو عقود الشبكة.
- افحص `git status --short` أولًا. كان هناك تعديل للمستخدم في `lib/features/calendar/presentation/widgets/calendar_meal_save_button.dart`؛ لا تلمسه أو تتراجع عنه.
- عند مراجعة الخطة ظهر أيضًا تعديل قائم في `calendar_meal_selection_screen.dart`. اقرأ diff قبل Task 4 وادمج التغيير المطلوب مع العمل الموجود؛ لا تستبدل الملف أو تلغي تعديلات المستخدم. أعد فحص baseline الحالي لأن الملفات قد تتغير بعد إعداد الخطة.
- لا تعمل commit تلقائيًا ولا تنفذ خطة الاشتراكات المفتوحة في IDE.
- ملف widget واحد لكل custom widget. لا تفتح مكتبة widgets بالكامل أو تحول كل part إلى import؛ هذا ريفاكتور منفصل غير مطلوب لتحسين الأداء.

## ملفات العمل ومسؤولياتها

المسارات التالية تحت `lib/features/restaurant_menu/` ما لم يذكر غير ذلك:

| الملف | المطلوب |
|---|---|
| presentation/widgets/restaurant_menu_view.dart | تركيب frame ومحتوى ثابت؛ إخراج حالة التاب منه، حذف mapping part |
| presentation/widgets/restaurant_menu_content.dart | Slivers منفصلة للهيدر، المصادر، التابات، القائمة، footer؛ فلترة pagination notifications |
| presentation/widgets/restaurant_menu_meals_body.dart — جديد | StatefulWidget يملك selectedSlotKey ويجمع التابات والقائمة والـ scroll lifecycle |
| presentation/widgets/restaurant_menu_options_section.dart | تحويله إلى مكون Sliver يبني الكروت كسولًا؛ حذف AnimatedSwitcher المحيط بالقائمة كلها |
| presentation/widgets/restaurant_menu_animated_option.dart — جديد | أنيميشن دخول لكارت واحد، بدون تكرار بسبب rebuild |
| presentation/widgets/restaurant_menu_option_card.dart | فصل تغير الاختيار عن المعلومات والصورة والمكونات |
| presentation/widgets/restaurant_menu_select_button.dart | إبقاء selected/enabled قيمًا محددة؛ دون اشتراك في state كاملة |
| presentation/widgets/restaurant_menu_nutrition.dart | حذف icon غير المقروء، جعل animationAsset مطلوبًا بدل nullable force unwrap |
| presentation/widgets/restaurant_menu_nutrition_row.dart | حذف تمرير icon، وفصل هذا الجزء الثابت عن إعادة بناء الاختيار |
| presentation/widgets/restaurant_menu_navigation.dart | localization ومنع اختيار الوجبات المحظورة |
| presentation/widgets/restaurant_menu_mapping.dart | حذف الملف الفارغ فقط |
| presentation/screens/restaurant_menu_screen.dart | تمرير نقاط التخصيص الجديدة بصورة اختيارية تحافظ على preview |
| lib/features/calendar/presentation/screens/calendar_meal_selection_screen.dart | فصل اختيار كل وجبة والتحميل عن بناء بيانات المنيو |
| lib/features/calendar/presentation/mapper/calendar_menu_mapper.dart | استخدامه لبيانات الوجبات فقط عند تغير بياناتها/اللغة؛ لا تكرر mapping بسبب toggle |
| test/restaurant_menu_view_test.dart | اختبارات سلوك المنيو والاختيار والتابات |
| test/restaurant_menu_performance_test.dart — جديد | lazy building، حدود rebuild، animation lifecycle، pagination notifications |

لا تحذف أي widget آخر: ملفات المنيو مستخدمة عبر part declarations. `subtitle` في SourceCard غير معروض حاليًا؛ لا تضف نصه للتصميم ولا تحذف عقد Origin المشترك لمجرد أنه غير معروض.

## Task 1: تثبيت baseline والتنظيف المحدود

- [ ] شغل `flutter analyze lib/features/restaurant_menu`.
- [ ] شغل `flutter test test/restaurant_menu_view_test.dart test/calendar_source_card_overflow_test.dart`. baseline وقت كتابة الخطة: analyzer بدون مشاكل و12 اختبار ناجح.
- [ ] احذف restaurant_menu_mapping.dart وسطر part الخاص به؛ الملف لا يحتوي تنفيذًا.
- [ ] في RestaurantMenuNutrition احذف `icon` غير المستخدم واجعل العقد `required String animationAsset`. احذف تمرير Icons الأربعة من NutritionRow، واستبدل `animationAsset!` بالقيمة غير nullable.
- [ ] أعد التحليل والاختبارات السابقة؛ لا تكتب اختبارًا يطابق مجرد حذف سطر import.

## Task 2: القائمة الكسولة وحدود حالة التاب

**Interface:** يظل `RestaurantMenuScreen(mode:, menuData:, onMealToggled:, onOptionDetails:, onLoadMore:, ...)` متوافقًا مع مستدعيه الحاليين. المكون الجديد RestaurantMenuMealsBody يستهلك بيانات المنيو وcallbacks الحالية ويمتلك selectedSlotKey؛ View لا يملك حالة التاب بعد هذه المهمة.

- [ ] أضف fixture فيه 100 وجبة بعناوين مميزة. قبل التمرير تأكد أن widget الوجبة الأخيرة غير مبني، وبعد scrollUntilVisible يظهر. الاختبار لازم يفشل مع Column الحالية.
- [ ] أضف اختبارات: تغيير ترتيب tabs يحتفظ بالـ slot key المختار؛ حذف slot المختار يختار أول slot متاح؛ tabs فارغة لا تسبب RangeError وتعرض fallback الحالي.
- [ ] انقل حالة التاب من View إلى RestaurantMenuMealsBody. مرر header/source widgets كأطفال ثابتين من الخارج؛ إعادة بناء body بسبب التاب لا تعيد إنشاء هذه الأطفال أو frame. احتفظ بالفصل بين بيانات restaurant وبيانات التابات.
- [ ] احتفظ بCustomScrollView واحد رأسي. استخدم SliverToBoxAdapter للأجزاء القصيرة فقط وSliverList بSliverChildBuilderDelegate للكروت والفواصل. لا تستخدم shrinkWrap ListView أو Column لكل الوجبات.

```dart
// الشكل المقصود داخل قائمة الوجبات؛ حافظ على padding والفواصل الحالية.
SliverList(
  delegate: SliverChildBuilderDelegate(
    (context, index) {
      if (index.isOdd) return const RestaurantMenuDividerLine();
      final option = options[index ~/ 2];
      return RestaurantMenuOptionCard(
        key: ValueKey((selectedSlotKey, option.id)),
        option: option,
        onTap: onMealToggled == null ? null : () => onMealToggled!(option.id),
        onDetailsTap: () => onOptionDetails(option),
      );
    },
    childCount: options.isEmpty ? 0 : options.length * 2 - 1,
  ),
)
```

- [ ] لا تستخدم index كهوية وجبة. لو تغير ترتيب القائمة داخل slot، وفر findChildIndexCallback بمطابقة مفاتيح الوجبات مع مواقعها الجديدة والفواصل عند الحاجة.
- [ ] loader وsave footer كل منهما SliverToBoxAdapter منفصل؛ تغيير loadingMore لا يعيد بناء معلومات الوجبات.
- [ ] حافظ على scroll position عند اختيار وجبة وإضافة صفحة. عند تبديل slot ارجع لبداية قسم الوجبات بدل الإبقاء على offset كبير من تاب أطول. لا تستخدم ScrollController جديد داخل build، وتخلص من controller المملوك عند dispose.
- [ ] أضف build counters في test harness لإثبات أن تبديل تاب لا يعيد بناء frame/header/source. لا تضف counters إلى production code.

## Task 3: أنيميشن عرض الوجبات باستخدام flutter_animate

**Interface:** RestaurantMenuAnimatedOption يستقبل `child`, `delay`, `animateEntry`. سجل الهويات التي بدأت ظهورها يملكه MealsBody لكل زيارة تاب، خارج build.

**السلوك المطلوب بالضبط:**

- fade من 0 إلى 1 مع slideY من 0.06 إلى 0، مدة 260ms وcurve easeOutCubic.
- تتابع أول 6 عناصر فقط: delay يساوي `min(index, 5) * 35ms`، حد أقصى 175ms. العناصر التالية بلا delay.
- الحركة عند أول بناء للوجبة في زيارة التاب، وعند ظهور وجبات جديدة من pagination. اختيار/إلغاء اختيار وجبة أو save/loading rebuild لا يعيد الحركة.
- عند الخروج من التاب والعودة إليه تبدأ زيارة جديدة؛ يمكن إعادة دخول العناصر المبنية. الرجوع لنفس العنصر أثناء التمرير داخل نفس الزيارة لا يعيد الحركة حتى لو تم التخلص من widget خارج الشاشة.
- سجل الهوية `(slotKey, mealId)` يبقى في lifecycle؛ امسحه عند تغيير restaurant/menu session، ولا تمسحه بسبب mapping أو pagination. callback تسجيل دخول العنصر لا يستدعي setState ولا يغير Cubit.
- `MediaQuery.disableAnimationsOf(context)` يعرض الطفل فورًا بدون delay أو حركة. تفعيل تقليل الحركة أثناء التشغيل ينهي الحركة ويعرض المحتوى.

```dart
import 'package:flutter_animate/flutter_animate.dart';

// داخل wrapper؛ lifecycle هو الذي يحدد animateEntry، وليس selected.
if (!animateEntry || MediaQuery.disableAnimationsOf(context)) return child;
return child
    .animate(delay: delay)
    .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
    .slideY(begin: 0.06, end: 0, duration: 260.ms, curve: Curves.easeOutCubic);
```

- [ ] افحص API النسخة المثبتة محليًا وpatterns الموجودة في calendar_day_content.dart قبل التنفيذ؛ لا تحدث الحزمة.
- [ ] استبدل AnimatedSwitcher/FadeTransition/SizeTransition/SlideTransition التي تلف القائمة كلها بهذه الحركة على الكروت المبنية فقط. لا تجمع الأنيميشن القديم والجديد.
- [ ] wrapper يبقى بنفس الهوية أثناء toggle. لا تستخدم selected/loading ضمن ValueKey ولا onPlay repeat/reverse؛ لا controllers أو futures جديدة في build.
- [ ] اختبر: ظهور أولي، toggle أثناء/بعد الحركة بدون إعادة البداية، pagination تحرك الجديد فقط، التخلص وإعادة البناء بالتمرير لا يعيد الحركة في نفس زيارة التاب، زيارة جديدة تعيدها، وتقليل الحركة يظهر المحتوى فورًا.
- [ ] لا تستخدم pumpAndSettle مع Lottie المتكرر؛ استخدم pump بمدة محددة لاختبارات الأنيميشن.

## Task 4: اختيار وجبة يعيد بناء الجزء المتغير فقط

**Interface المقترح:** أضف نقطة تخصيص اختيارية على Screen/View/Body تمرر إلى الكارت: `Widget Function(BuildContext context, RestaurantMenuOption option)? selectionControlBuilder`. عند null استخدم RestaurantMenuSelectButton الحالي مع option.selected. Calendar يمرر builder لـ BlocSelector على selectedMealIds.contains(option.id)، وليس state كاملة. preview يظل بلا زر.

- [ ] اكتب اختبار وجبتين: toggle الأولى يغير زرها؛ زر الثانية ومعلومات وصورة وnutrition الوجبتين لا يعاد بناؤها. راعِ أي وجبتين تتغيران معًا بالفعل بسبب قواعد ViewModel.
- [ ] في Calendar builder احذف selectedMealIds من شروط بناء بيانات المنيو؛ اجعل selector الاختيار على زر كل وجبة. لا تفقد اختيارًا سابقًا عند دخول الشاشة أو البيانات الواردة من API: المصدر المرجعي هو state.selectedMealIds كما في السلوك الحالي.
- [ ] اجعل onOptionDetails/onMealToggled يستخدمان id وهوية الوجبة الحالية، ولا يغلقان على index قديم.
- [ ] لا تعتمد navigation على option.selected القديم بعد فصل الاختيار. وفر resolver اختياري `bool Function(String mealId)? isMealSelected` من Calendar يقرأ الحالة الحالية عند فتح التفاصيل، ويتحقق منها عند تنفيذ callback؛ fallback هو option.selected للمستدعين الآخرين. مرر resolver عبر Screen/View إلى navigation.
- [ ] احتفظ بمعلومات الكارت خارج BlocSelector. bool selected هو القيمة المختارة الوحيدة؛ لا تضع الكارت كله داخل selector.
- [ ] افصل isLoadingMore عن builder الذي ينفذ CalendarMenuMapper. وفر loader builder اختياري يختار bool isLoadingMoreMeals فقط؛ لا يعيد mapping عند بدء/انتهاء التحميل. وصول availableMeals جديدة يعيد mapping لأنه تغير حقيقي.
- [ ] احتفظ بـ saveFailure وavailableMealsFailure والسلوك الحالي للأخطاء. لا تعدل CalendarMealSaveButton؛ هو خارج نطاق هذه المهمة وعليه تعديل للمستخدم.
- [ ] لا تضف Cubit جديدًا أو ValueNotifier mirror لكل selected state. اعتمد flutter_bloc الحالي.
- [ ] لا تضف cache عامًا أو مساواة لكل models لمجرد تقليل rebuild. إذا احتجت memoization لmapping، احفظ الناتج حسب هوية availableMeals + localization + restaurant metadata فقط في lifecycle مناسب، وغيّر الناتج عندما يتغير أي منها. لا تنفذ mapper لكل toggle أو loadingMore.

## Task 5: pagination notifications صحيحة

- [ ] أضف اختبارات: horizontal ingredients/source scroll لا يستدعي onLoadMore؛ التمرير الرأسي الخارجي قرب النهاية يستدعيه للـ slot key الحالي؛ loading/loadingMore يمنع الاستدعاء.
- [ ] طبق فلترة الإشعار قبل threshold:

```dart
if (notification.depth != 0 ||
    notification.metrics.axis != Axis.vertical ||
    notification is! ScrollUpdateNotification ||
    isLoading || isLoadingMore) {
  return false;
}
if (notification.metrics.extentAfter <= 200) {
  onLoadMore?.call(selectedSlotKey);
}
return false;
```

- [ ] القيمة 200 threshold سلوك pagination موجود، وليست spacing للتصميم. لا تضف debounce عشوائيًا؛ ViewModel بالفعل يمنع in-flight request ويفحص hasNextPage. لا تعدل هذا المنطق.
- [ ] تأكد أن آخر صفحة لا تسبب API requests إضافية من خلال اختبارات ViewModel الموجودة إن وجدت، دون تغيير backend contract.

## Task 6: تفاصيل الوجبة وlocalization

- [ ] في navigation استبدل النصوص اليدوية بمفاتيح موجودة: `meal_details_restaurant_rating`, `meal_details_delivery_time`, `meal_details_nutrition_facts`, `meal_details_macro_distribution`, `meal_details_allergens`. افحص بقية مفاتيح suitable program/fiber داخل ARB؛ استخدم الموجود، وإذا غاب مفتاح أضفه لكل locales المكونة ثم شغل gen-l10n.
- [ ] callback اختيار الوجبة داخل التفاصيل لا يتوفر إذا blockReason غير فارغ. استخدم نفس شرط الكارت، واستعلم عن selected الحالي باستخدام resolver من Task 4. لا تظهر إجراء يسمح باختيار وجبة محظورة.
- [ ] اختبر blocked option في مسار Calendar fallback للتفاصيل؛ callback الخاص بالاشتراكات يظل يفتح SubscriptionMealDetailsArgs كما هو.
- [ ] لا تغير mapping التفاصيل إلى API جديد ولا تعرض معلومات غير موجودة.
- [ ] أجّل تعديل copyWith الخاص بمسح nullable fields: لا يوجد احتياج وظيفي له في هذا الريفاكتور، وتغييره هنا يوسع النطاق بلا ضرورة.

## Task 7: تحقق الأداء والسلوك وتسليم النتيجة

- [ ] شغل formatter على الملفات المعدلة فقط، ثم `flutter analyze`، ثم `flutter test test/restaurant_menu_view_test.dart test/calendar_source_card_overflow_test.dart test/restaurant_menu_performance_test.dart` وأي اختبارات Calendar mapper/details المتأثرة.
- [ ] لو اختبار موجود يعتمد على نص source أو شكل AnimatedSwitcher القديم، عدله لاختبار السلوك المرئي المطلوب؛ لا تلغي assertion سلوكي لمجرد نجاح التنفيذ.
- [ ] جرب Calendar selection وSubscription preview: اختيار، إلغاء، blocked meal، تفاصيل، back، tabs، empty/error/loading، pagination، RTL/LTR، text scaling.
- [ ] في Profile mode استخدم DevTools build tracking وPerformance timeline قبل/بعد بنفس dataset وعدد الوجبات والجهاز. سجل تبديل تاب، اختيار وجبة، سكرول، وإضافة صفحة.
- [ ] معيار البناء: toggle لا يعيد frame/header/source أو معلومات الوجبات؛ loadingMore يغير footer فقط؛ قائمة 100 وجبة لا تبني 100 كارت دفعة واحدة. عدد الكروت المبنية يعتمد على viewport وcacheExtent، فلا تستخدم رقمًا ثابتًا غير موثق.
- [ ] راقب Lottie: أربع animations لكل كارت. البناء الكسول يقلل عددها؛ إذا ظلت عناصر cache خارج العرض تستهلك frame time، استخدم TickerMode عند حدود العنصر مع visibility محسوبة من scroll lifecycle دون package جديدة. لا تفترض أن TickerMode وحده يكتشف visibility أو أن SliverList يوقف كل ticker خارج الشاشة.
- [ ] لا تستبدل Lottie بصور ثابتة أو تغير شكل الأيقونات من نفسك. أي تغيير بصري إضافي يحتاج طلبًا منفصلًا.
- [ ] إذا تعذر قياس Profile/DevTools، اذكر ذلك صراحة: اختبارات rebuild ليست دليلًا على تحسن FPS. لا تدّعِ رقمًا أو نسبة أداء غير مقاسة.
- [ ] افحص git diff: الملفات المسموحة فقط، ولا تغيرات في pubspec/lock أو ViewModel/State/API أو تعديل المستخدم.

## صيغة تسليم جيميناي

أبلغ المستخدم: الملفات المعدلة، ما تم حذفه، كيف أصبحت القائمة lazy، الحدود التي تعيد البناء عند التاب/الاختيار/التحميل، سلوك flutter_animate ومتى يعاد تشغيله، نتائج الأوامر الفعلية، نتائج Profile إن كانت متاحة، وأي جزء متوقف بسبب قواعد backend المفقودة. لا تقل «تم تحسين الأداء» دون بيان ما تحقق بالكود والاختبارات وما تم قياسه فعليًا.
