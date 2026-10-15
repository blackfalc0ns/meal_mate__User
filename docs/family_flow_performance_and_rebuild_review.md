# Family Flow Rebuild & Performance Audit

## Overview
This document tracks widget rebuilding optimizations, state selectors, and performance boundaries across all presentation files in the Family Subscription Flow.

## Rebuild Optimization Matrix

| Widget | Exact State Fields Read | Listener / Consumer | Trigger | Changes That Must NOT Rebuild It |
|---|---|---|---|---|
| `FamilyFlowScaffold` / Navigator | `currentStep` | `ValueListenableBuilder<int>` | Step route transitions | Member addition, allergy updates, price calculation, member selection |
| `FamilyAddMemberDialog` | `isAddingMember`, `memberSaveFailure` | Local controller + `BlocListener` | Save member action | Typing in text fields (handled via TextEditingController listeners) |
| `FamilyMemberDialogHeader` | None (static / localized) | Stateless Widget | Initial render | Field changes, validation errors, submission |
| `FamilyMemberFormFieldsSection` | Controllers / focus nodes | Stateful Widget | Controller events | Dialog background operations |
| `FamilyMemberRelationshipSection` | Selected relationship string | Stateful / Callback | User tap | Input field changes |
| `FamilyMemberDialogActions` | `isLoading` | `BlocSelector<..., bool>` | Submission loading state | Typing in phone/name fields |
| `FamilyProgramGridLoadingSkeleton` | None (static skeleton) | Keyed Stateless Widget | Loading state entry | Polling, tab changes |
| `FamilyProgramSetupScreen` | `isProgramsLoading`, `failure` | `BlocConsumer` with `buildWhen` | Initial load or retry | Stepper updates, target member changes in other screens |
| `FamilyPaymentSetupScreen` | `isCurrentFlowLoading`, `failure` | `BlocConsumer` with `buildWhen` | Initial load or failure | Payment method selection, start date picker tap |
| `FamilyPaymentContent` | Composition of sections | Keyed with `ValueKey('family-payment-content')` | First successful summary | Individual member check/uncheck |
| `FamilyPaymentMethodsActionsSection` | `isPaymentMethodsLoading`, `selectedPaymentMethod` | `BlocSelector` / selective build | Gateway list load | Meal count calculation, schedule updates |
| `PaymentSuccessScreen` | `PaymentSuccessArgs` | Keyed with `ValueKey('subscription-success-content')` | Initial route push | Background fulfillment polling ticks |

## Selective Listening & Rebuild Boundaries
1. **Scaffold Isolation:** The `FamilyFlowScaffold` observes `currentStepListenable` exclusively. Emitting member additions, addresses, or allergies in child Cubits does not trigger rebuild of the top app bar or stepper.
2. **Dialog Form Decoupling:** `FamilyAddMemberDialog` was decomposed into 4 discrete components. Character-by-character typing does not trigger `BlocBuilder` rebuilds because form state resides in `TextEditingController`s with validation triggered on-demand.
3. **Entrance Animation Stability:** All entrance animations use stable `ValueKey`s. State mutations such as selecting a payment method or toggling a member reuse existing widget keys, preventing Flutter Animate from restarting entrance transitions.
4. **DevTools / Measurement Context:** In this environment, offline unit and widget tests verify rebuild constraints (e.g. `buildWhen` and `BlocSelector` scopes). Live frame profiling via Flutter DevTools requires an interactive simulator profile build; non-measurable metrics are documented accordingly without claiming simulated verification.
