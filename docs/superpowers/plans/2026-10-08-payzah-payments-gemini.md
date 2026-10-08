# خطة تنفيذ Payzah في Flutter — تسليم إلى Gemini

> للمُنفّذ: نفّذ المهام بالترتيب باستخدام executing-plans إن كانت المهارة متاحة. هذه خطة تنفيذ مطلوبة من المستخدم؛ لا تبدأ معمارية جديدة ولا تغيّر عقود الخادم. علّم مربعات الإنجاز بعد التحقق الفعلي فقط.

**الهدف:** استبدال مسار الدفع القديم بمسار Payzah المستضاف، والتحقق الخادمي بعد العودة، والاستعادة الآمنة بعد إغلاق التطبيق، مع منع تكرار الدفع أو إظهار نجاح غير موثوق.

**المعمارية:** حافظ على UI → Event → ViewModel → UseCase → Repository → RemoteDataSource → ApiServices. استخدم WebView الموجود؛ أضف داخل البنية الحالية إدارة صغيرة لمحاولة الدفع المحفوظة واستقبال روابط العودة. لا تتصل بواجهات Payzah مباشرة من Flutter.

**التقنيات الموجودة:** Flutter، flutter_bloc، Dio/Retrofit، GetIt/Injectable، json_serializable، webview_flutter، flutter_secure_storage، shared_preferences.

**المواصفة:** الطلب الأصلي وتكملته هما المرجع. الخلاصة الملزمة أدناه كافية لفهم نطاق الموبايل؛ نسخة العقد الخاصة موجودة في رسالة المستخدم، ورابط GitHub الخاص قد يعيد 404. بيانات الحساب والبطاقة وOTP تؤخذ من رسالة المستخدم وقت الاختبار، ولا تُنسخ إلى المستودع أو هذا الملف.

## 1. العقد الذي يجب الحفاظ عليه

- API المنشور: `https://maelmate.runasp.net`.
- `GET /api/v1/customer/subscription-flow/payment-methods?amount=<amount>` عند كل دخول لشاشة الطرق، بدون قائمة ثابتة أو كاش طرق.
- الطريقة النشطة `code=PAYZAH` و`integrationType=PAYZAH_HOSTED`. رقمها الحالي 3، لكن الطلب يستخدم `paymentMethodId` القادم من الاستجابة، ولا يستنتجه من code ولا يثبّته في الكود.
- الطريقة `MEALMATE_WALLET` قد تعود بـ`paymentMethodId=null` و`isAvailable=false` و`unavailableReason=wallet_not_implemented`: تظهر معطّلة مع سببها.
- `serviceCharge` و`totalAmount` قد يكونان null. لا تحولهما إلى صفر، ولا تعرض إجماليًا شامل الرسوم إن لم يكن معلومًا. السعر الموجود في ملخص الاشتراك يمكن عرضه بوصفه سعر الاشتراك.
- `POST /api/v1/customer/subscriptions/checkout` بنفس العقد الموجود؛ افتح `paymentUrl` في WebView كامل. اختيار KNET والبطاقة داخل Payzah فقط.
- رقم المزوّد `PaymentID` مختلف عن معرّف التطبيق `pz-<TrackId>`. خزّن واستخدم معرّف التطبيق للربط؛ لا تستخرجه من URL ولا تختلق تحويلًا بينهما.
- مسارات العودة الأربعة: `mealmate://checkout/success?paymentId=pz-...`، و`error`، و`pending`، و`review`.
- كل عودة تستدعي `GET /api/v1/customer/subscriptions/{subscriptionId}/payment` وواجهات حالة الاشتراك القائمة. هذا GET قد يزامن الحالة من Payzah خادميًا؛ لا تحاول تنفيذ المزامنة بنفسك.
- النجاح يتطلب تحقق الدفع وقبول المعالجة خادميًا. `Paid` يعني الدفع موثق والتنفيذ جارٍ؛ `Scheduled/Active` يعني الاشتراك منفّذ وفعّال. لا تعرض التفعيل النهائي بناءً على رابط النجاح أو `isPaid` وحده.
- `PendingPayment`: غير محسوم، اعرض جاري التحقق. `PaymentFailed`: فشل نهائي من الخادم، محاولة جديدة يبدأها المستخدم. `SuspendedForReview`: تحت مراجعة التاجر، امنع دفعًا جديدًا حتى تتضح العملية.
- `checkout.existing_subscription`/409 يوجّه إلى الاشتراك القائم. اعرض رسائل `checkout.address_required` و`checkout.allergies_required` و`checkout.dietary_preferences_required` و`payment.gateway_unavailable` كما يعيدها الخادم.
- لا إعادة تلقائية لـcheckout، سواء بعد فشل بوابة أو timeout أو رجوع التطبيق أو تجديد التوكن. الاستعلام عن الحالة فقط قابل للتكرار المحدود.
- الباك مسؤول عن مفاتيح Payzah، البيئات، الربط، المبلغ والعملة، الالتقاط والاسترجاع. endpoints الأدمن وwebhook وget-payment-details ليست endpoints يستدعيها التطبيق.
- sandbox في الباك الحقيقي يختلف عن طريقة الإكمال التجريبية القديمة `-1/SANDBOX`: احذف الأخيرة من مسار الدفع، ولا تمنع اختبار Payzah الصحيح.

## 2. قواعد المشروع وحدود العمل

- اقرأ `AGENTS.md` و`rules/ui_rules.md` و`rules/backend_rules.md`. لو الأخير غير موجود، الملف الموجود حاليًا هو `rules/rules_backend.md`؛ اقرأه وسجّل اختلاف الاسم.
- اقرأ DESIGN.md إن وجد. حافظ على الشكل الحالي، theme وspacing وstyles والترجمة؛ أضف مفاتيح الحالات اللازمة لكل locales المفعلة.
- لا تضف dependency جديدة دون إذن المستخدم. webview_flutter وflutter_secure_storage موجودان. افحص استقبال الروابط الحالي قبل اختيار آلية Flutter أو platform channels؛ لو احتجت package جديدة اشرح الحاجة الدقيقة.
- `git status --short` أولًا. توجد تغييرات مسبقة تخص calling وrouting وtheme/localization وpubspec؛ لا تمسحها، ولا تعمل reset/stash شاملًا ولا تضمها في commit الدفع. راجع diff لكل ملف مشترك.
- نطاق التنفيذ الأساسي هو checkout الاشتراك الحالي. افحص مستهلكي widget الدفع المشتركة، خصوصًا family/upgrade، لتجنب كسرهم. لا تغيّر عقودهم ولا تلغي أي مسار مجاني شرعي مستقل عن طريقة SANDBOX القديمة.
- لا تعدّل الباك ولا إعدادات التاجر ولا مفاتيح البيئة. حساب الاختبار ليس حساب أدمن ولا يلزم استخدام صلاحيات أدمن.

## 3. خريطة الملفات والعيوب المعروفة

ملفات القراءة والتعديل الأساسية:

- `lib/features/payment/data/models/response/payment_method_response_dto.dart`
- `lib/features/payment/data/models/response/payment_checkout_response_dto.dart`
- `lib/features/payment/data/models/response/payment_status_response_dto.dart`
- `lib/features/payment/data/mapper/payment_mapper.dart`
- `lib/features/payment/domain/entities/payment_entity.dart`
- `lib/features/payment/domain/entities/payment_args.dart`
- `lib/features/payment/presentation/manager/payment_view_model.dart`
- `lib/features/payment/presentation/manager/payment_state.dart`
- `lib/features/payment/presentation/manager/payment_event.dart`
- `lib/features/payment/presentation/screens/payment_screen.dart`
- `lib/features/payment/presentation/screens/payment_web_view_screen.dart`
- `lib/features/payment/presentation/widgets/payment_method_selector.dart`
- `lib/features/payment/presentation/widgets/payment_method_tile.dart`
- `lib/features/payment/presentation/widgets/payment_method_logo.dart`
- `lib/features/payment/presentation/widgets/payment_unresolved_status_view.dart`
- `lib/core/payment/payment_return.dart`
- `lib/core/payment/payment_navigation.dart`
- `lib/core/widget/payment_redirect_web_view.dart`
- `lib/core/network/api_services.dart` وملفات endpoints وinterceptors القائمة عند الضرورة فقط.
- `lib/core/services/token_interceptor.dart` و`lib/core/network/external_modules.dart` لمراجعة replay والـlogging.
- `lib/features/subscription_settings/` لإعادة استخدام current/uncompleted subscriptions والـUseCases القائمة.
- `lib/main.dart` و`lib/config/routing/` و`lib/core/di/` لتركيب استقبال العودة بعد تهيئة auth/navigation.
- `android/app/src/main/AndroidManifest.xml` و`ios/Runner/Info.plist`؛ ملفات MainActivity/SceneDelegate عند الحاجة.
- `lib/core/l10n/app_ar.arb` و`app_en.arb` وما يقابلهما من locales موجودة.

عيوب تأكدت بالمراجعة وتحتاج إصلاحًا:

1. `_load` يخفي unavailable/wallet بدل عرضها معطّلة.
2. Mapper يصنّف Payzah بالرقم 3 ويحتفظ بـsandbox والمعرّفات السالبة.
3. PaymentWebViewScreen ينشئ PaymentViewModel جديدًا دون تهيئة checkout؛ `HandlePaymentReturnEvent` لا يجد subscriptionId في state، فتتعطل verification على success/pending.
4. error return يضع فشلًا محليًا مباشرة، بدل قراءة الخادم.
5. review lock داخل ViewModel فقط، ويضيع بفتح شاشة جديدة؛ ولا يُزال على أساس حالة خادم محسومة بشكل واضح.
6. parsePaymentReturn يدعم الأربع مسارات، لكن تسجيل scheme في Android/iOS غير موجود في الملفات المفحوصة.
7. confirmation الحالي مبني على isPaid؛ يجب فصل دفع موثق عن اشتراك فعّال.
8. DTOs لا تحمل unavailableReason/integrationType/nullable fees ولا معرّف المحاولة التطبيقي؛ الاسم JSON الفعلي للأخير لم يُثبت بعد.
9. Presenter العام قد يفضل الرسالة المحلية على رسالة الخادم؛ لا تغيّر سلوك التطبيق كله لتلبية دفع فقط.

## 4. Task 1 — تثبيت أشكال الاستجابات قبل أي تخمين

- [ ] شغّل الفحص المحلي واقرأ ملفات الدفع والاختبارات. التزم بالقواعد السابقة.
- [ ] من حساب الاختبار، اقرأ payment-methods وcurrent/uncompleted subscriptions بالـAPI الموجود. افحص OpenAPI/Swagger إن كان متاحًا ومصرحًا به.
- [ ] أثبت أسماء وأنواع: subscriptionId، معرّف `pz-` في checkout، حالة payment endpoint، وحالة الاشتراك في current/list. لا تخلط provider PaymentID بمعرّف التطبيق.
- [ ] لا تنشئ checkout للاكتشاف مرارًا. إن احتجت أول checkout لمعرفة schema، أنشئ محاولة اختبار واحدة وسجّلها مؤقتًا واستكملها/استعد حالتها بدل إنشاء ثانية.
- [ ] لو checkout لا يعيد `pz-` أصلًا، أو قائمة الاشتراكات لا تسمح باستعادة المرشح، سجّل تعارضًا محددًا مع العقد واطلب توضيحًا من الباك. نفّذ المهام المستقلة؛ لا تختلق اسم حقل/endpoint ولا تستخرج المعرّف من paymentUrl.
- [ ] احفظ fixtures صناعية بنفس schema للاختبارات، بعد إزالة بيانات الحساب والتوكن والروابط الفعلية. لا تحفظ الاستجابات الشخصية الخام.

**ناتج المهمة:** schema موثق في ملاحظات التنفيذ، والـendpoints الموجودة التي سيعتمد عليها recovery، بدون أسرار.

## 5. Task 2 — DTOs وطرق الدفع الديناميكية

**الملفات:** DTO/Entity/Mapper/selector/tile/logo/ViewModel و`test/payment_payzah_mapper_test.dart` واختبار شاشة جديد `test/payment_methods_refresh_test.dart`.

- [ ] أضف حقول code وintegrationType وunavailableReason والرسوم nullable والعملة، واحتفظ بـpaymentMethodId nullable في المجال عندما يعبّر null عن طريقة لا يمكن الدفع بها.
- [ ] أضف معرّف المحاولة إلى checkout DTO/Entity وفق الاسم المثبت في Task 1؛ لا aliases تخمينية. أعد توليد g.dart بالـbuild_runner، ولا تعدّله يدويًا.
- [ ] الاختيار صالح فقط إن كانت الطريقة موجودة في أحدث استجابة، available، ومعرّفها صالح لمسار الدفع الحقيقي. لا يحوّل التطبيق طريقة ناقصة البيانات إلى PAYZAH افتراضي.
- [ ] اعرض كل الطرق المعادة بالاسم/الوصف المناسبين للغة من السيرفر، مع fallback ترجمة قائم إن غاب الاسم. عطّل النقر وradio وCTA للطريقة unavailable، واعرض سببها. لا تستنتج اتجاه الواجهة من اللغة.
- [ ] عند كل فتح route جديد، امسح الاختيار والقائمة القديمة أثناء التحميل واطلب endpoint. عند رجوع شاشة الطرق من WebView أعد التحميل عبر lifecycle/route observer القائم. rebuild وحده لا يرسل طلبًا جديدًا.
- [ ] لا تُظهر بيانات قديمة كخيارات صالحة إذا فشل التحميل. تجاهل استجابة تحميل أقدم باستخدام generation الحالي.
- [ ] صنّف hosted Payzah من code/integrationType، دون شرط `id==3`. إرسال checkout يستخدم المعرّف المعاد حرفيًا. احتفظ بضبط الطلب في ViewModel، وليس تعطيل الزر وحده.
- [ ] لا تعرض رسوم null كصفر أو نص مجاني، ولا تجمع عليها. اجعل labels تميز سعر الاشتراك عن إجمالي رسوم البوابة غير المعروف.

اختبار خالص مقترح للـMapper بعد إضافة الحقول:

```dart
test('hosted checkout uses the returned id and keeps unknown fees null', () {
  final method = PaymentMethodResponseDto.fromJson({
    'paymentMethodId': 7,
    'code': 'PAYZAH',
    'integrationType': 'PAYZAH_HOSTED',
    'isAvailable': true,
    'nameEn': 'Payzah hosted checkout',
    'serviceCharge': null,
    'totalAmount': null,
    'currencyCode': 'KWD',
  }).toEntity();
  expect(method.id, 7);
  expect(method.type, PaymentMethodType.payzah);
  expect(method.serviceCharge, isNull);
  expect(method.totalAmount, isNull);
});
```

اختبر أن wallet null id يظهر معطّلًا، وأن محاولة Select/Checkout عليه لا تصل إلى repository؛ وأن فتح الشاشة مرتين يرسل طلبين ويستبدل الاختيار القديم، وأن rebuild لا يضيف طلبًا ثالثًا.

## 6. Task 3 — حفظ المحاولة وربطها بالحساب قبل فتح البوابة

**ملفات جديدة ضمن core/payment إذا لا يوجد بديل قائم:** `payment_attempt.dart` و`payment_attempt_store.dart`. استخدم تخزين الأمان القائم وDI الحالي، ولا تنشئ نظام تخزين/شبكة مستقلًا.

سجل محلي واحد لكل محاولة يتضمن:

```text
schemaVersion
ownerCustomerId  // معرف المستخدم الموثوق من جلسة auth، ليس من deep link
subscriptionId  // من checkout response
paymentId       // معرّف التطبيق pz- من checkout response
createdAtUtc
reviewRequired  // حظر محافظ؛ ليس إثبات دفع
lastPresentedFinalStatus // للمساعدة على منع تكرار عرض التأكيد
```

**الواجهة الداخلية المقترحة:** `readForCustomer(String customerId)`، `save(PaymentAttempt attempt)`، `removeForCustomer(String customerId)`؛ جميعها async. استخدم types/timestamps واضحة وأضف serialization دفاعي مع version handling. لا تحفظ paymentUrl أو بطاقة أو CVV أو JWT في هذا السجل.

- [ ] اكتب اختبارات roundtrip/corrupt record/wrong customer/logout.
- [ ] بعد نجاح POST، تحقّق من subscriptionId وpaymentId والرابط، ثم انتظر اكتمال حفظ السجل قبل navigation.
- [ ] لو فشل الحفظ: لا تفتح البوابة ولا ترسل checkout ثانيًا. أخبر المستخدم أن الاستعادة تعذر تجهيزها، مع فحص الاشتراك القائم من الخادم.
- [ ] init شاشة WebView يهيّئ الـViewModel بـcheckout/current attempt قبل callback؛ إما event تهيئة صريح أو إعادة استخدام instance بالطريقة القائمة، مع ownership/dispose صحيحين. لا تعتمد على state فارغ ولا lifetime شاشة الدفع السابقة.
- [ ] عند logout/account switch ألغِ polling/requests منطقيًا وامسح بيانات المحاولة القديمة. auth generation يمنع وصول نتيجة الحساب السابق إلى واجهة الحساب الجديد.
- [ ] local reviewRequired يمنع checkout مؤقتًا حتى إعادة قراءة حالة الاشتراك من الخادم. التلاعب بالتخزين لا يمنح نجاحًا ولا يغيّر مالك الطلب؛ التفويض النهائي للخادم.
- [ ] الاحتفاظ بسجل terminal لإزالة التكرار لا يحظر checkout جديدًا للأبد. أزل حظر الدفع بناءً على الحالة الحالية/قواعد الاشتراك من الخادم، وليس expiry محليًا أو مجرد error link.

## 7. Task 4 — آلة الحالات والتحقق الخادمي لجميع العودة

**الملفات:** payment_view_model/state/event، WebViewScreen، unresolved view، success screen عند الحاجة، وUseCases حالة الاشتراك القائمة. أضف adapter داخلي لتصنيف الحالات إن لم يوجد؛ لا DTO في UI.

استبدل القرارات المتعارضة من booleans بحالة واضحة أو getters متسقة ضمن State الحالية، دون إعادة كتابة معماريتها. الحالات الداخلية المقترحة:

```text
ready -> submitting -> awaitingGateway -> verifying
verifying -> pending | paidProcessing | active | failed | review | statusUnavailable
```

| نتيجة الخادم | عرض التطبيق | checkout جديد |
|---|---|---|
| PendingPayment | جاري التحقق + فحص الحالة | لا تبدأ محاولة موازية ما دامت العملية غير محسومة |
| Paid | تم الدفع، جارٍ تجهيز الاشتراك | ممنوع لهذه العملية |
| Scheduled / Active | الاشتراك مؤكد وموعده/حالته من الخادم | يخضع لقواعد الاشتراك القائم |
| PaymentFailed | فشل/إلغاء مؤكد ورسالة الخادم | فقط بمبادرة المستخدم وبعد تحقق عدم وجود review/اشتراك يمنعه |
| SuspendedForReview | تحت المراجعة + فحص الحالة/الاشتراك | ممنوع |
| null/unknown/timeout/5xx | تعذّر التحقق الآن، حالة غير محسومة | لا إعادة تلقائية ولا تأكيد نجاح |

- [ ] `HandlePaymentReturnEvent` لا يعتبر destination دليلًا على الدفع؛ الأربعة تؤدي إلى resolver ثم GET payment وحالة الاشتراك.
- [ ] معرّف subscription للمحاولة يأتي من السجل المطابق للحساب/paymentId، وليس parameter يضيفه مهاجم إلى URI.
- [ ] link review يشغّل حظرًا محافظًا قبل GET؛ لا يثبت وجود التقاط. link error لا يمسح حظرًا ولا يُظهر فشلًا نهائيًا قبل الخادم.
- [ ] بعد payment.isPaid=true، اقرأ حالة الاشتراك. لا تعرض Active بناءً على isPaid وحده، ولا تجعل نجاح calendar request بديلًا عن حالة الاشتراك. calendar مرحلة تجهيز فقط.
- [ ] افحص المراجعة قبل paid/failed في mapping عند تناقض flags؛ الحالة المتناقضة غير محسومة وتُعرض للمراجعة/الفحص، لا كنجاح.
- [ ] polling محدود: استعلام فوري ثم backoff الحالي بعد مراجعته، ومهلة نحو دقيقتين. stop عند terminal أو logout أو dispose، pause في background، resume باستعلام واحد. لا loops مفتوحة.
- [ ] منع jobs مكررة per attempt؛ generation يمنع استجابة قديمة من تعديل محاولة جديدة. retry في واجهة الحالة يعيد GET فقط.
- [ ] response review من الخادم يثبت الحظر المخزن. انتقال خادمي موثوق إلى Paid/Active/PaymentFailed يحدّثه؛ تعذر الشبكة لا يزيله.
- [ ] إعادة فتح الرابط نفسه تعرض الحالة الحالية دون إعادة POST أو تنفيذ تفعيل أو route نجاح إضافي. استخدم replace/عرض تفاصيل الاشتراك عند terminal مكرر؛ العلامة المحلية لمنع العرض المتكرر ليست مصدر الحالة.

**اختبارات:** fake repositories تُرجع تعاقب Pending→Paid→Active، review→failed، review→Active، network failure، paid مع current pending، status مجهول، وصول استجابات بترتيب معكوس. استخدم fake time لحدود polling، لا تنتظر دقيقتين حقيقيتين.

## 8. Task 5 — deep links والاستعادة في cold/warm start

**الملفات:** payment_return/parser tests، main/router، AndroidManifest، Info.plist؛ platform adapter صغير إن لزم. افحص دعم Flutter الموجود دون إضافة package تلقائية.

- [ ] Android: intent-filter داخل activity الحالية مع VIEW وDEFAULT وBROWSABLE وscheme `mealmate` وhost `checkout` والمسارات الأربعة. احتفظ بإعدادات التطبيق الأخرى.
- [ ] iOS: CFBundleURLTypes/CFBundleURLSchemes بقيمة `mealmate`، وتأكد وصول URL إلى Flutter عبر lifecycle الحالي وSceneDelegate إن مستخدم.
- [ ] تسجيل المنصة لا يغني عن parser: exact scheme/host/path، `paymentId` واحد، prefix pz- ومحتوى غير فارغ وطول محدود، بلا userinfo أو port أو fragment/control chars. URI غير صالح يُرفض بهدوء.
- [ ] لا تجعل arbitrary `to` أو redirectUrl أو subscriptionId في link يتحكم في navigation/طلبات الخادم. لا dynamic route من input.
- [ ] جهّز queue لعودة واحدة بعد init auth/storage/navigation؛ لو المستخدم logged out، احتفظ بالرابط في الذاكرة إلى تسجيل الدخول ثم resolve الحساب الحالي. لا تطلب API بحساب غير مسجل ولا تفتح نجاحًا قبل التحقق.
- [ ] إذا سجل المحاولة مطابق: استخدم subscriptionId. إذا paymentId غير مطابق/السجل مفقود: تجاهل ربطه بالعملية المحلية الجديدة، واقرأ current/uncompleted subscriptions من الحساب الحالي عبر UseCases موجودة.
- [ ] عند مرشح وحيد غير محسوم افحص حالته. عند عدة مرشحين لا تخمّن ارتباط الرابط؛ اعرض قائمة الاشتراكات من الخادم ليختار المستخدم الاشتراك الذي يفحصه. لا تستخرج هوية من pz- ولا تختلق endpoint paymentId→subscription.
- [ ] رابط قديم ومحاولة جديدة: لا تغيّر حظر/حالة المحاولة الجديدة من destination القديم؛ حدّث الاشتراك المختار من endpoints الحالة وأظهر نتيجة تخصّه فقط. endpoint الاشتراك لا يثبت نتيجة محاولة تاريخية بعينها، فلا تنسب إليه ذلك.
- [ ] custom schemes يمكن لتطبيق آخر تسجيلها؛ لا تزعم أنها تحقق هوية المرسل. الأمان مصدره auth + correlation + server status، لا ملكية scheme وحدها.

**اختبارات جهاز:** warm start/cold start/terminated app، قبل login، بعد account switch، link مكرر، link malformed، link قديم أثناء محاولة أحدث؛ بلا انهيار ولا checkout تلقائي.

## 9. Task 6 — أمان WebView والطلبات والـlogging

**الملفات:** payment_navigation، payment_redirect_web_view، token_interceptor/external_modules عند وجود مشكلة مثبتة، الاختبارات الحالية `test/core/payment/payment_navigation_test.dart` و`test/payment_return_security_test.dart`.

- [ ] paymentUrl الأول absolute HTTPS، host حقيقي، بلا userinfo/port غير معتمد/صيغة مموهة. لا HTTP/file/data/javascript/intent. اعتمد host policy على domains التي ثبتت من استجابة Sandbox الفعلية ووثائق Payzah/التاجر؛ لا تفترض أن رابط hosted هو نفسه endpoint التهيئة development.payzah.net.
- [ ] افحص redirect chain/3DS/KNET قبل tightening allowlist. اسمح hosts المثبتة اللازمة فقط، بما فيها backend return وACS البنكي الموثق. لو domain جديدة لازمة غير موثقة، وثّقها وأكّدها؛ لا تفتح كل الإنترنت ولا تكسر 3DS بإغلاقه تخمينًا.
- [ ] لا تعترض backend return `/api/v1/payments/payzah/return` باعتباره نجاحًا؛ يجب أن يصل GET/POST للخادم. اعتراض URI mealmate يكون للعودة للتطبيق والتحقق فقط.
- [ ] امنع HTTPS→HTTP downgrade، وتجاوز أخطاء TLS، وmixed content. لا تخفف network_security_config عمومًا من أجل الدفع.
- [ ] لا تمرر JWT/API Authorization headers أو cookies التطبيق إلى Payzah/ACS. لا JavaScript bridge بصلاحيات التطبيق، ولا JS injection يقرأ بيانات الدفع، ولا وصول local files/downloads/camera/geolocation دون ضرورة موثقة.
- [ ] فعّل JavaScript اللازم للبوابة فقط، وتعامل مع popups/3DS وفق السلوك المدعوم. خروج المستخدم أو إغلاق WebView ليس فشلًا نهائيًا؛ افحص الحالة.
- [ ] WebView callback وURL change قد يرسلان الحدث نفسه: dedupe per attempt مع إتاحة manual GET/recovery، وليس flag دائم يمنع التحقق اللاحق.
- [ ] منع double submit في ViewModel قبل await، مع CTA disabled. بعد timeout checkout: قد يكون الطلب وصل؛ استعلم عن الاشتراكات الحالية قبل السماح بمحاولة يدوية جديدة، ولا تعيد POST.
- [ ] راجع token refresh interceptor: لا replay تلقائي لطلب checkout حتى لو يفعل ذلك مع بقية endpoints. إن عاد 401 جدّد الجلسة ثم تحقق/أعد تحميل الشاشة؛ POST جديد يتطلب فعل مستخدم. استخدم Extra/config قائم لهذا الاستثناء إن موجود.
- [ ] لا تعطل auth في payment GET/POST. 401 يعيد authentication؛ 403/404 لا يتحول إلى نجاح أو اختيار اشتراك شخص آخر. resource ownership enforcement مطلوب خادميًا، والتطبيق لا يدّعي توفيره وحده.
- [ ] redact logs في الدفع: Authorization، password/OTP، بطاقة/CVV، paymentUrl query، raw checkout response والمحاولات. استعمل endpoint/status/errorCode ومعرّف مقتطع إن لزم، بلا روابط جلسة كاملة.
- [ ] لا تضف الأسرار إلى fixtures، screenshots، docs، source، env ملتزم به، crash analytics. لا تسجل أحداث route الكاملة إذا تحمل paymentId/query.

**مصدر الحقيقة:** local storage/link يمكن تزويرهما؛ أقصى ما يسمحان به هو بدء استعلام مصادق عليه. لا amount/currency من link؛ المبالغ الحقيقية والربط والالتقاط والتفويض من الخادم.

## 10. Task 7 — الأخطاء وتنظيف القديم دون كسر المسارات الأخرى

- [ ] 409 existing_subscription: اقرأ subscriptionId من payload الموثق إن موجود، وإلا current/uncompleted. افتح تفاصيل الاشتراك القائم/حالته؛ لا تؤكد نجاحه افتراضيًا.
- [ ] prerequisites: اعرض النص القادم من الخادم plain text كما هو، ثم وجّه إلى address/allergies/dietary_preferences عبر destinations القائمة. لا HTML/rendering للرسالة ولا بيانات تقنية/raw response.
- [ ] gateway_unavailable: النص الأصلي + محاولة لاحقًا بمبادرة المستخدم. لا background retry POST.
- [ ] error presenter للدفع يفضل الرسالة البشرية في response حسب العقد؛ code يوظّف للسلوك والترجمة فقط عند غياب رسالة. لا تخرّب مسارات coupon أو errors العامة الأخرى.
- [ ] امسح branch/enum/model/logo/constants/localizations الخاصة بطريقة -1/SANDBOX القديمة من المسار الفعلي بعد البحث عن المستهلكين. أزل Visa/Mada/ApplePay كاختيارات داخل checkout المستضاف، لا assets مشتركة تستخدم خارج النطاق بلا مراجعة.
- [ ] ابحث عن MyFatoorah وكل تهجئاته وpaymentMethodId=-1 وwithout_payment وsandbox_checkout وhardcoded 3. ليس كل ذكر sandbox قديمًا: احتفظ بتمييز بيئة Payzah والبيانات التاريخية الشرعية.
- [ ] حدّث `test/payment_sandbox_method_test.dart` ليختبر رفض المسار القديم أو احذفه إذا لم يعد يختبر عقدًا صالحًا؛ لا تحذف الاختبارات لمجرد جعل النتائج خضراء.
- [ ] لا تغيّر سياسة zero-amount checkout اعتمادًا على تخمين. أبقِ القيود القائمة ما دام العقد لا يجيز مسار مجاني، ولا تستخدم غياب paymentUrl كإذن نجاح.

## 11. مصفوفة اختبارات الأمان الإلزامية

| السيناريو | المتوقع |
|---|---|
| success link مزور وGET يقول PendingPayment | جاري التحقق؛ لا نجاح |
| error link وGET/current يقول Active | عرض حالة الاشتراك الفعلية؛ لا فشل محلي |
| review link مزور | حظر محافظ وفحص الخادم، ثم تصحيح الحظر وفق الحالة |
| review موثق ثم خروج/إعادة تشغيل | الحظر مستعاد؛ لا POST جديد |
| pz- غير معروف أو رابط لحساب آخر | فحص اشتراكات الحساب الحالي فقط؛ لا عرض بيانات الآخر |
| `mealmate://checkout.evil/success` أو path إضافي | رفض parser |
| userinfo/port/fragment/duplicate paymentId/control chars | رفض parser بلا انهيار |
| link مكرر من WebView وOS | استعلام متحكم به؛ لا POST ولا navigation متكرر |
| رابط قديم أثناء محاولة أحدث | لا ربط خاطئ ولا إلغاء قفل المحاولة الجديدة |
| تخزين محلي corrupt أو modified | استعادة من الخادم؛ لا نجاح من local flags |
| account switch أثناء GET | نتيجة الحساب القديم لا تُعرض ولا تُخزن للجديد |
| ضغط checkout مرتين | POST واحد |
| timeout بعد إرسال checkout | حالة غير محسومة + GET recovery، لا POST تلقائي |
| 401/token refresh في checkout | لا إعادة إرسال خفية |
| serviceCharge/totalAmount=null | لا crash ولا رسوم صفر مختلقة |
| initial URL خبيث أو HTTP/downgrade/TLS failure | لا فتح غير آمن ولا تجاوز SSL |
| backend return URL أو نص صفحة success | يمر للخادم، ولا يعتبر وحده تأكيدًا |
| isPaid=true واشتراك Paid | تم الدفع والتنفيذ جارٍ؛ لا تفعيل نهائي |
| Paid ثم Scheduled/Active | عرض نجاح نهائي مرة واحدة |
| 5xx/offline/status unknown | غير محسوم، فحص يدوي متاح بلا إعادة دفع |
| wallet unavailable أو طريقة من state قديمة | لا اختيار/POST حتى عبر event مباشر |

هذه اختبارات سلوك محلية وتكامل جهاز. اختبار IDOR/ملكية المورد خادميًا يحتاج حسابَي اختبار مملوكين ومصرحًا بهما فقط؛ لا تجرب معرّفات مستخدمين حقيقيين أو scanning. إن لم يُختبر، سجّله بوضوح ولا تدّعِ ضمان الخادم من مراجعة Flutter.

## 12. Task 8 — الاختبار الفعلي على Sandbox المنشور

- [ ] تأكد من الحساب والسياق التجريبي باستخدام معلومات المستخدم؛ لا تغيّر إعدادات الأدمن. إن الصفحة لا تعرض سياق الاختبار المتوقع، توقف عن إدخال بطاقة الاختبار وأبلغ عن عدم توافق البيئة.
- [ ] افتح شاشة الطرق: Payzah hosted checkout متاحة، wallet معطّلة وسببها ظاهر. أعد الدخول وتأكد من طلب جديد وعدم بقاء اختيار قديم.
- [ ] ابدأ checkout واحدًا؛ تأكد payload يحمل ID من response وأن حفظ attempt اكتمل قبل WebView.
- [ ] ادفع ببطاقة الاختبار الموجودة في رسالة المستخدم على صفحة Payzah فقط. تحقق من العودة success ومعرّف pz- مطابق، ثم GET payment، ثم Paid→Scheduled/Active بحسب الخادم. احتفظ بدليل HTTP/status منزوع البيانات الحساسة.
- [ ] اختبر الإلغاء بمحاولة مسموحة من الخادم؛ قد تحتاج حساب اختبار آخر لأن اشتراكًا فعّالًا يمنع checkout. قبول error/pending دون انهيار، والفصل النهائي من الحالة.
- [ ] اختبر التطبيق مقفولًا وقت العودة، ثم فتحه يدويًا. يجب استعادة العملية من local mapping أو قائمة الحساب دون POST جديد.
- [ ] أعد فتح رابط العودة القديم: عرض الحالة دون تكرار تأكيد/إنشاء. تحقق من عداد POST في أدوات التطوير مع تعطيل تسجيل الأسرار.
- [ ] pending/review التي لا يمكن توليدها فعليًا اختبرها بـfixtures/device link + fake server data محليًا؛ لا تضع endpoint dev أو bypass في إصدار التطبيق. اذكر ما لم يُختبر على البوابة.
- [ ] KNET مؤجل لحين بيانات اختبار التاجر. لا تسجله PASS اعتمادًا على نجاح البطاقة.
- [ ] لا تحذف اشتراكًا/حجزًا ولا تعمل refund لتنظيف الاختبارات دون إجراء مصرح به. استخدام DELETE ليس جزءًا من recovery ولا حلًا لـ409.

## 13. أوامر التحقق وتسليم النتيجة

من جذر المشروع، استخدم Flutter/Dart المتاحين محليًا؛ لا ترقّي SDK أو dependencies لهذا العمل.

```powershell
git status --short
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
flutter test test/core/payment
flutter test test/payment_return_security_test.dart
flutter test test/payment_payzah_mapper_test.dart
flutter test test/payment_unresolved_status_view_test.dart
flutter test test/payment_success_screen_test.dart
flutter test test/payment_methods_refresh_test.dart
flutter test test/payment_attempt_store_test.dart
flutter test test/payment_checkout_lifecycle_test.dart
flutter test test/payment_return_recovery_test.dart
flutter test
git diff --check
rg -n -i 'myfatoorah|sandbox_checkout|without_payment|PaymentMethodType.sandbox' lib/features/payment lib/core/payment
```

أضف الاختبارات الجديدة المذكورة إلى الملفات ذات الأسماء المحددة، واستعمل fakes موجودة/محدّثة بدل mock API حقيقي في unit tests. شغّل اختبارًا أحمر لكل سلوك مكسور قبل إصلاحه ثم أخضر بعده. format فقط الملفات المعدّلة، ولا تنسب فشل baseline سابق إلى المهمة دون مقارنة. راجع generated diffs لكي لا تبتلع تغييرات calling الحالية.

تشغيل روابط Android للتجربة، باستخدام معرّف محاولة الاختبار الفعلي محليًا بدل مثال غير مطابق:

```powershell
adb shell am start -W -a android.intent.action.VIEW -d 'mealmate://checkout/pending?paymentId=pz-test-attempt'
```

هذا أمر اختبار routing فقط؛ المثال لا يثبت حالة دفع. اختبر على iOS Simulator/Mac أو جهاز فعلي باستخدام أدواته؛ عدم توفر البيئة يُذكر كقيد، لا كنجاح تحقق.

**التسليم المطلوب من Gemini:**

- قائمة مختصرة بما تغير ولماذا، والملفات الأساسية.
- أسماء schema المثبتة ومعنى paid مقابل active وطريقة الاستعادة.
- نتائج unit/widget/analyzer/build مع أسباب أي فشل أو عدم تشغيل.
- جدول قبول لكل سيناريو فعلي: الجهاز/النظام، نتيجة الاختبار، الحالات الخادمية المنزوعة البيانات الحساسة.
- توضيح KNET/review/أي منصة لم تُختبر فعليًا، وأي اختلاف عقد يحتاج الباك.
- تأكيد عدم إضافة أسرار/بيانات اختبار إلى التطبيق، وعدم replay checkout وعدم تغيير endpoint contract.
- لا push/merge/deploy ولا تعديلات بوابة أدمن ضمن هذه المهمة. لا تعلن اكتمال الدفع النهائي قبل أدلة الاختبار المتاحة وتوضيح حدودها.
