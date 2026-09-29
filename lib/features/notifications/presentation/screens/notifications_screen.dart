import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/notifications/data/notifications_fake_data_source.dart';
import 'package:meal_meat_user/features/notifications/domain/entities/notification_item_entity.dart';
import 'package:meal_meat_user/features/notifications/presentation/widgets/notification_card.dart';
import 'package:meal_meat_user/features/notifications/presentation/widgets/notification_clear_all_button.dart';
import 'package:meal_meat_user/features/notifications/presentation/widgets/notification_empty_view.dart';
import 'package:meal_meat_user/features/notifications/presentation/widgets/notification_section_action_row.dart';
import 'package:meal_meat_user/features/notifications/presentation/widgets/notification_tab_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationsFakeDataSource _dataSource =
      const NotificationsFakeDataSource();
  List<NotificationItemEntity>? _notifications;
  NotificationCategory _selectedCategory = NotificationCategory.all;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_notifications == null) {
      final locale = context.localization;
      _notifications = _dataSource.loadNotifications(locale);
    }
  }

  void _onCategorySelected(NotificationCategory category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _markAllAsRead() {
    if (_notifications == null) return;
    setState(() {
      _notifications = _notifications!
          .map((item) => item.copyWith(isRead: true))
          .toList();
    });
  }

  void _clearAllNotifications() {
    setState(() {
      _notifications = [];
    });
  }

  void _onNotificationTap(NotificationItemEntity notification) {
    setState(() {
      _notifications = _notifications!.map((item) {
        if (item.id == notification.id) {
          return item.copyWith(isRead: true);
        }
        return item;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final allNotifications = _notifications ?? [];
    final filteredNotifications = _selectedCategory == NotificationCategory.all
        ? allNotifications
        : allNotifications
              .where((item) => item.category == _selectedCategory)
              .toList();

    final hasUnread = allNotifications.any((item) => !item.isRead);

    final todayItems = filteredNotifications
        .where((item) => item.isToday)
        .toList();
    final yesterdayItems = filteredNotifications
        .where((item) => !item.isToday)
        .toList();

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
              selectedCategory: _selectedCategory,
              onCategorySelected: _onCategorySelected,
            ),
            Expanded(
              child: filteredNotifications.isEmpty
                  ? const NotificationEmptyView()
                  : ListView(
                      padding: const EdgeInsets.only(
                        top: Spacing.xs,
                        bottom: Spacing.xxxl,
                      ),
                      children: [
                        if (todayItems.isNotEmpty) ...[
                          NotificationSectionActionRow(
                            sectionTitle: locale.notifications_group_today,
                            onMarkAllRead: _markAllAsRead,
                            showMarkAllRead: hasUnread,
                          ),
                          ...todayItems.map(
                            (item) => NotificationCard(
                              notification: item,
                              onTap: () => _onNotificationTap(item),
                            ),
                          ),
                        ],
                        if (yesterdayItems.isNotEmpty) ...[
                          const SizedBox(height: Spacing.xs),
                          NotificationSectionActionRow(
                            sectionTitle: locale.notifications_group_yesterday,
                            onMarkAllRead: () {},
                            showMarkAllRead: false,
                          ),
                          ...yesterdayItems.map(
                            (item) => NotificationCard(
                              notification: item,
                              onTap: () => _onNotificationTap(item),
                            ),
                          ),
                        ],
                        const SizedBox(height: Spacing.sm),
                        NotificationClearAllButton(
                          onPressed: _clearAllNotifications,
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
