# Unused Assets Cleanup Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove the 25 statically unreferenced asset files identified in the 2026-10-03 audit and remove only their 15 corresponding constants from `assets.dart`, without changing runtime UI, `assets_fake.dart`, or unrelated assets.

**Architecture:** This is a conservative asset-manifest cleanup, not a redesign or asset-system migration. Re-verify every candidate against the current working tree immediately before deletion, delete only candidates that still have zero consumers, remove their exact dead constants, and prove the remaining asset constants resolve to existing files.

**Tech Stack:** Flutter, Dart 3.12, PowerShell, ripgrep, flutter_test.

**Spec:** User-approved static asset audit from 2026-10-03, `AGENTS.md`, `rules/ui_rules.md`, `lib/core/constants/assets.dart`, and `lib/core/constants/assets_fake.dart`.

## Global Constraints

- Do not alter the current visual design or replace any asset with another asset.
- Do not delete an asset if any production source, test, native configuration, JSON, or generated source references it at execution time.
- A declaration inside `assets.dart` is not a runtime consumer; the constant must be referenced outside its declaration file to count as used.
- Directory declarations in `pubspec.yaml` are packaging declarations, not proof that every file in the directory is used.
- Do not remove directory entries from `pubspec.yaml`; all listed directories still contain used assets.
- Do not modify `lib/core/constants/assets_fake.dart`; none of the 25 approved candidates is declared there.
- Do not remove `_images` or `_svg` from `assets.dart`; both are shared base-path constants used by retained declarations.
- Do not remove `Assets.buttonSmall` or `Assets.buttonLarge` in this plan. Their constants may be unused, but the physical files are referenced directly by `custom_app_button.dart` and were not part of the approved 25-file cleanup.
- Preserve all existing uncommitted work. At plan-writing time, the working tree contained extensive calendar refactor changes; never reset, checkout, stash, or reformat them.
- Stage and commit only the asset files and `assets.dart` changes listed by this plan.
- If any candidate gained a consumer after this plan was written, exclude that candidate and its constant from deletion and report it.

## Exact Approved Deletion Set

### A. Files With a Constant in `Assets`

Delete the physical file and remove the named constant from `lib/core/constants/assets.dart`:

| Constant to remove | Physical file to delete |
| --- | --- |
| `Assets.homeFigmaAvatar` | `assets/images/home/figma/home_avatar.png` |
| `Assets.homeNutritionDivider` | `assets/images/home/figma/home_nutrition_divider.svg` |
| `Assets.homeSubscriptionProgress` | `assets/images/home/figma/home_subscription_progress.svg` |
| `Assets.nutritionDetailsBack` | `assets/images/home/figma/nutrition_details_back.svg` |
| `Assets.addressesChooseLocationMap` | `assets/images/profile/addresses_choose_location_map.png` |
| `Assets.addressesIconBuilding` | `assets/images/profile/addresses_icon_building.svg` |
| `Assets.addressesIconGps` | `assets/images/profile/addresses_icon_gps.svg` |
| `Assets.addressesIconHomeOutline` | `assets/images/profile/addresses_icon_home_outline.svg` |
| `Assets.healthGoalBack` | `assets/images/profile/health_goal_back.svg` |
| `Assets.familyManageInvoice` | `assets/images/subscriptions/figma/family_manage_invoice.svg` |
| `Assets.monthlyDurationSelector` | `assets/images/subscriptions/figma/monthly_duration_selector.svg` |
| `Assets.monthlyPackageTiers` | `assets/images/subscriptions/figma/monthly_package_tiers.svg` |
| `Assets.subscriptionPackageMealBox` | `assets/images/subscriptions/figma/package_meal_box.png` |
| `Assets.subscriptionWeightLossProgram` | `assets/images/subscriptions/figma/weight_loss_program.png` |
| `Assets.subscriptionNoteMeal` | `assets/images/subscriptions/subscription_note_meal.png` |

### B. Files With No Constant in Either Constants File

Delete only these physical files; there is no line to remove from `assets.dart` or `assets_fake.dart`:

- `assets/images/fire_icon.svg`
- `assets/images/food_icon.svg`
- `assets/images/home/figma/home_nutrition_carbs_ring.svg`
- `assets/images/home/figma/home_nutrition_fat_ring.svg`
- `assets/images/home/figma/home_nutrition_protein_ring.svg`
- `assets/images/offer_icon.svg`
- `assets/images/offers/banner_offfer.png`
- `assets/images/subscribe_icon.png`
- `assets/images/subscriptions/family_plan_hero.png`
- `assets/images/subscriptions/figma/monthly_plan_hero.png`

## Required Result in the Two Constants Files

### `lib/core/constants/assets.dart`

Remove exactly the 15 complete declarations listed in section A, including continuation lines and terminating semicolons. For example, remove the whole declaration:

```dart
static const String addressesChooseLocationMap =
    '$_images/profile/addresses_choose_location_map.png';
```

Do not leave an empty assignment, dangling string line, double blank block, or comment claiming the deleted asset still exists.

### `lib/core/constants/assets_fake.dart`

Make no change. None of the 25 approved file paths appears in this class. At the end, this command must produce no diff:

```powershell
git diff -- lib/core/constants/assets_fake.dart
```

---

### Task 1: Revalidate the Candidate Set Against the Current Worktree

**Files:**
- Read: `lib/core/constants/assets.dart`
- Read: `lib/core/constants/assets_fake.dart`
- Read: `pubspec.yaml`
- Read: all source/config files outside `assets/`
- Modify: none

**Interfaces:**
- Consumes: exact 25-file deletion set in this plan.
- Produces: a verified deletion list containing only files with zero current consumers.

- [ ] **Step 1: Record dirty-worktree ownership**

Run:

```powershell
git status --short
git diff -- lib/core/constants/assets.dart lib/core/constants/assets_fake.dart
```

Expected: record any pre-existing changes. Do not overwrite them and do not include unrelated calendar work in this cleanup commit.

- [ ] **Step 2: Verify all 25 candidates currently exist**

Create a temporary in-memory PowerShell array containing the exact paths from sections A and B, then run:

```powershell
$candidates | ForEach-Object {
  if (-not (Test-Path -LiteralPath $_)) {
    Write-Error "Candidate is already missing: $_"
  }
}
```

Expected: every candidate exists. If a file is already deleted by another in-progress change, do not recreate it; record its existing ownership and exclude it from this task's staging.

- [ ] **Step 3: Verify the 15 constants have no consumers**

Run one exact identifier search per constant outside `assets.dart`:

```powershell
rg -n "Assets\.(homeFigmaAvatar|homeNutritionDivider|homeSubscriptionProgress|nutritionDetailsBack|addressesChooseLocationMap|addressesIconBuilding|addressesIconGps|addressesIconHomeOutline|healthGoalBack|familyManageInvoice|monthlyDurationSelector|monthlyPackageTiers|subscriptionPackageMealBox|subscriptionWeightLossProgram|subscriptionNoteMeal)\b" lib test --glob "*.dart" --glob "!lib/core/constants/assets.dart"
```

Expected: no matches. If there is a match, keep that asset and its constant; report the exact consumer.

- [ ] **Step 4: Verify no path or filename consumers exist**

For each candidate, search both its full normalized path and filename outside `assets/`, `.dart_tool/`, and `build/`:

```powershell
foreach ($candidate in $candidates) {
  $normalized = $candidate.Replace('\', '/')
  $name = Split-Path -Leaf $candidate
  rg -n -F --glob "!assets/**" --glob "!.dart_tool/**" --glob "!build/**" $normalized .
  rg -n -F --glob "!assets/**" --glob "!.dart_tool/**" --glob "!build/**" $name .
}
```

Expected: the 15 constant-backed filenames may appear only in their own declarations in `assets.dart`; the other 10 should have no matches. `pubspec.yaml` directory declarations are allowed because they do not name these individual files.

- [ ] **Step 5: Check native and JSON references explicitly**

Run:

```powershell
rg -n "fire_icon|food_icon|home_avatar|home_nutrition_(carbs|divider|fat|protein)_ring|home_subscription_progress|nutrition_details_back|offer_icon|banner_offfer|addresses_choose_location_map|addresses_icon_(building|gps|home_outline)|health_goal_back|subscribe_icon|family_plan_hero|family_manage_invoice|monthly_duration_selector|monthly_package_tiers|monthly_plan_hero|package_meal_box|weight_loss_program|subscription_note_meal" android ios web windows linux macos assets/animations --glob "!*build*"
```

Expected: no matches. Missing platform directories are acceptable; references are not.

- [ ] **Step 6: Stop on ambiguity**

If a candidate is assembled dynamically from a verified filename convention, received from a local configuration, or referenced by native code, do not delete it. Produce a reduced explicit list before Task 2.

---

### Task 2: Remove the 15 Dead `Assets` Declarations

**Files:**
- Modify: `lib/core/constants/assets.dart`
- Must not modify: `lib/core/constants/assets_fake.dart`

**Interfaces:**
- Consumes: zero-consumer proof from Task 1.
- Produces: `Assets` without declarations for files scheduled for deletion.

- [ ] **Step 1: Remove the exact declarations**

Delete only these declaration names:

```text
homeFigmaAvatar
homeNutritionDivider
homeSubscriptionProgress
nutritionDetailsBack
addressesChooseLocationMap
addressesIconBuilding
addressesIconGps
addressesIconHomeOutline
healthGoalBack
familyManageInvoice
monthlyDurationSelector
monthlyPackageTiers
subscriptionPackageMealBox
subscriptionWeightLossProgram
subscriptionNoteMeal
```

Remove entire multiline declarations. Do not reorder or rename retained constants.

- [ ] **Step 2: Format only the modified constants file**

Run:

```powershell
dart format lib/core/constants/assets.dart
```

- [ ] **Step 3: Confirm the names are gone**

Run:

```powershell
rg -n "homeFigmaAvatar|homeNutritionDivider|homeSubscriptionProgress|nutritionDetailsBack|addressesChooseLocationMap|addressesIconBuilding|addressesIconGps|addressesIconHomeOutline|healthGoalBack|familyManageInvoice|monthlyDurationSelector|monthlyPackageTiers|subscriptionPackageMealBox|subscriptionWeightLossProgram|subscriptionNoteMeal" lib/core/constants/assets.dart
```

Expected: no matches.

- [ ] **Step 4: Confirm `assets_fake.dart` is untouched**

Run:

```powershell
git diff -- lib/core/constants/assets_fake.dart
```

Expected: no output attributable to this task.

---

### Task 3: Delete Exactly the 25 Approved Physical Asset Files

**Files:**
- Delete: all 25 paths in sections A and B.
- Modify: none other than deletions.

**Interfaces:**
- Consumes: reduced verified candidate set from Task 1 and removed constants from Task 2.
- Produces: repository without the unused binary/vector files.

- [ ] **Step 1: Resolve every deletion target safely**

Before deleting, resolve each path and verify it is inside the workspace `assets` directory:

```powershell
$assetRoot = (Resolve-Path -LiteralPath 'assets').Path
foreach ($candidate in $candidates) {
  $resolved = (Resolve-Path -LiteralPath $candidate).Path
  if (-not $resolved.StartsWith($assetRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
    throw "Refusing to delete path outside assets: $resolved"
  }
}
```

- [ ] **Step 2: Delete the explicit files only**

Use `Remove-Item -LiteralPath` on each verified candidate. Do not use wildcards, recursive deletion, or delete any containing directory:

```powershell
foreach ($candidate in $candidates) {
  Remove-Item -LiteralPath $candidate
}
```

- [ ] **Step 3: Verify all approved files are absent**

```powershell
$remaining = $candidates | Where-Object { Test-Path -LiteralPath $_ }
if ($remaining) {
  throw "Files were not deleted: $($remaining -join ', ')"
}
```

- [ ] **Step 4: Verify no unapproved asset was deleted**

Run:

```powershell
git diff --name-status -- assets
```

Expected: exactly 25 `D` entries matching sections A and B, with no modified or additional deleted asset files.

---

### Task 4: Verify Constants, Asset Integrity, and Application Safety

**Files:**
- Read: `lib/core/constants/assets.dart`
- Read: `lib/core/constants/assets_fake.dart`
- Read: all retained files under `assets/`
- Modify: none unless fixing a cleanup-caused failure.

**Interfaces:**
- Consumes: Tasks 2 and 3.
- Produces: proof that retained constants resolve, the Flutter bundle builds, and tests still pass.

- [ ] **Step 1: Confirm no deleted filename remains referenced**

Repeat the exact full-path and filename searches from Task 1.

Expected: zero matches for all 25 deleted paths and filenames.

- [ ] **Step 2: Validate every retained declared asset exists**

Parse all asset paths from `assets.dart` and `assets_fake.dart`, resolve `$_images` to `assets/images` and `$_svg` to `assets/images/svg`, then assert `Test-Path -LiteralPath` for every resolved path. Ignore `_images` and `_svg` themselves because they are base directories, not files.

Expected: zero missing retained assets.

- [ ] **Step 3: Verify Flutter asset configuration**

Run:

```powershell
flutter pub get
flutter analyze
```

Expected: commands succeed without missing-asset or missing-constant errors.

- [ ] **Step 4: Run the complete test suite**

```powershell
flutter test
```

Expected: all tests pass. If a test demonstrates a real consumer, restore that specific asset and constant from `HEAD`, then remove it from this cleanup's deletion set. Do not broadly restore other files.

- [ ] **Step 5: Inspect the final scoped diff**

Run:

```powershell
git diff --stat -- lib/core/constants/assets.dart lib/core/constants/assets_fake.dart assets
git diff -- lib/core/constants/assets.dart lib/core/constants/assets_fake.dart
git diff --name-status -- assets
```

Expected:

- 15 declarations removed from `assets.dart`.
- No diff in `assets_fake.dart`.
- Exactly 25 asset files deleted.
- No additions, renames, or modifications under `assets/`.

- [ ] **Step 6: Stage only this cleanup**

Stage `assets.dart` and the explicit 25 deleted paths. Do not use `git add .` because the workspace contains unrelated calendar refactor work.

```powershell
git add lib/core/constants/assets.dart
git add -u -- assets/images/fire_icon.svg assets/images/food_icon.svg assets/images/home/figma/home_avatar.png assets/images/home/figma/home_nutrition_carbs_ring.svg assets/images/home/figma/home_nutrition_divider.svg assets/images/home/figma/home_nutrition_fat_ring.svg assets/images/home/figma/home_nutrition_protein_ring.svg assets/images/home/figma/home_subscription_progress.svg assets/images/home/figma/nutrition_details_back.svg assets/images/offer_icon.svg assets/images/offers/banner_offfer.png assets/images/profile/addresses_choose_location_map.png assets/images/profile/addresses_icon_building.svg assets/images/profile/addresses_icon_gps.svg assets/images/profile/addresses_icon_home_outline.svg assets/images/profile/health_goal_back.svg assets/images/subscribe_icon.png assets/images/subscriptions/family_plan_hero.png assets/images/subscriptions/figma/family_manage_invoice.svg assets/images/subscriptions/figma/monthly_duration_selector.svg assets/images/subscriptions/figma/monthly_package_tiers.svg assets/images/subscriptions/figma/monthly_plan_hero.png assets/images/subscriptions/figma/package_meal_box.png assets/images/subscriptions/figma/weight_loss_program.png assets/images/subscriptions/subscription_note_meal.png
```

- [ ] **Step 7: Inspect the staged diff and commit**

```powershell
git diff --cached --name-status
git diff --cached -- lib/core/constants/assets.dart
git commit -m "chore(assets): remove verified unused files"
```

Expected: the staged diff contains no calendar source, no plan documents, no tests from another task, and no `assets_fake.dart` change.

## Acceptance Criteria

- Every deleted asset had zero verified consumers immediately before deletion.
- Exactly 25 approved asset files are deleted, or fewer with an explicit report for any newly discovered consumer.
- Exactly the matching 15 declarations are removed from `Assets`.
- `Assets._images`, `Assets._svg`, `Assets.buttonSmall`, and `Assets.buttonLarge` remain intact.
- `assets_fake.dart` is byte-for-byte unchanged by this cleanup.
- `pubspec.yaml` remains unchanged.
- Every retained asset constant resolves to an existing physical file.
- `flutter analyze` and `flutter test` pass.
- The cleanup commit contains no unrelated calendar refactor changes.

## Rollback Strategy

If a deleted asset is proven to be a real runtime consumer, restore only its physical file and matching constant from the cleanup commit. Never use `git reset --hard`, `git checkout -- .`, or a broad restore because the workspace contains unrelated user work.
