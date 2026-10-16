# Family Addresses Performance and Cleanup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** تقليل الـ rebuilds وتحسين الأداء وتنظيف الكود في `lib/features/family_addresses` مع الحفاظ على نفس الـ UI والـ architecture.

**Architecture:** الحفاظ على Flutter وflutter_bloc وClean Architecture الحالية. استخدام `BlocSelector` و`buildWhen` لعزل التغييرات، وتقسيم الـ widgets الكبيرة حسب المسؤولية، وإعادة استخدام Core errors بدون إضافة state-management أو networking جديد.

**Tech Stack:** Flutter, Dart, flutter_bloc, Injectable/GetIt, Retrofit, ApiResult, safeApiCall, existing theme/localization/spacing, `lib/core/errors`.

**Spec:** `AGENTS.md`, `rules/ui_rules.md`, `rules/rules_backend.md`, والتحليل السابق للفيتشر.

## Global Constraints

- لا تغيير في التصميم أو النصوص أو الـ navigation أو الـ API contracts.
- الالتزام بـ `rules/ui_rules.md`: `colorScheme`, localization, styles, `Spacing`, directional APIs, const, selective rebuilds.
- الالتزام بـ `rules/rules_backend.md`: DTO → mapper → entity، `ApiResult`, `safeApiCall`, Injectable، و`ApiServices` الحالية.
- استخدام `lib/core/errors`: `ApiErrorWidget` لفشل الشاشة، و`InlineApiErrorWidget` لفشل جزء من الشاشة.
- عدم تعديل ملفات `*.g.dart` أو `di.config.dart` يدويًا.
- عدم حذف أي use case أو repository method قبل البحث عن كل استخداماته في `lib` و`test`.
- عدم إضافة packages أو architecture جديدة.

---

### Task 1: Baseline and inventory

**Files:** اقرأ `lib/features/family_addresses/**`, `lib/core/errors/**`, `lib/core/network/api_services.dart`, واختبارات family addresses.

- [ ] شغّل `flutter analyze lib/features/family_addresses` وسجّل النتيجة.
- [ ] شغّل الاختبارات المرتبطة بالفيتشر قبل التعديل.
- [ ] ابحث عن استخدامات `isSaving`, `addresses`, كل family-address use cases، وكل `FamilyDeliveryAddress*` في المشروع.
- [ ] راجع constructors الخاصة بـ `ApiErrorWidget` و`InlineApiErrorWidget`.
- [ ] تأكد من عدم إدخال تغييرات غير مرتبطة.

### Task 2: Split the large screen

**Files:**
- Modify: `lib/features/family_addresses/presentation/screens/family_addresses_screen.dart`
- Create: `presentation/widgets/family_addresses_body.dart`
- Create: `presentation/widgets/family_addresses_header.dart`
- Create: `presentation/widgets/family_addresses_member_strip.dart`
- Create: `presentation/widgets/family_addresses_actions.dart`

- [ ] انقل header/stepper إلى widget مستقل مع نفس `color`, `locale`, `Spacing`.
- [ ] انقل member strip إلى widget مستقل، واجعل حساب `FamilyProgramMemberUiModel` يتنفذ فقط عند تغير بياناته.
- [ ] انقل actions إلى widget مستقل مع الحفاظ على نفس visibility condition وcallback.
- [ ] اجعل الشاشة تستخدم selectors منفصلة بدل builder واسع يعيد بناء كل المحتوى.
- [ ] أبقِ `FamilyAddressLocationStage` مسؤولًا عن مرحلة الخريطة فقط.
- [ ] لا تنقل business logic إلى widgets.
- [ ] شغّل formatter والاختبارات بعد المهمة.

### Task 3: Reuse Core error handling

**Files:**
- Modify: `family_addresses_screen.dart` أو `family_addresses_body.dart`
- Reuse: `lib/core/errors/error_widgets/api_error_widget.dart`
- Reuse عند الحاجة: `lib/core/errors/error_widgets/inline_api_error_widget.dart`

- [ ] عند فشل التحميل وعدم وجود أعضاء، استخدم `ApiErrorWidget.fromTypedFailure`.
- [ ] اجعل retry يستدعي `FamilyAddressesViewModel.load(memberId: ...)` فقط.
- [ ] عند فشل refresh مع وجود بيانات، أبقِ البيانات ظاهرة.
- [ ] لا تضف فروعًا حسب نوع الخطأ داخل الفيتشر.
- [ ] لا تغيّر snackbar الخاصة بأخطاء حفظ العنوان الحالية.
- [ ] اختبر initial failure وretry وrefresh failure وempty success.

### Task 4: Isolate location-stage rebuilds

**Files:**
- Modify: `presentation/widgets/family_address_location_stage.dart`
- Create: `presentation/widgets/family_address_map_section.dart`
- Create: `presentation/widgets/family_address_coverage_section.dart`
- Modify if needed: `presentation/widgets/family_address_location_loading_skeleton.dart`

- [ ] انقل map selector إلى `FamilyAddressMapSection` ليستمع فقط إلى `locations` و`action.isLoading`.
- [ ] انقل coverage selector إلى `FamilyAddressCoverageSection` ليستمع فقط إلى `coveragePreview` والقيم المطلوبة للحفظ.
- [ ] أبقِ parent مسؤولًا عن lifecycle وcontrollers والـ listener وترتيب الـ Stack.
- [ ] حافظ على `ValueKey(memberId)` وsession keys الحالية.
- [ ] لا تنشئ API calls أو events أو controllers أو futures داخل `build`.
- [ ] استبدل `Positioned(left/right)` بـ `PositionedDirectional(start/end)`.
- [ ] تحقق أن تغيير coverage لا يعيد بناء الخريطة والعكس.

### Task 5: Remove verified dead state and avoid duplicate emits

**Files:**
- Modify: `presentation/manager/family_addresses_state.dart`
- Modify: `presentation/manager/family_addresses_view_model.dart`
- Modify tests only if they reference removed fields.

- [ ] احذف `isSaving` و`addresses` فقط إذا لم يوجد لهما أي استخدام في `lib` أو `test`.
- [ ] احذف constructor/copyWith assignments المرتبطة بهما بالكامل.
- [ ] في `addressSaved`, لا تعمل `emit` إذا كان callback مكررًا ولم يتغير العنوان فعليًا.
- [ ] حافظ على `_activeLoadId`, `isClosed`, و`addressSaveRevision` عند الحفظ الحقيقي.
- [ ] أضف اختبارات للـ duplicate save، current member، invalid index، وstale load response.

### Task 6: Review unused backend slices safely

**Files:** راجع `domain/usecase/family_addresses_usecases.dart`, `domain/repo`, `data/repo`, `data_source`, `entities/family_delivery_address_entity.dart`, وDTOs.

- [ ] تأكد من استخدام `GetFamilyMemberAddressesUseCase`, `PreviewExistingFamilyMemberAddressUseCase`, و`SetDefaultFamilyMemberAddressUseCase` خارج الشاشة.
- [ ] تأكد من استخدام subscription delivery address في features أخرى.
- [ ] إذا ثبت عدم الاستخدام، احذف vertical slice كاملًا مع الاختبارات، ولا تحذف جزءًا يترك interface مكسورة.
- [ ] إذا كانت مستخدمة، اتركها وسجّل أنها shared code.
- [ ] لا تغيّر endpoint أو request/response contract.

### Task 7: Validate

**Files:** كل الملفات التي عدلتها المهام السابقة فقط.

- [ ] شغّل `dart format` على ملفات Dart المعدلة.
- [ ] شغّل `flutter analyze lib/features/family_addresses`.
- [ ] شغّل اختبارات الفيتشر ثم `flutter test`.
- [ ] إذا تغيرت annotations أو DTOs أو Retrofit، شغّل `dart run build_runner build --delete-conflicting-outputs`.
- [ ] استخدم Flutter DevTools rebuild tracking أو أداة المشروع للتحقق من حدود الـ rebuild.
- [ ] اختبر RTL وLTR.
- [ ] راجع localization و`colorScheme` و`Spacing` وstyles و`lib/core/errors`.
- [ ] تأكد من عدم وجود imports أو variables أو methods أو widgets غير مستخدمة.
- [ ] تأكد من عدم تعديل ملفات خارج نطاق الفيتشر.

## Acceptance Criteria

- header وmember strip والخريطة وcoverage وactions لها rebuild boundaries مستقلة.
- تغيير coverage لا يعيد بناء الخريطة، وتغيير العضو لا يعيد بناء الأجزاء الثابتة.
- لا توجد side effects أو controllers أو futures داخل `build`.
- الملفات الكبيرة مقسمة إلى widgets، وكل widget في ملف مستقل.
- تم حذف الكود غير المستخدم فقط بعد التحقق من كل references.
- تم استخدام `lib/core/errors` بدل error widgets مكررة.
- `flutter analyze` والاختبارات تمر.
- لا يوجد redesign أو API change أو package جديد.
