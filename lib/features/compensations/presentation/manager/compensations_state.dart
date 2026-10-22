import 'package:meal_meat_user/core/errors/failures.dart';
import '../../domain/entities/compensation_entity.dart';
import '../../domain/entities/alternative_date_entity.dart';

class CompensationsState {
  const CompensationsState({
    this.items = const [],
    this.isLoading = false,
    this.hasLoaded = false,
    this.failure,
    this.loadingDates = const {},
    this.submitting = const {},
    this.dates = const {},
    this.selectedDates = const {},
    this.actionFailures = const {},
    this.blockedChoices = const {},
    this.alternativeIneligible = const {},
  });
  final List<CompensationEntity> items;
  final bool isLoading, hasLoaded;
  final Failure? failure;
  final Set<String> loadingDates,
      submitting,
      blockedChoices,
      alternativeIneligible;
  final Map<String, List<AlternativeDateEntity>> dates;
  final Map<String, String> selectedDates;
  final Map<String, Failure> actionFailures;
  CompensationsState copyWith({
    List<CompensationEntity>? items,
    bool? isLoading,
    bool? hasLoaded,
    Failure? failure,
    bool clearFailure = false,
    Set<String>? loadingDates,
    Set<String>? submitting,
    Set<String>? blockedChoices,
    Set<String>? alternativeIneligible,
    Map<String, List<AlternativeDateEntity>>? dates,
    Map<String, String>? selectedDates,
    Map<String, Failure>? actionFailures,
  }) => CompensationsState(
    items: items ?? this.items,
    isLoading: isLoading ?? this.isLoading,
    hasLoaded: hasLoaded ?? this.hasLoaded,
    failure: clearFailure ? null : failure ?? this.failure,
    loadingDates: loadingDates ?? this.loadingDates,
    submitting: submitting ?? this.submitting,
    dates: dates ?? this.dates,
    selectedDates: selectedDates ?? this.selectedDates,
    actionFailures: actionFailures ?? this.actionFailures,
    blockedChoices: blockedChoices ?? this.blockedChoices,
    alternativeIneligible: alternativeIneligible ?? this.alternativeIneligible,
  );
}
