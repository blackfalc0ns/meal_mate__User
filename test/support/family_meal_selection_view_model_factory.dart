import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_available_meals_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurants_page_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/auto_select_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/confirm_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_available_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_day_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/save_calendar_day_meals_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/set_calendar_day_restaurant_usecase.dart';
import 'package:meal_meat_user/features/family_context/domain/entities/family_context_entity.dart';
import 'package:meal_meat_user/features/family_context/domain/usecase/get_my_family_contexts_usecase.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_view_model.dart';
import 'package:meal_meat_user/features/family_management/calendar/presentation/manager/family_calendar_view_model.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_state.dart';
import 'package:meal_meat_user/features/family_management/meal_selection/presentation/manager/family_meal_selection_view_model.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';

FamilyMealSelectionViewModel createFamilyMealSelectionViewModel({
  required FamilyCalendarViewModel calendar,
  FamilyMealSelectionState? initialState,
  String? subscriptionId,
  DateTime? date,
  String? memberName,
  List<FamilyMemberSummaryEntity>? members,
  GetCalendarRestaurantsUseCase? getRestaurantsUseCase,
  GetCalendarAvailableMealsUseCase? getAvailableMealsUseCase,
  SaveCalendarDayMealsUseCase? saveDayMealsUseCase,
  SetCalendarDayRestaurantUseCase? setDayRestaurantUseCase,
  ConfirmCalendarDayMealsUseCase? confirmDayMealsUseCase,
  AutoSelectCalendarDayUseCase? autoSelectDayUseCase,
  GetCalendarDayUseCase? getCalendarDayUseCase,
}) {
  final repository = _EmptySelectionRepository();
  return FamilyMealSelectionViewModel(
    getRestaurantsUseCase ??
        (getIt.isRegistered<GetCalendarRestaurantsUseCase>()
            ? getIt<GetCalendarRestaurantsUseCase>()
            : GetCalendarRestaurantsUseCase(repository)),
    getAvailableMealsUseCase ?? GetCalendarAvailableMealsUseCase(repository),
    saveDayMealsUseCase ?? SaveCalendarDayMealsUseCase(repository),
    setDayRestaurantUseCase ?? SetCalendarDayRestaurantUseCase(repository),
    confirmDayMealsUseCase ?? ConfirmCalendarDayMealsUseCase(repository),
    autoSelectDayUseCase ?? AutoSelectCalendarDayUseCase(repository),
    getCalendarDayUseCase ?? GetCalendarDayUseCase(repository),
    getIt.isRegistered<FamilyContextViewModel>()
        ? getIt<FamilyContextViewModel>()
        : FamilyContextViewModel(_EmptyContextsUseCase()),
    calendar: calendar,
    initialState:
        initialState ??
        FamilyMealSelectionState.fromCalendar(
          calendar.state,
          subscriptionId: subscriptionId,
          date: date,
          memberName: memberName,
          members: members,
        ),
  );
}

void registerFamilyMealSelectionFactory() {
  getIt.registerFactoryParam<
    FamilyMealSelectionViewModel,
    FamilyCalendarViewModel,
    FamilyMealSelectionState?
  >(
    (calendar, initialState) => createFamilyMealSelectionViewModel(
      calendar: calendar,
      initialState: initialState,
    ),
  );
}

class _EmptyContextsUseCase implements GetMyFamilyContextsUseCase {
  @override
  Future<ApiResult<List<FamilyContextEntity>>> call() async =>
      const ApiSuccessResult(data: []);
}

class _EmptySelectionRepository implements CalendarRepository {
  @override
  Future<ApiResult<CalendarRestaurantsPageEntity>> getRestaurants({
    required String subscriptionId,
    required String date,
    required String localeName,
    String? query,
    int? page,
    int? pageSize,
  }) async => const ApiSuccessResult(
    data: CalendarRestaurantsPageEntity(
      restaurants: [],
      page: 1,
      pageSize: 10,
      totalCount: 0,
      totalPages: 0,
      hasNextPage: false,
      hasPreviousPage: false,
    ),
  );
  @override
  Future<ApiResult<CalendarAvailableMealsEntity>> getAvailableMeals({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
    String? slot,
    int? page,
    int? pageSize,
  }) async => const ApiSuccessResult(
    data: CalendarAvailableMealsEntity(
      restaurant: null,
      meals: [],
      slotRequirements: [],
    ),
  );
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      Future<ApiResult<CalendarDayEntity>>.value(
        ApiErrorResult(
          failure: Failure(errorMessage: 'No test result supplied'),
        ),
      );
}
