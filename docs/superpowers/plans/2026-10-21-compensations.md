# Customer compensations implementation

Goal: Add the approved compensations page in Profile and a pending-choice notice in Home.

Architecture: Follow existing feature-based Clean Architecture, Retrofit ApiServices, nullable JSON DTOs, mapper extensions, ApiResult/safeApiCall, Injectable, use cases, and Cubit ViewModel with sealed events and immutable state. Reuse existing UI tokens and controls as explicitly authorized by the user. No payment/calendar flow changes.

Contract: User-provided Flutter integration guide dated 2026-10-21. GET /customer/compensations, GET /customer/compensations/{compensationId}/alternative-dates?count=14, POST /customer/compensations/{compensationId}/choose. Choice is CashRefund or AlternativeDay; targetDate required only for AlternativeDay.

- [x] Test defensive mapping, choice safety, server deadline, and conflict recovery.
- [x] Implement DTOs, entities, mappers, remote data source, repository, use cases and generated transport/DI.
- [x] Implement ViewModel, isolated countdown, date selection, compensation cards and refresh/lifecycle handling.
- [x] Add Profile entry and Home notice; Arabic/English localization.
- [x] Generate files, format, analyze, run focused tests and review diff.

Validation: 27 tests passed across compensation mapping, ViewModel, generated transport, UI, existing wallet and profile settings suites. Narrow 360px UI tests cover both Arabic RTL and English LTR, profile navigation and replacement date selection. Code review identified GET alternative-date expiry/eligibility recovery; fixed and regression tested. No live backend payment/refund calls were made. Existing generator warnings concern unrelated pre-existing registrations. Broader analysis includes existing Home/Profile styling lints; compensation code and related API/routing checks are clean.

Safety: Never infer a completed refund from expiry. Refresh authoritative state; Settled alone means complete. Prevent duplicate choices; reload dates on CAPACITY_DEPLETED_FOR_DATE; hide alternative choice on ALTERNATIVE_DAY_NOT_ELIGIBLE. Missing timing/identity must not enable choices. Use a monotonic elapsed clock anchored to server time for countdowns. Reload after app resume and deadline expiry.
