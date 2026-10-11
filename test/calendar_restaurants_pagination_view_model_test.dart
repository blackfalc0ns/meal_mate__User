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

class _FakePaginationCalendarRepo implements CalendarRepository {
  final List<Completer<ApiResult<CalendarRestaurantsPageEntity>>> completers =
      [];
  final List<_RepoCall> calls = [];

  @override
  Future<ApiResult<CalendarRestaurantsPageEntity>> getRestaurants({
    required String subscriptionId,
    required String date,
    required String localeName,
    String? query,
    int? page,
    int? pageSize,
  }) {
    calls.add(
      _RepoCall(
        subscriptionId: subscriptionId,
        date: date,
        localeName: localeName,
        query: query,
        page: page,
        pageSize: pageSize,
      ),
    );
    final completer = Completer<ApiResult<CalendarRestaurantsPageEntity>>();
    completers.add(completer);
    return completer.future;
  }

  @override
  Future<ApiResult<CalendarDayEntity>> setDayRestaurant({
    required String subscriptionId,
    required String date,
    required String restaurantId,
    required String localeName,
  }) async {
    throw UnimplementedError();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

class _RepoCall {
  _RepoCall({
    required this.subscriptionId,
    required this.date,
    required this.localeName,
    this.query,
    this.page,
    this.pageSize,
  });
  final String subscriptionId;
  final String date;
  final String localeName;
  final String? query;
  final int? page;
  final int? pageSize;
}

CalendarRestaurantOptionEntity _makeOption(String id, String name) {
  return CalendarRestaurantOptionEntity(
    id: id,
    name: name,
    description: 'Desc',
    mealCount: 3,
    rating: '4.5',
    logoType: CalendarRestaurantLogoType.healthyBowl,
  );
}

CalendarRestaurantsPageEntity _makePage({
  required List<CalendarRestaurantOptionEntity> items,
  required int page,
  required int pageSize,
  required int totalCount,
  required int totalPages,
  required bool hasNextPage,
  required bool hasPreviousPage,
}) {
  return CalendarRestaurantsPageEntity(
    restaurants: items,
    page: page,
    pageSize: pageSize,
    totalCount: totalCount,
    totalPages: totalPages,
    hasNextPage: hasNextPage,
    hasPreviousPage: hasPreviousPage,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakePaginationCalendarRepo repo;
  late RestaurantPickerViewModel viewModel;
  final testDate = DateTime(2026, 10, 15);

  setUp(() {
    repo = _FakePaginationCalendarRepo();
    viewModel = RestaurantPickerViewModel(
      GetCalendarRestaurantsUseCase(repo),
      SetCalendarDayRestaurantUseCase(repo),
    );
  });

  tearDown(() async {
    await viewModel.close();
  });

  group('RestaurantPickerViewModel Pagination', () {
    test('1. Initial load sends page=1, pageSize=20 and sets state', () async {
      final future = viewModel.load(
        subscriptionId: 'sub-1',
        date: testDate,
        localeName: 'en',
      );

      expect(viewModel.state.isLoading, isTrue);
      expect(repo.calls.length, 1);
      expect(repo.calls.first.page, 1);
      expect(repo.calls.first.pageSize, 20);

      final r1 = _makeOption('r1', 'Kitchen 1');
      repo.completers.first.complete(
        ApiSuccessResult(
          data: _makePage(
            items: [r1],
            page: 1,
            pageSize: 20,
            totalCount: 25,
            totalPages: 2,
            hasNextPage: true,
            hasPreviousPage: false,
          ),
        ),
      );
      await future;

      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.page, 1);
      expect(viewModel.state.pageSize, 20);
      expect(viewModel.state.totalCount, 25);
      expect(viewModel.state.hasNextPage, isTrue);
      expect(viewModel.state.restaurants, [r1]);
    });

    test(
      '2. loadMore requests page+1, appends items and deduplicates IDs',
      () async {
        final r1 = _makeOption('r1', 'Kitchen 1');
        final r2 = _makeOption('r2', 'Kitchen 2');

        final initialFuture = viewModel.load(
          subscriptionId: 'sub-1',
          date: testDate,
          localeName: 'en',
        );
        repo.completers[0].complete(
          ApiSuccessResult(
            data: _makePage(
              items: [r1],
              page: 1,
              pageSize: 20,
              totalCount: 25,
              totalPages: 2,
              hasNextPage: true,
              hasPreviousPage: false,
            ),
          ),
        );
        await initialFuture;

        final loadMoreFuture = viewModel.loadMore();
        expect(viewModel.state.isLoadingMore, isTrue);
        expect(repo.calls.length, 2);
        expect(repo.calls[1].page, 2);
        expect(repo.calls[1].pageSize, 20);

        // Return r1 duplicate and r2
        repo.completers[1].complete(
          ApiSuccessResult(
            data: _makePage(
              items: [r1, r2],
              page: 2,
              pageSize: 20,
              totalCount: 25,
              totalPages: 2,
              hasNextPage: false,
              hasPreviousPage: true,
            ),
          ),
        );
        await loadMoreFuture;

        expect(viewModel.state.isLoadingMore, isFalse);
        expect(viewModel.state.page, 2);
        expect(viewModel.state.hasNextPage, isFalse);
        // Items should be unique [r1, r2] preserving server order
        expect(viewModel.state.restaurants.map((e) => e.id).toList(), [
          'r1',
          'r2',
        ]);
      },
    );

    test(
      '3. loadMore guard prevents redundant requests when already loading or hasNextPage is false',
      () async {
        final r1 = _makeOption('r1', 'Kitchen 1');
        final initialFuture = viewModel.load(
          subscriptionId: 'sub-1',
          date: testDate,
          localeName: 'en',
        );
        repo.completers[0].complete(
          ApiSuccessResult(
            data: _makePage(
              items: [r1],
              page: 1,
              pageSize: 20,
              totalCount: 1,
              totalPages: 1,
              hasNextPage: false,
              hasPreviousPage: false,
            ),
          ),
        );
        await initialFuture;

        expect(viewModel.state.hasNextPage, isFalse);
        await viewModel.loadMore();
        expect(repo.calls.length, 1); // No second call!
      },
    );

    test(
      '4. loadMore failure preserves existing rows and page, sets loadMoreFailure',
      () async {
        final r1 = _makeOption('r1', 'Kitchen 1');
        final initialFuture = viewModel.load(
          subscriptionId: 'sub-1',
          date: testDate,
          localeName: 'en',
        );
        repo.completers[0].complete(
          ApiSuccessResult(
            data: _makePage(
              items: [r1],
              page: 1,
              pageSize: 20,
              totalCount: 25,
              totalPages: 2,
              hasNextPage: true,
              hasPreviousPage: false,
            ),
          ),
        );
        await initialFuture;

        final loadMoreFuture = viewModel.loadMore();
        repo.completers[1].complete(
          ApiErrorResult(
            failure: Failure(errorMessage: 'Network error', code: 'net_err'),
          ),
        );
        await loadMoreFuture;

        expect(viewModel.state.isLoadingMore, isFalse);
        expect(viewModel.state.restaurants, [r1]);
        expect(viewModel.state.page, 1);
        expect(viewModel.state.loadMoreFailure?.errorMessage, 'Network error');

        // Retry loadMore retries page 2
        final retryFuture = viewModel.retryLoadMore();
        expect(viewModel.state.isLoadingMore, isTrue);
        expect(repo.calls.length, 3);
        expect(repo.calls[2].page, 2);

        final r2 = _makeOption('r2', 'Kitchen 2');
        repo.completers[2].complete(
          ApiSuccessResult(
            data: _makePage(
              items: [r2],
              page: 2,
              pageSize: 20,
              totalCount: 25,
              totalPages: 2,
              hasNextPage: false,
              hasPreviousPage: true,
            ),
          ),
        );
        await retryFuture;

        expect(viewModel.state.isLoadingMore, isFalse);
        expect(viewModel.state.loadMoreFailure, isNull);
        expect(viewModel.state.restaurants.length, 2);
      },
    );

    test(
      '5. Search query or date change resets pagination state and invalidates pending requests',
      () async {
        final initialFuture = viewModel.load(
          subscriptionId: 'sub-1',
          date: testDate,
          localeName: 'en',
        );
        repo.completers[0].complete(
          ApiSuccessResult(
            data: _makePage(
              items: [_makeOption('r1', 'Kitchen 1')],
              page: 1,
              pageSize: 20,
              totalCount: 25,
              totalPages: 2,
              hasNextPage: true,
              hasPreviousPage: false,
            ),
          ),
        );
        await initialFuture;

        // Start loadMore
        unawaited(viewModel.loadMore());
        expect(viewModel.state.isLoadingMore, isTrue);

        // Search query changes immediately
        final searchFuture = viewModel.load(
          subscriptionId: 'sub-1',
          date: testDate,
          localeName: 'en',
          query: 'Vegan',
        );

        expect(viewModel.state.isLoading, isTrue);
        expect(viewModel.state.isLoadingMore, isFalse);
        expect(viewModel.state.restaurants, isEmpty);

        // Complete old loadMore late - must be ignored!
        repo.completers[1].complete(
          ApiSuccessResult(
            data: _makePage(
              items: [_makeOption('r2', 'Old')],
              page: 2,
              pageSize: 20,
              totalCount: 25,
              totalPages: 2,
              hasNextPage: false,
              hasPreviousPage: true,
            ),
          ),
        );
        await Future<void>.delayed(Duration.zero);

        expect(viewModel.state.restaurants, isEmpty);

        // Complete search query
        final v1 = _makeOption('v1', 'Vegan Bowl');
        repo.completers[2].complete(
          ApiSuccessResult(
            data: _makePage(
              items: [v1],
              page: 1,
              pageSize: 20,
              totalCount: 1,
              totalPages: 1,
              hasNextPage: false,
              hasPreviousPage: false,
            ),
          ),
        );
        await searchFuture;

        expect(viewModel.state.restaurants, [v1]);
        expect(viewModel.state.page, 1);
      },
    );
  });
}
