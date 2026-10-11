# External Deployment Prerequisite — Database Migrations (2026-10-11)

## Overview
This document specifies the required database migrations that MUST be applied to the backend database prior to serving requests from clients running the subscription updates of 2026-10-11.

> **Important:** These migrations are strictly backend/database operations and MUST NOT be executed inside Flutter, nor should the Flutter client fabricate replacement windows or failure reasons for legacy records.

## Required Migrations

### 1. `20261010173000_AddSubscriptionDayFailureReasonCode`
- **Purpose:** Adds the `failureReasonCode` field to the subscription days table.
- **Contract Impact:** Enables reporting specific failure codes (`calendar.restaurant_coverage_unavailable`, `calendar.box_not_ready`, `calendar.no_safe_box`, `RESTAURANT_CAPACITY_FULL`, `calendar.restaurant_busy`, `calendar.quota_exhausted`) in day details, summary, and push notifications.
- **Legacy Records:** Legacy records without a saved failure reason preserve backward compatibility and are handled gracefully without artificial codes.

### 2. `20261011090000_AddSubscriptionDayReplacementWindow`
- **Purpose:** Adds the optional replacement window UTC deadline timestamps (`selectionDeadlineUtc`, `lockRemainingSeconds`) for days reopened by admin.
- **Contract Impact:** When an admin reopens a locked day for replacement, the backend provides an effective 24-hour window from the actual reopening time. The client takes `selectionDeadlineUtc` and `canEdit` strictly as the authority from the server.
- **Legacy Records:** Legacy records without deadlines MUST NOT receive a fabricated window from order creation date; a genuine replacement window must be opened via the admin portal if required.

## Backend Deployment Notes
- By default outside testing environments, the ASP.NET Core backend applies migrations on startup unless `Database:ApplyMigrationsOnStartup` is disabled.
- Ensure staging and production databases have successfully executed both migrations before routing production mobile client traffic.
