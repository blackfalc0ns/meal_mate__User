# Backend Follow-up Plan 3 — Restaurant Readiness and Period Context

> **For agentic workers:** This is a standalone follow-up plan. Execute only after the previous backend plans are complete. Do not change the UI design without explicit approval.

**Goal:** تطبيق التعديلات الجديدة الخاصة بجاهزية المطاعم والبرنامج والباقة، وسياق المدة والتاريخ والجمعة، بدون إعادة تنفيذ التعديلات السابقة.

**Source:** `C:\Users\orignal store\.codex\attachments\cfea03e9-4035-4244-ac4f-5fe4e486dc61\Pasted text.txt`

**Rules:** `rules/rules_backend.md`, `lib/core/errors`.

## Scope exclusions

- لا تعيد تنفيذ متطلبات الاشتراك أو التقويم أو التجميد الموجودة في الخطط السابقة.
- اترك برومبتات مكالمات المندوب والعميل وملف voice patch خارج هذا العمل.
- لا تغيير في التصميم أو الألوان أو spacing أو typography أو navigation.

### Task 1: جاهزية البرنامج والباقة والفئة

**Files:** DTOs, entities, mappers, repositories, data sources and ViewModels الموجودة في features البرامج والباقات والفئات والمطاعم.

- [ ] اعتبر `canSelect=false` مانعًا لاختيار البرنامج أو الباقة أو الفئة.
- [ ] أضف/اربط الحالة `subscription_flow.no_prepared_restaurants` عندما توجد تغطية، لكن لا يوجد مطعم يملك وجبات مؤهلة كافية وأسعارًا صالحة.
- [ ] افصل بين التغطية والجاهزية: لا تستخدم `availability.coveredRestaurantCount` لعرض الشعارات أو إثبات الجاهزية.
- [ ] اعرض قائمة `restaurants` والعداد من المطاعم الجاهزة فقط.
- [ ] عند عدم الجاهزية أو غياب العنوان أو عدم تأكيد الحساسية/التفضيلات، اجعل قائمة الشعارات فارغة ولا تعرض شعارات محفوظة من طلب سابق.
- [ ] أعد readiness وsummary قبل الدفع؛ لا تعتمد على آخر استعراض للمطاعم لأن بيانات التشغيل قد تتغير.

### Task 2: سياق المطاعم حسب الفترة

**Files:** `ApiServices`, network constants، subscription tier restaurant remote data source/repository/use case/ViewModel، DTOs/mappers، والاختبارات الحالية للمطاعم.

- [ ] حدّث مسار `/programs/{programId}/bundles/{bundleId}/tiers/{tier}/restaurants` ليدعم `durationDays`, `startDate`, `includeFriday`.
- [ ] أرسل نفس مدة وتاريخ البداية وخيار الجمعة المستخدمين في summary، ودع السيرفر يحوّل التاريخ لأول توصيل.
- [ ] ادعم المسار المقابل بدون `bundleId` إذا كان موجودًا حاليًا، مع نفس query parameters.
- [ ] حافظ على pagination عند تمرير هذه المعلمات.
- [ ] عند عدم وجود مدة/تاريخ، اعرض مطاعم جاهزة من حيث التغطية والأسعار ومخزون الوجبات فقط، ولا تدّعِ صلاحية كل أيام الفترة.
- [ ] بعد تحديد المدة والتاريخ، أعد تحميل المطاعم بالسياق الجديد أو استخدم `/restaurant-availability` لقراءة `availability.failureReasons` والقائمة والعداد المؤهل الصحيح.
- [ ] إذا مررت مدة أو تاريخًا فقط، أكمل السياق من الحالة الحالية؛ لا تستبدل الخطأ بقائمة مخزنة.
- [ ] إذا أصبح المطعم غير جاهز أو غير مغطى، امنع فتح التفاصيل اعتمادًا على معرف قديم وأعد قراءة القائمة.

### Task 3: الرسائل والأخطاء

**Files:** `lib/core/errors/`, `lib/core/network/failuer_mapper.dart`, localization resources and restaurant presentation mappers.

- [ ] أضف `noPreparedRestaurants` إلى الترجمة العربية والإنجليزية بالمفتاح `subscription_flow.no_prepared_restaurants`.
- [ ] فرّق في العرض بين `no_delivery_to_address`, `no_restaurants_for_address`, `no_prepared_restaurants`, `no_restaurants_for_selection`, و`pricing_unavailable`.
- [ ] لا تعرض raw backend details ولا تحول عدم الجاهزية إلى قائمة فارغة ناجحة.
- [ ] حافظ على الرسائل الموجودة لباقي الأكواد، ولا تترجم identifiers.

### Task 4: اختبار الأداء والعقود

**Files:** اختبارات features المطاعم والباقات والفئات والتغطية والـ readiness/summary.

- [ ] اختبر covered count موجبًا مع `canSelect=false` وعدم ظهور شعارات.
- [ ] اختبر `no_prepared_restaurants` مع تغطية موجودة، ومطاعم جاهزة جزئيًا، وأسعار أو وجبات مؤهلة ناقصة.
- [ ] اختبر إرسال `durationDays`, `startDate`, `includeFriday` في endpoint ذي tier وbundle، وفي endpoint بدون bundle إن كان مستخدمًا.
- [ ] اختبر pagination مع query context وعدم استخدام نتائج سياق سابق.
- [ ] اختبر تغيير التاريخ أو المدة وإعادة تحميل المطاعم، ثم readiness/summary قبل checkout.
- [ ] راجع `BlocSelector`/`buildWhen` ومنع إعادة بناء القائمة كاملة عند تغير availability جزئي، ومنع الطلبات المكررة لنفس السياق.
- [ ] شغّل `dart format`, `flutter analyze`, الاختبارات المتأثرة، وbuild_runner فقط عند تعديل annotations.

## Acceptance checklist

- المطاعم والشعارات والعداد تعكس الجاهزية الفعلية فقط.
- `coveredRestaurantCount` لا يفتح اختيارًا ولا يثبت الدفع.
- سياق المطاعم يطابق مدة وتاريخ وخيار الجمعة في summary.
- تغيير السياق يلغي النتائج القديمة ويعيد القراءة.
- رسالة `no_prepared_restaurants` مترجمة ومميزة عن عدم التوصيل أو عدم تغطية الخيار.
- لا يوجد تغيير تصميم أو بيانات وهمية أو نجاح دفع مبني على استعراض المطاعم.
