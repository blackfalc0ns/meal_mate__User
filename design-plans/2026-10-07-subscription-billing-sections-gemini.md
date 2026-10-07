# Subscription Billing Sections Implementation Plan

> For Gemini: نفّذ الخطة خطوة بخطوة باستخدام executing-plans إن كانت متاحة. المطلوب تنفيذ داخل النطاق أدناه فقط، بدون commit أو push أو عمليات فعلية على اشتراكات العملاء.

**Goal:** تصغير شاشة الاشتراكات والفواتير بتقسيمها لسكاشن مستقلة، وإخراج معالجة نتائج العمليات والأخطاء منها، وتنظيف القيم الثابتة المؤكدة بدون تغيير التصميم أو سلوك الاشتراك.

**Architecture:** احتفظ بـ Cubit / Event / State / UseCase / Repository الحالي. الشاشة تنشئ الـViewModel مرة واحدة؛ المحتوى يركب الهيكل؛ كل section يمتلك الـselector الخاص به ويعيد استخدام الكارت الموجود. الـCoordinator يستقبل نتائج العمليات وينفذ تأثيرات الواجهة، ولا يستدعي API مباشرة.

**Tech Stack:** Flutter، flutter_bloc، GetIt/Injectable، localization، flutter_animate الموجود بالفعل.

**Spec:** طلب المستخدم: تقسيم الصفحة الكبيرة لسكاشن، منع الهارد كود ومعالجة الأخطاء داخل الشاشة، حذف الزائد فقط. قواعد المشروع: `rules/ui_rules.md` و`rules/rules_backend.md` (الاسم الموجود فعليًا؛ `rules/backend_rules.md` غير موجود).

Written against: `f48fdf41249ab007d8ef8d900a978571a2b79c3f` مع تغييرات محلية موجودة مسبقًا؛ ملفات billing الجديدة غير متتبعة حاليًا. الكود المحلي هو مرجع التنفيذ، وليس HEAD وحده.

## Global constraints

- اقرأ AGENTS.md والقواعد المذكورة قبل التنفيذ. اقرأ خطة migration السابقة `docs/superpowers/plans/2026-10-06-subscription-billing-migration-gemini.md` للسياق، ولا تعِد تنفيذ النقل المنجز بالفعل.
- لا تعدّل calendar أو profile أو subscription_upgrade أو family screens إلا إذا ثبت اعتماد مباشر يمنع تجميع التغييرات المطلوبة؛ اذكر أي توسيع للنطاق قبل تنفيذه.
- لا تغيّر endpoint أو payload أو سياسة اشتراك أو بنية المشروع، ولا تضف packages.
- Widget واحد لكل ملف؛ State الخاصة بـStatefulWidget تبقى مع الـWidget. لا تفصل Row وColumn البسيطة لمجرد تقليل السطور.
- النصوص من localization، الألوان من colorScheme، typography من styles_manager، والمسافات من spacing. اختيار اللغة للنصوص يختلف عن اتجاه layout؛ لا تستخدم RTL كبديل لاختيار اللغة.
- لا تحذف معالجة أخطاء التطبيق: انقل تفسيرها وتأثيراتها خارج الشاشة، واستخدم نظام `lib/core/errors` الموجود فعليًا. استخدم `ErrorMessagePresenter.fromFailure(context, failure)` لرسائل أخطاء العمليات بدل بناء سلسلة rawError أو تكرار mapping محلي، و`ApiErrorWidget` لحالة فشل التحميل الأولي. احتفظ بـFailure وبـmapping المشترك الذي يستدعيه presenter داخليًا.
- لا تخترع tokens أو حد تواريخ أو ترجمات أو قيم دفع مفقودة. سجّل العائق المحدد إذا لم يوجد مصدر معتمد.
- لا تدّعِ تطابق Figma أو قياس rebuilds بدون دليل. لا يوجد Figma node موفّر لهذا الطلب؛ التقسيم يحافظ على الشكل الحالي.
- لا reset ولا checkout للتغييرات المحلية، ولا formatter شامل، ولا commit/push.

## Evidence and decisions

- `subscription_billing_screen.dart` يجمع Provider وWidget محتوى وselectors لستة أقسام و`_handleBillingActionState`، ويستخدم MultiBlocListener بقائمة تحتوي Listener واحدًا.
- state.type عبارة عن `String?`، والـViewModel والشاشة والاختبارات تستخدم أسماء عمليات نصية.
- coordinator فيه اختيار تواريخ بحد `365` يوم وفحص mounted متكرر بعد شرط يعالج نفس الحالة بدون await بينهما.
- `subscription_freeze_notice_sheet.dart` فيه maxHeight: 280؛ empty subscription card فيه height: 130.
- plan card يفرض TextDirection.rtl في عدة Rows ويعرض statusNameAr في جميع اللغات.
- widgets بالصورة مستخدمة بالفعل: action من plan؛ active freeze وrules وreason من coordinator؛ date column من active freeze؛ empty invoices من invoice history. لا تحذفها باعتبارها غير مستخدمة.

## File map

كل الأسماء التالية تحت `lib/features/subscription_settings/presentation/`، افحص وجود بديل مطابق قبل الإنشاء:

| File | Responsibility |
| --- | --- |
| `screens/subscription_billing_screen.dart` | Provider واحد وinitial event واحد ثم SubscriptionBillingContent |
| `widgets/subscription_billing_content.dart` | Scaffold وAppBar وBlocListener وربط coordinator طوال عمر route |
| `widgets/subscription_billing_body.dart` | selector لحالة التحميل/الخطأ الأولي/توفر البيانات، ثم SafeArea وScrollView وتركيب السكاشن |
| `widgets/subscription_billing_plan_section.dart` | subscription وfreezePolicy وhasUncompleted وisActionLoading؛ empty/plan card وcallbacks |
| `widgets/subscription_billing_pending_freeze_section.dart` | subscription وpendingFreeze وfreezePolicy؛ pending card وdialog callback |
| `widgets/subscription_billing_uncompleted_section.dart` | unfinished list وaction loading/subscriptionId؛ heading والقائمة وdelete/resume callbacks |
| `widgets/subscription_billing_payment_section.dart` | paymentMethod فقط؛ إخفاء القسم بدون saved method |
| `widgets/subscription_billing_invoices_section.dart` | invoices فقط؛ history card بما فيها empty invoices |
| `widgets/subscription_billing_management_section.dart` | hasSubscription وfreezePolicy؛ notice وmanagement CTA |
| `widgets/subscription_billing_entrance_registry.dart` | registry واحدة مستقرة لكل route |
| `widgets/subscription_billing_entrance.dart` | entrance Widget فقط؛ animation لا تبدأ مجددًا مع action updates |
| `widgets/subscription_billing_action_coordinator.dart` | التدفقات الموجودة وhandleActionState للنتائج وnavigation/snackbars |
| `manager/subscription_billing_action_type.dart` | enum لأسماء العمليات الداخلية |

عدّل كذلك `manager/subscription_billing_state.dart` و`manager/subscription_billing_view_model.dart` ومستهلكي action type المباشرين في tests. لا تقسّم ملفات غير مرتبطة بهذا السطح.

## Task 1 — Baseline and typed actions

- [x] سجّل git status واقرأ الملفات الحالية والاختبارات؛ شغّل اختبارات billing الموجودة قبل التعديل وسجّل أي فشل سابق.
- [x] ابحث عن جميع `.type` و`type:` المتعلقة بـSubscriptionBillingActionState في lib وtest.
- [x] أنشئ enum التالي وغيّر type في constructor وcopyWith والـViewModel والـswitch والاختبارات معًا:

```dart
enum SubscriptionBillingActionType {
  quote,
  renew,
  freeze,
  cancel,
  deleteUncompleted,
  resumePreview,
  resume,
}
```

- [x] استخدم `SubscriptionBillingActionType?` بدل `String?`. احتفظ بسلوك clearType/reset الحالي. قيم السيرفر مثل `freeze.confirm_overwrite_selections` ليست أسماء العمليات الداخلية؛ لا تغيّر عقدها ولا تحولها إلى enum العمليات.
- [x] تحقق من اختبارات النجاح والفشل والتصفير والتجميد الموجودة بعد تغيير النوع، وعدم بقاء أسماء العمليات النصية في state/viewmodel/consumer switch.

## Task 2 — Separate content and action effects

- [x] انقل `_SubscriptionBillingContent` إلى `SubscriptionBillingContent` في ملفه، مع initState وcoordinator callbacks الحالية دون تغيير الطلبات.
- [x] اترك الشاشة بهذا الشكل بعد إضافة imports الصحيحة:

```dart
class SubscriptionBillingScreen extends StatelessWidget {
  const SubscriptionBillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubscriptionBillingViewModel>(
      create: (_) => getIt<SubscriptionBillingViewModel>()
        ..doIntent(const GetSubscriptionBillingEvent()),
      child: const SubscriptionBillingContent(),
    );
  }
}
```

- [x] أضف إلى الـCoordinator:

```dart
void handleActionState(
  BuildContext context,
  SubscriptionBillingActionState actionState,
)
```

- [x] انقل إليه كامل `_handleBillingActionState`: mounted guard، مسار overwrite consent قبل الخطأ العام، snackbar/reset، quote/cancel dialog، success messages، resume preview وPaymentWebViewArgs. استبدل mapping المحلي بـErrorMessagePresenter.fromFailure حسب الفقرة التالية. استخدم enum. لا تنقل BuildContext أو localization أو navigation للـViewModel.
- [x] افحص `lib/core/errors/api_exception.dart` و`api_exception_mapper.dart` و`error_message_presenter.dart` و`error_presentation.dart` و`subscription_error_codes.dart` و`error_widgets/api_error_widget.dart` و`error_widgets/inline_api_error_widget.dart`. تتبع Failure.exception إلى مصدره في الشبكة؛ أعد استخدام mapper الحالي ولا تصنع mapper داخل feature. افحص سياسة presentation المشتركة قبل اختيار العرض، دون تحويل فشل عملية إلى شاشة كاملة تمسح بيانات الفواتير المحملة.
- [x] بعد مسار overwrite الخاص، اعرض الخطأ العام هكذا، ثم نفّذ reset الحالي مرة واحدة:

```dart
final failure = actionState.failure;
if (failure != null) {
  CustomSnackbar.showError(
    context: context,
    message: ErrorMessagePresenter.fromFailure(context, failure),
  );
  onResetAction();
  return;
}
```

- [x] راجع constants الموجودة في SubscriptionErrorCodes قبل أي مقارنة backend code. أعد استخدام المطابق إن وجد؛ لا تخترع constant موجودة بالاسم فقط ولا تغيّر قيمة الكود المتفق عليها. لا تنشئ switch لترجمة أخطاء API داخل الشاشة أو coordinator.
- [x] استبدل MultiBlocListener بـBlocListener واحد في Content، بنفس listenWhen على billingAction، واستدعِ coordinator.handleActionState من listener فقط.
- [x] لا تضف catch عام أو reset قبل عرض quote/resume dialog يفسد التدفق. لا تحذف overwrite confirmation باعتباره مجرد error.
- [x] أزل mounted guard المكرر عند بدء اختيار تواريخ التجميد فقط؛ احتفظ بفحوص mounted بعد await وtry/finally الذي يصفّر _isFreezeFlowOpen.
- [x] تحقق باختبارات consent الحالية: الرفض والإغلاق لا يفتحان picker ولا mutation؛ الموافقة تفتح picker؛ overwrite يحتاج موافقة مستقلة؛ إغلاق route أثناء dialog لا ينفذ navigation على context غير mounted.

## Task 3 — Extract six sections without moving the giant screen elsewhere

- [x] أنشئ Body وsections حسب file map. Body يراقب loading/failure/hasData فقط، ولا يراقب billingAction. احتفظ ببيانات سابقة أثناء refresh وبعرض ApiErrorWidget عند فشل التحميل الأولي فقط وRetry event الحالي.
- [x] انقل كل selector وبناؤه كما هما للقسم المسؤول عنه. Payment وInvoices لا يستقبلان coordinator ولا actionState. الأقسام التي تحتاج تصرفات تستقبل `SubscriptionBillingActionCoordinator` عبر constructor، ولا تنشئ coordinator جديدًا.
- [x] Body يركب Column ثابتة من plan/pending/uncompleted/payment/invoices/management، داخل نفس ScrollView وبنفس padding والترتيب. لا nested scroll ولا constraints جديدة.
- [x] كل section يعيد استخدام الكارت الحالي؛ لا تكرر UI الكارت داخل section ولا تعمل wrapper لا مسؤولية له.
- [x] احتفظ بقواعد الإخفاء والمسافات التابعة لها: pending عند وجود pending freeze؛ unfinished عند عدم فراغ القائمة؛ payment عند saved method؛ management عند وجود اشتراك. Invoices يحتفظ بحالة empty.
- [x] retain selectors الدقيقة؛ لا تمرّر state كاملة للسكاشن ولا تستدعي API من build أو selector. راقب isActionLoading فقط حيث تعتمد الأزرار عليه.
- [x] تحقق من اختبار `test/subscription_billing_rebuild_isolation_test.dart`؛ لا تعتبر فصل الملف وحده إثبات عزل rebuild. استخدم instrumentation الموجود لقياس أن action update لا يعيد بناء جسم payment/invoices ولا يكرر aggregate fetch.

## Task 4 — Stable entrance ownership

- [x] افصل registry عن entrance لتحقيق Widget واحد لكل ملف. احتفظ بمفاتيح sections الحالية وتتابع دخولها وreduced motion.
- [x] Set الحالية تُنشأ في constructor للـInheritedWidget، وRegistry تُنشأ داخل build؛ اجعل ContentState يمتلك `final Set<String> _playedSectionKeys = <String>{};`، ومرّرها للـRegistry حتى لا تضيع عند rebuild للـContent.
- [x] لا تعدّل registry ولا تشغّل side effects داخل build. اجعل entrance StatefulWidget يسجل أول ظهور في lifecycle المناسب ويحفظ قرار الأنيميشن، ويفصل rebuild عن أول mount.
- [x] اختبر action update وrefresh وtheme/locale rebuild: لا replay لقسم سبق عرضه، والقسم الذي يظهر لأول مرة يظل له entrance. disableAnimations يعرض الحالة النهائية فورًا، بدون تكرار requests أو تغيير eligibility.

## Task 5 — Remove confirmed hardcodes and correct language presentation

- [x] في plan card احذف TextDirection.rtl المفروضة على layout Rows؛ استخدم الاتجاه الموروث. احتفظ باتجاه LTR المعزول لرقم بطاقة الدفع لأنه محتوى ذو اتجاه معروف.
- [x] تتبع status code وstatusNameAr عبر entity/mapper/DTO. أعد استخدام localization لحالة status المعروفة إذا كانت موجودة. إذا لم يوجد نص مناسب لغير العربية فاذكر المفاتيح/الحقول الناقصة؛ لا تعرض billing_active لكل الحالات ولا تخترع statusNameEn غير موجود.
- [x] لا تستبدل اختيار النص العربي/الإنجليزي بفحص RTL: العربية والفارسية مثلًا اتجاههما واحد ولغتهما مختلفة. التزم بكل locales المهيأة فعليًا وبتنسيق السيرفر المتاح.
- [x] استبدل `height: 130` و`maxHeight: 280` بتوكن موجود يطابق قياسًا معتمدًا فقط، أو sizing طبيعي يثبت أنه يحافظ على التصميم؛ لا تنقل نفس الرقم إلى constant جديدة وتسمي ذلك إزالة للهارد كود. عند غياب دليل القياس سجّلها كعائق بدل اختراع قيمة.
- [x] تتبع home route arguments ومصدر tab definitions قبل استبدال `arguments: 3` بقيمة مسماة. أعد استخدام المصدر الموجود؛ إذا لا يوجد مصدر مسمى أنشئ قيمة واحدة في مالك tabs الحالي وعدّل consumer المباشر فقط، مع بقاء contracts الحالية.
- [x] راجع مصدر `lastDate = firstDate + 365 days`: لا تختزل مدة السماح إلى maximumFreezeDays لأنهما سياستان مختلفتان. استعمل existing scheduling horizon أو قيمة server مؤكدة إن وجدت؛ وإلا اذكر أن سياسة نهاية الحجز غير موثقة ولا تغيّرها تخمينًا.
- [x] قيم animation مثل 280ms وstagger ليست بيانات اشتراك وهمية؛ احتفظ بها كإعدادات animation واضحة. assets الثابتة لرسوم empty state والأيقونات ليست صور backend.
- [x] لا تمسح حقول checkout الفارغة قبل تتبع PaymentWebViewArgs ومستهلكيها؛ لا تملأها ببيانات مصطنعة. سجّل أي حقل إلزامي ناقص كعائق منفصل.

## Task 6 — Validation and handoff

- [x] حدّث الاختبارات التي تستورد owners المنقولين فقط، وأضف regression cases للسلوك الجديد عند الحاجة داخل suites الحالية. لا تكتب اختبارات تعد الملفات أو تفرض عدد سطور أو تطابق implementation.
- [x] شغّل:

```powershell
flutter test test/subscription_billing_freeze_consent_flow_test.dart test/subscription_billing_freeze_notice_contract_test.dart test/subscription_billing_rebuild_isolation_test.dart test/profile_billing_plan_card_test.dart test/profile_billing_empty_state_test.dart test/profile_billing_active_freeze_card_test.dart test/profile_billing_freeze_response_test.dart test/profile_billing_freeze_policy_and_calendar_test.dart test/profile_billing_freeze_details_endpoint_test.dart
flutter analyze
git diff --check
git status --short
```

- [x] format الملفات المعدلة فقط باستخدام dart format مع paths صريحة قبل التحليل النهائي. لا تشغّل code generation إلا لو تغيّر input يتطلبه فعلًا؛ enum وتقسيم widgets لا يحتاجان DI generation عادة.
- [x] اختبر loading، initial failure/retry، no subscription، unfinished subscriptions، empty/nonempty invoices، payment absent/present، active/pending freeze، renew/cancel/delete/resume/payment. استخدم fake repositories؛ لا live mutation.
- [x] راجع العربي والإنجليزي وRTL/LTR والشاشة الضيقة وتكبير النص بعد تغييرات الاتجاه والحجم. سجّل ما اختُبر فعليًا وما لم يمكن التحقق منه.
- [x] قارن git status بالـbaseline. احذف imports/methods/wrappers الزائدة المثبتة فقط، ولا تحذف widgets مستخدمة.
- [x] تحقق باختبارات no internet وtimeout وserver/validation failure أن عرض التحميل الأولي يستخدم ApiErrorWidget وأن أخطاء العمليات تستخدم ErrorMessagePresenter، وأن النص الخام/كود السيرفر لا يتسرب بدل الرسالة المعروضة بواسطة النظام المشترك. اختبر Retry والحفاظ على البيانات السابقة وعدم تكرار snackbar/reset، واحتفظ باختبار overwrite consent قبل الخطأ العام. أعد استخدام fake failures والاختبارات الموجودة؛ سجّل أوامر الاختبارات الإضافية ونتائجها في التقرير.

## Acceptance

- [x] الشاشة لا تحتوي selectors للأقسام ولا error mapping ولا switch لنتائج العمليات ولا navigation للدفع؛ Provider وinitial load فقط.
- [x] Content يركب الهيكل ويربط listener؛ Body يركب sections ويملك root data status؛ لم يتحول أحدهما إلى نسخة جديدة من الملف الضخم.
- [x] enum مستخدم في جميع consumers، مع الحفاظ على API codes.
- [x] لكل Widget ملف مستقل، والأقسام تعيد استخدام الكروت الموجودة.
- [x] لا requests إضافية ولا فقد scroll/state ولا replay animation عند action updates.
- [x] الأخطاء تظل مرئية وقابلة لإعادة المحاولة، وoverwrite consent محفوظ.
- [x] استخدام `lib/core/errors` مثبت في مسار التنفيذ والاختبارات: ApiErrorWidget لفشل التحميل الأولي وErrorMessagePresenter.fromFailure لأخطاء العمليات؛ لا معالجة/ترجمة أخطاء موازية داخل feature. تقرير التسليم يذكر الملفات المشتركة المستخدمة ودليل التحقق، ولا يكتفي بوجود imports.
- [x] لا فرض RTL لصفوف layout ولا status عربي في واجهة إنجليزية بدون mapping موثّق.
- [x] تقرير التسليم يذكر الملفات والتغييرات ونتائج الاختبارات وأي hardcode متبقٍ وسبب تعذر حسمه. لا تقول إن كل شيء انتهى إذا بقيت قيم لا مصدر معتمد لها.

## Prompt for Gemini

اقرأ `design-plans/2026-10-07-subscription-billing-sections-gemini.md` كاملة وقواعد المشروع، ثم نفّذها خطوة بخطوة. قسّم شاشة subscription_billing الكبيرة إلى content وbody وستة sections حسب المسؤولية، وأعد استخدام widgets الموجودة. انقل معالجة نتائج العمليات والأخطاء إلى coordinator ومكونات الحالة الموجودة، واستخدم enum لأسماء العمليات الداخلية. لازم تتأكد أن الأخطاء تستخدم `lib/core/errors` فعلًا: ApiErrorWidget للتحميل الأولي وErrorMessagePresenter.fromFailure لرسائل أخطاء العمليات، بدون mapping مكرر داخل feature، مع الحفاظ على overwrite consent. أثبت الاستخدام بالاختبارات ومسار التنفيذ في التقرير. صحّح اتجاه الصفوف وعرض status حسب اللغة، وأزل الزائد المؤكد. لا تخترع قياسات أو سياسة تواريخ أو بيانات ناقصة، ولا تغيّر التصميم أو API أو صفحات غير مرتبطة، ولا commit أو live mutations. شغّل الاختبارات والتحليل وسلّم تقريرًا واضحًا بالنتائج والعوائق.
