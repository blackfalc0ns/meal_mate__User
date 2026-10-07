import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/logout_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/logout_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/logout_view_model.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_logout_button.dart';

class ProfileLogoutAction extends StatelessWidget {
  const ProfileLogoutAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LogoutViewModel>(
      create: (_) => getIt<LogoutViewModel>(),
      child: BlocListener<LogoutViewModel, LogoutState>(
        listenWhen: (previous, current) =>
            previous.isLoading &&
            !current.isLoading &&
            current.outcome == LogoutOutcome.success,
        listener: (context, state) => context.pushNamedAndRemoveUntil(
          AppRoutes.signIn,
          predicate: (_) => false,
        ),
        child: BlocSelector<LogoutViewModel, LogoutState, bool>(
          selector: (state) => state.isLoading,
          builder: (context, isLoading) => ProfileLogoutButton(
            isLoading: isLoading,
            onConfirmLogout: () {
              context.read<LogoutViewModel>().add(const RequestLogoutEvent());
            },
          ),
        ),
      ),
    );
  }
}
