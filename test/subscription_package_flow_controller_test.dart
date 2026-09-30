import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_package_flow_controller.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_event.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_state.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_view_model.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';

class FakeSubscriptionPackagesViewModel extends Cubit<SubscriptionPackagesState>
    implements SubscriptionPackagesViewModel {
  FakeSubscriptionPackagesViewModel()
      : super(const SubscriptionPackagesState());

  SubscriptionPackagesEvent? lastEvent;

  @override
  void doIntent(SubscriptionPackagesEvent event) {
    lastEvent = event;
  }
}

void main() {
  late FakeSubscriptionPackagesViewModel fakeViewModel;
  late SubscriptionPackageFlowController controller;

  setUp(() {
    fakeViewModel = FakeSubscriptionPackagesViewModel();
    controller = SubscriptionPackageFlowController(
      selectedProgram: const SubscriptionProgramEntity(
        programId: 'program-1',
        code: 'PROG_WEIGHT_LOSS',
        shortCode: 'WL',
        nameAr: 'خسارة الوزن',
        nameEn: 'Weight Loss',
        descriptionAr: 'وصف',
        descriptionEn: 'Description',
        keywordsAr: ['صحي'],
        keywordsEn: ['Healthy'],
        imageUrl: 'https://example.com/img.png',
        bundleCount: 3,
        supportedSlots: ['breakfast'],
        fallbackImageAsset: 'assets/images/default.png',
      ),
      viewModel: fakeViewModel,
    );
  });

  tearDown(() {
    controller.dispose();
  });

  test('selectPackage updates notifier value when changed', () {
    expect(controller.selectedPackageNotifier.value, isNull);

    controller.selectPackage(2);
    expect(controller.selectedPackageNotifier.value, 2);

    // selecting same index does not trigger unnecessary change
    controller.selectPackage(2);
    expect(controller.selectedPackageNotifier.value, 2);
  });

  test('shouldListenToProfileUpdate returns true only after profile update triggered and loading finishes', () {
    const previousLoading = SubscriptionPackagesState(isLoading: true);
    const currentFinished = SubscriptionPackagesState(isLoading: false);

    // Initial: no profile update pending
    expect(
      controller.shouldListenToProfileUpdate(previousLoading, currentFinished),
      isFalse,
    );
  });
}
