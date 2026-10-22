# Operational capacity integration plan

Goal: Complete the remaining approved backend changes after the compensations feature.

Contract: user attachments dated 2026-10-21, latest guide at C:/Users/orignal store/.codex/attachments/2da15d84-7f05-4d59-aab8-c4f7b07d6724/Pasted text.txt plus prior calendar contract at C:/Users/orignal store/.codex/attachments/c7d5b31c-45e2-4301-b3c2-ee919d1fc2ab/Pasted text.txt.

Architecture: Keep existing feature-based DTO/mapper/entity, data source/repository/use case and Cubit ViewModel Event State flow. Keep existing Retrofit/DI. No new packages. Existing visual components and theme/localization are approved for reuse.

- [x] Start dates: GET /api/v1/customer/subscription-flow/eligible-start-dates?includeFriday=false&lookaheadDays=14, server eligible dates only, individual and family date pickers; no local lead-date invention.
- [x] Payment: map serverTimeUtc and holdExpiresAtUtc from checkout/resume; isolate countdown, block expired payment, renew through existing subscription resume flow and recover checkout.quote_changed.
- [x] Calendar: map server canSelectMeal/canChangeAddress/canFreeze plus individual cutoffs and operationalLeadHours; enforce on screen and intents; hide Friday according to plan including family screens using actual documented contracts.
- [x] Generate code and localizations, format touched files, run targeted tests/analyzer, task and final review.

Ruling: Work in the current workspace without a new worktree — authorized compensation changes are uncommitted here and must remain visible together; no commits or external side effects requested.
Ruling: Reuse the approved existing UI style rather than require new Figma approval — user explicitly authorized existing components/styles.
Ruling: Do not invent family backend endpoints or change family checkout contract. Apply shared rules through existing family APIs/entities and shared eligible-start-dates endpoint where applicable.

Validation requires behavior tests for server-only start dates, Friday filtering, payment expiry/renewal/conflicts, and calendar permission cutoffs; keep compensation regression tests passing. Live server behavior must be distinguished from local transport tests.

## Validation and review, 2026-10-22

45 focused tests passed in the final combined run: calendar deadline widgets and permissions, freeze range UI, eligible date transport/mapping/summary/UI, payment hold/resume/UI, and compensation regressions. The summary coupon/pagination/date/range batch also passed 16 tests after adding the already-required pricing-preview method to its stale test repository stubs. Generated Retrofit/JSON/DI and Arabic/English localizations are updated. Broader source analysis found no compile errors; remaining existing warnings/info are outside the focused clean analysis set. Final read-only code review found no remaining important issue in the five reviewed risk areas.

Review fixes: verify the server payment status before replacing a launched checkout; revalidate picker dates against a fresh server list; retain read-only family meal details after cutoff; schedule scoped deadline-driven action rebuilds; require real eligible freeze endpoints while allowing excluded Friday only inside a service-date range. Freeze bounds now come from permitted calendar days rather than local lead-day calculations.

Existing broader-test limitations observed: calendar edit-permission tests contain expectations contrary to the original entity's locked/block-reason semantics, and a billing action snackbar test expects raw server text rather than the localized presenter output. These expectations were not changed to force a green full suite. This is not a claim that every repository test passes.

Contract limits: existing per-day address controls/endpoints do not exist in the current customer/family calendar surfaces; canChangeAddress/addressEditClosesAt are mapped into the shared day entity and its server-clock permission getter for those integrations. Global pre-checkout address setup is preserved. No undocumented address mutation endpoint was invented. If calendar serverTimeUtc is absent, server can* flags remain authoritative; device wall-clock time never substitutes for server time. Family payment renewal uses its existing family retry context, not the individual resume endpoint.

No live gateway charge/refund or authenticated server end-to-end checkout was performed. Device/server integration QA remains required before release.
