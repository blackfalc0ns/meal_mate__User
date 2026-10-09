# Subscription Availability and Calendar Implementation Plan — Gemini

> **For agentic workers:** Execute task-by-task using `superpowers:executing-plans` when available. Track checkbox steps. This handoff authorizes implementing the described application changes; it does not authorize push, merge, deployment, refunds, or deleting subscriptions.

**Goal:** تحديث تدفق الاشتراك الفردي ليتوافق مع عقد الباك الجديد: الحفاظ على تاريخ اختيار العميل، عرض أول توصيل من الخادم، تقييم توافر المطاعم للفترة كاملة، منع الدفع غير المسموح، وتمكين اختيار الوجبات وفق `CanEdit` مع أسباب القفل المترجمة.

**Architecture:** التزم بالطبقات القائمة DTO → Mapper → Entity → Repository → UseCase → ViewModel/Cubit → UI. استخدم تدفق `monthly_plans` للاستعراض، و`subscription_checkout` للملخص والعقد المشترك للتوافر، و`calendar` للأيام والوجبات. استكمل مسارات الدفع والاستعادة القائمة دون إنشاء coordinator أو state machine موازية.

**Tech Stack:** Flutter/Dart، flutter_bloc، Dio/Retrofit، json_serializable/build_runner، injectable، intl، ARB/gen-l10n، flutter_test، الأدوات الموجودة في المشروع فقط.

**Spec:** متطلبات وتسليم الباك مضمّنة في القسم 2 أدناه، مع العلاقة الملزمة بخطة `docs/superpowers/plans/2026-10-08-payzah-payments-gemini.md`. لا تحتاج الوصول إلى ملف attachment الخاص بالمحادثة لتنفيذ هذه الخطة.

## 1. حدود التنفيذ وقواعد المشروع

- اقرأ `AGENTS.md` و`rules/ui_rules.md` و`rules/backend_rules.md` قبل تعديل كود المنتج. عند إعداد الخطة، `rules/backend_rules.md` غير موجود؛ ابحث عنه بـ`rg --files`، وإذا بقي مفقودًا اطلب الملف من المالك قبل تغييرات الربط. لا تنشئ قواعد بديلة من عندك. هذه عقبة لتطبيق قواعد المشروع، وليست سببًا لإعادة طلب اعتماد متطلبات الباك كلها.
- المستخدم أكد أن الباك يرفع التعديلات. افحص العقد المنشور عند التنفيذ؛ لا تعتبر ملاحظة عدم النشر في التسليم وصفًا دائمًا للبيئة، ولا تعتبر كلام الرفع إثباتًا لاكتماله.
- لا تضف packages أو تغيّر SDK أو architecture. لا تعيد تصميم الواجهات ولا تطلب Figma لمجرد تحديث سلوك قائم؛ اتبع التصميم الموجود. أي تصميم جديد يحتاج مرجعًا فعليًا.
- UI: `context.colorScheme`، `context.localization`، `styles_manager.dart`، `spacing.dart`؛ لا نصوص أو ألوان أو مقاسات مخترعة. Widget مخصص واحد لكل ملف. الاتجاه من `Directionality`.
- النطاق هو الاشتراك الفردي. افحص مستهلكي الملفات المشتركة والعائلي عند تغيير type مشترك، دون تغيير عقد العائلي أو الترقية أو الفوترة.
- لا تصلح مشاكل غير مرتبطة بالمهمة. احفظ تغيرات المستخدم الموجودة، ولا تعمل reset/stash/checkout للملفات لإخفائها.
- وقت إعداد الخطة توجد تعديلات في `lib/core/constants/assets.dart`، `app_shell_screen.dart`، شاشة `payment_success_screen.dart`، widgets نجاح الدفع، `test/payment_success_screen_test.dart`، وصورة نجاح جديدة. اقرأ الحالة الفعلية وقت التنفيذ؛ هذه ليست ملفات يجوز استبدالها بنسخة قديمة.
- لا تسجل tokens أو بيانات حساب أو بيانات بطاقة. عينات الاختبار ثابتة ومصطنعة؛ الردود الفعلية تُنقّح قبل حفظها.
- نفّذ اختبارات سلوك حمراء قبل إصلاح السلوك، ثم اجعلها خضراء. لا تختبر مجرد وجود أسماء في source بدل النتيجة الفعلية.
- لا commits تشمل تغييرات المستخدم. يمكن عمل commits محلية صغيرة فقط إذا كانت سياسة الجلسة تسمح؛ لا تجعل commit شرطًا لإكمال التنفيذ.

## 2. العقد المرجعي ومتطلبات القبول

### 2.1 التاريخ

- `startDate` في query التوافر والملخص وجسم checkout = تاريخ اختيار العميل كأساس العرض/الدفع، بصيغة `yyyy-MM-dd`.
- `StartDate` في summary = بداية الاشتراك وأول توصيل محسوبين من السيرفر. الحقل مطلوب في schema الملخص.
- `ChosenStartDate` في summary = تاريخ الاختيار الأصلي؛ nullable للتوافق. إذا غاب، استخدم تاريخ الطلب الأصلي لعرض تاريخ الاختيار فقط.
- التاريخان nullable في checkout response؛ اعتمد قبل الدفع على الملخص وبعد الإنشاء على `Subscription.StartDate` والتقويم. لا تعتبر غياب تاريخ checkout دليل فشل الدفع أو إذنًا لحساب التوصيل محليًا.
- مثال acceptance: request `2026-10-08`، summary.startDate `2026-10-11`؛ طلب الكوبون والصفحة التالية والدفع يبقى `2026-10-08`، والعرض لأول توصيل `2026-10-11`.
- ممنوع إضافة 3/4 أيام أو نقل قيمة response.startDate إلى request.startDate. لا تحوّل تاريخ الخدمة الخالي من timezone بطريقة تغيّر اليوم.

### 2.2 التوافر

```http
GET /api/v1/customer/subscription-flow/restaurant-availability
?programId={programId}&bundleId={bundleId}&tier={tier}
&durationDays={durationDays}&startDate={chosenAnchorDate}
&includeFriday={true|false}&restaurantsPage={page}&restaurantsPageSize={pageSize}
```

```json
{
  "availability": {
    "status": "no_restaurants_for_address",
    "coveredRestaurantCount": 0,
    "eligibleRestaurantCount": 0,
    "checkedAtUtc": "2026-10-08T10:00:00Z",
    "effectiveStartDate": "2026-10-11",
    "messageCode": "subscription_flow.no_restaurants_for_address"
  },
  "totalCount": 0,
  "pagination": null,
  "restaurants": []
}
```

| status | تصرف التطبيق |
|---|---|
| `address_required` | إضافة/اختيار عنوان، ثم إعادة التحميل |
| `selection_required` | استكمال سياق الاشتراك والتاريخ؛ لا تخترع تاريخًا لتجاوز الحالة |
| `no_restaurants_for_address` | رسالة عدم تغطية عنوان العميل للبرنامج |
| `no_restaurants_for_selection` | رسالة عدم التوافر طوال الفترة مع الرجوع لتعديل الاختيارات |
| `available` | عرض المطاعم المؤهلة للفترة |

`coveredRestaurantCount` = تغطية جغرافية، `eligibleRestaurantCount` = أهلية الفترة كلها. `totalCount` = إجمالي النتائج قبل pagination؛ الصفحة الفارغة لا تعني غياب التوافر. `effectiveStartDate` للعرض فقط، ولا يُعاد كـanchor.

### 2.3 الملخص والعنوان

- `GET /api/v1/customer/subscription-flow/summary` بنفس سياق الاختيار؛ يضاف `Availability` للـDTO/entity بعد التحقق من schema.
- `CanCheckout == true` شرط السماح؛ missing/null يعامل كعدم وجود تصريح بالدفع.
- اعرض `FinalPrice` كما أرجعه الخادم، دون جمع/طرح `CampaignDiscount` و`Coupon.DiscountAmount` مرة أخرى.
- أسباب منع checkout الحالية: `checkout.address_required`، `checkout.allergies_required`، `checkout.dietary_preferences_required`، `checkout.start_date_required`، `subscription_flow.no_restaurants_for_selection`، `subscription_flow.no_restaurants_for_address`، `checkout.existing_subscription`.
- لا يوجد `addressId` في summary query أو checkout body. الخادم يستخدم `ActiveDeliveryAddressId` مع fallback مناسب/افتراضي.
- تغيير العنوان قبل الاشتراك عبر الموجود في التطبيق والمتوافق مع:

```http
GET /api/v1/customers/me/addresses
POST /api/v1/customers/me/addresses/{id}/set-default
```

- انتظر نجاح تغيير العنوان، ثم أعد summary/availability. لا تعرض أهلية عنوان قديم بجوار اسم عنوان جديد. لا تغيّر عنوان الاشتراك المنشأ بهذا endpoint تحت افتراض أنه نفس التدفق.

### 2.4 الدفع

المسار الحالي `POST /api/v1/customer/subscriptions/checkout`. لا يوجد snapshotId/summaryId يرسله العميل؛ الخادم يعيد فحص الأهلية والسعر وينشئ snapshots داخليًا.

```json
{
  "programId": "{guid}",
  "bundleId": "{guid}",
  "tier": "Basic",
  "durationDays": 26,
  "startDate": "2026-10-08",
  "includeFriday": false,
  "callbackUrl": "mealmate://checkout/success",
  "errorUrl": "mealmate://checkout/error",
  "correlationId": "{client-generated-id-or-null}",
  "paymentMethodId": "{integer-from-payment-methods-response}",
  "promoCode": null
}
```

القيم داخل الأقواس هنا وصف للمصدر وليست payload حرفيًا؛ `paymentMethodId` رقم فعلي. تسليم الباك عرض `mealmate://payment/success` و`.../cancel` وID=3 كأمثلة؛ الكود الحالي وخطة Payzah يستخدمان `mealmate://checkout/success` و`.../error` وID ديناميكيًا. لا تغيّر parser أو الروابط أو تستبدل ID بـ3 بسبب المثال. تحقق من قبول الباك للروابط القائمة؛ إذا كان هناك شرط جديد موثق، سجّل التعارض واطلب توحيده قبل تعديل عقد العودة.

تعامل مع `CheckoutEndpoint` داخل origin العميل الموثوق وبالطريقة المتوقعة. إذا طابق المسار القائم، استخدم abstraction الحالي. إذا احتاج دعم مسار ديناميكي، مرره داخل طبقات الدفع القائمة مع تحقق origin/path؛ لا تعمل Dio call داخل widget، ولا ترسل token لعنوان مطلق غير موثوق، ولا تخمّن مسارًا عندما الحقل غير معروف.

خطأ الأهلية المؤكد في تسليم الباك:

```http
HTTP 400
{"error":"restaurant.not_eligible","message":"Checkout eligibility or restaurant snapshot changed. Refresh and try again."}
```

اعرض رسالة مترجمة عن تغير التوافر، أعد الاستعراض والملخص، واترك إعادة الدفع لمبادرة المستخدم بعد مراجعة النتيجة. `subscription_flow.no_restaurants_for_selection` قد يأتي داخل summary HTTP 200 مع `CanCheckout=false`، وليس مضمونًا كخطأ checkout.

### 2.5 التقويم والأيام

```http
GET  /api/v1/customer/subscriptions/{subscriptionId}/calendar
GET  /api/v1/customer/subscriptions/{subscriptionId}/days/{yyyy-MM-dd}
GET  /api/v1/customer/subscriptions/{subscriptionId}/days/{yyyy-MM-dd}/restaurants
POST /api/v1/customer/subscriptions/{subscriptionId}/days/{yyyy-MM-dd}/restaurant
GET  /api/v1/customer/subscriptions/{subscriptionId}/days/{yyyy-MM-dd}/restaurants/{restaurantId}/meals
POST /api/v1/customer/subscriptions/{subscriptionId}/days/{yyyy-MM-dd}/meals/slot
POST /api/v1/customer/subscriptions/{subscriptionId}/days/{yyyy-MM-dd}/complete
```

- أجسام طلبات mutation ليست مرفقة في التسليم. استخرجها من Swagger المنشور؛ قارن بالـDTOs القائمة. لا تفترض أن `/meals` القديم يساوي `/meals/slot` الجديد.
- عدم تجهيز fulfillment وفق المصدر: `409 {"error":"calendar.fulfillment_not_ready"}`. تحقق بعد النشر؛ لا تعامل كل 409 كعدم تجهيز.
- التقويم الفارغ بدون أيام لا يثبت جاهزية اختيار الوجبات؛ حالة انتظار/تحديث، دون نجاح زائف.
- `CanEdit` المصدر الوحيد لتصريح mutations؛ القيمة الغائبة لا تسمح بالتعديل. لا تمنع يومًا بسبب `Scheduled` أو confirmed/pending status عندما `CanEdit=true`، ولا تفتحه بحساب مهلة محلي.
- اليوم الأول: 24 ساعة من تأكيد الدفع، محسوبة خادميًا. بقية الأيام بحسب مواعيد الخادم. `ConfirmedAtUtc` لليوم ليس timestamp تأكيد الدفع.
- `SelectionDeadlineUtc` و`LockAtUtc` تُحفظ UTC، وتُعرض بتوقيت التطبيق المعتمد؛ افحص convention الحالي ولا تفترض timezone الهاتف أو Cairo أو Kuwait بلا دليل.
- `LockRemainingSeconds` معلومة، وليس إذن تعديل. يمكن تحديث countdown للعرض فقط؛ انتهاءه يستدعي refresh ولا ينتج تصريحًا محليًا.
- `EditBlockReason`: `selection_deadline_passed`، `day_locked`، `day_frozen`، `day_cancelled`، `fulfillment_not_ready`.
- حافظ على `Status`، `UiStatus`، `FilledCount`، `RequiredCount`، `SlotRequirements` كما يرسلها الخادم.

## 3. Task 0 — تثبيت العقد وbaseline قبل التعديل

**Read:** `rules/`، خطة Payzah، `l10n.yaml`/`pubspec.yaml`، ملفات الطبقات المشار إليها بالمهام التالية، اختبارات الدفع والتقويم والملخص القائمة.

- [ ] نفّذ `git status --short` واحتفظ بقائمة تغييرات المستخدم خارج patch المهمة.
- [ ] حل وجود ملف backend rules، ثم سجّل rules الفعلية التي تنطبق.
- [ ] افتح `https://maelmate.runasp.net/swagger/v1/swagger.json` أو base URL الفعلي من إعدادات المشروع. تحقق من route/schema/required/nullable/enum والـresponse wrapper وحالة تسمية JSON. لا تغيّر base URL لتجاوز اختلاف النشر.
- [ ] استخرج request/response للـsummary/availability/calendar/day/restaurant/slot/complete وطرق الدفع. سجّل أسماء schemas الصحيحة في تسليمك النهائي. انتبه للـ200 wrapper إن وُجد؛ المثال السابق لا يثبت عدم وجود wrapper.
- [ ] إذا النشر مازال ناقصًا: تابع اختبارات المنطق المحلي المعتمد على العقد الواضح، وأوقف فقط توصيل عقد لا يمكن إثباته. لا تستبدل availability بالمسار القديم باعتباره أهلية الفترة، ولا تدّعِ نجاح التكامل الحي.
- [ ] شغّل baseline `flutter analyze` واختبارات الـsummary/plan/calendar/payment الحالية وسجّل نتائج الفشل السابقة. استخدم SDK الموجود ولا ترقّيه.

## 4. Task 1 — إصلاح الفصل بين تاريخ الاختيار وأول توصيل

**Modify:**
- `lib/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart`
- `lib/features/subscription_checkout/presentation/manager/subscription_summary_state.dart`
- `lib/features/subscription_checkout/presentation/widgets/subscription_summary_details_card.dart`
- `lib/features/subscription_checkout/presentation/widgets/subscription_dates_row.dart`
- `lib/features/subscription_checkout/presentation/screens/subscription_summary_screen.dart`
- `lib/features/payment/presentation/screens/payment_screen.dart` و`payment_web_view_screen.dart` إذا ثبت خلط تاريخ العرض بالطلب.

**Tests:** أضف `test/subscription_anchor_date_test.dart`، واستكمل `subscription_summary_coupon_test.dart` و`subscription_summary_restaurants_pagination_test.dart` و`subscription_coupon_checkout_test.dart`.

**Interface:** `SubscriptionSummaryRequestEntity.startDate` و`state.selectedStartDate` يظلان anchor؛ `summary.startDate` للعرض؛ `state.activeRequest` نسخة السياق الأصلي مع الكوبون المقبول والصفحة الأولى، دون استبدال التاريخ.

- [ ] استخدم fake repository وباني summary الموجودين في اختبارات الملخص، وسجّل جميع requests بدل آخر request فقط. اجعل reply يحمل chosen=08 وstart=11.
- [ ] أضف test يفشل على السلوك الحالي: أول GET يحمل 08، وبعد الرد `activeRequest.startDate` و`selectedStartDate` يظلان 08؛ ثم apply/remove coupon وload-more وcheckout تحمل 08.
- [ ] شغّل الاختبار وتأكد أن الفشل بسبب انتقال response.startDate إلى request، لا بسبب fixture ناقص.
- [ ] أصلح `_getSummary` عند `backendStartDate`: احذف استبدال تاريخ request وأبقِ promo normalization القائم.

```dart
final activeRequest = request.copyWith(
  promoCode: approvedPromoCode,
  clearPromoCode: approvedPromoCode == null,
  restaurantsPage: 1,
);
// selectedStartDate في emit = request.startDate؛
// result.data.startDate لا يدخل request أو date picker anchor.
```

- [ ] افحص `earliestStartDate` وقيود date picker: لا تستعمل تاريخ أول توصيل كأقل anchor إلا لو هناك حقل/عقد صريح يحدده. إن اختيار التاريخ يحدث حاليًا في الملخص، حافظ على موضعه واجعله متاحًا قبل تقييم التوافر دون حساب offset محلي.
- [ ] العرض: تاريخ الاختيار من chosenStartDate أو request anchor؛ أول توصيل من summary.startDate. إذا startDate غير صالح/غائب، اعرض حالة بيانات غير مكتملة مترجمة، دون تسمية anchor بأنه أول توصيل.
- [ ] أضف تغيير anchor إلى تاريخ جديد، chosenStartDate=null، واختبار الجمعة. لا تثبّت توقع offset في Flutter؛ fixture الخادم وحده يحدد أول توصيل.
- [ ] شغّل الاختبارات المحددة؛ النتيجة طلبات 08 وعرض 11 وعدم ظهور 15.

## 5. Task 2 — نموذج التوافر وربطه بالشبكة

**Create inside `subscription_checkout`:**
- `data/models/response/subscription_availability_response_dto.dart`
- `data/models/response/subscription_restaurant_availability_response_dto.dart`
- `domain/entities/subscription_availability_entity.dart`
- `domain/entities/subscription_restaurant_availability_entity.dart`
- `data/mapper/subscription_availability_mapper.dart`
- `domain/usecase/get_subscription_restaurant_availability_usecase.dart`

**Modify:** `lib/core/network/network_constants.dart`، `api_services.dart`، `subscription_summary_response_dto.dart`، `subscription_summary_entity.dart`، `subscription_summary_mapper.dart`، واجهتا/تنفيذ data source وrepository في `subscription_checkout`، ثم generated network/DTO/DI فقط عبر generator.

**Tests:** `test/subscription_availability_mapper_test.dart` و`test/subscription_availability_endpoint_test.dart`.

**Interface:** أضف للـrepository method بالشكل التالي، ونفسها للـusecase عبر `call` وفق convention الحالي:

```dart
Future<ApiResult<SubscriptionRestaurantAvailabilityEntity>>
getRestaurantAvailability(SubscriptionSummaryRequestEntity request);
```

`SubscriptionAvailabilityEntity`: status/messageCode String، coveredRestaurantCount/eligibleRestaurantCount int، checkedAtUtc DateTime?، effectiveStartDate String. Wrapper entity: availability، totalCount، PaginationEntity?، وقائمة restaurant cards بالنوع القائم إن طابقت schema؛ لا تختلق DTO جديدًا لبطاقة مطابقة.

- [ ] أضف parsing tests للمثال المرفق، ولـavailable مع totalCount أكبر من طول الصفحة، وpagination=null، وكود status غير معروف.
- [ ] أضف transport test باستخدام Dio adapter/fake الشبكة القائم يثبت GET والمسار وأسماء query الثمانية والقيم، ويثبت startDate=anchor. لا تستخدم substring assertion على source.
- [ ] شغّل الأحمر، ثم أضف الـDTOs والـmappers والـentity والـrepository/usecase/API binding.
- [ ] حافظ على status/messageCode دون ترجمة أو تغيير قيم؛ unknown status لا يصبح available.
- [ ] أضف `availability` nullable للملخص حتى لا يكسر parsing fixture/رد توافق قديم، واحفظه في `copyWith`. غياب الحقل لا يسمح باستنتاج الأهلية من restaurants.
- [ ] غيّر mapping الملخص إلى `canCheckout: canCheckout ?? false` واختبر false/null/true. حافظ على `FinalPrice` دون إعادة حساب.
- [ ] شغّل generation ثم tests، وحدّث fakes التي تنفذ repository حتى لا ينهار compile بسبب method جديد.

## 6. Task 3 — استعراض المطاعم بسياق كامل وإبطال النتائج القديمة

**Modify:**
- `lib/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart`
- `subscription_plan_event.dart` و`subscription_plan_state.dart` و`subscription_plan_state_mapper.dart` في نفس المجلد.
- `lib/features/monthly_plans/presentation/screens/subscription_plan_details_screen.dart`
- widgets فتح/عرض استعراض المطاعم داخل `monthly_plans` التي يستعملها هذا screen؛ حددها من imports قبل تعديلها.
- `lib/features/subscription_checkout/domain/entities/subscription_flow_args.dart` و`subscription_summary_args.dart` فقط إذا احتاج تمرير anchor القائم.

**Tests:** `test/subscription_contextual_availability_test.dart`، واستكمل `subscription_tier_restaurants_pagination_test.dart` و`subscription_plan_toggle_friday_test.dart` و`subscription_package_flow_controller_test.dart`.

**Consumes:** `GetSubscriptionRestaurantAvailabilityUseCase.call(SubscriptionSummaryRequestEntity)`.
**Produces:** browse state يحمل result.availability/totalCount/pagination/restaurants، وسياق الطلب الذي ولّدها. الملخص يتلقى نفس program/bundle/tier/duration/anchor/includeFriday.

- [ ] افحص مسار الحصول على التاريخ الحالي. الـreadiness القائم ينشئ request دون startDate؛ لا تعتبره proof لأهلية الفترة. إذا التاريخ لم يُختر بعد، اعرض `selection_required` وخيار استكمال التاريخ في تدفق التطبيق القائم؛ لا تختار DateTime.now كحل صامت.
- [ ] اختبر الفرق بين geographic coverage وأهلية الفترة: covered=4، eligible=0، status=no_restaurants_for_selection؛ لا تعرض أربع بطاقات كأنها متاحة.
- [ ] استبدل provider الاستعراض في تدفق الاشتراك الفردي الجديد بالـusecase السياقي. اترك endpoints تفاصيل مطعم/وجبة وغيرها لمستهلكيها الحقيقيين.
- [ ] مرّر anchor من مصدر اختيار واحد، لا من effectiveStartDate. لا تضاعف local state بين browse/summary بحيث تختلف التواريخ.
- [ ] كل تغيير program/bundle/tier/duration/anchor/includeFriday/address يبطل result القديم ويعيد الصفحة إلى 1 ويبدأ GET جديدًا. استخدام `_browseGeneration` الحالي مناسب؛ زِده أيضًا عند إغلاق الاستعراض أو تغيير السياق.
- [ ] اختبر باثنين Completer: request A قديم ثم B جديد؛ اكتمال A بعد B لا يغيّر المطاعم أو حالة التوافر أو الإجمالي.
- [ ] pagination: append فقط لنفس السياق؛ deduplicate restaurant IDs؛ loading/error/retry للصفحة التالية لا يحذف القائمة ولا يحوّل حالة available إلى no restaurants.
- [ ] اختبر صفحة فارغة مع totalCount>0؛ لا يظهر no restaurants. الصفحة التالية لا تعيد حساب finalPrice أو eligible count من طول القائمة.
- [ ] اختبر تغيير الجمعة/المدة أثناء تحميل الصفحة التالية؛ الرد القديم يُهمل.
- [ ] شغّل tests المستهدفة. عدّل الاختبارات القديمة التي كانت تثبت استخدام endpoint القديم في هذا التدفق لتثبت العقد الجديد؛ لا تمسح اختبارات مستهلك آخر لا يزال يستخدم القديم.

## 7. Task 4 — الملخص وصلاحية الدفع وتحديث العنوان

**Modify:** summary ViewModel/state/event والـbottom bar/coverage banner/details card، وشاشات/manager إدارة العنوان القائمة فقط في نقطة الرجوع إلى flow. افحص مسار الرجوع الحالي بدل إنشاء event bus عام.

**Tests:** `test/subscription_checkout_permission_test.dart`، `test/subscription_address_availability_refresh_test.dart`، و`subscription_summary_screen_test.dart`.

**Interface:** أضف bool `isSummaryRefreshing` إلى state إن لم يوجد مكافئ. ملخص سابق يمكن إبقاؤه للعرض أثناء refresh لكن لا يُعتبر approved للسياق الجديد.

- [ ] اكتب tests: canCheckout=false مع قائمة مطاعم غير فارغة يمنع الزر؛ null parsed false؛ GET جديد مع summary قديم true يمنع الضغط طوال refresh؛ failure لا يعيد صلاحية الملخص القديم.
- [ ] حدّث start/success/failure لمرحلة refresh بصورة متسقة، مع generation token. اجعل شرط زر الدفع والـnavigation يجمع permission true + summary للسياق الحالي + عدم وجود refresh + الشروط القائمة للموافقة/طريقة الدفع.
- [ ] أضف نفس حراسة canCheckout والسياق عند event checkout داخل `PaymentViewModel`؛ تعطيل UI وحده غير كافٍ. لا تمرر نتيجة summary قديمة بعد تغير العنوان.
- [ ] بعد نجاح set-default، refresh للـsummary والتوافر بنفس anchor. failure يحافظ على العنوان السابق ولا يعلن نجاح تغيير العنوان.
- [ ] اربط جميع أسباب CheckoutBlockReason بمسارات prerequisites القائمة، خصوصًا allergy/dietary/address/existing subscription، مع رسالة مترجمة. لا تفترض أن كل منع سببه المطاعم.
- [ ] مقارنة browse/summary: إذا اختلف verdict لنفس السياق بسبب تغير خادمي، أحدث summary هو قرار checkout؛ أعد browse ليطابقه. تجنب حلقة refresh لا نهائية عند اختلاف الردين.
- [ ] أضف test لحساب السعر: base=100، campaign=10، coupon=5، final=85؛ الرقم المعروض 85 ولا يتحول إلى 80 أو 75.
- [ ] شغّل اختبارات الملخص والكوبون والعنوان.

## 8. Task 5 — رفض الأهلية وإعادة المراجعة دون replay للدفع

**Modify:** `lib/core/errors/subscription_error_codes.dart`، `lib/core/network/failuer_mapper.dart` إن احتاج حفظ code، `lib/features/payment/presentation/manager/payment_view_model.dart` وstate/event، `payment_screen.dart`، error presentation الخاص بهذا flow.

**Tests:** `test/payment_availability_changed_test.dart` و`payment_checkout_lifecycle_test.dart` و`subscription_coupon_checkout_test.dart`.

- [ ] fake checkout يرجع 400 بكود restaurant.not_eligible؛ سجل عدد POSTs؛ المتوقع 1 فقط، ورسالة availabilityChanged وخروج/عودة لمراجعة summary مع invalidation للاستعراض.
- [ ] فرّق بين رفض صريح من الخادم وبين timeout/5xx بعد POST: الرفض الموثق يعيد المراجعة، أما نتيجة دفع غير محسومة فتظل داخل recovery القائمة ولا تفتح إعادة دفع غير آمنة.
- [ ] استعمل failure backend code لا النص الإنجليزي للمقارنة. لا تترجم error code نفسه، ولا تعرض raw Dio exception.
- [ ] لا تغيّر العنوان أو المطعم أو التاريخ لتجاوز الرفض؛ احتفظ بالكوبون حتى يعيد السيرفر تقييمه، ثم اتبع approved promo logic الحالي.
- [ ] عند العودة للمراجعة اطلب summary/browse جديدين، وامنع الدفع بالنتيجة السابقة. إعادة الدفع تتطلب ضغطًا جديدًا بعد اكتمال GET.
- [ ] حافظ على single-flight وعدم retry POST في interceptors/recovery وفق خطة Payzah. افحص `CheckoutEndpoint` والروابط/ID كما في القسم 2.4.
- [ ] tests للضغط المزدوج، وevent مباشر عندما canCheckout=false، ورفض الأهلية ثم ضغط المستخدم بعد تحديث summary، وtimeout بدون POST تلقائي آخر.

## 9. Task 6 — تجهيز التقويم بعد الدفع واستعادة المحاولة

**Modify only when necessary:** `lib/features/payment/presentation/manager/payment_view_model.dart` وstate/event، `lib/features/payment/domain/usecase/get_subscription_calendar_usecase.dart`، شاشات/مكونات الحالة القائمة، `lib/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart` وstate.

**Tests:** استكمل `test/payment_fulfillment_state_test.dart` و`payment_unresolved_status_view_test.dart`، وأضف `test/calendar_preparing_state_test.dart`.

المشروع لديه `_pollCalendar` و`_isCalendarFulfillmentNotReady` بالفعل؛ اقرأهما أولًا. لا تنشئ polling loop ثانية ولا تعتبر وجودهما دليل صحة كل الحالات.

- [ ] اختبر تأكيد دفع خادمي ثم GET calendar=409 code exact؛ تظهر preparing + refresh ولا يحدث checkout جديد أو success لاختيار الوجبات.
- [ ] اختبر انتقال 409 إلى 200 بأيام فعلية؛ يعرض التقويم لذات subscriptionId مرة واحدة. 200 بأيام فارغة يظل waiting.
- [ ] ميّز دفع Pending/Paid/Active كما في خطة Payzah. رابط return أو الصفحة وحدهما لا يثبتان الدفع؛ لا تغير منطق التحقق الخادمي لإرضاء شاشة success.
- [ ] أعد استخدام retry schedule القائم إن كان bounded؛ إن لم يكن، GET attempts محدودة بفواصل 2 ثم 4 ثم 8 ثوانٍ، وبعدها زر تحديث. هذه سياسة UI وليست مهلة API. امنع أكثر من loop/request group متزامن.
- [ ] close/background/logout/account switch يلغي timer أو يبطل generation. نتيجة subscription/account قديم لا تعرض ولا تُخزن للحساب الجديد.
- [ ] 401 يعالج ضمن session flow، network failure يعرض retry مترجم، و409 بكود آخر ليس preparing.
- [ ] اختبر refresh متكرر أثناء request؛ لا overlap؛ retry بعد exhaustion يعمل GET فقط. افتح التقويم بعد restart عبر recovery القائم بدون POST جديد.
- [ ] لا تزيل mapping لمحاولة الدفع قبل أن تسمح سياسة Payzah القائمة بذلك؛ عدم تجهيز التقويم ليس سببًا لفقدان recovery.

## 10. Task 7 — حقول اليوم وصلاحية التعديل من السيرفر

**Modify:**
- `lib/features/calendar/data/models/response/calendar_day_response_dto.dart`
- `lib/features/calendar/data/mapper/calendar_day_mapper.dart`
- `lib/features/calendar/domain/entities/calendar_day_entity.dart`
- `calendar_days_builder.dart` و`calendar_meals_merger.dart` في presentation/helpers عند نسخ الحقول.
- ViewModels `flow/calendar_flow_view_model.dart` و`meal_selection/meal_selection_view_model.dart` و`restaurant_picker/restaurant_picker_view_model.dart` وoverview عند الحاجة.
- widgets selected day/content/save button/picker وشاشة `calendar_meal_selection_screen.dart`.

**Tests:** `test/calendar_edit_permission_contract_test.dart`، واستكمل calendar flow/meal selection/restaurant picker/confirm tests.

**Interface:** entity يحمل `editBlockReason` String? و`selectionDeadlineUtc` DateTime? و`lockAtUtc` DateTime? و`lockRemainingSeconds` int? و`filledCount` int? و`requiredCount` int? بجانب الحقول القائمة. حافظ على editDeadlineUtc القديم لمستهلكيه إن لزم، لكن لا تدمج selection deadline وlock timestamp في حقل واحد للعرض الجديد.

- [ ] أضف parsing/mapping/copyWith tests لحفظ كل حقل وإعادة بناء entity؛ counters الغائبة لا تتحول إلى نجاح completion.
- [ ] اختبار حاسم للسلوك الحالي: status=Confirmed أو pending أو locked مع canEdit=true → editable=true؛ canEdit=false مع يوم مستقبلي/countdown موجب → false؛ null → false.
- [ ] أصلح getter إلى:

```dart
bool get isEditable => canEdit == true;
```

- [ ] افصل status badges/presentation عن permission. لا تمنع UI عبر `isFrozen` أو `isLocked` إذا خالف CanEdit=true. إذا كان response متناقضًا، أعد fetch بدل إعادة تعريف تصريح محلي؛ اجعل counters وbadges descriptive.
- [ ] لا تجعل mapper يفرض isLocked بناءً على status بحيث يستخدمه widget كحراسة أوسع من CanEdit. افحص كل `isEditable`/`canEdit`/`isLocked` داخل النطاق.
- [ ] حراسة كل mutation داخل ViewModel قبل إرسالها، بالإضافة للـbuttons: restaurant selection، slot save، complete، وأي auto-select موجود. افحص latest loaded day، لا snapshot الشاشة القديمة.
- [ ] أثناء refresh لليوم أو mutation جارٍ امنع mutation إضافية؛ هذا منع تزامن وليس سياسة قفل يوم محلية.
- [ ] عند رفض الخادم mutation بسبب تغير الحالة: اعرض code مترجم ثم refresh اليوم والتقويم؛ لا retry POST تلقائيًا ولا تعتبر optimistic draft محفوظًا.
- [ ] حافظ على UTC؛ عرض موعد محلي باستخدام convention المشروع، واختبر formatting دون تغيير timestamp. لا تربط ConfirmedAtUtc بساعة الدفع.
- [ ] شغّل الاختبارات؛ راجع أي test قديم يتوقع أن status وحده يمنع التعديل وعدله للعقد الجديد مع retaining عرض status الصحيح.

## 11. Task 8 — اختيار المطعم والوجبات وإكمال اليوم

**Modify only after schema validation:** `network_constants.dart`، `api_services.dart`، `calendar_remote_data_source.dart`/impl، `calendar_repository.dart`/impl، usecases الحالية، `calendar_set_restaurant_request_dto.dart`، `calendar_save_meals_request_dto.dart`، `calendar_request_mapper.dart`، meal-selection/flow ViewModels.

**Tests:** `test/calendar_slot_request_contract_test.dart`، `calendar_restaurants_request_test.dart`، `calendar_confirm_meals_test.dart`، `calendar_meal_selection_cubit_test.dart`.

- [ ] احصل على body/schema الحقيقيين للـrestaurant وslot وcomplete. إذا Swagger ناقص، اطلب فقط bodies الناقصة من الباك؛ لا تخترع slot/mealIds/count fields أو enum values.
- [ ] أضف transport tests تثبت path/date/body/HTTP method للثلاثة، وفق schema المؤكد، بما فيها رفض تمرير restaurantId غير المعتمد لليوم.
- [ ] إذا `/meals/slot` يختلف عن حفظ قائمة الوجبات الحالي، أضف request DTO مستقل باسم `CalendarSaveMealSlotRequestDto` في مجلد request القائم، وعدّل usecase القائم أو أضف slot usecase ضمن نفس architecture. لا تستخدم body القديم بتغيير path فقط.
- [ ] احفظ slot بالنوع/العدد المقرر من `SlotRequirements`، واقرأ الحالة النهائية من response/day refresh. إذا contract يحتاج index للوجبة داخل slot، استخدم القيمة المعتمدة فقط.
- [ ] لا complete قبل نجاح كل saves اللازمة؛ failure في save لا يظهر success ولا يزيل draft بصمت. complete response هو دليل تأكيد اليوم؛ اختيار الوجبات محليًا ليس تأكيدًا.
- [ ] بعد تغيير المطعم، استعمل نتيجة السيرفر لتحديث meals/requirements؛ لا تحمل meals مطعم سابق إلى مطعم جديد.
- [ ] اختبر filled<required وfilled=required وفق rules المستقاة من API. لا تجعل عدد عناصر قائمة UI بديلًا عن counters/requirements.
- [ ] اختبر طلب قديم لوجبات restaurant A يكتمل بعد اختيار B؛ لا يستبدل القائمة الجديدة. اختبر complete مرتين، day switch أثناء save، ورفض CanEdit مع event مباشر.
- [ ] احتفظ pagination/search وأهلية safe meals الحالية ولا توسّع النطاق لتعديل قواعد الحساسية.

## 12. Task 9 — الترجمة ورسائل الحالات وتبديل اللغة

**Modify:** `lib/core/l10n/app_ar.arb` و`app_en.arb` وكل locale فعلي configured، localization generated عبر gen-l10n، error mapper/coverage banner/day state widgets القائمة. أضف widget مستقل لحالة منع تعديل اليوم فقط إذا لا يوجد مكوّن قابل لإعادة الاستخدام.

**Tests:** `test/subscription_availability_localization_test.dart`، `test/calendar_edit_block_reason_localization_test.dart`، واختبارات عرض اليوم والعنوان القائمة.

أسماء ARB camelCase التالية مقترحة؛ أعد استخدام keys موجودة ذات نفس المعنى قبل إضافة أخرى. placeholders لها metadata types المناسبة. الأكواد نفسها لا تُترجم.

| ARB key | العربية | English |
|---|---|---|
| subscriptionFirstDelivery | بداية الاشتراك وأول توصيل: {date} | Subscription start and first delivery: {date} |
| subscriptionPaymentAnchor | تاريخ الاختيار: {date} | Selected payment date: {date} |
| subscriptionNoRestaurantsForAddress | لا توجد مطاعم تقدم برنامج {programName} وتوصل إلى عنوانك المحدد. | No restaurants offer the {programName} program and deliver to your selected address. |
| subscriptionNoRestaurantsForSelection | لا توجد مطاعم متاحة طوال مدة الاشتراك وفق اختياراتك الحالية. | No restaurants are available throughout the subscription period with your current selections. |
| subscriptionAvailabilityChanged | تغير توافر المطاعم. راجع الملخص قبل إعادة محاولة الدفع. | Restaurant availability changed. Review the summary before trying payment again. |
| calendarPreparing | جارٍ تجهيز تقويم اشتراكك بعد تأكيد الدفع. | Your subscription calendar is being prepared after payment confirmation. |
| calendarSelectionDeadline | يمكنك اختيار الوجبات حتى {dateTime}. | You can select meals until {dateTime}. |
| calendarSelectionDeadlinePassed | انتهت مهلة اختيار الوجبات لهذا اليوم. | The meal selection deadline for this day has passed. |
| calendarDayLocked | تم إغلاق التعديل لهذا اليوم. | Editing is closed for this day. |
| calendarDayFrozen | هذا اليوم مجمّد ولا يمكن تعديله الآن. | This day is frozen and cannot be edited now. |
| calendarDayCancelled | تم إلغاء هذا اليوم. | This day was cancelled. |
| calendarFulfillmentNotReady | التقويم غير جاهز بعد. حاول التحديث بعد قليل. | The calendar is not ready yet. Refresh in a moment. |

- [ ] اكتب widget test بنفس state وأكواد API: ar → en → ar دون إعادة تشغيل، فتتغير الرسائل والتواريخ وأسماء البرامج والمطاعم والوجبات.
- [ ] احفظ codes وNameAr/NameEn في state/entity؛ اختَر النص داخل presentation بناءً على locale الحالية. إذا mapper حاليًا يخزن اسمًا مترجمًا فقط، أضف الحقول الثنائية ضمن النطاق أو أعد mapping من DTO محفوظ عند تبديل اللغة؛ لا تجعل تبديل اللغة يحتاج mutation أو إعادة دفع.
- [ ] أضف mapping دقيق للحالات الخمس وأسباب منع اليوم الخمسة وأسباب checkout. unknown code يظهر رسالة عامة مترجمة مناسبة دون code خام أو raw exception، ودون السماح بالتعديل/الدفع.
- [ ] tests للـplaceholders، programName باللغة الحالية، null deadline، يوم بدون lock info، وحالة overflow في RTL/LTR مع text scale أكبر.
- [ ] أضف semantics لأزرار refresh وتعديل التاريخ والحالات المعطلة وفق patterns الموجودة، دون تغيير الهوية البصرية.
- [ ] شغّل gen-l10n ثم الاختبارات. لا تعدل ملفات localization generated باليد.

## 13. التحقق النهائي

نفّذ من جذر المشروع، format فقط ملفات Dart المعدلة. الملفات التالية الجديدة يجب أن تكون موجودة بحلول هذه المرحلة؛ الاختبارات القديمة المستهدفة تُشغّل أيضًا ضمن suite.

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
flutter test test/subscription_anchor_date_test.dart
flutter test test/subscription_availability_mapper_test.dart
flutter test test/subscription_availability_endpoint_test.dart
flutter test test/subscription_contextual_availability_test.dart
flutter test test/subscription_checkout_permission_test.dart
flutter test test/subscription_address_availability_refresh_test.dart
flutter test test/payment_availability_changed_test.dart
flutter test test/calendar_preparing_state_test.dart
flutter test test/calendar_edit_permission_contract_test.dart
flutter test test/calendar_slot_request_contract_test.dart
flutter test test/subscription_availability_localization_test.dart
flutter test test/calendar_edit_block_reason_localization_test.dart
flutter test test/core/payment
flutter test
git diff --check
git status --short
```

- [ ] راجع generated diff حتى لا تدخل API/DI changes غير مرتبطة. فشل build أو test يُحل داخل النطاق أو يسجل مع baseline ودليل؛ لا تُحذف tests لمجرد تمرير suite.
- [ ] ابحث بـ`rg` عن استخدام response.startDate في requests، وعن حساب offsets للتوصيل، وعن permissions مبنية على status/deadline داخل النطاق. افحص النتائج واحدة واحدة، ولا تستبدل كل `Duration(days:...)` عشوائيًا.
- [ ] راجع diff مقابل قواعد UI: لا نصوص hardcoded، theme/spacing سليمان، rebuild scope محدود، وwidgets الجديدة منفصلة.
- [ ] build للمنصة المتاحة محليًا وفق إجراءات المشروع؛ لا تدّعِ اختبار iOS على Windows. قيود SDK/device/network تذكر صراحة.

## 14. قبول حي بعد نشر الباك

بحساب اختبار مصرح، دون بيانات دفع حقيقية أو تنظيف اشتراكات بالحذف:

| السيناريو | الدليل المطلوب |
|---|---|
| اختيار 8 أكتوبر والخادم يعيد 11 | request anchor 08، عرض first delivery 11، checkout anchor 08 |
| تطبيق/إزالة كوبون ثم pagination | anchor ثابت، finalPrice من الخادم، الإجمالي لا يساوي طول الصفحة |
| عنوان خارج التغطية | no_restaurants_for_address مترجمة وزر الدفع معطل |
| عنوان متغطّي لكن الفترة غير مؤهلة | no_restaurants_for_selection، covered وeligible مميزان |
| تغيير المدة/الفئة/الجمعة/العنوان | GET بسياق جديد، النتائج القديمة لا تظهر كصالحة |
| تغير الأهلية بين summary وcheckout | رسالة واضحة، تحديث الاستعراض والملخص، لا POST تلقائي |
| الدفع confirmed والتقويم غير جاهز | preparing/refresh؛ 409 الصحيح؛ لا نجاح اختيار وجبات زائف |
| التقويم يصبح جاهزًا | أيام فعلية لذات subscriptionId، انتقال واحد |
| يوم CanEdit=true رغم status سابق | الاختيار متاح وتصريح mutation من الخادم |
| يوم CanEdit=false | كل mutation ممنوعة، سبب مترجم وموعد من API عند توفره |
| save slots ثم complete | body مطابق للعقد، counters/اليوم النهائي من الخادم |
| تبديل ar/en/ar | الرسائل والأسماء والتواريخ تتغير بلا restart |
| restart/account switch أثناء recovery | لا checkout جديد ولا بيانات حساب سابق |

إذا لا يمكن توليد حالة حيًا، اختبرها بفake محلي واذكر أنها لم تُختبر على الخدمة. لا تتسبب في دفع/إلغاء/تعديل بيانات حساب حقيقي لتوليد fixture. نجاح المحلي لا يثبت نشر route أو صحة حساب/سعر حي.

## 15. تسليم Gemini المطلوب

- ملخص ما تغير والملفات الأساسية، مع فصل تغييراتك عن الملفات المعدلة مسبقًا.
- schemas والمسارات المؤكدة من الباك المنشور، ومعنى anchor مقابل first delivery، وشكل slot body المعتمد.
- نتائج analyzer/tests/build بالأوامر الفعلية؛ baseline failures وأسباب عدم تشغيل أي check.
- جدول القبول السابق بنتيجة PASS/FAIL/NOT RUN ودليل منقح، مع تحديد محلي مقابل حي.
- أي blockers متبقية بدقة: backend rules مفقودة، schema لم ينشر، body ناقص، callback conflict، أو حساب اختبار غير متاح؛ لا تقل إن المهمة كاملة إذا بقي ربط مطلوب غير منفذ.
- تأكيد عدم حساب تاريخ التوصيل محليًا، وعدم استنتاج التوافر من طول الصفحة، وعدم replay checkout، وعدم تغيير contract Payzah اعتمادًا على أمثلة الباك.
- لا push/merge/deploy ولا حذف/إلغاء/استرداد اشتراك ضمن هذه المهمة.
