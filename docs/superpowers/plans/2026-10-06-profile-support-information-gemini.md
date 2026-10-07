# Profile Support, Information Pages, and App Version — Gemini Implementation Plan

> **For agentic workers:** Use `superpowers:executing-plans` if available. Execute the checklist task by task. Read the current implementation before making changes.

**Goal:** Remove Appearance from application settings, implement six missing support/information destinations inside profile using clearly identified fake data, and replace the static version display with a reliable bottom-of-page version component.

**Architecture:** Keep profile as the feature owner. Group presentation under `support` and `information`; reuse existing profile settings entry screen, shared UI components, routing, localization, and theme. Keep fake content and fake submission behind small typed interfaces outside widgets so replacing fake data later does not require redesigning screens. Do not build an entire new backend architecture for static FAQ/legal content.

**Tech stack:** Flutter/Dart, existing routing and localization, existing Bloc/Cubit when async state is needed, existing theme/widgets, Flutter tests. No live API or sending email/messages. No new state-management or UI package.

**Spec:** The approved design and behavior in this document are the self-contained specification. User requested the plan only; this file is a handoff for Gemini, not evidence that product changes were implemented.

## Global requirements

- Read `AGENTS.md` and all of `rules/ui_rules.md`. If implementing repositories/usecases/DI also read `rules/rules_backend.md`; `rules/backend_rules.md` was absent in the inspected checkout. Honor existing architecture before introducing any layer.
- Re-read `git status --short`; preserve all existing unrelated modifications, especially ongoing subscription and calendar work. Do not reset/stash/commit/push or execute subscription-billing/address-coverage plans.
- All six new pages stay inside `lib/features/profile`; do not create top-level `features/support` or `features/app_settings`.
- Reuse `CustomAppBar`, `AppButton`, `AppTextField`, settings cards, error/loading widgets, `AppWoltModalSheet` for modal feedback where suitable, existing assets/logo, and theme styles. Never create a duplicate design system.
- Each custom widget class has its own file. Plain Row/Column/Padding composition does not require extracting artificial components.
- Colors come from `context.colorScheme`; styles from `styles_manager.dart`; spacing from `Spacing`; app copy from `context.localization`. Add necessary keys to every configured locale and regenerate localization through the existing workflow.
- Inherited Directionality owns layout. No locale-code direction checks, forced RTL, manually reversed rows, guessed screen dimensions, or fixed-height content cards that truncate translated text.
- Controllers/focus nodes are created outside build and disposed. Use selective state listeners; no network/fake-submission calls in build. Preserve form input across loading/error states.
- Fake submissions must explicitly say nothing was sent to MealMate. Never invent working support contacts, complaint tracking status, approved legal terms, or company promises.
- Keep current Notifications and Language behavior. Do not redesign unrelated profile screens, authentication, subscriptions, or health goals.

## 1. Scope and current evidence

Current entry screen: `lib/features/profile/presentation/screens/profile_settings_screen.dart`.

- Notifications already opens `AppRoutes.notifications`.
- Language already opens `ProfileLanguageBottomSheet` and persists the selection.
- Appearance, Help Center, Contact Us, Complaints, About, Privacy, Terms, and Version currently have null action callbacks.
- Version also appears in a small bottom pill as `locale.profile_settings_version_label`, a static translated string rather than runtime app metadata.
- SecurityPrivacyScreen separately exposes privacy/terms through coming-soon feedback. Point these two entries at the new pages for consistent behavior; leave other security controls untouched.
- Shared settings tile currently contains locale-driven direction logic/fixed heights. Do not blindly reuse it for lengthy FAQ/legal content. If the settings surface itself needs a narrow shared fix, inspect its consumers and regression-test them; avoid a broad shared widget rewrite.

Approved destinations:

| Item | Behavior |
| --- | --- |
| Appearance | Remove completely from visible settings |
| Help Center | New FAQ page with local fake content and search |
| Contact Us | New local demo message form |
| Complaints | New local demo complaint form |
| About MealMate | New branded information page with sample content |
| Privacy Policy | New readable demonstration policy page |
| Terms and Conditions | New readable demonstration terms page |
| Application Version | No route/page; one noninteractive version footer at the very bottom |

## 2. Target file structure and ownership

Paths below are relative to `lib/features/profile/`:

```text
presentation/
  screens/profile_settings_screen.dart             # existing entry screen
  support/
    screens/profile_help_center_screen.dart
    screens/profile_contact_us_screen.dart
    screens/profile_complaints_screen.dart
    widgets/profile_faq_item.dart
    widgets/profile_support_intro_card.dart
    widgets/profile_support_message_form.dart
    widgets/profile_support_demo_result_sheet.dart
    manager/profile_support_form_view_model.dart
    manager/profile_support_form_state.dart
  information/
    screens/profile_about_screen.dart
    screens/profile_privacy_policy_screen.dart
    screens/profile_terms_screen.dart
    widgets/profile_about_identity_card.dart
    widgets/profile_information_document.dart
    widgets/profile_information_section.dart
  widgets/profile_app_version_footer.dart
domain/
  entities/profile_support_content_entity.dart
  entities/profile_support_message_entity.dart
  entities/profile_information_document_entity.dart
  repo/profile_support_repository.dart
  usecase/submit_profile_support_message_usecase.dart
data/
  fake/profile_support_fake_data.dart
  fake/profile_information_fake_data.dart
  repo/profile_support_fake_repository.dart
```

Create only components needed by the final implementation; do not fill folders with unused abstractions. FAQ item, intro card, form and legal renderer may be reused within profile. Keep contact and complaint routes/screens distinct while sharing their form component. Add a version service only if the project lacks one.

Content localization: keep stable IDs/section structure in fake data, resolve all displayed content using the existing localization system. Do not store translated strings in state or rebuild the fake dataset for every keystroke. Search operates on already localized text; refresh prepared search text when locale changes. Legal demo document is data; layout does not depend on document language checks.

## Task 1 — Baseline, design evidence, and reusable components

- [ ] Read rules and current settings/route/theme/localization implementations.
- [ ] Search for existing support/legal/version utilities and reuse any verified compatible ones.
- [ ] Record current status and analysis baseline; identify currently configured locales and localization generation command.
- [ ] Inspect the supplied screenshots and existing ProfileSettingsScreen: preserve its green icon containers, rounded surface cards, understated separators, compact typography, and MealMate brand treatment. This task has no full Figma reference for the six pages; do not claim invented geometry is Figma-measured.

```powershell
git status --short
rg --files lib | rg 'support|help_center|contact_us|complaint|about|privacy|terms|version|package_info'
rg -n 'profile_settings_|profile_privacy_policy|profile_privacy_terms' lib/core/l10n lib/config/routing
rg -n 'package_info|^version:' pubspec.yaml
flutter analyze
```

Deliverable: verified reuse decisions, version mechanism decision, and baseline. No backend endpoint guessing.

## Task 2 — Typed fake data and local submission behavior

**Interfaces:**

```dart
enum ProfileSupportMessageKind { contact, complaint }

class ProfileSupportMessageEntity {
  const ProfileSupportMessageEntity({
    required this.kind, required this.subject, required this.message,
    this.replyEmail,
  });
  final ProfileSupportMessageKind kind;
  final String subject;
  final String message;
  final String? replyEmail;
}
```

- [ ] Implement `ProfileSupportRepository.submit(ProfileSupportMessageEntity request)` through the existing `ApiResult` convention with a fake implementation and `SubmitProfileSupportMessageUseCase.call(request)` forwarding to it. Return a small typed local-demo result, never a server ticket number.
- [ ] Fake implementation has no Dio, HTTP, url_launcher, email, WhatsApp, analytics payloads, disk persistence, or logging of personal form text. A short local delay may exercise loading state. Do not retain submitted personal data after leaving the page.
- [ ] Use one route-owned `ProfileSupportFormViewModel` with immutable state: submitting, result, and failure; no shared instance between contact and complaints. Guard duplicate submission and emissions after close. Result shown once, with explicit reset/consume semantics.
- [ ] Seed about eight meaningful sample FAQ entries: subscription start, choosing meals, delivery address, freeze, invoices/payment, dietary preferences, renewal, and contacting support. Answers must be clearly demo/help examples; avoid fixed operational limits not verified by API contracts.
- [ ] Prepare sample About content describing meal planning, subscription management, and delivery organization without invented founding year, ratings, customer totals, or service guarantees.
- [ ] Prepare sectioned demonstration Privacy/Terms content with stable section IDs. Never claim these are the company's legally approved documents. Include a prominent localized “demonstration content, not final published policy/terms” notice.

Tests: fake repo performs zero transport calls; contact/complaint kind survives forwarding; duplicate submit is ignored while busy; close during delay does not emit; blank input never reaches repository.

## Task 3 — Help Center

**Screen:** `ProfileHelpCenterScreen`.

- [ ] Use shared app bar with localized Help Center title and back navigation.
- [ ] Show branded intro card with support icon, short heading, demo-content label, and concise guidance.
- [ ] Provide localized search field and FAQ expansion items. Search covers question/answer, trims whitespace, and matches case-insensitively. Prepare localized content outside repeated build work.
- [ ] Search state belongs to the FAQ section, so typing does not rebuild app bar/intro. Empty query shows all FAQs; no matches shows an explanatory state and clear-search action.
- [ ] Expansion uses stable FAQ IDs. Long answers wrap naturally and remain scrollable. Only item expansion state changes; no API request.
- [ ] Bottom links open Contact Us and Complaints via the routes defined in Task 7.

Tests: default list, matching search, no matches, clearing, expanding a long answer, correct contact/complaint route.

## Task 4 — Contact Us and Complaints

**Screens:** `ProfileContactUsScreen`, `ProfileComplaintsScreen`.

- [ ] Shared branded intro and shared `ProfileSupportMessageForm`; screens provide message kind and localized titles/labels.
- [ ] Fields: subject required, message required, reply email optional with format validation when nonempty. Use existing validations where compatible. If field limits are useful, declare them as local demo UI limits, not server rules; do not invent API validation constraints.
- [ ] Complaints additionally offers a small localized category selection (delivery, meals, payment, other); carry category as an optional typed field in the request if implemented. Do not offer tracking/history unless there is actual local data and clear demo labeling; it is outside this task.
- [ ] Disable submission while busy; keyboard submit uses the same guard/validation. Preserve input on local failure. Controllers remain owned by the form State and are disposed.
- [ ] Submission success shows `AppWoltModalSheet` or existing confirmation component with explicit localized copy: demo only, no message/complaint was sent. Never label it “successfully sent” or fabricate a support SLA.
- [ ] Do not automatically clear the form before the result appears. Provide an explicit reset/new-message action after demo completion. Back navigation with nonempty draft can use existing discard confirmation if available.
- [ ] Do not display fake phone/email as working company contacts. Any decorative channel card must be labeled sample and noninteractive; prefer omitting it until official contact data is supplied.

Tests: empty fields, invalid optional email, valid submit exactly once, repeated taps, loading spinner, retained draft, demo result wording, keyboard layout and long input.

## Task 5 — About, Privacy, and Terms

- [ ] About page: brand/logo from existing assets, short product introduction, compact value/feature cards, and link to Contact Us. Reuse existing green/surface identity without oversized decorative heroes or fabricated statistics.
- [ ] Privacy and Terms have separate routes and page titles but share `ProfileInformationDocument` rendering typed sections through `ProfileInformationSection`.
- [ ] Use clear heading/body hierarchy, comfortable paragraph spacing, scrollable content, and selectable text where compatible. Include localized demo-content notice before the document, not hidden at the bottom.
- [ ] Suggested Privacy sections: information provided, app usage, purpose of processing, user controls, support. Suggested Terms sections: service overview, account use, subscriptions, payment, delivery, support. Content remains placeholder/demo and does not invent binding refund/retention terms.
- [ ] Keep legal date/version optional. Do not display an invented “last updated” date as a real company publication date.
- [ ] Wire privacy and terms links in `security_privacy_screen.dart` to these same new routes; do not create duplicate policy screens.

Tests: title and demo notice visible; ordered sections; long translated paragraphs scroll without overflow; route from settings and security opens same destination.

## Task 6 — Bottom application version component

**Create:** `presentation/widgets/profile_app_version_footer.dart`.

- [ ] Remove the separate Application Version navigation row from the information card; keep only About, Privacy, Terms there. Replace the existing static bottom pill with the new footer so version appears once.
- [ ] Footer stays after the final information card, within the page scroll content and above bottom safe-area padding. It is not an overlay and does not need a fixed screen position or artificial Spacer to push it.
- [ ] Preserve the compact centered brand-colored pill from the screenshot: subtle semantic background, small existing icon, localized version label with dynamic value. No arrow, InkWell, onTap, route, or disabled-button styling.
- [ ] Read real app version using an existing package-info/version service if available. Load once outside build and isolate metadata loading from settings content.
- [ ] If package_info_plus is installed, reuse it and show its `version` (optional build number only if product style needs it). If absent, do not silently add a new package: use a verified existing build-metadata mechanism. An explicitly labeled fake version is acceptable under the user's fake-data scope until runtime metadata is available; report this limitation instead of claiming it is real.
- [ ] Never parse pubspec at runtime, hardcode `2.4.0` into a widget, or put a fixed number inside the translation key. Use parameterized localization such as `profile_settings_version_value(version)`.
- [ ] On metadata failure show localized “version unavailable”; no fabricated latest-version/update state. Fake version, if used, lives in the fake source and is clearly marked in the UI.

Tests: version rendered once; dynamic value changes without changing ARB; no navigation semantics; footer accessible after scrolling; metadata failure; English/Arabic readable version.

## Task 7 — Remove Appearance and connect navigation

**Modify:** profile settings screen, security privacy screen, `lib/config/routing/app_routes.dart`, `routing_generator.dart`, configured ARB files/generated localization.

Add routes following existing naming/value conventions:

```dart
static const String profileHelpCenter = '/profile-help-center';
static const String profileContactUs = '/profile-contact-us';
static const String profileComplaints = '/profile-complaints';
static const String profileAbout = '/profile-about';
static const String profilePrivacyPolicy = '/profile-privacy-policy';
static const String profileTerms = '/profile-terms';
```

- [ ] Check for existing equivalent routes first; reuse rather than duplicate.
- [ ] Route generator constructs the six screens at their new grouped presentation paths. No required account/DTO arguments for static content pages.
- [ ] Replace six null callbacks in settings with corresponding navigation callbacks. Update security Privacy/Terms callbacks from coming-soon to the same route pair.
- [ ] Remove Appearance row entirely. Remove its dedicated translations/helpers/assets only after `rg` proves they are unused; do not remove theme infrastructure used elsewhere.
- [ ] Preserve Notifications/Language and existing top-level `profileSettings` route. Sections adapt to new item counts and natural content height.
- [ ] Reuse a settings composition wrapper only if needed; do not move the entire existing settings screen to a different route as an incidental cleanup.

Deliverable: every retained navigation arrow in settings opens a real destination; version footer has no arrow; Appearance is absent in all configured languages.

## Task 8 — Identity, accessibility, and verification

- [ ] Match existing identity: compact green semantic icons, rounded light surfaces, subtle borders/shadows, existing Alexandria typography, natural content hierarchy, MealMate assets. New pages should look like the same app, not generic web forms.
- [ ] All screens respect SafeArea and scrolling; keyboard does not hide form actions. Verify narrow viewport (about 320px), regular phone, and large text scale. No arbitrary maxWidth/breakpoint without existing rule/design evidence.
- [ ] Verify AR/LTR rendering and every configured locale. Icon-only actions have semantic labels; forms have visible labels/errors; expanded FAQ state is understandable to accessibility tools.
- [ ] Avoid unnecessary animation/dependency changes. If using existing motion, respect reduced motion and never repeat entrance effects on form updates.
- [ ] Create meaningful focused suites: `test/profile_settings_destinations_test.dart`, `test/profile_help_center_test.dart`, `test/profile_support_form_test.dart`, `test/profile_information_pages_test.dart`, `test/profile_app_version_footer_test.dart`. Use fake dependencies/localization harness matching existing tests.
- [ ] Validate navigation for all six rows; absence of Appearance; unchanged language/notifications; no version route; no real transport on fake submission; draft/state lifetime; demo copy; long FAQ/legal text.

```powershell
flutter test test/profile_settings_destinations_test.dart test/profile_help_center_test.dart test/profile_support_form_test.dart test/profile_information_pages_test.dart test/profile_app_version_footer_test.dart
flutter analyze
git diff --check
git status --short
rg -n 'profile_settings_appearance|profile_settings_version_label' lib
```

Format only explicit changed Dart files. Regenerate localization/DI only through existing tools. Run existing relevant profile tests if shared widgets/routes changed. Classify baseline failures separately and inspect scoped diff for unrelated changes.

## Acceptance checklist

- [ ] Appearance removed; no leftover dead callback or unused owned helper.
- [ ] Six new destinations implemented and connected inside profile support/information groups.
- [ ] Existing notifications/language remain functional; security Privacy/Terms use new documents.
- [ ] UI follows `rules/ui_rules.md` and existing MealMate identity across locales/sizes.
- [ ] Fake content lives outside widgets; contact/complaint submissions are local, clearly demo, and make no external calls.
- [ ] Legal content prominently identified as demonstration content.
- [ ] Version shown exactly once at bottom, no arrow/route; runtime metadata or explicitly disclosed fake/unavailable state.
- [ ] Forms/search limit rebuilds, preserve state, dispose resources, and prevent duplicate submission.
- [ ] Tests/checks and representative screenshots recorded; no unrelated changes/commits/live mutation.

## Delivery report required from Gemini

Report files changed, route/page mapping, reused components, fake-data boundaries, version mechanism and whether real/demo, tests and analysis results, known baseline issues, and screenshots of Arabic/English settings, FAQ/search-empty, contact/complaint validation/result, About, and long Privacy/Terms. Do not claim API integration or official legal content.

## Ready-to-send Gemini prompt

> اقرأ `docs/superpowers/plans/2026-10-06-profile-support-information-gemini.md` كاملة و`rules/ui_rules.md` ثم نفذها. احذف المظهر من إعدادات التطبيق، واعمل مركز المساعدة وتواصل معنا والشكاوى وعن MealMate وسياسة الخصوصية والشروط والأحكام داخل profile بتقسيم support وinformation وبنفس هوية التطبيق ومكوناته. استخدم داتا وهمية منفصلة عن الواجهة دلوقتي؛ التواصل والشكاوى تجربة محلية فقط ولا تقول إن الرسالة اتبعتت فعلًا، والسياسات نصوص تجريبية مش قانونية معتمدة. اربط الست صفحات بالـroutes واربط الخصوصية والشروط في شاشة الأمان بنفس الصفحات. شيل صف إصدار التطبيق اللي فيه سهم واعمل جزء الإصدار مرة واحدة تحت آخر كارت، بقيمة فعلية لو آلية metadata موجودة، أو fake معلن بوضوح بدون حزمة جديدة غير مصرح بها. حافظ على اللغة والإشعارات وباقي الشغل الموجود، وقلل rebuilds، وادعم RTL/LTR والكيبورد والخط الكبير. اختبر التنقل والفورمز والداتا الوهمية والإصدار وسلّم النتائج والصور والحدود بوضوح. لا تعمل commit أو إرسال خارجي ولا تنفذ الخطط الأخرى.
