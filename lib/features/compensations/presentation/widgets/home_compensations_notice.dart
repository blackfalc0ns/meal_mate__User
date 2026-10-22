import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import '../manager/compensations_view_model.dart';
import '../manager/compensations_state.dart';
import '../manager/compensations_event.dart';

class HomeCompensationsNotice extends StatefulWidget {
  const HomeCompensationsNotice({super.key, this.viewModel});
  final CompensationsViewModel? viewModel;
  @override
  State<HomeCompensationsNotice> createState() =>
      _HomeCompensationsNoticeState();
}

class _HomeCompensationsNoticeState extends State<HomeCompensationsNotice>
    with WidgetsBindingObserver {
  late final CompensationsViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _viewModel = widget.viewModel ?? getIt<CompensationsViewModel>();
    _viewModel.doIntent(const LoadCompensationsEvent());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _viewModel.doIntent(const LoadCompensationsEvent());
    }
  }

  Future<void> _open() async {
    await Navigator.of(context).pushNamed(AppRoutes.compensations);
    if (mounted) _viewModel.doIntent(const LoadCompensationsEvent());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (widget.viewModel == null) unawaited(_viewModel.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return BlocSelector<CompensationsViewModel, CompensationsState, bool>(
      bloc: _viewModel,
      selector: (state) => state.items.any((item) => item.isPendingChoice),
      builder: (context, hasPending) {
        if (!hasPending) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: Spacing.base),
          child: Material(
            color: color.secondaryContainer,
            borderRadius: BorderRadius.circular(Spacing.cardRadius),
            child: InkWell(
              onTap: _open,
              borderRadius: BorderRadius.circular(Spacing.cardRadius),
              child: Padding(
                padding: const EdgeInsets.all(Spacing.cardPadding),
                child: Row(
                  children: [
                    Icon(
                      Icons.redeem_rounded,
                      color: color.onSecondaryContainer,
                    ),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            locale.compensations_title,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              color: color.onSecondaryContainer,
                            ),
                          ),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            locale.compensations_pending_notice,
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              color: color.onSecondaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: color.onSecondaryContainer,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
