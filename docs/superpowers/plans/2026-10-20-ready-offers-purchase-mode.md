# Ready Offers Purchase Mode Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Separate ready-to-buy offers from coupon-only offers in the Flutter app using the backend `purchaseMode` field, and route each type to its valid flow.

**Architecture:** Keep the current Offers DTO → mapper → entity → repository/use case → OffersViewModel → screens path. Derive sections from the existing offer list; keep the existing direct-purchase screen and coupon validation flow. Do not request purchase options for every item in the list.

**Tech Stack:** Flutter, Dart, Dio/Retrofit, json_serializable, Injectable/GetIt, flutter_bloc, Flutter l10n, flutter_test.

**Spec:** Backend handoff pasted as `C:\Users\orignal store\.codex\attachments\ed1c2fc0-101c-457e-90ac-42472d6c9c0f\Pasted text.txt`; existing offer checkout contract in `C:\Users\orignal store\.codex\attachments\1c52a08c-c95f-4b39-a6f8-604ddc0b6979\Pasted text.txt`.

## Global Constraints

- Read `rules/ui_rules.md` and `rules/rules_backend.md` before implementation; the AGENTS.md backend_rules.md name is stale in this checkout.
- Preserve the current feature architecture, design tokens, localization, and unrelated worktree changes. No new package.
- The worktree currently contains unrelated uncommitted edits; stage only the files belonging to this plan if implementation is committed.
- Backend values are exactly `DirectPurchase` and `CouponOnly`. The backend report says both are deployed, but verify with a fresh API response during QA.
- Request `includeCampaigns=false` for these offer lists so campaign projections remain in their separate campaign flow. A campaign projection can still arrive from another entry point with `purchaseMode=CouponOnly` and a campaign ID; never pass that ID to offer `/details` or `/purchase-options`.
- `packageTargets`, `promoCode`, title, and image are not purchase-mode classifiers. Prices and eligibility come from `/purchase-options` and summary.
- The new campaign quote/checkout flow is a separate project. This plan covers the ready-offer listing and coupon routing only.

---

### Task 1: Carry `purchaseMode` through the offer model

**Files:**
- Modify: `lib/features/offers/data/models/response/offer_response_dto.dart`
- Modify: `lib/features/offers/domain/entities/offer_entity.dart`
- Modify: `lib/features/offers/data/mapper/offer_mapper.dart`
- Generated: `lib/features/offers/data/models/response/offer_response_dto.g.dart`
- Test: `test/features/offers/offer_mapper_test.dart`

**Interfaces:** `OfferResponseDto.purchaseMode: String?`; `OfferEntity.purchaseMode: OfferPurchaseMode`; `OfferPurchaseMode { directPurchase, couponOnly, unknown }`; `OfferEntity.isDirectPurchase` and `isCouponOnly` getters.

- [ ] **Step 1: Write mapper tests** for `DirectPurchase`, `CouponOnly`, a missing field, and an unrecognized value. Verify `copyWith` keeps the parsed mode.
- [ ] **Step 2: Run** `flutter test --no-pub test/features/offers/offer_mapper_test.dart` and confirm the new cases fail.
- [ ] **Step 3: Add** nullable `purchaseMode` to the DTO, parse the two exact backend strings in the mapper, and represent any other value as `unknown`. Add it to the entity constructor and `copyWith`. Never infer the mode from `promoCode` or `campaignId`.
- [ ] **Step 4: Run** `dart run build_runner build`, then the targeted test. Confirm generated JSON reads `purchaseMode`.

Implementation shape:

```dart
enum OfferPurchaseMode { directPurchase, couponOnly, unknown }

OfferPurchaseMode parseOfferPurchaseMode(String? raw) => switch (raw) {
  'DirectPurchase' => OfferPurchaseMode.directPurchase,
  'CouponOnly' => OfferPurchaseMode.couponOnly,
  _ => OfferPurchaseMode.unknown,
};
```

Test shape:

```dart
expect(OfferResponseDto.fromJson({'purchaseMode': 'DirectPurchase'})
    .toEntity().purchaseMode, OfferPurchaseMode.directPurchase);
expect(OfferResponseDto.fromJson({'purchaseMode': 'FutureMode'})
    .toEntity().purchaseMode, OfferPurchaseMode.unknown);
```

### Task 2: Derive two sections from the current offers response

**Files:**
- Modify: `lib/features/offers/presentation/manager/offers_state.dart`
- Modify: `lib/features/offers/presentation/manager/offers_view_model.dart`
- Test: `test/features/offers/offer_purchase_mode_sections_test.dart`

**Interfaces:** State getters `readyOffers`, `couponOffers`, and `unclassifiedOffers` over `filteredOffers`. Existing category selection continues to filter before these getters are evaluated.

- [ ] **Step 1: Write tests** with a mixed list: one direct, one coupon, one unknown. Assert the direct item appears once in ready offers, the coupon once in coupon offers, and unknown appears only in the safe general/unclassified list. Exercise a category filter and a refresh.
- [ ] **Step 2: Run** `flutter test --no-pub test/features/offers/offer_purchase_mode_sections_test.dart` and confirm failure.
- [ ] **Step 3: Derive sections** from `filteredOffers`; do not keep a second mutable copy of each section. Leave unrelated category behavior in place; never use those category heuristics to decide purchase routing.
- [ ] **Step 4: Run** the new test and existing offers tests. Confirm refresh and save/unsave still update both sections from one source list.

Implementation shape:

```dart
List<OfferEntity> get readyOffers => filteredOffers
    .where((offer) => offer.purchaseMode == OfferPurchaseMode.directPurchase)
    .toList();
List<OfferEntity> get couponOffers => filteredOffers
    .where((offer) => offer.purchaseMode == OfferPurchaseMode.couponOnly)
    .toList();
List<OfferEntity> get unclassifiedOffers => filteredOffers
    .where((offer) => offer.purchaseMode == OfferPurchaseMode.unknown)
    .toList();
```

### Task 3: Show ready offers and coupons separately

**Files:**
- Modify: `lib/features/offers/presentation/screens/offers_screen.dart`
- Modify: `lib/features/offers/presentation/screens/browse_offers_screen.dart`
- Reuse: `lib/features/offers/presentation/widgets/offer_deal_card.dart`, `offer_browse_card.dart`, `offers_section_header.dart`, existing loading/empty/error widgets
- Modify: `lib/core/l10n/app_ar.arb`, `app_en.arb`; regenerate `lib/core/l10n/translations/` if the section titles need new keys
- Test: `test/features/offers/offer_purchase_mode_sections_test.dart`

- [ ] **Step 1: Add a widget test** with two known modes. Assert both named sections appear, each card belongs to one section, and an empty ready section shows its own empty state without hiding coupons.
- [ ] **Step 2: Run** the widget test and confirm failure.
- [ ] **Step 3: Compose** the two sections using the existing cards, spacing, typography, and semantic colors. Keep the hero card and current page loading/error behavior. Place `unknown` offers in the general browsing list with no action, so older or malformed responses cannot be misclassified.
- [ ] **Step 4: Run** `flutter gen-l10n` if keys were added, then the widget test. Verify Arabic and English labels and RTL layout through the existing localization setup.

Composition shape:

```dart
OffersSectionHeader(title: locale.offers_ready_section_title);
AnimatedOfferRow(
  itemCount: state.readyOffers.length,
  itemBuilder: (context, index) => OfferDealCard(
    offer: state.readyOffers[index],
    onTap: () => Navigator.of(context).pushNamed(
      AppRoutes.offerDetails,
      arguments: state.readyOffers[index].id,
    ),
  ),
);
```

The coupon section uses the same existing cards with `state.couponOffers` and its own localized title. When a section is empty, show its localized empty text in that section. The general browse list retains unknown offers without a purchase action.

### Task 4: Route each mode safely from every entry point

**Files:**
- Modify: `lib/features/offers/presentation/screens/offers_screen.dart`
- Modify: `lib/features/offers/presentation/screens/browse_offers_screen.dart`
- Modify: `lib/features/offers/presentation/widgets/offer_quick_preview_sheet.dart`
- Modify: `lib/features/offer_details/presentation/screens/offer_details_screen.dart`
- Modify: `lib/features/offers/presentation/screens/promo_code_input_screen.dart` and `lib/config/routing/routing_generator.dart` only if passing an initial coupon code is needed
- Test: `test/features/offers/offer_purchase_mode_navigation_test.dart`

- [ ] **Step 1: Write navigation tests** for a real direct offer, a coupon-only offer, a coupon-only campaign projection, and an unknown mode. The campaign ID must never reach offer details or purchase-options.
- [ ] **Step 2: Run** the navigation test and confirm failure.
- [ ] **Step 3: Send** `DirectPurchase` to existing offer details and then the existing `redeemPackage` route. Send `CouponOnly` to the coupon path, preserving its code for validation; add a nullable initial code to `PromoCodeInputScreen` route arguments only if the current screen cannot accept it. Do not issue campaign checkout from this offer route. Keep unknown entries viewable in the general list without a purchase CTA.
- [ ] **Step 4: Guard** both the offer-details CTA and quick-preview CTA so a coupon-only or unknown entity cannot enter `redeemPackage` even from saved offers, hero, or a stale deep link. Where details are fetched again, use the returned `purchaseMode` as the final decision.
- [ ] **Step 5: Run** navigation tests. Manually tap hero, row card, browse card, quick sheet, and offer-details button for both known modes.

Routing rule applied at every entry point:

```dart
switch (offer.purchaseMode) {
  case OfferPurchaseMode.directPurchase:
    Navigator.of(context).pushNamed(AppRoutes.offerDetails, arguments: offer.id);
  case OfferPurchaseMode.couponOnly:
    Navigator.of(context).pushNamed(
      AppRoutes.promoCodeInput,
      arguments: offer.promoCode,
    );
  case OfferPurchaseMode.unknown:
    // No navigation: neither an offer ID nor a coupon flow is guaranteed.
}
```

For an unexpected campaign projection from another entry point, route to coupon input only when a nonempty promo code exists. Otherwise show no action; never request offer details using its campaign ID. The optional initial code is copied into the promo input for user review, not automatically applied.

### Task 5: Transport and acceptance checks

**Files:**
- Modify only if verified necessary: `lib/core/network/api_services.dart`, offer data source/repository/use case signatures, and generated Retrofit code
- Test: targeted offer and payment tests

- [ ] **Step 1: Check** a fresh authenticated `/api/v1/customer/offers/available` response for `purchaseMode` on each returned item. Verify the report's direct test offer resolves `/purchase-options`; do not hardcode test IDs or prices in the app.
- [ ] **Step 2: Add** optional `includeCampaigns` to `ApiServices.getCustomerAvailableOffers` and thread it through the offer data source, repository, and use case. Both `OffersScreen` and `BrowseOffersScreen` call the use case with `false`; leave the default `null` for other callers to preserve legacy behavior. Assert the generated Retrofit query sends `includeCampaigns=false` only for these screens.
- [ ] **Step 3: Run** `flutter analyze --no-pub` on changed features, targeted offer/navigation/widget tests, and `git diff --check`. Check the generated files are included.
- [ ] **Step 4: Device QA:** open the offers page, confirm one direct QA offer appears under ready offers and coupon-only items under coupons; open direct offer, select a real backend option, review quote, and stop before live payment unless sandbox credentials and approved callback URLs are available. Confirm coupon-only campaign projection never produces an offer-details 404.
- [ ] **Step 5: Report** exact checks run and remaining live dependencies. Do not claim the backend deploy or payment gateway succeeded based solely on the backend handoff text.

Acceptance assertions:

```dart
expect(availableResponse.any((item) => item['purchaseMode'] == 'DirectPurchase'), isTrue);
expect(readyOffers.every((offer) => offer.isDirectPurchase), isTrue);
expect(couponOffers.every((offer) => offer.isCouponOnly), isTrue);
expect(purchaseOptionsCallsForCouponOnly, 0);
expect(availableQuery['includeCampaigns'], false);
```

## Scope boundary

The backend handoff also introduces a separate `/api/v1/customer/campaigns` list/details/quote/checkout flow. It needs its own implementation plan from `CAMPAIGN_MOBILE_FLOW_CONTRACT.md`. The existing individual/family coupon checkout remains unchanged here.
