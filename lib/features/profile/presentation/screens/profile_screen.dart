import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/loading_widget.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_event.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_state.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_view_model.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_header.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_image_upload_builder.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_logout_button.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_settings_card.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_stats_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<ProfileViewModel>(
      create: (_) =>
          getIt<ProfileViewModel>()..doIntent(const GetCustomerProfileEvent()),
      child: ProfileImageUploadBuilder(
        builder: (context, isImageActionLoading, onEditImagePressed) =>
            Scaffold(
              backgroundColor: color.surface,
              appBar: CustomAppBar(
                showBackButton: false,
                automaticallyImplyLeading: false,
                titleWidget: SizedBox(
                  width: Spacing.profileAppBarLogoWidth,
                  height: Spacing.profileAppBarLogoHeight,
                  child: SvgPicture.asset(Assets.mealMateLogo),
                ),
                leading: IconButton(
                  onPressed: () => context.pushNamed(AppRoutes.profileSettings),

                  constraints: const BoxConstraints.tightFor(
                    width: Spacing.profileHeaderActionSize,
                    height: Spacing.profileHeaderActionSize,
                  ),
                  padding: EdgeInsetsDirectional.only(start: Spacing.screenH),
                  icon: Icon(
                    Icons.settings_rounded,
                    color: color.onSurface,
                    size: Spacing.profileHeaderIconSize,
                  ),
                ),
                actions: [
                  Badge(
                    alignment: Alignment.topRight,
                    backgroundColor: color.error,
                    smallSize: Spacing.md,
                    child: IconButton(
                      onPressed: () {},
                      constraints: const BoxConstraints.tightFor(
                        width: Spacing.profileHeaderActionSize,
                        height: Spacing.profileHeaderActionSize,
                      ),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.notifications_rounded,
                        color: color.onSurface,
                        size: Spacing.profileHeaderIconSize,
                      ),
                    ),
                  ),
                ],
              ),
              body: BlocBuilder<ProfileViewModel, ProfileState>(
                buildWhen: (previous, current) =>
                    previous.profile != current.profile,
                builder: (context, state) {
                  final profileState = state.profile;

                  if (profileState.isLoading && profileState.data == null) {
                    return const LoadingWidget.fullScreen();
                  }

                  if (profileState.failure != null &&
                      profileState.data == null) {
                    return ApiErrorWidget(
                      exception: profileState.failure!.exception,
                      onRetry: () => context.read<ProfileViewModel>().doIntent(
                        const GetCustomerProfileEvent(),
                      ),
                    );
                  }

                  return SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.profileScreenHorizontalPadding,
                      ),
                      child: Column(
                        children: [
                          ProfileHeader(
                            semanticsLabel: locale.nav_profile,
                            profile: profileState.data,
                            isImageActionLoading: isImageActionLoading,
                            onEditImagePressed: onEditImagePressed,
                          ),
                          const SizedBox(height: Spacing.profileStatsTopGap),
                          const ProfileStatsCard(),
                          const SizedBox(height: Spacing.profileSettingsTopGap),
                          const ProfileSettingsCard(),
                          const SizedBox(height: Spacing.profileLogoutTopGap),
                          const ProfileLogoutButton(),
                          const SizedBox(height: Spacing.xxxl),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      ),
    );
  }
}
