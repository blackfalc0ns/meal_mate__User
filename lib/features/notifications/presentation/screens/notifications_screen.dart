import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notification_item_entity.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notifications_event.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notifications_state.dart';
import 'package:meal_meat_user/features/notifications/presentation/manager/notifications_view_model.dart';
import 'package:meal_meat_user/features/notifications/presentation/mapper/notification_presentation_mapper.dart';
import 'package:meal_meat_user/features/notifications/presentation/widgets/notification_card.dart';
import 'package:meal_meat_user/features/notifications/presentation/widgets/notification_empty_view.dart';
import 'package:meal_meat_user/features/notifications/presentation/widgets/notification_section_action_row.dart';
import 'package:meal_meat_user/features/notifications/presentation/widgets/notification_tab_bar.dart';
import 'package:meal_meat_user/features/notifications/presentation/widgets/notifications_loading_skeleton.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, this.viewModel});

  final NotificationsViewModel? viewModel;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with WidgetsBindingObserver {
  late final NotificationsViewModel _viewModel;
  bool _ownsViewModel = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
      _ownsViewModel = false;
    } else {
      _viewModel = getIt<NotificationsViewModel>();
      _ownsViewModel = true;
    }
    unawaited(_viewModel.load());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      unawaited(_viewModel.refresh());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_ownsViewModel) {
      unawaited(_viewModel.close());
    }
    super.dispose();
  }

  void _onNotificationTap(NotificationItemEntity notification) {
    unawaited(
      _viewModel.markRead(
        notification.id,
        onSuccess: () {
          if (!mounted) return;
          _navigateForNotification(notification);
        },
      ),
    );
  }

  void _navigateForNotification(NotificationItemEntity notification) {
    final link = notification.deepLink;
    if (link != null && link.isNotEmpty) {
      final uri = Uri.tryParse(link);
      if (uri != null &&
          uri.path.startsWith(AppRoutes.customerSupportCasePrefix)) {
        unawaited(Navigator.of(context).pushNamed(uri.path));
        return;
      }
      if (link.contains('calendar')) {
        unawaited(Navigator.of(context).pushNamed(AppRoutes.calendar));
        return;
      }
      if (link.contains('orders')) {
        unawaited(Navigator.of(context).pushNamed(AppRoutes.calendar));
        return;
      }
      if (link.contains('influencer')) {
        unawaited(
          Navigator.of(context).pushNamed(AppRoutes.influencerDashboard),
        );
        return;
      }
    }

    if (notification.category == NotificationCategory.subscription ||
        notification.category == NotificationCategory.meals) {
      unawaited(Navigator.of(context).pushNamed(AppRoutes.calendar));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<NotificationsViewModel>.value(
      value: _viewModel,
      child: BlocConsumer<NotificationsViewModel, NotificationsState>(
        listenWhen: (previous, current) =>
            previous.actionFailure != current.actionFailure &&
            current.actionFailure != null,
        listener: (context, state) {
          if (state.actionFailure != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(
                context,
                state.actionFailure!,
              ),
            );
            _viewModel.doIntent(const ClearActionFailureEvent());
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              showBackButton: true,
              title: locale.notifications_screen_title,
              titleColor: color.primary,
              titleFontSize: FontSize.size16,
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: color.primary,
                    size: Spacing.iconMd,
                  ),
                  onPressed: () {
                    unawaited(
                      Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.notificationPreferences),
                    );
                  },
                ),
              ],
            ),
            body: SafeArea(
              top: false,
              child: Column(
                children: [
                  NotificationTabBar(
                    selectedCategory: state.selectedCategory,
                    onCategorySelected: (cat) {
                      _viewModel.selectCategory(cat);
                    },
                  ),
                  Expanded(child: _buildBody(context, state, locale)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotificationsState state,
    AppLocalizations locale,
  ) {
    if (state.isLoading && state.rawItems.isEmpty) {
      return const NotificationsLoadingSkeleton();
    }

    if (state.initialFailure != null && state.rawItems.isEmpty) {
      return Center(
        child: ApiErrorWidget(
          exception: state.initialFailure!.exception,
          onRetry: () => _viewModel.load(),
        ),
      );
    }

    final sections = NotificationPresentationMapper.buildSections(
      items: state.rawItems,
      selectedCategory: state.selectedCategory,
      locale: locale,
    );

    if (sections.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _viewModel.refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: Spacing.xxxl),
            NotificationEmptyView(),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter <= 200) {
          unawaited(_viewModel.loadMore());
        }
        return false;
      },
      child: RefreshIndicator(
        onRefresh: () => _viewModel.refresh(),
        child: ListView(
          padding: const EdgeInsets.only(top: Spacing.xs, bottom: Spacing.xxxl),
          children: [
            for (final section in sections) ...[
              NotificationSectionActionRow(
                sectionTitle: section.title,
                onMarkAllRead: () => _viewModel.markAllRead(),
                showMarkAllRead:
                    section.showMarkAllRead && !state.isMarkingAllRead,
              ),
              for (final item in section.items)
                NotificationCard(
                  notification: item,
                  onTap: () => _onNotificationTap(item),
                ),
              const SizedBox(height: Spacing.xs),
            ],
            if (state.isLoadingMore) const NotificationsLoadMoreSkeleton(),
            if (state.loadMoreFailure != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenH,
                  vertical: Spacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        ErrorMessagePresenter.fromFailure(
                          context,
                          state.loadMoreFailure!,
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () => _viewModel.loadMore(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
