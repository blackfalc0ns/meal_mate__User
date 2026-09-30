import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/subscription_type_entity.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/manager/subscription_types_event.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/manager/subscription_types_state.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/manager/subscription_types_view_model.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/widgets/subscription_types_content.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/widgets/subscription_types_loading_skeleton.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key, this.showBottomSpace = false});

  final bool showBottomSpace;

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  int? _selectedTypeIndex;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<SubscriptionTypesViewModel>(
      create: (_) =>
          getIt<SubscriptionTypesViewModel>()
            ..doIntent(const GetSubscriptionTypesEvent()),
      child: Semantics(
        label: locale.nav_subscription,
        child: Scaffold(
          backgroundColor: color.surface,
          body: SafeArea(
            bottom: false,
            child:
                BlocConsumer<
                  SubscriptionTypesViewModel,
                  SubscriptionTypesState
                >(
                  listenWhen: (previous, current) =>
                      previous.isConversionSuccess !=
                          current.isConversionSuccess ||
                      previous.conversionFailure != current.conversionFailure,
                  listener: (context, state) {
                    if (state.isConversionSuccess) {
                      final conversionOptions = state.conversionOptions;
                      if (conversionOptions != null) {
                        unawaited(
                          context.pushNamed(
                            AppRoutes.conversionOptions,
                            arguments: conversionOptions,
                          ),
                        );
                      }
                      return;
                    }

                    final message = state.conversionFailure?.errorMessage;
                    if (message != null && message.isNotEmpty) {
                      CustomSnackbar.showError(
                        context: context,
                        message: message,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.isLoading && state.types.isEmpty) {
                      return SubscriptionTypesLoadingSkeleton(
                        showBottomSpace: widget.showBottomSpace,
                      );
                    }

                    if (state.failure != null && state.types.isEmpty) {
                      return ApiErrorWidget(
                        exception: state.failure!.exception,
                        onRetry: () => context
                            .read<SubscriptionTypesViewModel>()
                            .doIntent(const GetSubscriptionTypesEvent()),
                      );
                    }

                    if (state.isSuccess && state.types.isEmpty) {
                      return EmptyStateWidget(
                        title: locale.subscription_type_title,
                        description: locale.subscription_type_subtitle,
                        icon: Icons.subscriptions_rounded,
                      );
                    }

                    return SubscriptionTypesContent(
                      state: state,
                      showBottomSpace: widget.showBottomSpace,
                      scrollController: _scrollController,
                      selectedTypeIndex: _selectedTypeIndex,
                      onSelectType: _selectSubscriptionType,
                      onOpenSelectedType: () {
                        _openSelectedSubscription(context, state.types);
                      },
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }

  void _selectSubscriptionType(int index) {
    if (_selectedTypeIndex != index) {
      setState(() => _selectedTypeIndex = index);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      unawaited(
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        ),
      );
    });
  }

  void _openSelectedSubscription(
    BuildContext context,
    List<SubscriptionTypeEntity> types,
  ) {
    final selectedTypeIndex = _selectedTypeIndex;
    if (selectedTypeIndex == null || selectedTypeIndex >= types.length) return;

    final selectedType = types[selectedTypeIndex];
    if (!selectedType.isAvailable) return;

    if (!selectedType.isFamily) {
      unawaited(context.pushNamed(AppRoutes.subscriptionProgramSelection));
      return;
    }

    if (selectedType.requiresConversion) {
      context.read<SubscriptionTypesViewModel>().doIntent(
        const GetSubscriptionConversionOptionsEvent(),
      );
      return;
    }

    unawaited(context.pushNamed(AppRoutes.familyPackageSelection));
  }
}
