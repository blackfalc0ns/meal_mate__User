# Checkout/payment separation

Approved scope: move preparation (methods, selection, request creation, order summary and pay button) from payment into subscription_checkout; payment retains gateway redirect, recovery, verification, hold renewal and outcomes. Remove verified unused files/classes and unused factory parameter. Preserve visuals, route URLs, real API contracts and prior operational-capacity behavior.

- [x] Split checkout data/domain operations into existing subscription_checkout architecture; reuse shared gateway session response.
- [x] Split checkout ViewModel/Event/State and move preparation screen/widgets/arguments; route existing entry points to relocated screen.
- [x] Reduce PaymentViewModel/Event/State dependencies; persist recovery record and initialize session before exposing gateway; verify empty-URL or existing subscriptions in payment layer.
- [x] Remove audited unused UI/classes, update imports/DI/tests, generate files and analyze/test.
- [x] Read-only final review for preparation/recovery boundaries and duplicate-checkout safety.

Constraints: no package changes, no unrelated source cleanup, no manual generated-file edits, no commits requested. Existing staged/unstaged user changes preserved. UI reuses current components/styles; no redesign. Import migrations outside the two feature directories are allowed only where they consume moved types/widgets/usecases.

Review ledger:
- Initial review: checkout preparation ownership, DTO/usecase consumer migration and DI verified. Fixed retained-session gateway reopening, moved family mapper extension import, and routed empty-URL promo checkout through payment verification.
- Independent final review: terminal-failure return must differ from cancellation; persisted-attempt status writes must match current session identity. Both findings assigned together for one fix wave and focused re-review.
- Validation so far: build_runner succeeded; scoped feature/routing/DI analyzer clean; 44 checkout/payment tests and 66 expanded mapper/recovery/family contract tests passed (overlapping coverage). Campaign screen/callback check also passed (10 tests).
- Broader `dart analyze lib test` reports issues outside this split, including calendar navigation test mocks, missing SensitiveDataSanitizer references, influencer test entity references, and summary repository test mocks missing getPricingPreview. Those unrelated files were not changed for this task.

Completion:
- Final review fix wave: terminal failures return a distinct outcome, release the completed checkout and idempotency key for deliberate retry; cancellation retains the original session. Failed no-URL recovery returns to the summary with localized failure copy.
- Every persisted verification-status update now matches subscription, flow, and payment handle when available. Review callbacks match payment handle and flow.
- Scoped re-review: both findings addressed; no new regression found in those fixes.
- Final targeted analyzer across both features, routing, generated DI, family mapper consumer, and 8 related test files: No issues found.
- Final review regression suite: 34 tests passed across 5 affected files. Earlier 44-test migration suite, expanded 66-test run, and 10-test campaign callback run passed; counts overlap and are not a distinct total.
- No live payment transaction was performed. Broad repository analyzer remains non-clean for the unrelated issues recorded above. No commits created; existing user changes retained.
