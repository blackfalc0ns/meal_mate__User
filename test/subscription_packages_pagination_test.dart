import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/entities/pagination_entity.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/entities/subscription_bundle_entity.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/repo/subscription_packages_repository.dart';
import 'package:meal_meat_user/features/subscription_packages/domain/usecase/get_subscription_packages_usecase.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_package_flow_controller.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_event.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_view_model.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

void main() {
  late _FakeSubscriptionPackagesRepository repo;
  late GetSubscriptionPackagesUseCase useCase;
  late SubscriptionPackagesViewModel viewModel;

  setUp(() {
    repo = _FakeSubscriptionPackagesRepository();
    useCase = GetSubscriptionPackagesUseCase(repo);
    viewModel = SubscriptionPackagesViewModel(useCase);
  });

  tearDown(() {
    viewModel.close();
  });

  group('SubscriptionPackagesViewModel Pagination Tests', () {
    test('initial packages request fetches page 1 and keeps profile flags and pagination', () async {
      repo.result = ApiSuccessResult(
        data: SubscriptionProgramBundlesEntity(
          hasDeliveryAddress: true,
          hasAllergies: false,
          hasDietaryPreferences: true,
          isProfileComplete: true,
          bundles: [
            _createBundle('b1', 'prog_1', 'Bundle 1'),
            _createBundle('b2', 'prog_1', 'Bundle 2'),
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

      viewModel.doIntent(const GetSubscriptionPackagesEvent('prog_1'));
      await pumpEventQueue();

      expect(viewModel.state.bundles.length, 2);
      expect(viewModel.state.hasDeliveryAddress, isTrue);
      expect(viewModel.state.pagination?.hasNextPage, isTrue);
      expect(viewModel.state.pagination?.page, 1);
    });

    test('load more appends bundles without duplicates and preserves profile status', () async {
      repo.result = ApiSuccessResult(
        data: SubscriptionProgramBundlesEntity(
          hasDeliveryAddress: true,
          hasAllergies: false,
          hasDietaryPreferences: true,
          isProfileComplete: true,
          bundles: [_createBundle('b1', 'prog_1', 'Bundle 1')],
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

      viewModel.doIntent(const GetSubscriptionPackagesEvent('prog_1'));
      await pumpEventQueue();

      repo.result = ApiSuccessResult(
        data: SubscriptionProgramBundlesEntity(
          hasDeliveryAddress: true,
          hasAllergies: false,
          hasDietaryPreferences: true,
          isProfileComplete: true,
          bundles: [
            _createBundle('b1', 'prog_1', 'Bundle 1'), // duplicate
            _createBundle('b2', 'prog_1', 'Bundle 2'),
          ],
          pagination: const PaginationEntity(
            totalCount: 2,
            page: 2,
            pageSize: 1,
            totalPages: 2,
            hasNextPage: false,
            hasPreviousPage: true,
          ),
        ),
      );

      viewModel.doIntent(const LoadMoreSubscriptionPackagesEvent());
      await pumpEventQueue();

      expect(viewModel.state.bundles.length, 2);
      expect(viewModel.state.bundles.map((b) => b.bundleId).toList(), ['b1', 'b2']);
      expect(viewModel.state.pagination?.hasNextPage, isFalse);
    });

    test('changing program resets bundles and cancels older request effect', () async {
      final completer1 = Completer<ApiResult<SubscriptionProgramBundlesEntity>>();
      final completer2 = Completer<ApiResult<SubscriptionProgramBundlesEntity>>();

      repo.customHandler = (programId, page, pageSize) {
        if (programId == 'prog_1') return completer1.future;
        return completer2.future;
      };

      viewModel.doIntent(const GetSubscriptionPackagesEvent('prog_1'));
      await pumpEventQueue();

      viewModel.doIntent(const GetSubscriptionPackagesEvent('prog_2'));
      await pumpEventQueue();

      completer2.complete(
        ApiSuccessResult(
          data: SubscriptionProgramBundlesEntity(
            hasDeliveryAddress: true,
            hasAllergies: false,
            hasDietaryPreferences: true,
            isProfileComplete: true,
            bundles: [_createBundle('b_new', 'prog_2', 'Bundle New')],
            pagination: null,
          ),
        ),
      );
      await pumpEventQueue();

      expect(viewModel.state.bundles.first.bundleId, 'b_new');

      // Older program response finishes late
      completer1.complete(
        ApiSuccessResult(
          data: SubscriptionProgramBundlesEntity(
            hasDeliveryAddress: false,
            hasAllergies: false,
            hasDietaryPreferences: false,
            isProfileComplete: false,
            bundles: [_createBundle('b_old', 'prog_1', 'Bundle Old')],
            pagination: null,
          ),
        ),
      );
      await pumpEventQueue();

      // State must remain for prog_2
      expect(viewModel.state.bundles.first.bundleId, 'b_new');
    });

    test('SubscriptionPackageFlowController maintains selected bundle by identity after refresh', () async {
      final controller = SubscriptionPackageFlowController(
        selectedProgram: _createDummyProgram('p1'),
        viewModel: viewModel,
      );

      final initialBundles = [
        _createBundle('b1', 'p1', 'Bundle 1'),
        _createBundle('b2', 'p1', 'Bundle 2'),
      ];

      // User selects b2 (index 1)
      controller.syncBundles(initialBundles);
      controller.selectPackage(1);
      expect(controller.selectedPackageNotifier.value, 1);
      expect(controller.selectedBundleId, 'b2');

      // Refresh arrives where bundles are prepended or reordered
      final updatedBundles = [
        _createBundle('b0', 'p1', 'Bundle 0'),
        _createBundle('b1', 'p1', 'Bundle 1'),
        _createBundle('b2', 'p1', 'Bundle 2'), // now index 2
      ];

      controller.syncBundles(updatedBundles);
      // Index should automatically update to 2 for b2
      expect(controller.selectedPackageNotifier.value, 2);
      expect(controller.selectedBundleId, 'b2');

      controller.dispose();
    });
  });
}

SubscriptionBundleEntity _createBundle(String id, String progId, String name) {
  return SubscriptionBundleEntity(
    bundleId: id,
    programId: progId,
    code: id,
    nameAr: name,
    nameEn: name,
    descriptionAr: '',
    descriptionEn: '',
    imageUrl: null,
    mealsPerDay: 3,
    breakfastCount: 1,
    lunchCount: 1,
    dinnerCount: 1,
    snackCount: 0,
    slots: const [],
    restaurantCount: 10,
    restaurants: const [],
    selectionCount: 5,
    isMostSelected: false,
    badge: null,
  );
}

SubscriptionProgramEntity _createDummyProgram(String id) {
  return SubscriptionProgramEntity(
    programId: id,
    code: id,
    shortCode: id,
    nameAr: 'Prog',
    nameEn: 'Prog',
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

class _FakeSubscriptionPackagesRepository implements SubscriptionPackagesRepository {
  ApiResult<SubscriptionProgramBundlesEntity>? result;
  Future<ApiResult<SubscriptionProgramBundlesEntity>> Function(
    String programId,
    int? page,
    int? pageSize,
  )? customHandler;

  @override
  Future<ApiResult<SubscriptionProgramBundlesEntity>> getSubscriptionPackages(
    String programId, {
    int? page,
    int? pageSize,
  }) async {
    if (customHandler != null) {
      return customHandler!(programId, page, pageSize);
    }
    return result ??
        ApiSuccessResult(
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
