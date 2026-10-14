# Family Management Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** تنفيذ Feature مستقلة لإدارة اشتراك العائلة تغطي شاشات الإدارة، الأعضاء، الصلاحيات، الوصول، التقويم، المطاعم، الوجبات، المراجعة والتأكيد، وتلتزم بعقد الـ backend في `family-management-screens`.

**Architecture:** إنشاء `lib/features/family_management` كحد مستقل لا يعتمد على Features العائلة الحالية مثل `family_checkout` أو `calendar` أو `restaurant_menu`. تقسيمها داخليًا إلى `overview` و`member` و`meal_management`، مع فصل `data/domain/presentation` داخل كل وحدة، وViewModel/State/Event مستقل لكل وحدة. إعادة استخدام أدوات المشروع العامة فقط مثل Dio/DI/localization/theme و`lib/core/errors`.

**Tech Stack:** Flutter/Dart، architecture الحالية للمشروع، ViewModel/State/Event pattern الموجود، Dio/remote data sources، `flutter_animate: ^4.5.2` للانتقالات والعرض التدريجي، `lib/core/errors` لتوحيد error codes، localization العربية والإنجليزية، RTL/LTR.

**Spec:** `D:/yahya/meal meat/family-management-mobile-handoff-2026-10-14/family-management-screens/README.md` و`00-flow-and-contract.md` إلى `12-mobile-acceptance-checklist.md`.

## Global Constraints

- كل ملفات التنفيذ تكون تحت `lib/features/family_management` باستثناء التسجيل الضروري في DI والـ routes، ولا يتم تعديل Features أخرى.
- لا يتم اختراع endpoint أو DTO field أو error code؛ المصدر هو handoff والـ backend contract.
- استخدم `lib/core/errors` في parsing/classification وعرض أخطاء الـ API، مع الحفاظ على error `code`.
- استخدم `flutter_animate: ^4.5.2` فقط للـ entrance/transition animations، بدون animation تسبب rebuild أو API calls.
- كل user-facing copy يمر من localization، وكل الألوان من theme، وكل spacing/styles من tokens الحالية.
- لا تستخدم language code لتحديد RTL/LTR، ولا تعكس collections يدويًا.
- المدير فقط يدخل إدارة العائلة؛ تعامل مع 401/403/409 حسب error code وليس status فقط.
- لا تعتمد على بيانات قديمة بعد mutation؛ أعد GET بعد النجاح أو بعد تعارض النسخة/الـ quote.
- لا يوجد checkout تلقائي عند إنشاء فرد؛ اختيار `subscribeNow` صريح ثم summary ثم checkout.
- لا تعرض calendar للاشتراك القادم كأنه اشتراك حالي، ولا تستخدم `memberId` مكان `subscriptionId`.
- أي mutation تمنع duplicate requests، وتحتفظ بالمدخلات بعد validation/network errors.

---

## Target Feature Structure

```text
lib/features/family_management/
├── data/
│   ├── data_source/
│   ├── mapper/
│   ├── models/
│   │   ├── request/
│   │   └── response/
│   └── repo/
├── domain/
│   ├── entities/
│   ├── repo/
│   └── usecase/
├── overview/
│   └── presentation/
│       ├── manager/
│       ├── screens/
│       └── widgets/
├── member/
│   └── presentation/
│       ├── manager/
│       ├── screens/
│       └── widgets/
├── meal_management/
│   └── presentation/
│       ├── manager/
│       ├── screens/
│       └── widgets/
└── family_management_injection.dart
```

الـ shared data/domain files تظل داخل الـ feature حتى لا تتكرر DTOs أو repositories، بينما كل UI flow يملك manager مستقل.

---

### Task 1: تثبيت حدود الـ feature وتسجيلها

**Files:**
- Create: `lib/features/family_management/family_management_injection.dart`
- Create: `lib/features/family_management/overview/presentation/...` folders
- Create: `lib/features/family_management/member/presentation/...` folders
- Create: `lib/features/family_management/meal_management/presentation/...` folders
- Modify: `lib/core/di/di.dart` فقط لتسجيل dependencies الجديدة.
- Modify: route registry الموجود فقط لإضافة entry points المطلوبة.

**Interfaces:**
- Produces `registerFamilyManagementDependencies(GetIt getIt)` أو نفس signature المستخدم في DI الحالي.
- Produces route arguments تحمل `memberId` أو `subscriptionId` typed بدل strings غير موثقة.

- [ ] افحص pattern تسجيل Feature قائم مثل `family_checkout` وطبقه دون إنشاء DI pattern جديد.
- [ ] سجل data sources، repositories، use cases، والـ three managers مرة واحدة.
- [ ] أضف routes للـ home/members/member detail/calendar flows مع guards للمدير.
- [ ] شغّل `dart format` و`flutter analyze` على الملفات الجديدة.

---

### Task 2: طبقة الأخطاء والتعاقد المشترك

**Files:**
- Create: `lib/features/family_management/data/family_management_error_mapper.dart`
- Create: `lib/features/family_management/domain/entities/family_management_failure.dart`
- Modify: `lib/core/errors` فقط إذا كان code موجودًا في handoff وغير موجود فعليًا، وبأقل إضافة ممكنة.

**Interfaces:**
- `FamilyManagementFailure mapFamilyManagementError(Object error)`.
- كل repository يرجع failure typed أو يستخدم Result pattern الموجود بالمشروع.

**Required codes:**
`family.not_manager`, `family.member_not_found`, `family.permissions_changed`, `family.permissions_version_required`, `family.manager_permissions_immutable`, `family.access_paused`, `family.access_disabled`, `family.permission_required`, `family.action_not_available`, `family.quote_changed`, `family.use_checkout_flow`, `family.member_incomplete`, `family.group_not_active`, `calendar.fulfillment_not_ready`, `calendar.service_unavailable`, `calendar.box_incomplete`, `calendar.allergy_conflict`, `calendar.box_not_ready`, `subscription.service_unavailable`, `auth.forbidden`.

- [ ] راجع `lib/core/errors` قبل إضافة أي constant.
- [ ] اربط status + code برسائل localization دون إخفاء code.
- [ ] فرّق بين خطأ manager access وبين خطأ member access؛ المدير يظل قادرًا على إدارة member موقوف.
- [ ] أضف unit tests للـ mapper لكل code حرج، وتأكد أن unknown code يظهر generic localized retry state.

---

### Task 3: Data source وDTOs وmappers العامة

**Files:**
- Create: `lib/features/family_management/data/data_source/family_management_remote_data_source.dart`
- Create: `lib/features/family_management/data/data_source/family_management_remote_data_source_impl.dart`
- Create response models داخل `data/models/response/` لـ home, member list, member detail, access, permissions, calendar, day, restaurants, meals, delivery address, summary.
- Create request models داخل `data/models/request/` للتعديلات، permissions، access، meal slot، complete، checkout selection، checkout.
- Create: `lib/features/family_management/data/mapper/family_management_mapper.dart`

**Interfaces:**
- Remote methods use exact paths from the handoff:
  - `GET /api/v1/customer/family/home`
  - `GET /api/v1/customer/family/members`
  - `GET /api/v1/customer/family/members/{memberId}`
  - `GET/PUT /api/v1/customer/family/members/{memberId}/access`
  - `GET/PUT /api/v1/customer/family/members/{memberId}/permissions`
  - `POST /api/v1/customer/family-subscription-flow/members`
  - `PUT /api/v1/customer/family-subscription-flow/members/{memberId}`
  - `GET /api/v1/customer/family-subscription-flow/members/{memberId}/addresses`
  - `GET/PUT .../allergies`, `.../disliked-ingredients`, `.../dietary`
  - `GET /api/v1/customer/subscriptions/{subscriptionId}/calendar`
  - `GET .../days/{date}`
  - `GET .../days/{date}/restaurants`
  - `GET .../restaurants/{restaurantId}/meals`
  - `POST .../days/{date}/meals/slot`
  - `GET .../delivery-address`
  - `POST .../days/{date}/complete`
  - `POST .../days/{date}/confirm`
  - `PUT .../checkout-selection`, `GET .../summary`, `POST .../checkout`.

- [ ] استخدم `Accept-Language` من HTTP client الحالي.
- [ ] حافظ على nullable fields: current/upcoming subscriptions، address، phone، occupation، restaurant metadata، nutrition totals.
- [ ] اختَر الاسم المحلي من active locale ثم fallback غير فارغ ثم label مترجم.
- [ ] حوّل التاريخ إلى `yyyy-MM-dd`، والـ timezone التشغيلي Asia/Kuwait، والعملة KWD بثلاث منازل.
- [ ] لا تستنتج `NO_ALLERGIES` أو `NO_DIETARY_RESTRICTIONS` من list فاضية؛ اقرأ `noneOptionCode` و`selectedOptionCodes`.
- [ ] اختبر serialization لـ `ageYears`، `expectedVersion`، `batchVersion`، و`idempotencyKey` nullable.

---

### Task 4: Domain entities, repositories, use cases

**Files:**
- Create domain entities under `domain/entities/` لكل response المذكور في Task 3.
- Create `domain/repo/family_management_repository.dart` وimplementation تحت `data/repo/`.
- Create use cases under `domain/usecase/` grouped as overview/member/meal management.

**Required use cases:**
- `getFamilyHome`, `getFamilyMembers`, `getFamilyMemberDetail`.
- `getMemberAccess`, `saveMemberAccess`, `deleteMember`, `createFamilyMember`.
- `getMemberPermissions`, `saveMemberPermissions`.
- `updateFamilyMember`, `getMemberAddresses`, `saveMemberAllergies`, `saveMemberDislikedIngredients`, `saveMemberDietary`.
- `getCalendar`, `getDayDetails`, `searchRestaurants`, `getRestaurantMeals`, `selectMealSlot`.
- `getDeliveryAddress`, `completeDayBox`, `confirmDay`.
- `selectCheckoutMember`, `getFamilySummary`, `startFamilyCheckout`, `retryFamilyPayment`.

- [ ] كل use case يقبل typed params، لا Map dynamic.
- [ ] mutations ترجع أحدث entity أو success marker حسب API ثم manager يعمل refresh.
- [ ] `completeDayBox` منفصل تمامًا عن `confirmDay`.
- [ ] `selectCheckoutMember` لا يبدأ دفعًا؛ `subscribeNow` explicit.
- [ ] عند `quote_changed` أو version conflict ارجع failure مع latest refresh instruction.

---

### Task 5: Overview flow وViewModel

**Files:**
- Create `overview/presentation/manager/family_overview_view_model.dart`
- Create `family_overview_state.dart`, `family_overview_event.dart`
- Create screens `family_home_screen.dart`, `family_members_screen.dart`
- Create focused widgets for summary, member card, current/upcoming subscription, errors, loading, empty states.

**State design:**
- State fields منفصلة: `homeStatus`, `membersStatus`, `homeData`, `members`, `selectedMemberId`, `failure`, `refreshToken`.
- لا تستخدم state object واحد mutable أو broad listener لكل الشاشة.

- [ ] نفذ `GET home` و`GET members` مع cache invalidation بعد add/edit/access/checkout.
- [ ] calendar shortcut يختار memberId أولًا ثم effective subscription ID (`current` ثم `upcoming`).
- [ ] لا تعرض renewal أو today schedule للاشتراك القادم عندما `current=null`.
- [ ] manager guard يعرض `family.not_manager`، و401 يذهب إلى auth flow، وnetwork error يحافظ على البيانات القديمة ويعرض retry.
- [ ] استخدم `BlocSelector`/`buildWhen` أو equivalent الموجود، بحيث تغيير عضو واحد لا يعيد بناء header والقائمة كلها.
- [ ] استخدم `flutter_animate` للـ list/card entrance مرة عند ظهور البيانات، مع stable keys وعدم إعادة تشغيل animation عند كل state emission.

---

### Task 6: Member flow وViewModel

**Files:**
- Create `member/presentation/manager/family_member_view_model.dart`
- Create `family_member_state.dart`, `family_member_event.dart`
- Create screens: detail, edit, access, permissions.
- Create widgets for profile summary, editable fields, access state, one-time password, permission groups.

- [ ] تحميل القيم قبل فتح edit، وتعطيل duplicate save.
- [ ] `FamilyMemberWriteDto` يحتوي فقط: `displayName`, `relationshipCode`, `gender`, `ageYears`, `deliveryAddressId`, `phone`, `occupation`.
- [ ] لا ترسل nutritional goal/activity/program/bundle/tier/duration/includeFriday في M08.22 PUT.
- [ ] `null` في address/phone يحافظ على الموجود حسب العقد؛ occupation null يحافظ، وempty string يمسح.
- [ ] اختيار العنوان يبدأ بـ GET member addresses ثم يرسل valid ID فقط.
- [ ] allergy/dietary/disliked كل endpoint مستقل، مع none codes الصحيحة.
- [ ] permissions PUT يرسل الثمانية الأساسية دائمًا و`expectedVersion`، ولا يرسل `groups`؛ capabilities الـ11 اختيارية حسب DTO.
- [ ] conflict `family.permissions_changed` يعمل GET ثم يعرض التغيير للمستخدم بدون auto-resubmit.
- [ ] manager permissions immutable تظهر read-only.
- [ ] access password one-time: لا تعرض password إلا في response الخاص بها ولا تحفظه في state طويل الأجل.
- [ ] بعد success أبطل list/detail/home cache ثم GET حديث.
- [ ] selectors منفصلة لكل form section ولكل permission toggle لتقليل rebuild.
- [ ] animate sections عند الدخول فقط، وanimate validation/error inline بدون إعادة بناء الشاشة كاملة.

---

### Task 7: Meal management flow وViewModel

**Files:**
- Create `meal_management/presentation/manager/family_meal_management_view_model.dart`
- Create `family_meal_management_state.dart`, `family_meal_management_event.dart`
- Create screens: calendar, day details, restaurants, meals, review confirm.
- Create widgets for day strip, status badges, slot rows, restaurant cards, meal cards, nutrition summary, address snapshot, action footer.

- [ ] effective calendar subscription ID = current ثم upcoming؛ لا تستخدم memberId في endpoint.
- [ ] calendar fulfillment not ready يعرض Preparing ويعيد GET لاحقًا بدون fake calendar.
- [ ] upcoming يعرض future dates فقط ولا يحوله لحالة اليوم الحالي.
- [ ] stale response لا يبدّل الشهر/العضو المختار: استخدم request generation/token أو compare context قبل commit state.
- [ ] restaurant search paging يبدأ page 1 وpageSize 20 ويحافظ على النتائج أثناء retry.
- [ ] meals paging لكل restaurant/slot، والـ empty response حالة فارغة صحيحة.
- [ ] `canEdit=false`, cutoff, frozen, cancelled, locked = read-only؛ cutoff من API وليس حسابًا محليًا.
- [ ] اختيار slot يستخدم العدد والبدائل التي يعيدها API؛ لا تنشئ remove endpoint.
- [ ] complete يتأكد من `filledCount >= requiredCount` ثم POST complete body `{}`؛ بعد النجاح GET day/calendar.
- [ ] confirm منفصل بدون body؛ لا ترسل duplicate requests ولا optimistic success.
- [ ] عرض address من `acceptedAddress` snapshot، وليس profile address.
- [ ] selectors على selected day، search query، paging page، وmutation status كلٌ على حدة.
- [ ] `flutter_animate` للعناصر الجديدة والـ loading transition فقط؛ لا تعيد animation عند pagination أو كل rebuild.

---

### Task 8: Localization, theme, accessibility, and animation policy

**Files:**
- Modify existing localization files only for new keys.
- Modify existing theme/spacing/style files only when an exact missing token is confirmed.
- Create feature animation helper only if existing animation utilities cannot express the requirement.

- [ ] أضف مفاتيح عربية/إنجليزية لكل label وerror state وstatus وretry action.
- [ ] اختبر `ar → en → ar` بدون reload.
- [ ] استخدم inherited Directionality و`EdgeInsetsDirectional` و`TextAlign.start/end`.
- [ ] استخدم semantics labels للـ cards، toggles، retry، confirm، restaurant/meal selection.
- [ ] لا تستخدم `Colors.*` أو hex أو spacing literals داخل widgets.
- [ ] كل animation لها duration/curve ثابتة من constants، وتُحترم reduced-motion إن كان المشروع يدعمها.
- [ ] لا تستخدم animation لتغطية loading أو network latency؛ الحالة الوظيفية تظل واضحة.

---

### Task 9: Performance and rebuild verification

**Files:**
- Modify only feature managers/widgets where profiling reveals an issue.
- Create tests under the project’s existing test convention for selectors and request guards.

- [ ] حدد state-dependent widgets قبل التنفيذ وسجل selector المسؤول عن كل واحد.
- [ ] افصل static app bar/section headers عن reactive content.
- [ ] استخدم immutable state، const widgets، stable item keys عند الحاجة، وmemoized callbacks حيث pattern المشروع يسمح.
- [ ] لا تنشئ controllers/futures/streams/maps الثقيلة داخل `build`.
- [ ] pagination/search لا يعيدان تحميل الشاشة كلها.
- [ ] mutation واحدة لا تعيد بناء كل list item؛ استخدم item-level selector.
- [ ] شغّل Flutter DevTools rebuild tracking أو performance tooling المتاح، وسجل النتيجة.
- [ ] اختبر rapid taps، تغيير member أثناء request، تغيير day أثناء request، وretry بعد 409.

---

### Task 10: Integration tests وacceptance checklist

**Files:**
- Create tests حسب convention تحت `test/features/family_management/`.
- Create/update `docs/superpowers/plans` tracking only if implementation reveals contract change.

**Required tests:**
- manager-only access and 401/403 behavior.
- home/members refresh after create/edit/delete/checkout.
- current/upcoming subscription separation.
- permissions version required/conflict/immutable manager.
- edit DTO excludes forbidden fields and preserves null semantics.
- none option codes for allergies/dietary and empty disliked list.
- calendar uses subscriptionId, fulfillment not ready, service unavailable.
- stale response ignored after member/day/search context changes.
- complete then confirm order; incomplete box and allergy conflict.
- quote changed refresh and no optimistic success.
- Arabic/English labels and RTL/LTR direction.
- reduced rebuild assertions or widget rebuild counters where supported.

- [ ] شغّل `dart format --set-exit-if-changed` على الملفات المعدلة.
- [ ] شغّل `flutter analyze`.
- [ ] شغّل unit/widget/integration tests الخاصة بالـ feature.
- [ ] نفذ checklist الملف `12-mobile-acceptance-checklist.md` بندًا بندًا، وسجل أي blocker بدليل واضح.
- [ ] راجع أن كل التغييرات محصورة في `family_management` وDI/routes/localization/theme الضرورية فقط.

---

## Backend Contract Coverage Matrix

| Handoff | مكان التغطية في الخطة |
|---|---|
| 00 flow and contract | Tasks 2–4 وTask 6/10 |
| 01 home | Task 5 |
| 02 members | Task 5 وTask 10 |
| 03 member detail | Task 6 |
| 04 access | Task 6 |
| 05 permissions | Tasks 2, 6, 10 |
| 06 calendar | Task 7 |
| 07 day details | Task 7 |
| 08 restaurants | Task 7 |
| 09 meals | Task 7 |
| 10 review/confirm | Task 7 |
| 11 member edit | Task 6 |
| 12 acceptance checklist | Task 10 |

## Completion Gate

لا تعتبر Feature مكتملة إلا بعد:

- نجاح analyzer والاختبارات.
- تغطية كل endpoints والعقود في المصفوفة.
- إثبات أن `lib/core/errors` مستخدم في كل error path.
- إثبات أن `flutter_animate: ^4.5.2` مستخدم بدون إعادة تشغيل animations مع كل rebuild.
- مراجعة rebuild scope ونتائج profiling.
- اختبار العربية والإنجليزية وRTL/LTR.
- تمرير checklist الموبايل مع توثيق أي backend blocker.
