import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/entities/paged_entity.dart';
import 'package:meal_meat_user/core/entities/pagination_entity.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/repo/subscription_programs_repository.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_program_bundles_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_programs_page_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/usecase/get_subscription_programs_usecase.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_event.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_programs_view_model.dart';

void main() {
  late _FakeSubscriptionProgramsRepository repo;
  late GetSubscriptionProgramsUseCase legacyUseCase;
  late GetSubscriptionProgramsPageUseCase pageUseCase;
  late GetSubscriptionProgramBundlesUseCase bundlesUseCase;
  late SubscriptionProgramsViewModel viewModel;

  setUp(() {
    repo = _FakeSubscriptionProgramsRepository();
    legacyUseCase = GetSubscriptionProgramsUseCase(repo);
    pageUseCase = GetSubscriptionProgramsPageUseCase(repo);
    bundlesUseCase = GetSubscriptionProgramBundlesUseCase(repo);
    viewModel = SubscriptionProgramsViewModel(
      legacyUseCase,
      bundlesUseCase,
      pageUseCase,
    );
  });

  tearDown(() {
    viewModel.close();
  });

  group('SubscriptionProgramsViewModel Pagination Tests', () {
    test(
      'initial load fetches page 1 and emits success with items and pagination',
      () async {
        repo.programsPageResult = ApiSuccessResult(
          data: PagedEntity(
            items: [
              _createProgram('prog_1', 'Program 1'),
              _createProgram('prog_2', 'Program 2'),
            ],
            pagination: const PaginationEntity(
              totalCount: 4,
              page: 1,
              pageSize: 2,
              totalPages: 2,
              hasNextPage: true,
              hasPreviousPage: false,
            ),
          ),
        );

        viewModel.doIntent(const GetSubscriptionProgramsEvent());
        await pumpEventQueue();

        expect(viewModel.state.programs.length, 2);
        expect(viewModel.state.programs[0].programId, 'prog_1');
        expect(viewModel.state.pagination?.hasNextPage, isTrue);
        expect(viewModel.state.pagination?.page, 1);
      },
    );

    test('load more appends page 2 without duplicates', () async {
      repo.programsPageResult = ApiSuccessResult(
        data: PagedEntity(
          items: [
            _createProgram('prog_1', 'Program 1'),
            _createProgram('prog_2', 'Program 2'),
          ],
          pagination: const PaginationEntity(
            totalCount: 3,
            page: 1,
            pageSize: 2,
            totalPages: 2,
            hasNextPage: true,
            hasPreviousPage: false,
          ),
        ),
      );

      viewModel.doIntent(const GetSubscriptionProgramsEvent());
      await pumpEventQueue();

      repo.programsPageResult = ApiSuccessResult(
        data: PagedEntity(
          items: [
            _createProgram('prog_2', 'Program 2'), // duplicate to test dedupe
            _createProgram('prog_3', 'Program 3'),
          ],
          pagination: const PaginationEntity(
            totalCount: 3,
            page: 2,
            pageSize: 2,
            totalPages: 2,
            hasNextPage: false,
            hasPreviousPage: true,
          ),
        ),
      );

      viewModel.doIntent(const LoadMoreSubscriptionProgramsEvent());
      await pumpEventQueue();

      expect(viewModel.state.programs.length, 3);
      expect(viewModel.state.programs.map((p) => p.programId).toList(), [
        'prog_1',
        'prog_2',
        'prog_3',
      ]);
      expect(viewModel.state.pagination?.hasNextPage, isFalse);
      expect(viewModel.state.pagination?.page, 2);
    });

    test('refresh resets list to page 1 and discards previous pages', () async {
      repo.programsPageResult = ApiSuccessResult(
        data: PagedEntity(
          items: [_createProgram('prog_1', 'Program 1')],
          pagination: const PaginationEntity(
            totalCount: 1,
            page: 1,
            pageSize: 10,
            totalPages: 1,
            hasNextPage: false,
            hasPreviousPage: false,
          ),
        ),
      );

      viewModel.doIntent(const GetSubscriptionProgramsEvent());
      await pumpEventQueue();

      repo.programsPageResult = ApiSuccessResult(
        data: PagedEntity(
          items: [_createProgram('prog_new', 'New Program')],
          pagination: const PaginationEntity(
            totalCount: 1,
            page: 1,
            pageSize: 10,
            totalPages: 1,
            hasNextPage: false,
            hasPreviousPage: false,
          ),
        ),
      );

      viewModel.doIntent(const GetSubscriptionProgramsEvent(isRefresh: true));
      await pumpEventQueue();

      expect(viewModel.state.programs.length, 1);
      expect(viewModel.state.programs.first.programId, 'prog_new');
    });

    test(
      'stale response from older request is ignored when a newer request completes first',
      () async {
        final completer1 =
            Completer<ApiResult<PagedEntity<SubscriptionProgramEntity>>>();
        final completer2 =
            Completer<ApiResult<PagedEntity<SubscriptionProgramEntity>>>();

        int callCount = 0;
        repo.customHandler = (page, pageSize) {
          callCount++;
          if (callCount == 1) {
            return completer1.future;
          }
          return completer2.future;
        };

        // Start first request
        viewModel.doIntent(const GetSubscriptionProgramsEvent());
        await pumpEventQueue();

        // Trigger second request (refresh)
        viewModel.doIntent(const GetSubscriptionProgramsEvent(isRefresh: true));
        await pumpEventQueue();

        // Complete request 2 first with new data
        completer2.complete(
          ApiSuccessResult(
            data: PagedEntity(
              items: [_createProgram('fresh_prog', 'Fresh')],
              pagination: const PaginationEntity(
                totalCount: 1,
                page: 1,
                pageSize: 10,
                totalPages: 1,
                hasNextPage: false,
                hasPreviousPage: false,
              ),
            ),
          ),
        );
        await pumpEventQueue();

        expect(viewModel.state.programs.first.programId, 'fresh_prog');

        // Now complete request 1 with stale data
        completer1.complete(
          ApiSuccessResult(
            data: PagedEntity(
              items: [_createProgram('stale_prog', 'Stale')],
              pagination: const PaginationEntity(
                totalCount: 1,
                page: 1,
                pageSize: 10,
                totalPages: 1,
                hasNextPage: false,
                hasPreviousPage: false,
              ),
            ),
          ),
        );
        await pumpEventQueue();

        // Should still be fresh_prog, stale was ignored
        expect(viewModel.state.programs.first.programId, 'fresh_prog');
      },
    );

    test('failure on loadMore preserves existing items in state', () async {
      repo.programsPageResult = ApiSuccessResult(
        data: PagedEntity(
          items: [_createProgram('prog_1', 'Program 1')],
          pagination: const PaginationEntity(
            totalCount: 2,
            page: 1,
            pageSize: 1,
            totalPages: 2,
            hasNextPage: true,
            hasPreviousPage: false,
          ),
        ),
      );

      viewModel.doIntent(const GetSubscriptionProgramsEvent());
      await pumpEventQueue();

      repo.programsPageResult = ApiErrorResult(
        failure: Failure.fromException(
          const ApiException(
            errorType: ApiErrorType.serverError,
            message: 'Network error',
          ),
        ),
      );

      viewModel.doIntent(const LoadMoreSubscriptionProgramsEvent());
      await pumpEventQueue();

      expect(viewModel.state.programs.length, 1);
      expect(viewModel.state.programs.first.programId, 'prog_1');
      expect(viewModel.state.loadMoreFailure, isNotNull);
    });
  });
}

SubscriptionProgramEntity _createProgram(String id, String name) {
  return SubscriptionProgramEntity(
    programId: id,
    code: id,
    shortCode: id,
    nameAr: name,
    nameEn: name,
    descriptionAr: '',
    descriptionEn: '',
    keywordsAr: const [],
    keywordsEn: const [],
    imageUrl: null,
    bundleCount: 1,
    supportedSlots: const [],
    fallbackImageAsset: '',
  );
}

class _FakeSubscriptionProgramsRepository
    implements SubscriptionProgramsRepository {
  ApiResult<PagedEntity<SubscriptionProgramEntity>>? programsPageResult;
  Future<ApiResult<PagedEntity<SubscriptionProgramEntity>>> Function(
    int page,
    int pageSize,
  )?
  customHandler;

  @override
  Future<ApiResult<List<SubscriptionProgramEntity>>>
  getSubscriptionPrograms() async {
    return ApiSuccessResult(data: []);
  }

  @override
  Future<ApiResult<PagedEntity<SubscriptionProgramEntity>>>
  getSubscriptionProgramsPage({
    required int page,
    required int pageSize,
  }) async {
    if (customHandler != null) {
      return customHandler!(page, pageSize);
    }
    return programsPageResult ??
        ApiSuccessResult(
          data: const PagedEntity(
            items: [],
            pagination: PaginationEntity(
              totalCount: 0,
              page: 1,
              pageSize: 20,
              totalPages: 0,
              hasNextPage: false,
              hasPreviousPage: false,
            ),
          ),
        );
  }

  @override
  Future<ApiResult<SubscriptionProgramBundlesEntity>>
  getSubscriptionProgramBundles(
    String programId, {
    int? page,
    int? pageSize,
  }) async {
    return ApiSuccessResult(
      data: const SubscriptionProgramBundlesEntity(
        hasDeliveryAddress: false,
        hasAllergies: false,
        hasDietaryPreferences: false,
        isProfileComplete: false,
        bundles: [],
      ),
    );
  }
}
