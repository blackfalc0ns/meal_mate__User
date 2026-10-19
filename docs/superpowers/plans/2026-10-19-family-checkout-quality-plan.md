# Family Checkout Quality Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** تحسين صحة الدفع ومعالجة الأخطاء وأداء إعادة البناء في `lib/features/family_checkout`، مع الالتزام بقواعد المشروع الحالية ودون تغيير شكل الواجهة أو إنشاء معمارية جديدة.

**Architecture:** الحفاظ على مسار `UI → Event → ViewModel → UseCase → Repository → DataSource → ApiServices`. تبقى مفاتيح الأخطاء في `lib/core/errors`، ويبقى تفسيرها العام وعرضها عبر الأدوات الموجودة. يحتفظ `FamilyMemberRestaurantsUiModel` بدوره كقيمة مقارنة لـ `BlocSelector`.

**Tech Stack:** Flutter، Dart، flutter_bloc، Dio/Retrofit، `ApiResult` و`safeApiCall`، localization وtheme و`Spacing` الحالية.

**Spec:** طلب المستخدم ومراجعة الكود، `AGENTS.md`، `rules/ui_rules.md`، و`rules/rules_backend.md` (الاسم الفعلي للملف؛ `AGENTS.md` يشير إلى `rules/backend_rules.md` غير الموجود). توجد خطة أوسع في `docs/superpowers/plans/2026-10-14-family-flow-architecture-performance-plan.md`؛ هذه الخطة مخصصة للـ checkout فقط ولا توسّع نطاقها إلى بقية الفلو.

## Global Constraints

- لا تغيّر تصميم الواجهة أو النصوص أو مسارات التنقل إلا لإصلاح سلوك مثبت، ولا تضف packages.
- لا تحرّك business logic إلى widgets، ولا تنشئ state management جديدًا.
- عرّف جميع مفاتيح API errors وcheckout blockers في `lib/core/errors/subscription_error_codes.dart`، مع إبقاء قرار الوجهة في feature.
- استخدم `ErrorMessagePresenter` و`ApiErrorWidget`/`InlineApiErrorWidget` وفق نوع الخطأ؛ لا تعرض backend code خامًا للمستخدم.
- لا تعتبر رقمًا أو تاريخًا أو عملة افتراضية صحيحًا إلا بعد مطابقة عقد الـ API أو Figma؛ عند غياب الدليل سجّل نقطة تحقق ولا تختر قيمة جديدة.
- عند تغيير DTO مولّد، استخدم `build_runner` ولا تعدّل `.g.dart` يدويًا.
- احتفظ بالموديل `presentation/models/family_member_restaurants_ui_model.dart` طالما `BlocSelector` يعتمد على `==` فيه.
- اختبر سلوكًا مرئيًا أو عقدًا حقيقيًا؛ لا تكتب اختبارًا يكرر التنفيذ فقط.

## Task 1: تثبيت خط الأساس وحالات السلوك

**Files:** Read: `lib/features/family_checkout/**`, `lib/core/errors/**`, `test/family_checkout_contract_test.dart`, `test/family_checkout_selection_policy_test.dart`, `test/family_summary_restaurants_display_test.dart`. Test additions under `test/` only when they prove a behavior below.

- [ ] سجّل `git status --short` ونتيجة `flutter analyze lib/features/family_checkout lib/core/errors` والاختبارات المذكورة، قبل أي تعديل.
- [ ] تتبّع أحداث التحميل وتغيير العضو والكوبون وتاريخ البداية والدفع والرجوع من WebView، وسجّل الـ state fields التي تتغير في كل حدث.
- [ ] استخدم Flutter DevTools rebuild tracking على سيناريو تغيير وسيلة الدفع، تطبيق كوبون، وتغيير العضو. سجّل عدد بناء الشاشة والأقسام قبل التنفيذ إن كان تشغيل التطبيق متاحًا؛ إذا لم يكن متاحًا، اذكر أن القياس غير متحقق بدل ادعاء تحسن رقمي.
- [ ] راجع عقد backend/Figma للقيم الافتراضية المذكورة في Task 5 قبل تغيير معناها.

## Task 2: منع تكرار عرض الأخطاء وفتح صفحة الدفع

**Files:** Modify: `lib/features/family_checkout/presentation/screens/family_payment_setup_screen.dart`, وعند الحاجة `presentation/manager/family_checkout_state.dart` و`family_checkout_view_model.dart`. Test: widget test جديد أو توسيع اختبار screen موجود.

**Interface:** يظل `checkoutResult` من نوع `PaymentCheckoutEntity?` و`failure` من نوع `Failure?`؛ لا تنشئ state hierarchy جديدة.

- [ ] اكتب اختبارًا: بعد إصدار `checkoutResult` ثم إصدار state مختلف مع نفس النتيجة، يُفتح WebView مرة واحدة فقط. واختبارًا مماثلًا لعرض Snackbar مرة واحدة عند استمرار نفس `failure`.
- [ ] شغّل الاختبار وتأكد أنه يكشف السلوك الحالي.
- [ ] أضف `listenWhen` أو آلية استهلاك حدث واضحة تقارن `previous` و`current`، بحيث لا تعاد الاستجابة لنفس النتيجة أو الخطأ. حافظ على القدرة على عرض خطأ جديد يحمل نفس الكود في محاولة جديدة.
- [ ] عند العودة من WebView، مرّر العضو المحدد الحالي في `GetFamilySummaryEvent(memberId: ...)` بدل حدث بلا `memberId`؛ اختبر بقاء اختيار العضو.
- [ ] شغّل اختبار الشاشة والاختبارات الموجودة ذات الصلة.

## Task 3: صحة الطلبات المتزامنة وتغييرات المستخدم

**Files:** Modify: `lib/features/family_checkout/presentation/manager/family_checkout_view_model.dart` و`family_checkout_state.dart` إن لزم. Test: وسّع `test/family_checkout_selection_policy_test.dart` أو أنشئ اختبار ViewModel مخصص.

- [ ] اختبر فشل `SaveFamilyMemberStartDateUseCase`: يجب ألا يبقى تاريخ محلي غير محفوظ ظاهرًا كأنه مؤكد. اختر إما عدم تطبيق تعديل محلي قبل النجاح، أو استرجاع snapshot السابق عند الفشل.
- [ ] اختبر فشل تطبيق كوبون: لا تُظهر `appliedPromoCode` ككوبون مؤكد بينما الـ summary القديم لا يحتويه؛ حافظ على الكود المدخل في الحقل إذا كانت الواجهة تحتاج إعادة المحاولة.
- [ ] اختبر وصول رد قديم بعد طلب أحدث عند تغيير العضو/الكوبون. الـ request IDs الحالية تحمي بعض fetches؛ وسّع الحماية إلى عمليات التعديل التي يمكن أن تنتج refresh قديمًا. تحقق من `isClosed` قبل أي `emit` بعد `await`.
- [ ] اختبر أن إعادة المحاولة لا تبدأ checkout مرتين أثناء `isRetryLoading` أو `isCheckoutLoading`، وأن وسائل الدفع مرتبطة بالـ summary/amount الحاليين قبل تأكيد الدفع.
- [ ] شغّل اختبارات الـ ViewModel والـ contract.

## Task 4: توحيد مفاتيح الأخطاء وعرضها

**Files:** Modify: `lib/core/errors/subscription_error_codes.dart`, `lib/core/errors/failure_mapper.dart` عند ثبوت مفاتيح غير مترجمة، `lib/features/family_checkout/presentation/manager/family_checkout_view_model.dart`, `presentation/widgets/family_payment_methods_actions_section.dart`, `domain/entities/family_checkout_blocker_destination.dart`, وقد يلزم `presentation/screens/family_payment_setup_screen.dart`. Test: `test/family_checkout_contract_test.dart` واختبار error mapping الحالي إن وجد.

- [ ] اجمع كل مفاتيح الأخطاء المستخدمة فعليًا في feature، وقارنها مع `SubscriptionErrorCodes` و`mapFailureMessage`. استخدم الثوابت الموجودة لـ `payment.initialization_failed`, `family.quote_changed`, `family.delivery_version_changed`, `family.permissions_changed`, و`family.idempotency_key_used`.
- [ ] أضف ثوابت في `SubscriptionErrorCodes` للمفاتيح الموجودة في كود checkout وغير المعرفة هناك، خصوصًا `family.batch_review_required`, `family.checkout_pending`, و`family.batch_closed`، بعد تأكيد تهجئتها من عقد API أو اختبارات العقد. انقل مفاتيح blocker المستخدمة في `family_checkout_blocker_destination.dart` إلى المصدر نفسه؛ اترك mapping إلى `AppRoutes` في feature.
- [ ] استبدل المقارنات النصية المباشرة بالثوابت. لا تضع callback URLs أو labels في `core/errors`؛ هذا المجلد للأخطاء فقط.
- [ ] اختبر أن كل failure code معروف يعطي الرسالة المحلية الصحيحة، وأن code مجهول لا يظهر خامًا. اختبر فشل وسائل الدفع مع summary صالحة: تبقى البيانات ظاهرة ويظهر خطأ القسم/إجراء إعادة المحاولة المناسب بدل استبدال الشاشة كلها.
- [ ] شغّل اختبارات الـ error mapping والـ checkout.

## Task 5: إزالة القيم الثابتة غير المؤكدة

**Files:** Review/modify only after contract verification: `presentation/widgets/family_payment_schedule_section.dart`, `presentation/widgets/family_member_restaurants_card.dart`, `presentation/widgets/family_payment_methods_actions_section.dart`, `presentation/manager/family_checkout_view_model.dart`, `data/mapper/family_checkout_mapper.dart`, وملفات request/usecase/repository المعنية.

- [ ] تحقّق من مصدر `20` يومًا، بداية `today + 2`، و`KWD` الافتراضية. إذا كانت البيانات مفقودة من الـ backend، اعرض حالة عدم توفر ملائمة بدل اختراع مدة أو تاريخ أو عملة. اختبر response ناقص الحقول.
- [ ] حدّد مصدرًا موجودًا أو ثابتًا واحدًا لنسخة العقد `1` وcallback/error URLs المتكررة، مع الحفاظ على قيم عقد API نفسها. اختبر serialization للطلبين العادي وretry.
- [ ] راجع سبب default `paymentMethodId = 3` في renewal. إن كان جزءًا من العقد، سمّه كثابت عقد في الموضع المناسب؛ وإلا مرّر اختيار المستخدم الصريح. اختبر المسار المعتمد.
- [ ] اترك أرقام enum/status مثل `setupStatus == 2` حتى يثبت تعريفها في عقد أو enum موجود؛ عندها استبدلها بمصدر معرّف، دون تغيير المعنى.

## Task 6: تقليل نطاق الـ rebuild والعمل داخل build

**Files:** Modify: `presentation/screens/family_payment_setup_screen.dart`, `presentation/widgets/family_payment_content.dart`, والأقسام التي تحتاج selector مثل `family_payment_members_section.dart`, `family_payment_methods_actions_section.dart`, `family_payment_schedule_section.dart`. Keep: `presentation/models/family_member_restaurants_ui_model.dart`.

- [ ] حدّد لكل قسم مدخلاته الدقيقة: الأعضاء، summary/selected member، الكوبون، وسائل الدفع، وloading flags. استخدم `BlocSelector` أو `buildWhen` بنمط المشروع فقط عندما يغيّر ذلك نطاق البناء فعليًا؛ أبقِ static UI خارج reactive builders.
- [ ] اجعل تغيّر `selectedPaymentMethod` يعيد بناء قسم وسائل الدفع والأزرار فقط، ولا يعيد بناء الجدول أو الجدول الزمني أو قائمة الأعضاء. اجعل تغيّر `isCouponLoading` يعيد بناء الكوبون فقط.
- [ ] راجع إنشاء `FamilyPaymentContent` و`SliverChildListDelegate.fixed` في كل emit، وكذلك `animate` على content وكارت المطاعم. حافظ على ظهور animation المقصود دون إعادته مع كل تغيّر state.
- [ ] انقل تحويل القوائم المتكرر إلى بيانات مشتقة محسوبة عند تغيّر مصدرها أو lookup واحد لكل build ضروري. المواضع: `family_payment_members_section.dart`, `family_payment_meal_overview_section.dart`, `family_payment_schedule_section.dart`. لا تضف cache إلا إذا ظهرت فائدة واضحة بالقياس.
- [ ] اختبر الـ rebuilds بوسيلة القياس نفسها من Task 1. الهدف السلوكي: تغيّر وسيلة الدفع لا يبني جدول الوجبات أو كارت المطاعم؛ تغيير عضو يحدّث الأقسام المعتمدة عليه. سجّل النتيجة الفعلية.

## Task 7: مطابقة قواعد UI وتنظيف طبقة البيانات

**Files:** Modify: `presentation/widgets/family_meals_table.dart` مع ملفات widgets منفصلة داخل `presentation/widgets/`، `presentation/widgets/family_coupon_card.dart`، `presentation/widgets/family_payment_setup_loading_skeleton.dart` عند وجود قيم تصميم موثقة، `data/models/response/family_checkout_selection_response_dto.dart`, و`data/mapper/family_checkout_mapper.dart` أو mapper منفصل بنفس نمط المشروع. Test: `test/family_checkout_contract_test.dart` واختبار widget للاتجاهين.

- [ ] افصل الـ custom widgets الخاصة من `family_meals_table.dart` إلى ملفات مستقلة، مع إبقاء السلوك والأسماء المرئية كما هي. لا تفصل `Row`/`Column` العاديين.
- [ ] أزل `TextDirection.rtl` المفروض على صفوف الجدول واستعمل `Directionality` الموروثة. اختبر ترتيب العناوين والخلايا في RTL وLTR.
- [ ] طابق قيم spacing/الأبعاد المباشرة مع Figma و`config/theme/spacing.dart`. استبدل فقط ما له token مطابق أو قياس مؤكد؛ لا تخمّن قيمًا. أبقِ أبعاد الأيقونات/التحكم الثابتة إذا ثبتت من التصميم.
- [ ] انقل `FamilyCheckoutSelectionResponseDto.toEntity()` إلى `data/mapper` حتى لا يستورد DTO طبقة domain. راجع parsing اليدوي مقارنة بـ `json_serializable` الموجود: إن أمكن تمثيل aliases/nullable converters بنفس النمط، استخدمه وشغّل `build_runner`؛ إن لم يمكن، وثّق سبب الإبقاء على parser المخصص داخل data layer. اختبر response ناقصًا وحقول `id/memberId` البديلة.
- [ ] نظّف قراءات `color.surface` و`locale.localeName` المستخدمة فقط لإسكات unused، مع احترام قاعدة تعريف المتغيرين فقط عند الاستخدام الحقيقي.

## Final verification

- [ ] شغّل formatter على الملفات المعدّلة فقط، ثم `flutter analyze lib/features/family_checkout lib/core/errors` والاختبارات المتعلقة بـ checkout والـ errors والـ RTL.
- [ ] راجع `git diff --check` و`git status --short`؛ لا تدخل ملفات غير مرتبطة أو تغييرات generated يدوية.
- [ ] تحقّق من نجاح checkout العادي وretry، ومن فشل الكوبون وتاريخ البداية ووسائل الدفع، ومن رجوع WebView مع نفس العضو المحدد.
- [ ] اكتب في التقرير النهائي: ما تغير، نتائج الاختبارات، قياسات DevTools قبل/بعد إن توفرت، وما لم يُحسم بسبب غياب عقد API أو Figma. لا تصف الأداء بأنه محسّن بقياس رقمي إن لم يُقَس.
