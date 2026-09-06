# Calendar presentation refactor

Goal: Reduce CalendarScreen responsibilities, reuse restaurant_menu and meal_details, and scroll meal details as one page.

Keep CalendarViewModel, events, state, repositories and APIs unchanged. Preserve existing save-success and route-close guards. Preserve existing visual tokens except the explicitly requested removal of sheet layout.

- [x] Add a regression test proving meal details header scrolls with content; retain selection and allergens coverage.
- [x] Replace MealDetailsSheet with non-scrolling MealDetailsContent inside the screen's single scroll view.
- [x] Extract calendar day content, restaurant selection sheet, meal selection page and save button using the existing ViewModel.
- [x] Extract calendar date-grid calculations and calendar-to-details presentation mapping. Reuse the mapping from restaurant_menu while preserving caller-specific fallbacks and selection callbacks.
- [x] Update affected tests, run targeted Flutter tests and analysis, review diff and preserve unrelated working changes.

Validation: 35 targeted Flutter tests passed; targeted Flutter analysis reports no issues; git diff --check passed. CalendarScreen is 251 lines. No ViewModel or API changes.
