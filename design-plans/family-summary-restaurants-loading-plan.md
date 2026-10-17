# خطة تطوير ملخص اشتراك العائلة وعرض المطاعم

## الهدف

تحديث شاشة ملخص اشتراك العائلة بحيث تعرض لكل فرد:

- أسماء المطاعم المتاحة له على شكل شعارات فقط.
- عدد تكرار المطاعم كقيمة عامة واحدة خلال مدة الاشتراك.
- حالة التحميل باستخدام `flutter_animate: 4.5.2` مع الحفاظ على نفس تصميم الـ shimmer الحالي.
- مؤشر `CustomProgressIndicator` في منتصف الشاشة أثناء تحميل طلب الـ summary.

## البيانات القادمة من الـ API

الـ endpoint المستخدم هو:

`GET /api/v1/customer/family-subscription-flow/summary`

الجزء المطلوب من الاستجابة هو `memberSchedules`، وكل عنصر يحتوي على:

- `memberId`: لربط الجدول بفرد العائلة.
- `mealsPerDay`, `totalMeals`, `deliveryDaysCount`: معلومات مساعدة للملخص.
- `restaurants`: قائمة المطاعم الخاصة بالفرد.
- `restaurants[].restaurantId`: مفتاح ثابت للعنصر.
- `restaurants[].logoUrl`: الصورة التي ستظهر في الواجهة.
- `restaurants[].name` و`nameAr`: الاسم البديل للوصولية أو عند فشل تحميل الصورة.
- `restaurants[].occurrenceCount`: عدد مرات تكرار المطعم.
- `restaurantRepetition.limit`: الحد المسموح للتكرار العام.
- `restaurantRepetition.restaurantCount`: عدد المطاعم المستخدمة.

يجب عدم حساب التكرار من الواجهة؛ يتم عرض `occurrenceCount` كما يرجع من الـ API.

## المرحلة 1: مراجعة وربط الـ DTO والـ Entity

1. مراجعة:
   - `family_summary_response_dto.dart`
   - `family_summary_entity.dart`
   - `family_checkout_mapper.dart`
2. التأكد من أن `memberSchedules` و`restaurants` و`occurrenceCount` و`logoUrl` ممثلة في DTO وEntity.
3. إذا كانت الحقول موجودة، إعادة استخدامها بدون إنشاء موديلات بديلة.
4. إذا كان أي حقل غير موجود، إضافته في ملفات الـ response/domain/mapper فقط، مع الحفاظ على null safety والتعامل مع `logoUrl == null`.
5. تشغيل `build_runner` بعد تعديل DTO annotations والتأكد من تحديث ملفات `.g.dart`.

## المرحلة 2: تجهيز حالة الـ ViewModel

1. مراجعة `family_checkout_view_model.dart` و`family_checkout_state.dart`.
2. التأكد من أن تحميل الـ summary له حالات واضحة:
   - initial
   - loading
   - success
   - failure
3. الاحتفاظ بالـ summary داخل state بشكل immutable.
4. ربط كل schedule بـ `memberId` بدل الاعتماد على ترتيب القوائم.
5. عند اختيار فرد، استخراج schedule الخاص به من الـ state باستخدام `memberId`.
6. عدم إضافة state أو event جديد إذا كان التدفق الحالي يغطي هذه الحالات بالفعل.

## المرحلة 3: ويدجت مطاعم الفرد

إنشاء ويدجت feature-specific داخل مجلد widgets، مثل:

`lib/features/family_checkout/presentation/widgets/family_member_restaurants.dart`

مسؤولياته:

1. استقبال `MemberScheduleEntity` أو قائمة المطاعم الخاصة بالفرد.
2. عرض الشعارات فقط في صف أو قائمة أفقية حسب الـ Figma.
3. استخدام `Image.network(logoUrl)` مع:
   - `errorBuilder` لعرض placeholder من الثيم عند فشل الصورة.
   - `loadingBuilder` أو placeholder أثناء تحميل كل شعار.
   - `ValueKey(restaurantId)` للحفاظ على هوية العنصر.
4. عدم وضع اسم المطعم كنص مرئي إذا كان المطلوب الشعارات فقط.
5. إضافة `Semantics` باسم المطعم وعدد مرات التكرار، حتى يظل المحتوى مفهومًا لقارئات الشاشة.
6. إظهار `occurrenceCount` بجوار أو فوق كل شعار وفق موضعه في التصميم.
7. استخدام `color`, `locale`, و`Spacing` و`styles_manager.dart` بدل أي قيم أو ألوان ثابتة.
8. استخدام `Directionality` الموروثة وخصائص `Directional` لدعم العربي والإنجليزي.

## المرحلة 4: عرض عدد تكرار المطاعم كقيمة عامة

1. قراءة القيمة من `memberSchedules[].restaurantRepetition.limit`.
2. عرض عدد التكرار مرة واحدة في ملخص الشاشة باستخدام localization.\n3. عرض عدد المطاعم المختلفة مرة واحدة من `restaurantRepetition.restaurantCount`.
4. عدم عرض `occurrenceCount` بجوار كل شعار.
5. `restaurantCount` هو الرقم المعروض لعدد المطاعم المختلفة.
6. `durationDays` يستخدم في النص العام إذا كان التصميم يعرض مدة الاشتراك.
## المرحلة 5: ربط المطاعم بكل فرد

في ويدجت ملخص أفراد العائلة:

1. عرض اسم الفرد ومعلوماته من `mealOverview` أو member entity حسب مصدر الشاشة الحالي.
2. إيجاد schedule المطابق من `memberSchedules` باستخدام `memberId`.
3. تمرير المطاعم إلى `FamilyMemberRestaurants`.
4. عند عدم وجود schedule أو عدم وجود مطاعم، عرض الحالة الفارغة الموجودة في التصميم مع localization.
5. عدم استخدام schedule الخاص بـ `selectedMember` لجميع الأفراد.
6. التأكد أن تغيير الفرد يعيد بناء جزء المطاعم فقط باستخدام `BlocSelector` أو `buildWhen` مناسب.

## المرحلة 6: الشيمر باستخدام flutter_animate

الحزمة موجودة بالفعل في `pubspec.yaml` بالإصدار `4.5.2`، لذلك لا نضيف dependency جديدة.

1. مراجعة `core/widget/shimmer_widget.dart` و`ShimmerPlaceholder` وإعادة استخدامها.
2. استخدام `flutter_animate` في skeleton المطلوب لتطبيق حركة shimmer بنفس ألوان وأبعاد التصميم الحالي.
3. الحفاظ على بنية skeleton الحالية في:
   - `family_addresses_loading_skeleton.dart`
   - `family_address_location_loading_skeleton.dart`
   - وأي skeleton خاص بملخص checkout.
4. عدم استبدال كل shimmer في المشروع دفعة واحدة؛ التعديل يقتصر على شاشة الملخص وتدفق العناوين المطلوب.
5. الحركة تكون متكررة، خفيفة، ومتزامنة عبر placeholders بدون تغيير أبعاد العناصر.
6. استخدام `Animate`/`ShimmerEffect` من `flutter_animate` فقط إذا كان مطابقًا بصريًا؛ وإلا يظل `ShimmerPlaceholder` الحالي هو الأساس وتُستخدم الحزمة للحركة المطلوبة.
7. احترام `TickerMode` وعدم إنشاء controllers داخل `build`.

## المرحلة 7: مؤشر التحميل في منتصف الشاشة

إعادة استخدام:

`lib/core/widget/custom_progress_indecator.dart`

التعديلات المقترحة:

1. أثناء طلب summary الأول، عرض `CustomProgressIndicator` في منتصف محتوى الشاشة.
2. وضعه داخل layout يسمح بالتمركز الحقيقي، مثل `Center` داخل `Expanded` أو body مناسب، دون `Positioned` بأبعاد مفترضة.
3. أثناء refresh أو طلب فرعي، لا نخفي البيانات الحالية بالكامل إلا إذا كان ذلك هو السلوك المطلوب في التصميم؛ يمكن إبقاء المحتوى وإظهار indicator overlay فقط عند الحاجة.
4. استخدام `const CustomProgressIndicator()` متى أمكن.
5. الإبقاء على Lottie الحالي وحجمه الافتراضي، مع استخدام ألوان الثيم للمساحة المحيطة إذا احتاج التصميم ذلك.
6. عدم إضافة progress indicator جديد أو نسخ منطق الـ Lottie.

## المرحلة 8: حالات الفشل والبيانات الناقصة

- `logoUrl` فارغ أو null: placeholder من الثيم.
- فشل تحميل صورة واحدة: لا يفشل الملخص كله.
- قائمة مطاعم فارغة: empty state مترجم.
- summary failure: استخدام `ApiErrorWidget` الحالي مع retry.
- occurrence count null أو غير صالح: عرض fallback آمن يوافق الـ API contract، مع توثيق القرار قبل التنفيذ.

## المرحلة 9: الترجمة والثيم

1. إضافة مفاتيح localization اللازمة في ملفات العربي والإنجليزي وكل locale مدعوم.
2. عدم كتابة نصوص مباشرة داخل widgets.
3. استخدام الألوان من `context.colorScheme`.
4. استخدام النصوص من `styles_manager.dart`.
5. استخدام المسافات وأنصاف الأقطار من `Spacing`.
6. إضافة style أو spacing جديد فقط إذا كان موجودًا بشكل صريح في Figma وغير متوفر حاليًا.

## المرحلة 10: التحقق والاختبارات

1. تشغيل formatter على الملفات المعدلة.
2. تشغيل `flutter analyze`.
3. تشغيل الاختبارات الحالية الخاصة بـ:
   - family checkout
   - family summary mapping
   - image/loading states إن وجدت
4. إضافة اختبار mapper/state فقط إذا كان هناك تعديل فعلي في mapping أو state.
5. التحقق يدويًا من الحالات التالية:
   - فردان ولكل منهما مطاعم مختلفة.
   - مطعم يتكرر 3 مرات.
   - `logoUrl` غير صالح.
   - قائمة مطاعم فارغة.
   - loading أولي يظهر المؤشر في المنتصف.
   - retry بعد فشل الـ summary.
   - RTL وLTR.
6. مراجعة rebuild scope للتأكد أن تغيير فرد واحد لا يعيد بناء الشاشة كلها بلا داعٍ.

## الملفات المتوقعة للتعديل

- `lib/features/family_checkout/data/models/response/family_summary_response_dto.dart`
- `lib/features/family_checkout/data/models/response/family_summary_response_dto.g.dart` (مولّد)
- `lib/features/family_checkout/domain/entities/family_summary_entity.dart`
- `lib/features/family_checkout/data/mapper/family_checkout_mapper.dart`
- `lib/features/family_checkout/presentation/manager/family_checkout_state.dart`
- `lib/features/family_checkout/presentation/manager/family_checkout_view_model.dart`
- شاشة/ويدجت ملخص checkout الحالية.
- ويدجت جديد لمطاعم كل فرد إذا لم يوجد ويدجت قابل لإعادة الاستخدام.
- `lib/core/widget/custom_progress_indecator.dart` فقط إذا احتاج التمركز أو semantics تعديلًا.
- `lib/core/widget/shimmer_widget.dart` أو skeleton feature files لتطبيق الحركة.
- ملفات localization العربي والإنجليزي وباقي اللغات المدعومة.

## شروط قبول التنفيذ

- كل فرد يعرض شعارات مطاعمه الخاصة به فقط.
- ملخص المطاعم يعرض قيمة التكرار العامة من `restaurantRepetition.limit`.
- لا يوجد اعتماد على ترتيب الأفراد أو المطاعم للربط.
- loading summary يعرض `CustomProgressIndicator` في منتصف الشاشة.
- skeleton مطابق لتصميم الشاشة ويستخدم حركة `flutter_animate` المطلوبة.
- الصور الفاشلة لا تكسر الشاشة.
- لا توجد نصوص أو ألوان أو مسافات hardcoded.
- يعمل التصميم في RTL وLTR.
- `flutter analyze` والاختبارات ذات الصلة يمران بنجاح.

## ملاحظة قبل التنفيذ

لتحقيق عبارة "نفس الديزاين بالظبط" يجب مراجعة node الـ Figma الخاص بملخص العائلة/مطاعم كل فرد قبل كتابة الكود. الخطة تحدد البيانات والتدفق، لكن أبعاد الشعار، مكان badge التكرار، وعدد العناصر الظاهرة أفقيًا يجب أخذها من الـ Figma وليس تخمينها.


