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

---

## Added coverage before implementation

The original task list is retained. The following tasks are mandatory additions because the family flow crosses checkout, external payment, deep links, persistence, and post-payment fulfillment.

### Task 13: Family payment lifecycle and recovery

**Files:**

- Modify: `lib/features/payment/domain/entities/payment_args.dart`, payment return/success/failure args, and routing only where required.
- Modify: `lib/features/family_checkout/presentation/manager/family_checkout_view_model.dart` and state/events.
- Modify: `lib/core/payment/payment_attempt.dart`, `payment_attempt_store.dart`, and `payment_deep_link_coordinator.dart` only where family context is missing.
- Test: family payment lifecycle, callback replay, app restart recovery, and family-context routing.

**Required contract:** every family attempt carries `flowType=family`, `batchId`, `batchVersion`, `paymentId`, `subscriptionId` when known, and a durable idempotency key. Individual payment recovery must never be used as a silent family fallback.

- [ ] Define one explicit state machine: `created ? redirected ? pending/review ? paid ? fulfillment_pending ? active`, with terminal `failed`, `expired`, and `cancelled` states.
- [ ] Persist the attempt before opening WebView and update it after every callback/status transition.
- [ ] Make callback handling idempotent: the same deep link/payment id must be processed once.
- [ ] Recover an unresolved family attempt after process death using the stored batch/payment identifiers.
- [ ] Route family success, review, pending, and failure to family-aware destinations with the correct summary/group data.
- [ ] Add tests for callback without subscription id, duplicate callback, app restart, WebView cancellation, and individual/family isolation.

### Task 14: Family batch fulfillment verification

**Files:**

- Modify or create only the existing family checkout/payment verification use case, repository, remote source, and DTO layers.
- Modify: family success/pending screens and routing when required.
- Test: batch fulfillment contract and polling policy.

- [ ] Verify the family batch contract after payment; do not infer success from one individual subscription.
- [ ] Require an authoritative family status such as `batch active/fulfilled`, or verify all required member subscriptions before success.
- [ ] Define polling timeout, retryable errors, terminal errors, and a user action after timeout.
- [ ] Refresh family flow snapshot, billing cache, meals/calendar data, and settings only after authoritative fulfillment success.
- [ ] Cover paid-but-not-ready, partial member fulfillment, stale batch version, and already-fulfilled responses.

### Task 15: Draft lifecycle and resume/abandon behavior

**Files:**

- Modify: `family_subscription_setup` exit/navigation handling and `FamilyFlowSnapshotStore`.
- Modify: existing `AbandonFamilyDraftUseCase` integration and draft/session entities.
- Test: resume, abandon, logout, and post-success cleanup.

- [ ] Define when a draft is created, resumed, abandoned, expired, or converted to an active family subscription.
- [ ] Confirm before abandoning a non-empty draft; never abandon automatically on a transient navigation event.
- [ ] Restore the last valid step and target member from server state, not only local memory.
- [ ] Clear local snapshot, payment attempt, and converted-draft markers after successful activation or explicit abandon.
- [ ] Handle logout/token expiry without leaking another user's family snapshot or payment attempt.

### Task 16: Quote/version invalidation and concurrency guards

**Files:**

- Modify: family setup, addresses, allergies, package days, checkout managers and shared snapshot store.
- Test: stale response and quote invalidation policies.

- [ ] Treat `batchVersion`/quote version as the source of truth; invalidate summary, payment methods, and idempotency when any priced input changes.
- [ ] Add generation/request guards to current flow, summary, payment methods, member selection, addresses, allergies, and package-day writes.
- [ ] Reject checkout when the server reports quote/version drift, then refresh and require explicit user confirmation.
- [ ] Prevent late responses from restoring deleted members, old addresses, or old payment methods.
- [ ] Define conflict behavior when another device changes the family draft.

### Task 17: Eligibility, authorization, and boundary contracts

**Files:**

- Modify only existing family DTOs/entities, mappers, error codes, and guards.
- Test: min/max members, manager eligibility, duplicate membership, authorization, and expired session.

- [ ] Validate backend-owned limits and eligibility; remove reliance on UI defaults for checkout decisions.
- [ ] Cover duplicate phone/member, member belonging to another family, deleted member, unauthorized member edits, and manager subscription requirements.
- [ ] Map each blocker to a destination and a retry/fix action through `lib/core/errors`.
- [ ] Ensure all family endpoints enforce the authenticated family/manager scope server-side and expose contract errors to the client.

### Task 18: Lifecycle and manual verification matrix

- [ ] Test app killed during WebView, resumed from deep link, duplicate callback, network loss before/after checkout, token expiry, logout, back navigation, step revisit, RTL/LTR, locale change, and reduced motion.
- [ ] Verify no family success screen is reachable before authoritative family fulfillment.
- [ ] Verify retry never creates a second batch for the same payment intent.
- [ ] Verify post-activation family settings, members, meals, and calendar load the newly activated family context.

## Updated acceptance criteria

- Payment recovery works after process death and preserves family context.
- Family success is based on authoritative batch fulfillment, not an individual subscription fallback.
- Draft resume/abandon/logout cleanup is deterministic and tested.
- Quote/version changes invalidate stale payment state and require explicit confirmation.
- Duplicate callbacks, duplicate submits, and late responses are harmless.
- Family and individual payment attempts remain isolated.

### Task 0: Capture and verify the new backend response before model changes

**Files:**

- Read-only: runtime/network logs, Dio/PrettyDioLogger output, API documentation, and captured request/response evidence.
- Modify only after confirmation: the affected response DTO, generated `.g.dart` file when required, mapper, entity, repository contract, and tests.

- [ ] Before changing any response model, Gemini must inspect the actual runtime response from the family endpoint, including HTTP status, headers needed by the client, response envelope, nested fields, nullability, and error payloads.
- [ ] Record the exact endpoint, request shape, response JSON, and timestamp/build context in the implementation notes or contract test fixture. Redact tokens, phone numbers, payment URLs, and other sensitive values.
- [ ] Compare the captured response against the current DTO, generated serialization, mapper, entity, and all callers; list added, removed, renamed, moved, and type-changed fields.
- [ ] If no trustworthy runtime log or backend contract is available, stop model changes and report the missing evidence. Do not infer the new response from old models or from a single error message.
- [ ] Add a fixture/contract test for the verified new response and preserve backward compatibility only when both old and new payloads are confirmed requirements.
- [ ] Re-run the affected family contract, mapper, repository, and integration tests after the model update.

## Scope lock: family flow only

- [ ] All implementation and manual simulator verification in this plan targets the family subscription flow only.
- [ ] Individual subscription checkout, payment, fulfillment, and success behavior must remain unchanged and must have regression coverage before completion.
- [ ] Shared payment/network code may be changed only when the family context is explicit and individual behavior is proven unchanged.
- [ ] Gemini may run the family flow on an available simulator and use sandbox credentials to exercise the flow. Never perform a real charge; if the simulator, credentials, backend environment, or trustworthy response log is unavailable, stop and report the blocker.
