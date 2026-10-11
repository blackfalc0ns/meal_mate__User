import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_day_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurants_page_entity.dart';
import 'package:meal_meat_user/features/calendar/domain/repo/calendar_repository.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart';
import 'package:meal_meat_user/features/calendar/domain/usecase/set_calendar_day_restaurant_usecase.dart';
import 'package:meal_meat_user/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_view_model.dart';

class _ControllableCalendarRepo implements CalendarRepository {
  final List<Completer<ApiResult<CalendarRestaurantsPageEntity>>>
  restaurantCompleters = [];
  final List<String?> restaurantQueries = [];

  final List<Completer<ApiResult<CalendarDayEntity>>>
  setDayRestaurantCompleters = [];
  final List<String> setDayRestaurantIds = [];

  @override
  Future<ApiResult<CalendarRestaurantsPageEntity>> getRestaurants({
    required String subscriptionId,
    required String date,
    required String localeName,
    String? query,
    int? page,
    int? pageSize,
  }) {
    restaurantQueries.add(query);
    final completer = Completer<ApiResult<CalendarRestaurantsPageEntity>>();
    restaurantCompleters.add(completer);
    return completer.future;
  }

  @override
  Future<ApiResult<CalendarDayEntity>> setDayRestaurant({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
  }) {
    setDayRestaurantIds.add(restaurantId);
    final completer = Completer<ApiResult<CalendarDayEntity>>();
    setDayRestaurantCompleters.add(completer);
    return completer.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

CalendarRestaurantOptionEntity _createOption(String id, String name) {
  return CalendarRestaurantOptionEntity(
    id: id,
    name: name,
    description: 'Desc',
    mealCount: 5,
    rating: '4.5',
    logoType: CalendarRestaurantLogoType.healthyBowl,
  );
}

CalendarRestaurantsPageEntity _createPage(
  List<CalendarRestaurantOptionEntity> options,
) {
  return CalendarRestaurantsPageEntity(
    restaurants: options,
    page: 1,
    pageSize: 20,
    totalCount: options.length,
    totalPages: options.isEmpty ? 0 : 1,
    hasNextPage: false,
    hasPreviousPage: false,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _ControllableCalendarRepo repo;
  late RestaurantPickerViewModel cubit;

  setUp(() {
    repo = _ControllableCalendarRepo();
    cubit = RestaurantPickerViewModel(
      GetCalendarRestaurantsUseCase(repo),
      SetCalendarDayRestaurantUseCase(repo),
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('RestaurantPickerCubit', () {
    final testDate = DateTime(2026, 10, 15);

    test('1. initial load fetches restaurants and updates state', () async {
      final future = cubit.load(
        subscriptionId: 'sub-1',
        date: testDate,
        localeName: 'en',
      );
      expect(cubit.state.isLoading, isTrue);

      final options = [_createOption('r1', 'Green Bowl')];
      repo.restaurantCompleters[0].complete(
        ApiSuccessResult(data: _createPage(options)),
      );
      await future;

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.restaurants, options);
      expect(cubit.state.hasRestaurants, isTrue);
    });

    test('2. search query forwarding and newer query wins', () async {
      // First query: 'sa'
      cubit.load(
        subscriptionId: 'sub-1',
        date: testDate,
        localeName: 'en',
        query: 'sa',
      );
      // Second query: 'sal'
      cubit.load(
        subscriptionId: 'sub-1',
        date: testDate,
        localeName: 'en',
        query: 'sal',
      );

      expect(repo.restaurantQueries, ['sa', 'sal']);

      // Resolve query 2 first
      final optionsSal = [_createOption('r2', 'Salad Co')];
      repo.restaurantCompleters[1].complete(
        ApiSuccessResult(data: _createPage(optionsSal)),
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.restaurants, optionsSal);

      // Resolve query 1 late
      final optionsSa = [_createOption('r1', 'Sandwich Bar')];
      repo.restaurantCompleters[0].complete(
        ApiSuccessResult(data: _createPage(optionsSa)),
      );
      await Future<void>.delayed(Duration.zero);

      // Must remain optionsSal
      expect(cubit.state.restaurants, optionsSal);
    });

    test('3. clear resets state and invalidates in-flight requests', () async {
      cubit.load(subscriptionId: 'sub-1', date: testDate, localeName: 'en');
      expect(cubit.state.isLoading, isTrue);

      cubit.clear();
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.restaurants, isEmpty);

      // Resolving late after clear should be ignored
      repo.restaurantCompleters[0].complete(
        ApiSuccessResult(data: _createPage([_createOption('r1', 'Late')])),
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.restaurants, isEmpty);
    });

    test(
      '4. selectRestaurant returns ApiSuccessResult without mutating overview',
      () async {
        final option = _createOption('r-100', 'Power Eats');
        final future = cubit.selectRestaurant(
          subscriptionId: 'sub-1',
          date: testDate,
          restaurant: option,
          localeName: 'en',
        );

        expect(cubit.state.isSelecting, isTrue);
        expect(cubit.state.selectingRestaurantId, 'r-100');

        final returnDay = CalendarDayEntity(
          dayNumber: 15,
          weekday: 'Thursday',
          date: testDate,
          restaurantId: 'r-100',
        );
        repo.setDayRestaurantCompleters[0].complete(
          ApiSuccessResult(data: returnDay),
        );

        final result = await future;
        expect(result, isA<ApiSuccessResult<CalendarDayEntity>>());
        expect(
          (result as ApiSuccessResult<CalendarDayEntity>).data.restaurantId,
          'r-100',
        );
        expect(cubit.state.isSelecting, isFalse);
        expect(cubit.state.selectingRestaurantId, isNull);
      },
    );

    test(
      '5. selectRestaurant failure emits selectFailure and returns error result',
      () async {
        final option = _createOption('r-100', 'Power Eats');
        final future = cubit.selectRestaurant(
          subscriptionId: 'sub-1',
          date: testDate,
          restaurant: option,
          localeName: 'en',
        );

        repo.setDayRestaurantCompleters[0].complete(
          ApiErrorResult(
            failure: Failure(errorMessage: 'Failed to select', code: 'sel_err'),
          ),
        );

        final result = await future;
        expect(result, isA<ApiErrorResult<CalendarDayEntity>>());
        expect(cubit.state.isSelecting, isFalse);
        expect(cubit.state.selectFailure?.errorMessage, 'Failed to select');
      },
    );

    test(
      '6. prevents duplicate selection of the same restaurant while in-flight',
      () async {
        final option = _createOption('r-100', 'Power Eats');
        cubit.selectRestaurant(
          subscriptionId: 'sub-1',
          date: testDate,
          restaurant: option,
          localeName: 'en',
        );
        expect(repo.setDayRestaurantCompleters.length, 1);

        // Trigger select again with same restaurant
        cubit.selectRestaurant(
          subscriptionId: 'sub-1',
          date: testDate,
          restaurant: option,
          localeName: 'en',
        );
        expect(repo.setDayRestaurantCompleters.length, 1);
      },
    );

    test(
      '7. newer restaurant selection invalidates older selection response',
      () async {
        final optionA = _createOption('r-A', 'Rest A');
        final optionB = _createOption('r-B', 'Rest B');

        unawaited(
          cubit.selectRestaurant(
            subscriptionId: 'sub-1',
            date: testDate,
            restaurant: optionA,
            localeName: 'en',
          ),
        );

        final futureB = cubit.selectRestaurant(
          subscriptionId: 'sub-1',
          date: testDate,
          restaurant: optionB,
          localeName: 'en',
        );

        expect(repo.setDayRestaurantCompleters.length, 2);

        final dayA = CalendarDayEntity(
          dayNumber: 15,
          weekday: 'Thu',
          date: testDate,
          restaurantId: 'r-A',
        );
        final dayB = CalendarDayEntity(
          dayNumber: 15,
          weekday: 'Thu',
          date: testDate,
          restaurantId: 'r-B',
        );

        // Complete A late after B has been triggered
        repo.setDayRestaurantCompleters[0].complete(
          ApiSuccessResult(data: dayA),
        );
        await Future<void>.delayed(Duration.zero);

        // A was invalidated by newer choice B
        expect(cubit.state.selectingRestaurantId, 'r-B');

        repo.setDayRestaurantCompleters[1].complete(
          ApiSuccessResult(data: dayB),
        );
        final resultB = await futureB;
        expect(
          (resultB as ApiSuccessResult<CalendarDayEntity>).data.restaurantId,
          'r-B',
        );
      },
    );
  });
}
