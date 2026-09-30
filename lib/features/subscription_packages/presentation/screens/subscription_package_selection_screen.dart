import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_package_flow_controller.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_event.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_state.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/manager/subscription_packages_view_model.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/sections/subscription_package_selection_body.dart';
import 'package:meal_meat_user/features/subscription_packages/presentation/widgets/subscription_packages_bottom_bar.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_program_entity.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';

class SubscriptionPackageSelectionScreen extends StatefulWidget {
  const SubscriptionPackageSelectionScreen({super.key, this.selectedProgram});

  final SubscriptionProgramEntity? selectedProgram;

  @override
  State<SubscriptionPackageSelectionScreen> createState() =>
      _SubscriptionPackageSelectionScreenState();
}

class _SubscriptionPackageSelectionScreenState
    extends State<SubscriptionPackageSelectionScreen> {
  late final SubscriptionPackagesViewModel _viewModel;
  late final SubscriptionPackageFlowController _flowController;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<SubscriptionPackagesViewModel>();
    final selectedProgram = widget.selectedProgram;
    if (selectedProgram != null) {
      _viewModel.doIntent(
        GetSubscriptionPackagesEvent(selectedProgram.programId),
      );
    }
    _flowController = SubscriptionPackageFlowController(
      selectedProgram: selectedProgram,
      viewModel: _viewModel,
    );
  }

  @override
  void dispose() {
    _flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final selectedProgram = widget.selectedProgram;

    return BlocProvider<SubscriptionPackagesViewModel>.value(
      value: _viewModel,
      child: BlocListener<
        SubscriptionPackagesViewModel,
        SubscriptionPackagesState
      >(
        listenWhen: (previous, current) =>
            _flowController.shouldListenToProfileUpdate(previous, current),
        listener: (context, state) =>
            _flowController.handleProfileUpdatedListener(context, state),
        child: Scaffold(
          backgroundColor: color.surface,
          appBar: CustomAppBar(
            titleWidget: const AppLogo(
              alignment: CrossAxisAlignment.center,
            ),
            backgroundColor: color.surface,
            onBackPressed: () => Navigator.maybePop(context),
          ),
          body: Stack(
            children: [
              BlocBuilder<
                SubscriptionPackagesViewModel,
                SubscriptionPackagesState
              >(
                buildWhen: (previous, current) =>
                    previous.isLoading != current.isLoading ||
                    previous.isSuccess != current.isSuccess ||
                    previous.failure != current.failure ||
                    previous.bundles != current.bundles,
                builder: (context, state) {
                  return SubscriptionPackageSelectionBody(
                    state: state,
                    selectedProgram: selectedProgram,
                    selectedPackageNotifier:
                        _flowController.selectedPackageNotifier,
                    onPackageSelected: _flowController.selectPackage,
                    onRetry: () {
                      if (selectedProgram != null) {
                        _viewModel.doIntent(
                          GetSubscriptionPackagesEvent(
                            selectedProgram.programId,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
              BlocSelector<
                SubscriptionPackagesViewModel,
                SubscriptionPackagesState,
                ({bool hasBundles, bool isLoading})
              >(
                selector: (state) => (
                  hasBundles: state.bundles.isNotEmpty,
                  isLoading: state.isLoading,
                ),
                builder: (context, data) {
                  return SubscriptionPackagesBottomBar(
                    selectedPackageNotifier:
                        _flowController.selectedPackageNotifier,
                    hasBundles: data.hasBundles,
                    isLoading: data.isLoading,
                    onContinue: () {
                      final state = _viewModel.state;
                      unawaited(
                        _flowController.continueWithProfileStatus(
                          context,
                          state,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
