import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';

class MealSelectionState {
  const MealSelectionState({
    this.subscriptionId = '',
    this.date,
    this.restaurantId = '',
    this.availableMeals,
    this.selectedMealIds = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isSaving = false,
    this.isConfirming = false,
    this.failure,
    this.loadMoreFailure,
    this.saveFailure,
    this.confirmFailure,
  });

  final String subscriptionId;
  final DateTime? date;
  final String restaurantId;
  final CalendarAvailableMealsEntity? availableMeals;
  final List<String> selectedMealIds;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSaving;
  final bool isConfirming;
  final Failure? failure;
  final Failure? loadMoreFailure;
  final Failure? saveFailure;
  final Failure? confirmFailure;

  bool get hasAvailableMeals => availableMeals != null;

  int get requiredMealsCount {
    final availableCount = availableMeals?.requiredMealsCount ?? 0;
    if (availableCount > 0) return availableCount;
    return 0;
  }

  bool get canSave {
    final available = availableMeals;
    if (available == null || isSaving || isConfirming) return false;
    if (selectedMealIds.length != requiredMealsCount) return false;
    for (final requirement in available.slotRequirements) {
      final count = available.meals
          .where(
            (meal) =>
                meal.slot.trim().toLowerCase() ==
                    requirement.slot.trim().toLowerCase() &&
                selectedMealIds.contains(meal.id),
          )
          .length;
      if (count != requirement.count) return false;
    }
    return true;
  }

  bool get canSaveMeals => canSave;
  bool get isAvailableMealsLoading => isLoading;
  bool get isLoadingMoreMeals => isLoadingMore;
  Failure? get availableMealsFailure => failure;
  List<String> get localSelectedMealIds => selectedMealIds;

  MealSelectionState copyWith({
    String? subscriptionId,
    DateTime? date,
    String? restaurantId,
    CalendarAvailableMealsEntity? availableMeals,
    List<String>? selectedMealIds,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isSaving,
    bool? isConfirming,
    Failure? failure,
    Failure? loadMoreFailure,
    Failure? saveFailure,
    Failure? confirmFailure,
    bool clearAvailableMeals = false,
    bool clearDate = false,
    bool clearFailure = false,
    bool clearLoadMoreFailure = false,
    bool clearSaveFailure = false,
    bool clearConfirmFailure = false,
  }) {
    return MealSelectionState(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      date: clearDate ? null : date ?? this.date,
      restaurantId: restaurantId ?? this.restaurantId,
      availableMeals: clearAvailableMeals
          ? null
          : availableMeals ?? this.availableMeals,
      selectedMealIds: selectedMealIds ?? this.selectedMealIds,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSaving: isSaving ?? this.isSaving,
      isConfirming: isConfirming ?? this.isConfirming,
      failure: clearFailure ? null : failure ?? this.failure,
      loadMoreFailure: clearLoadMoreFailure
          ? null
          : loadMoreFailure ?? this.loadMoreFailure,
      saveFailure: clearSaveFailure ? null : saveFailure ?? this.saveFailure,
      confirmFailure: clearConfirmFailure
          ? null
          : confirmFailure ?? this.confirmFailure,
    );
  }
}
