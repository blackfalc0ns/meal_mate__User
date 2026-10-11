import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_availability_entity.dart';

enum SubscriptionPrerequisiteDestination {
  address,
  allergies,
  dietaryPreferences;

  static SubscriptionPrerequisiteDestination? fromErrorCode(String code) {
    final normalized = code.trim();
    if (normalized == SubscriptionErrorCodes.addressRequired ||
        normalized == 'address_required' ||
        normalized == 'ADDRESS') {
      return address;
    }
    if (normalized == SubscriptionErrorCodes.allergiesRequired ||
        normalized == 'allergies_required' ||
        normalized == 'family.allergies_required' ||
        normalized == 'ALLERGIES') {
      return allergies;
    }
    if (normalized == SubscriptionErrorCodes.dietaryPreferencesRequired ||
        normalized == 'dietary_preferences_required' ||
        normalized == 'DIETARY_PREFERENCES') {
      return dietaryPreferences;
    }
    return null;
  }

  static SubscriptionPrerequisiteDestination? fromAvailability(
    SubscriptionAvailabilityEntity? availability,
  ) {
    if (availability == null) return null;
    if (availability.isAddressRequired) return address;
    if (availability.isAllergiesRequired) return allergies;
    if (availability.isDietaryPreferencesRequired) return dietaryPreferences;
    return null;
  }

  static SubscriptionPrerequisiteDestination? fromProfileStatus({
    required bool hasDeliveryAddress,
    required bool hasAllergies,
    required bool hasDietaryPreferences,
    String? allergiesCompletedAtUtc,
    String? dietaryPreferencesCompletedAtUtc,
  }) {
    if (!hasDeliveryAddress) return address;
    final allergiesConfirmed =
        hasAllergies ||
        (allergiesCompletedAtUtc != null && allergiesCompletedAtUtc.isNotEmpty);
    if (!allergiesConfirmed) return allergies;
    final dietaryConfirmed =
        hasDietaryPreferences ||
        (dietaryPreferencesCompletedAtUtc != null &&
            dietaryPreferencesCompletedAtUtc.isNotEmpty);
    if (!dietaryConfirmed) return dietaryPreferences;
    return null;
  }

  static List<SubscriptionPrerequisiteDestination> listFromProfileStatus({
    required bool hasDeliveryAddress,
    required bool hasAllergies,
    required bool hasDietaryPreferences,
    String? allergiesCompletedAtUtc,
    String? dietaryPreferencesCompletedAtUtc,
  }) {
    final list = <SubscriptionPrerequisiteDestination>[];
    if (!hasDeliveryAddress) list.add(address);
    final allergiesConfirmed =
        hasAllergies ||
        (allergiesCompletedAtUtc != null && allergiesCompletedAtUtc.isNotEmpty);
    if (!allergiesConfirmed) list.add(allergies);
    final dietaryConfirmed =
        hasDietaryPreferences ||
        (dietaryPreferencesCompletedAtUtc != null &&
            dietaryPreferencesCompletedAtUtc.isNotEmpty);
    if (!dietaryConfirmed) list.add(dietaryPreferences);
    return list;
  }

  static SubscriptionPrerequisiteDestination? fromMissingStep(String? step) {
    if (step == null) return null;
    return fromErrorCode(step);
  }

  static bool isAllergiesCompleted({
    required bool hasAllergiesFlag,
    required int allergiesCount,
    dynamic completedAtUtc,
  }) {
    if (hasAllergiesFlag || allergiesCount > 0) return true;
    if (completedAtUtc != null) {
      if (completedAtUtc is String) return completedAtUtc.trim().isNotEmpty;
      if (completedAtUtc is DateTime) return true;
    }
    return false;
  }

  static bool isDietaryPreferencesCompleted({
    required bool hasDietaryPreferencesFlag,
    required int preferencesCount,
    dynamic completedAtUtc,
  }) {
    if (hasDietaryPreferencesFlag || preferencesCount > 0) return true;
    if (completedAtUtc != null) {
      if (completedAtUtc is String) return completedAtUtc.trim().isNotEmpty;
      if (completedAtUtc is DateTime) return true;
    }
    return false;
  }
}
