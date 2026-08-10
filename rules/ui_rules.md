# Flutter UI Rules

## General

* Follow the existing project architecture.
* Modify only the requested files.
* Do not create unnecessary files or folders.
* Reuse existing widgets before creating new ones.
* Do not change the project structure unless explicitly requested.
* Do not add new packages unless explicitly requested.

## Context

At the beginning of every `build` method, always declare:

```dart
final color = context.colorScheme;
final locale = context.localization;
```

Use these variables throughout the widget.

## Colors

* Always use `color`.
* Never use `Colors.*` or `Color(...)`.
* Never hardcode colors.

## Localization

* Always use `locale`.
* Never hardcode user-facing text.
* If a localization key is missing, mention that a new key is required instead of hardcoding text.

## Text Styles

Always use the existing styles from:

```text
lib/config/theme/styles_manager.dart
```

* Never create a new `TextStyle`.
* Use `copyWith()` only when needed.
* If a required style is missing, add it to `styles_manager.dart`.

## Spacing

Always use spacing values from:

```text
lib/config/theme/spacing.dart
```
## EdgeInsets

* Prefer `EdgeInsets.symmetric()` whenever possible.
* Use `EdgeInsetsDirectional.only()` when the padding is related to `start` or `end`.
* Use `EdgeInsets.only()` only when the padding must remain physically fixed to `top`, `bottom`, `left`, or `right` in both RTL and LTR.
* Use `EdgeInsets.all()` when all sides have the same value.
* Avoid `EdgeInsets.fromLTRB()` unless it is the only correct option for the design.
* Keep padding values consistent by using the spacing constants from:

```text
lib/config/theme/spacing.dart
```

Examples:

✅ Preferred

```dart
EdgeInsets.symmetric(
  horizontal: Spacing.md,
  vertical: Spacing.sm,
)

EdgeInsets.only(
  top: Spacing.md,
  bottom: Spacing.lg,
)

EdgeInsets.all(Spacing.md)
```

❌ Avoid

```dart
EdgeInsets.fromLTRB(
  Spacing.md,
  Spacing.sm,
  Spacing.md,
  Spacing.sm,
)
```


* Never hardcode spacing values.
* Use the existing spacing constants for `Padding`, `SizedBox`, `Gap`, and `EdgeInsets`.

## Widget Files

* Every custom widget must be placed in its own separate file.
* Keep exactly one widget class per file.
* This rule applies to both public and private widgets.
* Never create private widgets inside another widget file.
* Never create widgets such as `_Header`, `_Card`, `_Item`, `_Tile`, `_Button`, `_Logo`, or `_MetaChip` inside another widget file.
* Even if a widget is used only once, it must still be placed in its own file.
* Place widgets inside the appropriate `widgets/` folder for the current feature.
* The parent screen or parent widget file should only compose and organize child widgets.
* Reuse existing widgets before creating new ones.
* Do not duplicate existing widgets.

## Responsive UI

* Build responsive layouts.
* Avoid fixed widths and heights unless required.
* Use `Expanded`, `Flexible`, `Spacer`, `Wrap`, `LayoutBuilder`, and `MediaQuery` when appropriate.

## UI Rules

- The Figma design is the single source of truth.
- Never redesign or improve the UI unless I explicitly ask.
- If you cannot complete a task, stop and ask me before continuing.
- Never guess values.
- Never swap left and right manually.

## RTL / LTR Rules

The application supports both RTL and LTR.

- Arabic → RTL.
- English → LTR.

Always use Flutter directional widgets:
- EdgeInsetsDirectional
- AlignmentDirectional
- BorderRadiusDirectional
- PositionedDirectional

Respect Directionality.of(context).

Never hardcode left/right.
Never mirror the UI manually.
The same code must work correctly for both Arabic and English.
Never think in terms of "left/right code".
Think in terms of the final rendered result.

The rendered UI must match the Figma exactly.
If using Directional APIs would place an element on the opposite side, use the correct implementation that preserves the visual position.

## Code Quality

* Use `const` whenever possible.
* Keep widgets small and readable.
* Remove unused imports.
* Remove unused variables.
* Remove unused methods.
* Do not add unnecessary comments.
* Do not add placeholder or dummy code.
* Do not create helper methods that have no functional purpose.
* Do not add new packages unless requested.

## Before Creating Anything

Always check whether the project already contains:

* A reusable widget
* A text style
* A spacing constant
* A localization key
* An asset
* A helper or extension

Reuse existing code whenever possible.

## Fake Data Models

* Any image that will later come from the backend must be represented as a field inside the corresponding model/entity.
* The image path must be stored in the fake data source as part of the model, not inside the UI.
* Store the asset path using `AssetsFake`.
* Widgets must always read the image from the model.
* Never hardcode asset paths inside widgets.

Example:

```dart
HomeMealEntity(
  title: '...',
  imageAsset: AssetsFake.homeOatmeal,
)
```

```dart
HomeCategoryEntity(
  title: '...',
  imageAsset: AssetsFake.homeBurger,
)
```

And in the UI:

```dart
Image.asset(meal.imageAsset)
```

Never do:

```dart
Image.asset(AssetsFake.homeOatmeal)
```

directly inside a widget.

If a model does not already contain an image field, add one instead of passing the asset separately.


## Never

* Hardcode colors.
* Hardcode user-facing text.
* Hardcode spacing.
* Create duplicate widgets.
* Change the project architecture.
* Add business logic when only UI is requested.
* Modify unrelated files.
* Create fake or placeholder code just to satisfy these rules.
* Leave unused imports, variables, methods, or classes in the final code.
- Never create a widget inside another widget file, even if it 
is used only once.
* Never hardcode `left` or `right` when `start` or `end` is intended.
* Never force a `TextDirection` unless explicitly requested.
* Never reverse a `Row` manually based on the locale.


# Figma Rules

- Figma is the single source of truth.
- Implement the design exactly as it appears in Figma.
- Never redesign, improve, or reinterpret the UI.
- Always inspect the Figma node before implementing.
- Never guess measurements, colors, typography, spacing, or sizes.
- Use the exact values from Figma for spacing, padding, margins, dimensions, border radius, colors, typography, shadows, and icon sizes.
- Never adjust spacing or alignment manually to "look better".
- Never change the widget hierarchy unless explicitly requested.
- If any detail is unclear, inspect the Figma properties instead of making assumptions.
- The final Flutter UI must match the Figma design as closely as possible, pixel by pixel.
- If the implementation differs from Figma, Figma is always correct.

- Do not use screenshots as the source of truth.
- Always inspect the Figma file and its nodes before implementing.
- Never estimate values from images when they are available in Figma.
- Avoid font sizes that are difficult to read. Use reasonable minimum font sizes for body text and labels unless there is a compelling design reason not to.

# CRITICAL RULE:

If you fail to complete any step, you MUST ask me before doing anything else.

Do NOT:
- Assume values.
- Invent implementations.
- Redesign the UI.
- Skip any requirement.
- Continue with a workaround without my approval.

Instead, stop, explain the issue, and ask me exactly what you need.







