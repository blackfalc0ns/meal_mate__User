# Family Subscription Flow Architecture and Performance Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** تحسين فلو اشتراك العائلة من إضافة الأعضاء حتى الدفع والنجاح، مع تقسيم الملفات الكبيرة، تقليل rebuild، توحيد errors، وإضافة animations تعمل مرة واحدة عند أول ظهور.

**Architecture:** الحفاظ على Clean Architecture الحالية. يظل `family_shared` منسق الفلو، وتظل `family_checkout` مسؤولة عن تجهيز checkout العائلي، بينما `payment` مسؤولة عن WebView والتحقق المشترك. لا يتم إنشاء Architecture جديدة.

**Tech Stack:** Flutter/Dart، Bloc/Cubit، Retrofit/Dio الحالي، `flutter_animate: ^4.5.2`، localization/theme/spacing الحالية.

**Spec:** متطلبات المستخدم الحالية، `AGENTS.md`، و`rules/ui_rules.md`.

## Global Constraints

- قراءة وتحليل قبل كل تعديل، وعدم حذف أي endpoint قبل إثبات عدم استخدامه.
- الحفاظ على architecture والأسماء وأنماط Bloc/Cubit الحالية.
- استخدام `lib/core/errors` في أخطاء الطلبات، لا رسائل hardcoded.
- استخدام `flutter_animate: ^4.5.2` في loading وعرض المحتوى أول مرة فقط.
- لا يعاد تشغيل animation مع كل rebuild أو emit.
- استخدام localization وtheme وspacing الحالية؛ لا `Colors.*` أو نصوص hardcoded.
- كل Widget مخصص في ملف مستقل.
- لا API calls أو side effects داخل `build`.
- لا تعديل generated files إلا عند الحاجة المثبتة.

## Scope

راجع هذه المسارات:

- `lib/features/family_subscription_setup`
- `lib/features/family_packages`
- `lib/features/family_programs`
- `lib/features/family_addresses`
- `lib/features/family_allergies`
- `lib/features/family_package_days`
- `lib/features/family_checkout`
- `lib/features/family_shared`
- `lib/features/payment`
- `lib/core/errors`
- `lib/core/network/api_services.dart`
- `lib/core/network/network_constants.dart`
- اختبارات `test/` الخاصة بالعائلة والدفع

## Target Flow

`packages → members → programs → addresses → allergies → package days → summary/payment → family checkout → Payment WebView → family fulfillment verification → success → family settings/meals`

---

### Task 1: Baseline and inventory

**Files:** Read فقط: `pubspec.yaml`، كل ملفات scope، الاختبارات. لا تعديل.

- [ ] تأكد أن dependency `flutter_animate: ^4.5.2` موجودة. لا تغيّر الإصدار إن كانت موجودة.
- [ ] شغّل:

```powershell
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

- [ ] سجل failures الموجودة قبل التنفيذ.
- [ ] استخرج جدولًا لكل API method: endpoint، data source، repository، use case، caller، والحالة.
- [ ] افصل تعديلات المستخدم الموجودة مسبقًا عبر `git status`; لا تنسبها للتنفيذ.

### Task 2: توحيد coordinator وsnapshot

**Files:**

- Modify: `family_shared/presentation/manager/family_subscription_flow_view_model.dart`
- Modify: `family_shared/presentation/manager/family_subscription_flow_state.dart`
- Modify: `family_shared/presentation/widgets/family_flow_scope.dart`
- Modify: `family_shared/presentation/widgets/family_flow_navigator.dart`
- Test: اختبار coordinator جديد فقط إن لم يوجد مكافئ.

**Produces:** مصدر واحد لحالة الفلو وcurrent step وtarget member.

- [ ] اكتب اختبارات cached load، force refresh، تحديث عنوان/حساسية، وفشل التحميل.
- [ ] اجعل كل تحديث يمر عبر `FamilyFlowSnapshotStore`; لا نسخ mutable إضافية.
- [ ] اجعل Navigator/scaffold يراقب current step فقط.
- [ ] انقل شروط الانتقال العامة للـ coordinator؛ Widgets ترسل intent فقط.
- [ ] استخدم selective listening ولا تعيد بناء scaffold عند تغيير عضو.
- [ ] شغّل formatter، اختبار coordinator، و`flutter analyze`.

### Task 3: تقسيم subscription setup وإضافة العضو

**Files:**

- Modify: `family_subscription_setup/presentation/manager/family_subscription_setup_view_model.dart`
- Modify: state and screen files.
- Split: `family_add_member_dialog.dart` إلى form، relationship، activity، actions sections، كل Widget في ملف.
- Tests: setup contract/operations tests.

- [ ] اختبر lookup، validation، add/update/delete، duplicate submit، وفشل API.
- [ ] اجعل Dialog composition-only؛ controllers/focus nodes في lifecycle الصحيح.
- [ ] استخدم `BlocSelector` لكل member tile أو primitive مطلوب.
- [ ] استخدم core errors للرسائل وretry.
- [ ] أضف animation مرة واحدة عند فتح Dialog/ظهور الأقسام، لا أثناء الكتابة أو validation.
- [ ] شغّل:

```powershell
dart format lib/features/family_subscription_setup test
flutter test test/family_setup_contract_test.dart test/family_subscription_operations_test.dart
flutter analyze
```

### Task 4: تقسيم packages/programs/package days

**Files:** شاشات ومديرو `family_packages`، `family_programs`، `family_package_days`، وwidgets التابعة فقط.

- [ ] اكتب dependency table لكل section: state fields، events، loading، error.
- [ ] افصل content/actions/loading sections.
- [ ] لا تجعل اختيار عضو أو برنامج يعيد بناء الشاشة كلها.
- [ ] استخدم skeleton الموجود لكل request؛ animate أثناء loading ثم fade/slide مرة واحدة بعد success.
- [ ] لا تنشئ controllers/futures/objects كبيرة داخل build.
- [ ] شغّل اختبارات البرامج والأيام و`flutter analyze`.

### Task 5: addresses and allergies

**Files:** شاشات ومديرو وwidgets العناوين والحساسية.

- [ ] وحّد request states إلى initial/loading/success/failure.
- [ ] استخدم `ApiErrorWidget` لفشل الشاشة و`InlineApiErrorWidget` لفشل section.
- [ ] مرر `Failure.exception` وretry callback؛ لا رسائل محلية مكررة.
- [ ] استخدم flutter_animate للسkeleton/content entrance مرة واحدة فقط.
- [ ] تحقق من RTL/LTR والعودة بين الخطوات.
- [ ] شغّل اختبارات allergies و`flutter analyze`.

### Task 6: تقسيم family checkout

**Files:**

- Modify: `family_checkout/presentation/manager/family_checkout_view_model.dart`
- Modify: state، screen، `family_payment_content.dart` والsections.
- Create only when needed: summary/selection/payment controllers داخل نفس manager folder.
- Tests: checkout contract and selection policy tests.

- [ ] اختبر summary، blockers، selection، start date، payment methods، checkout، retry، stale batch، idempotency، double submit.
- [ ] افصل orchestration إلى وحدات ذات interface واضح؛ لا تقسيم شكلي لمجرد تقليل الأسطر.
- [ ] اجعل content يجمع members/meal overview/schedule/price/payment sections.
- [ ] كل section يقرأ fields المطلوبة فقط عبر `BlocSelector` أو immutable parameters.
- [ ] افصل loading لكل summary/payment methods/checkout/retry.
- [ ] استخدم core error codes وblocker destination لتوجيه المستخدم.
- [ ] animate skeleton وظهور sections مرة واحدة؛ لا animation عند member/payment selection.
- [ ] شغّل tests وanalyzer.

### Task 7: توحيد core/errors

**Files:** `core/errors/error_message_presenter.dart`, `api_exception_mapper.dart`, `error_presentation.dart`, `core/network/failuer_mapper.dart`, و`subscription_error_codes.dart` عند الحاجة.

- [ ] أنشئ mapping table: exception → Failure code → localization key → UI.
- [ ] اجعل snackbar/inline/full-screen تستخدم resolver واحدًا.
- [ ] تحقق من family codes: incomplete plan/member، no selection، stale batch، method unavailable، currency unsupported، idempotency، use checkout flow.
- [ ] لا تعِد تسمية `failuer_mapper.dart` إلا مع تحديث كل imports واختبار كامل؛ ليست شرطًا للمرحلة.
- [ ] شغّل `test/family_error_contract_test.dart` وanalyzer.

### Task 8: family payment success

**Files:** `family_payment_setup_screen.dart`, `payment_web_view_screen.dart`, `payment_view_model.dart`، payment args/success args عند الحاجة، routing فقط عند إضافة destination.

- [ ] اكتب اختبارات WebView callback، success، pending/review، failed، retry، وغياب individual subscription.
- [ ] مرر payment context واضحًا (family/individual) داخل args؛ استخدم type موجودًا إن وجد.
- [ ] family verification يعتمد على family checkout/payment contract، لا current individual subscription كبديل صامت.
- [ ] مرر group/subscription/summary data الصحيحة إلى success.
- [ ] حافظ على payment WebView المشترك للفردي والعائلي.
- [ ] success/failed entrance animation مرة واحدة فقط؛ polling لا يعيدها.
- [ ] شغّل payment/family tests وanalyzer.

### Task 9: endpoint/method audit

**Files:** Read API services/constants وكل remote sources/repositories/use cases؛ اكتب inventory داخل `docs/`.

- [ ] صنّف كل method: used-directly، through remote source، renewal-only، no caller found، backend-contract-only.
- [ ] راجع يدويًا: metadata، dietary، disliked ingredients، allergies، food preferences catalog، country regions، calendar restaurants، abandon draft، retry payment، renewal checkout.
- [ ] لا تحذف method أو endpoint من declaration إلا بعد إثبات عدم وجود caller أو contract.
- [ ] أضف contract tests للعمليات الضرورية التي يجب أن تمر عبر repository/use case.

### Task 10: animation/loading rules

**Files:** skeletons وcontent sections داخل family features وpayment success/failed فقط.

- [ ] مسموح: skeleton أثناء request، content entrance بعد أول success، stagger محدود للقوائم، dialog، success/failed.
- [ ] ممنوع: animation لكل emit، أثناء الكتابة، اختيار member، polling، أو list كبيرة بلا حد.
- [ ] استخدم stable keys/state حتى لا تعيد Flutter animation عند rebuild.
- [ ] لا تنشئ animation controller/Future داخل build.
- [ ] راجع reduced motion إن كان مدعومًا بالمشروع.
- [ ] اختبر أول فتح، retry، back/forward، إعادة الطلب، RTL/LTR، وتأكد أن animation لا تتكرر.

### Task 11: rebuild/performance review

**Files:** كل presentation files المعدلة.

- [ ] أنشئ جدولًا: widget، exact fields، listener، trigger، changes that must not rebuild it.
- [ ] استبدل builders الواسعة بـ `BlocSelector` أو `buildWhen` عند القراءة الجزئية.
- [ ] افصل static UI عن state-dependent UI.
- [ ] اجعل تغيير عضو واحد لا يعيد بناء كل القائمة.
- [ ] استخدم DevTools rebuild tracking أو أداة المشروع. إذا تعذر القياس، سجّل ذلك ولا تدّع إثبات optimization.

### Task 12: final verification

- [ ] `dart format lib test`
- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] اختبر يدويًا: add/update/delete، lookup failure/retry، كل مراحل الفلو، blocker، family payment success، pending/review، failed/retry، success، RTL/LTR، وعدم تكرار animations.
- [ ] راجع:

```powershell
git status --short
git diff --stat
git diff --check
```

- [ ] تأكد أن diff لا يحتوي ملفات خارج النطاق أو يمس تعديلات المستخدم الموجودة مسبقًا.

## Acceptance Criteria

- كل شاشة كبيرة مقسمة إلى sections ذات مسؤولية واحدة.
- لا API calls أو side effects داخل build.
- كل family errors تمر عبر `lib/core/errors`.
- loading يعكس request الصحيح ولا يحجب الشاشة بلا سبب.
- flutter_animate يعمل عند أول ظهور فقط.
- family payment يمرر context عائليًا ويصل للنجاح بعد fulfillment العائلي.
- endpoints غير المستخدمة موثقة قبل أي حذف.
- rebuild scope محدود ومقاس أو موثق كغير قابل للقياس.
- formatter/analyzer/tests تمر، أو failures القديمة موثقة بوضوح.
