# Payment Success Data Implementation Plan — Gemini

> للمُنفّذ: نفّذ مهمة بمهمة باستخدام executing-plans إن متاحة، وعلّم الإنجاز بعد التحقق. المطلوب تنفيذ إصلاح بيانات شاشة النجاح؛ لا push/merge/deploy ولا تعديل إعدادات Payzah أو حذف/استرداد اشتراكات.

**Goal:** عرض ملخص الاشتراك المؤكد ببياناته الفعلية بعد الدفع، دون صفوف فارغة أو تواريخ وبيانات مخترعة، في المسار العادي والعروض والاستعادة بعد إغلاق التطبيق.

**Architecture:** استكمل ViewModel/State وUseCases/Repositories القائمة. احتفظ باستجابة الاشتراك التي تُستخدم بالفعل للتحقق من Active/Scheduled، ثم جهّز منها نموذج نجاح موحد. لا تنشئ coordinator أو networking client أو polling loop موازية.

**Tech Stack:** Flutter، flutter_bloc، Dio/Retrofit، json_serializable/build_runner، Injectable، intl، ARB/gen-l10n، flutter_test؛ dependencies القائمة فقط.

**Spec:** هذه الخطة مستقلة في شرح إصلاح البيانات، وتلتزم بعقدي `docs/superpowers/plans/2026-10-08-payzah-payments-gemini.md` و`docs/superpowers/plans/2026-10-08-subscription-calendar-gemini.md`. لا تعِد تنفيذ الأجزاء المكتملة فيهما؛ افحص الحالة الفعلية أولًا. الديزاين يحدد الحقول، والقيم الظاهرة فيه أمثلة لا بيانات إنتاج.

## 1. حدود المهمة والمراجعة المؤكدة

- اقرأ AGENTS.md وقواعد UI/backend. الملف البديل الموجود الذي سبق قراءته هو `rules/rules_backend.md` إذا بقي الاسم `rules/backend_rules.md` غير موجود. اتبع تعليمات المالك الفعلية، ولا تنشئ قواعد جديدة أو تتجاهلها.
- لا إعادة تصميم: حافظ على صورة النجاح وlayout/theme/spacing والأزرار الحالية وتعديلات المستخدم. تغييرات العرض مقتصرة على البيانات وتنسيقها وحالات التحميل/نقص البيانات.
- ابدأ بـ`git status --short` ومراجعة diff للملفات المشتركة. توجد تعديلات سابقة لشاشة النجاح وwidgets/assets/app shell؛ لا تستبدلها بكود قديم ولا تضمها تلقائيًا في commit المهمة.
- لا تغيير endpoint contract ولا packages ولا SDK؛ لا تغييرات backend ضمن المهمة.
- مراجعة الكود أثبتت أن PaymentWebViewScreen يبني PaymentSuccessArgs برقم الاشتراك وتاريخ جهاز وبداية فقط، وأن SummaryCard يحول بقية القيم إلى نصوص فارغة.
- PaymentScreen يبني نموذجًا مختلفًا من summary قبل الدفع. النجاح يجب أن يتشارك مصدرًا خادميًا واحدًا بعد التأكيد.
- PaymentViewModel يجلب current subscription أثناء التحقق لكنه لا يحتفظ بتفاصيله لعرض النجاح. يلزم أيضًا التحقق من مطابقة subscriptionId، لا مجرد وجود اشتراك Active آخر.
- PaymentSuccessScreen لديه fallback عند args=null يختلق باقة و30 يومًا وتواريخ من DateTime.now؛ يجب إزالته.
- account الاختبار الذي قُرئ وقت المراجعة لم يكن لديه current/uncompleted subscription. الموديلات تدعم أسماء الباقة والتصنيف والتواريخ وأيام الخدمة، لكن امتلاء حقول الاستجابة الحية لم يُثبت. لا تدّعِ نقص الباك أو كفايته من الموديلات وحدها.
- مصدر تاريخ الدفع الحقيقي لم يُثبت؛ payment/current DTOs التي تمت مراجعتها لا تحتويه. هذا سؤال schema محدد، لا تصريح لاختلاق timestamp.

## 2. مصدر كل حقل وقواعد عرضه

| حقل الشاشة | المصدر المعتمد | التعامل مع الغياب |
|---|---|---|
| الباقة | bundleNameAr/En للاشتراك المؤكد | fallback إلى programNameAr/En لنفس الاشتراك إن كان مناسبًا للعقد، وإلا غير متاح |
| المدة | durationDays إن ثبت أنه مدة الباقة؛ totalServiceDays لأيام الخدمة بمعناها الصريح | لا مساواة بينهما ولا صفر افتراضي، ولا end-start لحساب المدة |
| تصنيف المطاعم | tierNameAr/En للاشتراك المؤكد، أو ترجمة tier المعروفة | لا تعرض enum/raw tier رقمًا غير مفهوم أو قيمة من الديزاين |
| تاريخ الدفع | timestamp دفع مؤكد من endpoint موثّق لنفس العملية/الاشتراك | غير متاح مؤقتًا + تدوين المطلوب من الباك، دون DateTime.now |
| بداية الاشتراك | Subscription.StartDate من الخادم | لا chosenStartDate ولا request anchor ولا local offset |
| نهاية الاشتراك | Subscription.EndDate من الخادم | لا إضافة durationDays ولا dates من الديزاين |

- احتفظ بالأسماء العربية والإنجليزية في النموذج؛ اختيار النص والتنسيق في presentation بحسب locale الحالية، فلا تتجمد اللغة لحظة إنشاء args.
- date-only بصيغة yyyy-MM-dd لا يُحوّل timezone بما يغير اليوم. timestamp الدفع يحتفظ بالـUTC ويتنسق وفق سياسة timezone المعتمدة في المشروع؛ لا تفترض Cairo/Kuwait/توقيت الهاتف دون دليل.
- نص «مع يوم الجمعة» لا يظهر إلا من includeFriday مثبت لنفس الاشتراك. عدد الأيام لا يستنتج منه includeFriday. إن لم يُعد الخادم المعلومة في recovery، لا تخترعها.
- كل fallback وصفي من summary قبل الدفع يجب أن يحمل نفس context/معرّف العملية، وألا يطغى على بيانات الخادم. التواريخ النهائية وحالة التفعيل لا تُؤخذ من summary القديم.
- null/empty/whitespace/invalid date يعامل كغياب. الحقل الناقص يعرض قيمة مترجمة «غير متاح حاليًا» بدل صف فاضي. غياب معلومات وصفية لا يحوّل اشتراكًا Active مثبتًا إلى فشل دفع.

## 3. Task 0 — تثبيت schema وbaseline

**Read:** payment DTOs/Mapper/Entity/Args/State/ViewModel، شاشتا payment وWebView والنجاح والعروض، current subscription DTO/entity/mapper، coordinator/routing، اختبارات النجاح والدفع، ملفات l10n وformatters الحالية.

- [ ] اقرأ قواعد المشروع وخطتي Payzah والتقويم والحالة الحالية للملفات.
- [ ] شغّل baseline analyzer واختبارات النجاح والدفع، وسجّل الفشل السابق دون محاولة إصلاح غير مرتبط.
- [ ] افحص Swagger المنشور للـcurrent/payment وأي endpoint تفاصيل موثّق يعرض اشتراكًا بالـID. تحقق من required/nullable/casing/wrapper.
- [ ] اقرأ اشتراك اختبار متاح ومصرح به إن وجد، ونقّح أي دليل محفوظ. لا تنشئ checkout مرارًا لاكتشاف schema، ولا تستخدم حسابات حقيقية.
- [ ] أثبت: اسم حقل تاريخ الدفع ومعناه، durationDays مقابل totalServiceDays، includeFriday، وكيفية الحصول على تفاصيل subscriptionId بعينه.
- [ ] إذا timestamp الدفع غير موجود، لا تضف guessed paidAt/createdAt aliases ولا تستخدم ConfirmedAtUtc ليوم التقويم أو createdAtUtc للاشتراك. سلّم طلبًا دقيقًا للباك: إتاحة timestamp الدفع المؤكد لنفس الاشتراك/العملية في endpoint موثق. نفّذ بقية الإصلاح مع قيمة غير متاحة.

**المخرج:** أسماء الحقول/المسارات المثبتة وحدود ما لم يثبت؛ لا تتطلب هذه المهمة أسرار Payzah.

## 4. Task 1 — نموذج موحّد لبيانات النجاح

**Modify:** `lib/features/payment/domain/entities/payment_success_args.dart`، State/args الضرورية، وقائمة imports والمستهلكين بعد البحث.
**Create if needed:** `lib/features/payment/presentation/helpers/payment_success_summary_mapper.dart` لتحويل Domain Entities إلى نموذج الشاشة دون BuildContext أو DTO؛ أو أعد استخدام helper قائم يؤدي نفس الدور.
**Test:** `test/payment_success_summary_mapper_test.dart`.

واجهة مقترحة قابلة للضبط حسب conventions المشروع:

```text
PaymentSuccessArgs:
  subscriptionId: String
  verifiedSubscriptionStatus: String?
  packageNameAr/packageNameEn: String?
  programNameAr/programNameEn: String?
  restaurantTierAr/restaurantTierEn: String?
  tierCode: String?
  planDurationDays: int?
  serviceDays: int?
  includeFriday: bool?
  paidAtUtc: DateTime?  // لا يُملأ إلا من الحقل المثبت في Task 0
  startDate/endDate: String?  // server date-only
```

هذه أسماء داخلية وليست أسماء JSON جديدة. إن احتجت إبقاء الحقول القديمة مؤقتًا لتوافق مستهلك آخر، لا تجعلها المصدر الأساسي ولا توسع النطاق لتغيير شاشاته.

- [ ] اختبار أحمر يحوّل current subscription صناعي إلى كل الحقول مع حفظ null دون صفر/تاريخ جهاز.
- [ ] اختبار اختلاف الاسم العربي/الإنجليزي، tier name غائب، ومدة باقة مختلفة عن serviceDays.
- [ ] نفّذ mapper مرة واحدة من استجابة الاشتراك المؤكد؛ لا formatting/locale resolution في domain أو data mapper.
- [ ] add copyWith/equality/state reset الصحيح، دون تحويل empty إلى قيمة تبدو مكتملة.
- [ ] حدّث fakes/fixtures والمستهلكين اللازمة، وشغّل الاختبارات.

## 5. Task 2 — الاحتفاظ بتفاصيل الاشتراك أثناء تأكيد الدفع

**Modify:** `lib/features/payment/presentation/manager/payment_view_model.dart` و`payment_state.dart` و`payment_event.dart` عند الحاجة.
**Tests:** `test/payment_success_data_flow_test.dart` وtests fulfillment الموجودة؛ افحص ما تختبره الأخيرة فعلًا قبل الاعتماد عليها.

- [ ] قبل emit success، تحقق من استجابة حالة الاشتراك: ID يساوي subscriptionId المطلوب وحالة Scheduled/Active، مع دفع موثوق وفق عقد Payzah.
- [ ] اختبار أحمر: payment A مدفوع، current يعود باشتراك B Active؛ المتوقع عدم نجاح A وعدم عرض بيانات B. current=null أو Pending أو Paid فقط لا يفعّل واجهة النجاح النهائي.
- [ ] خزّن `confirmedSubscription` أو `successSummary` في نفس emit الذي يعلن النجاح. لا bool نجاح يصل قبل البيانات فيفتح الشاشة بنموذج ناقص.
- [ ] استفد من current response الموجودة؛ لا تطلب current مرتين لأجل cache ثم presentation. حدّث cache من الاستجابة المتحققة نفسها إن أمكن، دون تغيير سياسة التخزين العامة.
- [ ] عند mismatch/current لا يمثل الهدف: استخدم endpoint تفاصيل بالـID فقط إن كان موثقًا وقائمًا. إن لا يوجد مصدر مناسب، اعرض تعذر التحقق من الاشتراك المحدد، ولا تستخدم B ولا تخترع endpoint.
- [ ] generation/session checks بعد كل await؛ response قديم لا يكتب cache أو بيانات نجاح لحساب/عملية أحدث.
- [ ] نقص package/tier/endDate بعد Active: ملخص جزئي مع قيمة غير متاحة وفحص تفاصيل GET محدود إن متاح؛ لا POST ولا اختلاق بيانات.
- [ ] لا تغير polling/review lock/no-replay لخطة Payzah؛ لا تجعل calendar 200 أو قائمة أيام دليل تفعيل.

## 6. Task 3 — توحيد navigation في جميع مسارات النجاح

**Modify:** `payment_screen.dart`، `payment_web_view_screen.dart`، `payment_args.dart` عند الحاجة، `promo_applied_checkout_screen.dart`، `activation_success_screen.dart`/args بالقدر اللازم، وrouting/coordinator إن ثبت حاجة.
**Tests:** `test/payment_success_navigation_test.dart`، واستكمل اختبارات recovery القائمة.

- [ ] كلا listener في PaymentScreen وPaymentWebViewScreen يستخدمان نفس `state.successSummary` الناتج بعد التحقق. احذف بناء نموذج النجاح بتواريخ جهاز/checkout ناقص.
- [ ] تمرير summary الاختيار للـWebView اختياري لو احتجته لوصف الباقة؛ ليس بديلًا عن جلب التفاصيل في recovery. لا تعتمد على الشاشة السابقة أو instance الذي تم dispose.
- [ ] افحص مسار PromoAppliedCheckout الحالي: يثبت paymentMethodId=1، ويفتح activationSuccess عند paymentUrl فارغ، وينتظر bool من WebView بينما WebView يفتح paymentSuccess مباشرة. أصلح الجزء اللازم لهذا المسار عبر abstraction الدفع القائمة، مع ID من payment-methods والتحقق الخادمي. لا تختلق سياق عرض أو GUIDs افتراضية.
- [ ] اختر owner واحدًا للانتقال: شاشة حالة الدفع تفتح شاشة النجاح المناسبة من نتيجة موثقة؛ لا bool pop ثم route آخر بالتوازي. payload موفق يحدد presentation العروض فقط، لا حقيقة الدفع.
- [ ] احتفظ بتميز تصميم activationSuccess للعروض إن كان مقصودًا؛ لا تدمج الشاشتين بصريًا. تفاصيل الاشتراك الأساسية والحالة من مصدر مشترك، ومعلومات البرومو والشروط من offer context الصحيح.
- [ ] checkout URL فارغ ليس نجاحًا؛ تحقق الحالة. بيانات الاختيار ناقصة تمنع إنشاء طلب مزيف وتعرض استكمال المعلومات.
- [ ] cold start/deep link بدون summary: استعادة ID وفق النظام القائم ثم نفس verification/summary builder. لا حاجة لتخزين كل ملخص الاختيار أو paymentUrl محليًا.
- [ ] terminal return مكرر: اعرض الحالة/التفاصيل دون route نجاح احتفالي مكرر أو POST. لا lastPresentedFinalStatus محليًا كدليل دفع.

## 7. Task 4 — عرض البيانات والتواريخ دون fallback مخترع

**Modify:** `payment_success_screen.dart`، `subscription_success_summary_card.dart`، `subscription_success_summary_item_row.dart` عند الحاجة، widgets الأزرار، translation ARBs.
**Test:** `test/payment_success_screen_test.dart` و`test/payment_success_localization_test.dart`.

- [ ] احذف fallback args=null الذي يصنع باقة و30 يومًا وتواريخ الغد/31 يومًا. invalid/missing subscriptionId يفتح حالة بيانات غير صالحة مع طريق آمن للعودة/الاشتراكات، لا بانر «تم التفعيل».
- [ ] بيانات سليمة: اعرض الستة حقول من النموذج. غياب حقل وصفي يعرض «غير متاح حاليًا» مترجمة، لا `''`، ولا رقم 0 يفسر كمدة حقيقية.
- [ ] فرق loading details عن network failure عن partial result. retry يعيد GET فقط، مع الحفاظ على التفعيل المثبت ما دام لا يوجد اختلاف حالة خادمي.
- [ ] استخدم intl/formatter القائم لتنسيق تاريخ الشهر النصي بالعربي والإنجليزي؛ لا عرض ISO خام افتراضيًا. احتفظ date-only بنفس اليوم.
- [ ] labels واضحة للمدة: لا تسم serviceDays «مدة الباقة» إذا معنى schema مختلف. اعرض المعلومة الموثقة؛ لا تضف نص الجمعة إن مجهول.
- [ ] تغيير اللغة ar/en/ar يغير الأسماء والتواريخ والرسائل دون restart أو إعادة دفع. لا cache لنصوص مترجمة في ViewModel.
- [ ] أزرار التقويم/عرض الاشتراك تستخدم ID الهدف. unknown ID لا يسقط إلى تقويم اشتراك آخر بصمت. تجهيز التقويم يتبع الخطة القائمة.
- [ ] احتفظ بتغييرات التصميم الحالية؛ لا تعديل صورة/header/ألوان/مسافات إلا ما يلزم منع overflow للبيانات الحقيقية وفق tokens القائمة. لا تنقل الصورة المرجعية أو النصوص المثال إلى source.
- [ ] اختبر أسماء طويلة وtext scale وRTL/LTR، دون صفوف مفقودة أو overflow.

## 8. اختبارات سلوك القبول المطلوبة

| السيناريو | المتوقع |
|---|---|
| نجاح من WebView مع اشتراك كامل | الباقة والمدة والتصنيف والبداية والنهاية ظاهرة من الاشتراك المطابق |
| summary قديم وSubscription.StartDate مختلف | عرض بداية الخادم؛ request anchor لا يتغير |
| تاريخ دفع قديم ثم فتح الشاشة اليوم | عرض timestamp الخادم القديم، لا اليوم |
| paidAt غير متاح | رسالة غياب مترجمة، لا تاريخ مخترع |
| totalServiceDays يختلف عن مدة الباقة | لا خلط بين القيم/labels |
| includeFriday غير متاح | لا نص «مع يوم الجمعة» افتراضي |
| current ID مختلف | لا نجاح ولا بيانات اشتراك آخر |
| current status Paid فقط | تم الدفع والتنفيذ جارٍ؛ لا تفعيل نهائي |
| args=null/ID فارغ | لا بيانات مثال ولا تفعيل زائف |
| recovery بدون شاشة الاختيار | جلب بيانات الهدف وعرض نفس الملخص |
| نجاح عرض برومو | تحقق خادمي واحد ثم شاشة مناسبة واحدة |
| checkout paymentUrl فارغ | تحقق، لا activationSuccess مباشرة |
| رابط قديم/مكرر | لا POST ولا تكرار الاحتفال |
| logout/switch account أثناء GET | تجاهل الرد القديم ومسح بيانات العرض السابقة |
| بيانات وصفية ناقصة وActive مثبت | نجاح موثوق وملخص جزئي واضح، لا crash |
| GET timeout/5xx | فحص/تحميل تفاصيل يدوي، لا checkout تلقائي |

مثال اختبار حاسم داخل fake flow بعد إعداد fixture من الـbuilders القائمة:

```dart
// payment endpoint: isPaid=true للعملية sub-A.
// current endpoint: subscriptionId=sub-B, status=Active.
// Trigger VerifyPaymentFulfillmentEvent('sub-A').
expect(viewModel.state.isFulfillmentSuccess, isFalse);
// assert no success navigation; no checkout POST was sent.
```

نفس fake يعيد sub-A/Scheduled مع كل بيانات الملخص في اختبار ثانٍ؛ المتوقع successSummary يحمل sub-A والحقول نفسها، وnavigation مرة واحدة. استخدم fake time بدل انتظار polling الحقيقي.

## 9. الأمان وحدود البيانات

- تحقق مالك الجلسة وID المطابق قبل حفظ/عرض التفاصيل؛ request بالـID يخضع لتفويض الباك. لا اختيار اشتراك عشوائي لحل نقص البيانات.
- deep link وlocal flags وأسماء الباقات لا تثبت الدفع. لا success route بناءً على URI فقط؛ حتى route مباشرة بـargs مصطنعة لا تبدأ أي تفعيل خادمي.
- refresh details لا يعيد checkout ولا يغيّر عنوان/تاريخ/اشتراك. لا DELETE/refund لتجهيز fixture.
- لا card/CVV/OTP/JWT/paymentUrl أو استجابات شخصية خام في tests/logs/screenshots/commits. العينات مصطنعة، والدليل الحي منقح.
- لا claims أن Flutter يضمن سلامة الالتقاط أو authorization وحده؛ التحقق النهائي خادمي.

## 10. التحقق والتسليم

نفّذ generation فقط إن تغيّرت DTO/DI، وgen-l10n إن تغيّرت ARB. format الملفات المعدّلة فقط. لا تعدّل generated باليد.

```powershell
flutter analyze
flutter test test/payment_success_summary_mapper_test.dart
flutter test test/payment_success_data_flow_test.dart
flutter test test/payment_success_navigation_test.dart
flutter test test/payment_success_screen_test.dart
flutter test test/payment_success_localization_test.dart
flutter test test/payment_return_recovery_test.dart
flutter test test/core/payment
flutter test
git diff --check
git status --short
rg -n 'DateTime.now|Duration\(days:|PaymentSuccessArgs\(' lib/features/payment
```

راجع نتائج البحث واحدة واحدة؛ التاريخ في correlation/logging ليس بالضرورة تاريخ دفع خاطئ. لا استبدال عشوائي لكل DateTime.now.

- [ ] اختبارات حمراء ثم خضراء للسلوك المتغير، analyzer وtests/build للمنصة المتاحة، ومقارنة baseline.
- [ ] تجربة Sandbox بحساب مصرح له عند توفر اشتراك فعلي: نجاح WebView ثم screenshot للستة حقول وقيمها مقارنة باستجابة نفس ID، بدون معلومات حساسة.
- [ ] إعادة فتح التطبيق/رابط قديم وتجربة تبديل اللغة. لا بيانات مثال ولا إعادة POST.
- [ ] إن الحساب بلا اشتراك ولا توجد بيانات اختبار مناسبة، نفّذ الاختبارات المحلية وحدد live test كـNOT RUN، ولا تدّعِ اكتمال التحقق الحي.

**التسليم النهائي:** الملفات والتغييرات؛ مصدر كل حقل واسم JSON المثبت؛ نتائج الأوامر الفعلية؛ جدول PASS/FAIL/NOT RUN محلي مقابل حي؛ أي حقل غير متاح ورسالة محددة للباك بشأنه؛ تأكيد الحفاظ على التصميم وتغييرات المستخدم وعدم تغيير عقود الدفع أو anchor أو إعادة checkout.
