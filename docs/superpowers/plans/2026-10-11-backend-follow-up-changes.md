# Backend Changes Follow-up Plan — 2026-10-11

> **For agentic workers:** Execute this plan only after the original subscription integration plan has been completed. Do not change UI design without explicit approval.

**Goal:** تطبيق التحديثات الجديدة فقط من ملف الباك الأخير على تطبيق العميل، مع الحفاظ على كل ما نُفذ سابقًا.

**References:**
- `C:\Users\orignal store\.codex\attachments\65413c4c-72fa-46f5-bd8f-edf533bfaa7d\Pasted text.txt`
- `rules/rules_backend.md`
- `lib/core/errors`

## Scope Exclusion

اترك خارج هذه الخطة برومبتات مكالمات المندوب والعميل وملف `customer-voice-fixes.patch`؛ هذه تغييرات مستقلة على voice calls وليست ضمن تحديث الاشتراك.

## Global Rules

- لا تغيير في التصميم، الألوان، المسافات، الخطوط، الـ layout أو navigation.
- لا refactor خارج الملفات اللازمة، ولا architecture جديدة.
- استخدم `ApiServices`, Dio, `safeApiCall`, `ApiResult`, Injectable والـ layers الحالية.
- لا تعدّل `*.g.dart` أو ملفات DI المولدة يدويًا.
- لا تعتبر القائمة الفارغة غير مؤكدة؛ القائمة الفارغة المؤكدة تكمل الخطوة.
- استخدم قيم السيرفر كمصدر حقيقة، وتجاهل responses القديمة عند تغير السياق.
- راجع الأداء باستخدام `BlocSelector`/`buildWhen` ومنع الطلبات المكررة.

### Task 1: ترتيب المتطلبات وتوجيه الخطوات

**Files:** ملفات DTO/entity/mapper/view-model الحالية الخاصة بـ subscription types, prerequisites, programs, bundles.

- [ ] طبّق الترتيب الإلزامي: `ADDRESS` ثم `ALLERGIES` ثم `DIETARY_PREFERENCES`.
- [ ] اربط `messageCode`, `missingStep`, `actionEndpoint` من `availability`.
- [ ] عند غياب العنوان: `address_required`, `canSelect=false`, `checkout.address_required`.
- [ ] بعد العنوان: `allergies_required`، ثم `dietary_preferences_required`.
- [ ] اعتبر القائمة الفارغة مكتملة فقط مع `AllergiesCompletedAtUtc` أو `DietaryPreferencesCompletedAtUtc`.
- [ ] افتح `actionEndpoint` للقراءة فقط في الحساسية والتفضيلات، واحفظ التأكيد عبر شاشة البيانات الحالية.
- [ ] لا تحول نقص الحساسية أو التفضيلات إلى نقص سعر أو تغطية.

### Task 2: فصل عقود الكتالوج القديمة والجديدة

**Files:** `ApiServices`, network constants، DTOs/mappers/repositories الخاصة بالبرامج والباقات والفئات.

- [ ] حافظ على `/programs/{programId}/bundles` القديم بغلاف `bundles` وحقول `hasDeliveryAddress`, `hasAllergies`, `hasDietaryPreferences`, `isProfileComplete`.
- [ ] حافظ على `/catalog/programs/{programId}/bundles` الجديد باستخدام `items[].option` و`items[].availability`.
- [ ] لا تستبدل `/programs` القديم بغلاف catalog؛ استخدم `/catalog/programs` للتغطية العامة فقط.
- [ ] أبقِ البطاقات غير المتاحة ظاهرة ومعطلة، واحترم `canSelect=false`.
- [ ] اجعل البرنامج متاحًا فقط عند وجود باقة واحدة على الأقل لها مطعم معتمد وفعال يغطي العنوان.
- [ ] فسّر `coveredRestaurantCount` بدون عنوان كعدد عارض، و`eligibleRestaurantCount=null` كعدم إجراء فحص فترة.

### Task 3: إبطال الكاش وتغيير السياق

**Files:** cache/state/view-model الحالية للعنوان والكتالوج.

- [ ] عند إضافة أو تعديل أو تغيير عنوان التوصيل النشط، أطلِق cache لمسارات البرامج والباقات والفئات فورًا.
- [ ] ألغِ الاختيارات اللاحقة وأعد تحميل الكتالوج بالعنوان الجديد.
- [ ] أعد الفحص بعد تأكيد الحساسية أو التفضيلات.
- [ ] اربط كل request بسياقه، وتجاهل response من سياق قديم.
- [ ] اختبر تغيير العنوان أثناء وجود طلب catalog قيد التنفيذ.

### Task 4: عقد التقويم والاستبدال

**Files:** DTO/entity/mapper/data source/view model تحت `lib/features/calendar/`.

- [ ] أضف/اربط `lockRemainingSeconds`, `selectionDeadlineUtc`, `canEdit`, `editBlockReason`, `failureReasonCode`.
- [ ] استخدم endpoints: calendar، day، restaurants، restaurant meals، available meals، restaurant selection، meal slot، complete، confirm، auto-select.
- [ ] بعد كل كتابة أعد GET لليوم والتقويم، وعند عودة التطبيق أو انتهاء العد.
- [ ] ميّز `CustomerSelected` (محفوظ) عن `SentToRestaurant` (مرسل).
- [ ] لا تعتبر complete/confirm أو نجاح الدفع إرسالًا للمطعم دون الحالة التي يرسلها السيرفر.
- [ ] استخدم `canEdit` و`editBlockReason` كما يرسلهما السيرفر؛ لا تمدد المهلة محليًا.
- [ ] اربط أسباب القفل: `selection_deadline_passed`, `day_locked`, `day_frozen`, `day_cancelled`.
- [ ] عند `calendar.no_safe_box` بعد تغيير الحساسية، أعد قراءة اليوم حتى مع HTTP failure، واعرض `ReplacementRequired` دون تثبيت وجبات أو نجاح وهمي.
- [ ] اختبر الاستبدال `A → B → A`، وعدم تمديد النافذة بإعادة الفتح، والقفل عند الحد بالضبط.

### Task 5: الاختيار التلقائي والتغطية

**Files:** calendar selection/restaurant view models and mappers.

- [ ] اجعل auto-select يلتزم بقائمة المطاعم المؤهلة، ويتجنب busy/quota عند وجود بديل.
- [ ] عند رفض السعة جرّب البدائل المؤهلة؛ عند استنفادها اعرض السبب الحالي ولا تؤكد محليًا.
- [ ] عند `calendar.restaurant_coverage_unavailable` أعد قراءة اليوم والمطاعم، ولا تعرض نجاح الإرسال أو تبقِ المطعم القديم متاحًا.
- [ ] لا تستخدم menu من تاريخ آخر؛ غياب menu لليوم يعرض `calendar.box_not_ready`.
- [ ] اقرأ `failureReasonCode` من تفاصيل اليوم والملخص وبيانات push، وافتح اليوم للحصول على الحالة الحالية.

### Task 6: التجميد والـ migrations الخارجية

**Files:** freeze DTOs/data source/repository/use case/view model، errors/localization.

- [ ] استخدم freeze policy وfreeze details وfreeze requests الحالية.
- [ ] عند `Approved` أعد تحميل التقويم والتواريخ مباشرة.
- [ ] اربط: `freeze.preparation_unavailable`, `freeze.replacement_pool_unavailable`, `freeze.replacement_capacity_unavailable`, `freeze.replacement_restaurants_unavailable`, `freeze.no_service_days`, `freeze.locked_days_cannot_be_frozen`.
- [ ] لا تعرض نجاح تمديد عند فشل التحضير، ولا تؤكد أيام التعويض تلقائيًا.
- [ ] وثّق كشرط نشر خارجي وجود migrations `20261011090000_AddSubscriptionDayReplacementWindow` و`20261010173000_AddSubscriptionDayFailureReasonCode`؛ لا تنفذ migrations داخل Flutter ولا تصطنع نافذة للسجلات القديمة.

### Task 7: الترجمة والاختبارات والأداء

- [ ] أضف رسائل الأكواد الجديدة للعربية والإنجليزية مع عدم ترجمة identifiers.
- [ ] اختبر `ar → en → ar`، RTL/LTR، loading/error/empty/dialog.
- [ ] أضف اختبارات ترتيب المتطلبات، القوائم الفارغة المؤكدة، الكاش، الردود القديمة، `CustomerSelected/SentToRestaurant`, `no_safe_box`, replacement window، وfreeze errors.
- [ ] شغّل `dart format`, `flutter analyze`, الاختبارات المتأثرة و`flutter test`.
- [ ] شغّل build_runner فقط إذا تغيّرت Retrofit/json_serializable/injectable annotations.
- [ ] راجع عدم تكرار الطلبات وعدم إعادة بناء الشاشة كاملة عند تغير يوم واحد.

## Acceptance Checklist

- كل تحديثات الملف الجديد مغطاة دون إعادة تنفيذ التعديلات السابقة.
- لا يوجد تغيير تصميم غير مصرح.
- لا توجد بيانات وهمية أو نجاحات محلية غير مؤكدة.
- كل الكتابات يعقبها GET، والمهل والأسباب مصدرها السيرفر.
- اختبارات العقد والتغطية والتقويم والتجميد والترجمة والأداء تمر.
