# Family Package Days Refactor Plan

## الهدف

تحسين أداء وتنظيم `lib/features/family_package_days` مع الحفاظ على تحميل الصفحة كاملًا بالتوازي، وعدم تغيير شكل الواجهة أو تدفق المستخدم.

## المرحلة 1: فصل حالات التحميل والأخطاء

**الملف:**

- `lib/features/family_package_days/presentation/manager/family_package_days_state.dart`

إضافة حالة مستقلة لكل مصدر بيانات:

- `programsLoading` / `programsFailure`
- `bundlesLoading` / `bundlesFailure`
- `durationsLoading` / `durationsFailure`
- `tiersLoading` / `tiersFailure`

يبقى الخطأ العام مخصصًا للأخطاء العامة مثل current flow.

الهدف أن فشل `tiers` لا يخفي نجاح `bundles` أو `durations`.

## المرحلة 2: تنظيم تحميل البيانات

**الملف:**

- `lib/features/family_package_days/presentation/manager/family_package_days_view_model.dart`

فصل عمليات التحميل إلى:

- `_loadPrograms()`
- `_loadBundles()`
- `_loadDurations()`
- `_loadTiers()`
- `_loadMemberData()`

عند فتح الصفحة يتم تحميل `bundles` و`durations` و`tiers` بالتوازي.

كل عملية تحدث حالة loading/error الخاصة بها فقط.

## المرحلة 3: منع التكرار والطلبات القديمة

الحفاظ على التحسينات الحالية:

- cache للبيانات الناجحة.
- request key لكل مجموعة اختيارات.
- request tokens لمنع تطبيق النتائج القديمة.
- debounce للـ custom duration.
- منع تحميل نفس العضو مرتين.
- إلغاء timer عند إغلاق الـ ViewModel.

إضافة مشاركة للطلب الجاري بدل تجاهل الاستدعاء الثاني.

## المرحلة 4: تحسين الـ skeleton

**الملفات:**

- `family_package_days_setup_screen.dart`
- widgets الخاصة بالـ package والـ duration والـ plan

السلوك المطلوب:

- skeleton عام فقط أثناء تحميل current flow وعدم وجود أعضاء.
- skeleton خاص بالـ bundles أثناء تحميل bundles.
- skeleton خاص بالـ durations أثناء تحميل durations.
- skeleton خاص بالـ tiers أثناء تحميل tiers.
- عرض كل بيانات انتهى تحميلها فورًا دون انتظار باقي الطلبات.

## المرحلة 5: تحسين عرض الأخطاء

كل قسم يعرض خطأه بشكل مستقل:

- خطأ bundles يعيد bundles فقط.
- خطأ durations يعيد durations فقط.
- خطأ tiers يعيد tiers فقط.
- الخطأ العام يظل مخصصًا لفشل current flow.

## المرحلة 6: تقليل إعادة البناء

**الملفات:**

- `family_package_days_setup_screen.dart`
- `family_package_days_content.dart`
- widgets الخاصة بالأقسام

استخدام:

- `BlocSelector`
- `buildWhen`
- builders منفصلة لكل section

النتيجة المطلوبة:

- تغيير tiers لا يعيد بناء header.
- تغيير الأيام لا يعيد بناء قائمة الأعضاء.
- تغيير العضو يعيد بناء الأقسام التابعة له فقط.
- app bar والـ stepper يظلان ثابتين.

## المرحلة 7: تبديل الأعضاء

عند اختيار عضو:

1. تحديث العضو المحدد فورًا.
2. إظهار loading للأقسام التابعة له فقط.
3. تحميل بياناته كاملة بالتوازي.
4. تجاهل response قديم لعضو سابق.
5. عرض البيانات الجديدة دون التأثير على باقي الصفحة.

## المرحلة 8: الحفظ

الحفاظ على contract الحفظ الحالي.

قبل الحفظ يتم التأكد من وجود:

- `programId`
- `bundleId`
- `durationDays`
- `tier`
- `includeFriday`
- `memberId`

بعد النجاح:

- تحديث current flow.
- تحديث العضو الحالي.
- الانتقال للعضو التالي أو checkout كما هو حاليًا.

## المرحلة 9: الاختبارات

إضافة أو تحديث اختبارات لـ:

- skeleton العام.
- skeleton مستقل لكل section.
- فشل bundles مع نجاح durations.
- فشل tiers مع نجاح باقي البيانات.
- عدم تكرار requests.
- تبديل عضو قبل اكتمال request.
- تجاهل response قديم.
- debounce للمدة.
- حفظ الخطة والانتقال الصحيح.

## المرحلة 10: التحقق النهائي

تشغيل:

```bash
dart format lib test
flutter analyze
flutter test
```

ثم مراجعة:

- عدد الملفات المعدلة.
- عدم تعديل `core/errors` بدون حاجة.
- عدم تغيير شكل أو تدفق المستخدم.
- عدم وجود warnings أو imports غير مستخدمة.
