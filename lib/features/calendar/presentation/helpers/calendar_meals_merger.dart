import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';

class CalendarMealsMerger {
  const CalendarMealsMerger._();

  static CalendarAvailableMealsEntity mergeMoreMeals({
    required CalendarAvailableMealsEntity current,
    required CalendarAvailableMealsEntity incoming,
    required String requestedSlot,
  }) {
    if (incoming.slots.isEmpty && incoming.meals.isNotEmpty) {
      final updatedSlots = current.slots.map((existingSlot) {
        if (existingSlot.slot.trim().toLowerCase() !=
            requestedSlot.trim().toLowerCase()) {
          return existingSlot;
        }
        final existingMealIds = existingSlot.meals.map((m) => m.id).toSet();
        final newMeals = incoming.meals
            .where((m) => !existingMealIds.contains(m.id))
            .toList();
        return existingSlot.copyWith(
          meals: [...existingSlot.meals, ...newMeals],
        );
      }).toList();
      return current.copyWith(
        slots: updatedSlots,
        meals: updatedSlots.expand((s) => s.meals).toList(),
      );
    }

    final updatedSlots = <CalendarSlotMealsEntity>[];
    for (final existingSlot in current.slots) {
      final matchingIncoming = incoming.slots
          .where(
            (s) =>
                s.slot.trim().toLowerCase() ==
                existingSlot.slot.trim().toLowerCase(),
          )
          .firstOrNull;

      if (matchingIncoming == null) {
        updatedSlots.add(existingSlot);
        continue;
      }

      final existingMealIds = existingSlot.meals.map((m) => m.id).toSet();
      final newUniqueMeals = matchingIncoming.meals
          .where((m) => !existingMealIds.contains(m.id))
          .toList();

      final mergedMeals = [...existingSlot.meals, ...newUniqueMeals];

      updatedSlots.add(
        existingSlot.copyWith(
          page: matchingIncoming.page,
          pageSize: matchingIncoming.pageSize,
          totalCount: matchingIncoming.totalCount,
          totalPages: matchingIncoming.totalPages,
          hasNextPage: matchingIncoming.hasNextPage,
          hasPreviousPage: matchingIncoming.hasPreviousPage,
          meals: mergedMeals,
        ),
      );
    }

    for (final incomingSlot in incoming.slots) {
      final exists = updatedSlots.any(
        (s) =>
            s.slot.trim().toLowerCase() ==
            incomingSlot.slot.trim().toLowerCase(),
      );
      if (!exists) {
        updatedSlots.add(incomingSlot);
      }
    }

    final allMergedMeals = updatedSlots.expand((s) => s.meals).toList();

    return current.copyWith(slots: updatedSlots, meals: allMergedMeals);
  }
}
