import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import '../manager/compensations_view_model.dart';
import '../manager/compensations_event.dart';
import '../widgets/compensations_content.dart';

class CompensationsScreen extends StatefulWidget {
  const CompensationsScreen({super.key, this.viewModel});
  final CompensationsViewModel? viewModel;
  @override
  State<CompensationsScreen> createState() => _CompensationsScreenState();
}

class _CompensationsScreenState extends State<CompensationsScreen>
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
    return BlocProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: color.surface,
        appBar: CustomAppBar(
          title: locale.compensations_title,
          actions: [
            IconButton(
              tooltip: locale.compensations_refresh,
              onPressed: () =>
                  _viewModel.doIntent(const LoadCompensationsEvent()),
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
        body: const SafeArea(child: CompensationsContent()),
      ),
    );
  }
}
