# Subscription Flow Delta Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** توصيل تحديثات فلو الاشتراك الفردي الخاصة بتاريخ البداية وAvailability وfailureReasons مع الحفاظ على بنية المشروع الحالية.

**Architecture:** إعادة استخدام طبقات `ApiServices → DataSource → Repository → UseCase → ViewModel/State` الحالية. يضاف نموذج nullable مشترك لـ availability مع قاموس ترجمة مركزي لأسباب الفشل، بينما يبقى family flow مستقلًا ولا يرسل `startDate`.

**Tech Stack:** Flutter/Dart، Dio/Retrofit، json_serializable، injectable، Cubit/ViewModel، flutter_test.

**Spec:** `docs/superpowers/plans/2026-10-08-subscription-calendar-gemini.md` وملخص المتطلبات المرسل بتاريخ 2026-10-10.

## Global Constraints

- لا تغيّر family subscription flow ولا تستنتج availability من غياب الحقل.
- `readiness.canCheckout` هو الحكم الوحيد للسماح بالدفع.
- `pricing_unavailable` يعني أن السعر nullable؛ لا تعرض صفرًا كبديل.
- `startDate` بصيغة `yyyy-MM-dd` ويُرسل مع `durationDays` في الفئات الفردية فقط.
- لا تعرض failure-reason code خامًا؛ الأكواد غير المعروفة تذهب إلى “أسباب أخرى” مع العدد.
- استخدم nullable DTO fields للحفاظ على توافق الردود القديمة.
- شغّل build_runner عند تغيير generated models، ثم format وanalyze والاختبارات المناسبة.

---

### Task 1: Extend tier request and response contract

**Files:**
- Modify: `lib/core/network/api_services.dart:337-344`
- Modify: `lib/core/subscription_tiers/data/models/response/subscription_tier_response_dto.dart`
- Modify: `lib/core/subscription_tiers/data/data_source/subscription_tier_remote_data_source.dart`
- Modify: `lib/core/subscription_tiers/data/data_source/subscription_tier_remote_data_source_impl.dart`
- Modify: `lib/core/subscription_tiers/domain/repo/subscription_tier_repository.dart`
- Modify: `lib/core/subscription_tiers/domain/usecase/get_subscription_tiers_usecase.dart`
- Modify: `lib/features/monthly_plans/data/data_source/subscription_plan_remote_data_source.dart`
- Modify: `lib/features/monthly_plans/data/data_source/subscription_plan_remote_data_source_impl.dart`
- Modify: `lib/features/monthly_plans/domain/repo/subscription_plan_repository.dart`
- Test: `test/subscription_tiers_endpoint_test.dart`

**Interfaces:**
- `getSubscriptionTiers(..., @Query('startDate') String? startDate)`.
- All individual-flow repository/use-case methods accept `String? startDate`.
- Family methods keep their existing signatures and never send `startDate`.

- [ ] Add a transport test proving `durationDays`, `includeFriday`, and `startDate` are sent for individual tiers and omitted when `startDate == null`.
- [ ] Thread `startDate` through each existing interface without creating a second repository architecture.
- [ ] Run `dart run build_runner build --delete-conflicting-outputs` and the focused endpoint test.

### Task 2: Model tier availability

**Files:**
- Create: `lib/core/subscription_tiers/data/models/response/subscription_tier_availability_response_dto.dart`
- Create: `lib/core/subscription_tiers/domain/entities/subscription_tier_availability_entity.dart`
- Modify: `lib/core/subscription_tiers/data/models/response/subscription_tier_response_dto.dart`
- Modify: `lib/core/subscription_tiers/data/mapper/subscription_tier_mapper.dart`
- Modify: `lib/core/subscription_tiers/domain/entities/subscription_tier_entity.dart`
- Modify: `lib/features/monthly_plans/data/mapper/subscription_tier_mapper.dart`
- Test: `test/subscription_tier_availability_mapper_test.dart`

**Interfaces:**
- `SubscriptionTierAvailabilityEntity` exposes `scope`, `status`, `canSelect`, `coveredRestaurantCount`, `eligibleRestaurantCount`, and nullable `messageCode`.
- `SubscriptionTierEntity.availability` is nullable.

- [ ] Add nullable json DTO fields and generated serialization.
- [ ] Map missing availability to `null`, not to an “available” default.
- [ ] Preserve nullable prices from the response.
- [ ] Test available, unavailable, pricing-unavailable with null price, and missing availability fixtures.

### Task 3: Reload tiers and enforce selection state

**Files:**
- Modify: `lib/features/monthly_plans/presentation/manager/subscription_plan_event.dart`
- Modify: `lib/features/monthly_plans/presentation/manager/subscription_plan_view_model.dart`
- Modify: `lib/features/monthly_plans/presentation/manager/subscription_plan_state.dart`
- Modify: `lib/features/monthly_plans/presentation/widgets/monthly_plan_details_content.dart`
- Modify: `lib/features/monthly_plans/presentation/widgets/sections/monthly_plan_hero_sliver_section.dart`
- Test: `test/subscription_plan_start_date_tiers_test.dart`

- [ ] Trigger a tier reload after both a valid duration and `selectedStartDate` exist.
- [ ] Invalidate older tier responses when duration, date, address, or account context changes.
- [ ] Keep a tier visible when `canSelect == false`, but prevent selecting it.
- [ ] Render translated `messageCode`; do not render the backend code directly.
- [ ] Verify the old response cannot overwrite the newer request result.

### Task 4: Add failureReasons to shared availability

**Files:**
- Modify: `lib/features/subscription_checkout/data/models/response/subscription_availability_response_dto.dart`
- Modify: `lib/features/subscription_checkout/domain/entities/subscription_availability_entity.dart`
- Modify: `lib/features/subscription_checkout/data/mapper/subscription_availability_mapper.dart`
- Modify: `lib/features/subscription_checkout/data/models/response/subscription_readiness_response_dto.dart`
- Modify: `lib/features/subscription_checkout/domain/entities/subscription_readiness_entity.dart`
- Modify: `lib/features/subscription_checkout/data/mapper/subscription_readiness_mapper.dart`
- Test: `test/subscription_failure_reasons_mapper_test.dart`

**Interfaces:**
- `failureReasons` is `Map<String, int>?` on DTO and Entity.
- Availability remains nullable in summary/readiness/restaurant-availability.

- [ ] Parse null, empty, known, and unknown reason maps without throwing.
- [ ] Preserve counts exactly and avoid mutating the response map.
- [ ] Add readiness availability only as nullable; do not infer checkout permission from it.
- [ ] Verify summary and restaurant-availability continue parsing old fixtures without the field.

### Task 5: Localize availability and failure reasons

**Files:**
- Modify: `lib/core/l10n/app_ar.arb`
- Modify: `lib/core/l10n/app_en.arb`
- Modify: generated localization files through the project’s existing generator
- Create or modify: existing subscription localization helper under `lib/core/errors` or `lib/features/subscription_checkout`
- Test: `test/subscription_availability_localization_test.dart`

- [ ] Add translations for all listed failure codes and tier availability message codes.
- [ ] Return a localized fallback for unknown codes under “أسباب أخرى” / “Other reasons”, including the count.
- [ ] Test Arabic and English output for known and unknown codes.

### Task 6: Validate checkout and compatibility behavior

**Files:**
- Inspect and modify only if required: `lib/features/subscription_checkout/...`, `lib/features/payment/...`
- Test: `test/subscription_checkout_permission_test.dart`
- Test: `test/subscription_anchor_date_test.dart`

- [ ] Prove checkout remains enabled/disabled solely from `readiness.canCheckout`.
- [ ] Prove missing tier availability does not become implicit approval.
- [ ] Prove `startDate` remains the request anchor after summary responses, coupon changes, pagination, and checkout.
- [ ] Prove timeout/404/old response handling leaves the existing flow recoverable and does not crash the screen.

### Task 7: Generated code and final verification

**Files:**
- Modify: generated `.g.dart` files only through build_runner.

- [ ] Run `dart run build_runner build --delete-conflicting-outputs`.
- [ ] Run `dart format lib test`.
- [ ] Run `flutter analyze`.
- [ ] Run focused tests:
  - `flutter test test/subscription_tiers_endpoint_test.dart`
  - `flutter test test/subscription_tier_availability_mapper_test.dart`
  - `flutter test test/subscription_failure_reasons_mapper_test.dart`
  - `flutter test test/subscription_plan_start_date_tiers_test.dart`
  - `flutter test test/subscription_checkout_permission_test.dart`
  - `flutter test test/subscription_anchor_date_test.dart`
- [ ] Report changed files, checks, and any behavior requiring live backend/device verification.

## Handoff Notes for Gemini

نفّذ المهام بالترتيب، وافحص الملفات الحالية قبل كل تعديل. لا تنشئ feature جديدة ولا تنقل الكود من `core/subscription_tiers` إلى مكان آخر. إذا اختلف اسم mapper أو generated file عن المذكور، اتبع الاسم الموجود فعليًا في المشروع مع الحفاظ على نفس الطبقة والواجهة. لا تعتبر نجاح unit tests إثباتًا لصحة بيانات الباك الحية أو الدفع الحقيقي.
