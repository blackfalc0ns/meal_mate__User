import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/services/token_service.dart';
import 'package:meal_meat_user/features/auth/domain/entities/logout_request_entity.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_event.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_state.dart';
import 'package:meal_meat_user/features/auth/presentation/manager/auth_view_model.dart';
import 'package:meal_meat_user/features/profile/presentation/widgets/profile_logout_button.dart';

class ProfileLogoutAction extends StatelessWidget {
  const ProfileLogoutAction({super.key});

  Future<void> _logout(BuildContext context) async {
    final refreshToken = await getIt<TokenService>().getRefreshToken() ?? '';
    if (!context.mounted) return;
    context.read<AuthViewModel>().doIntent(
      LogoutEvent(LogoutRequestEntity(refreshToken: refreshToken)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthViewModel>(
      create: (_) => getIt<AuthViewModel>(),
      child: BlocListener<AuthViewModel, AuthState>(
        listenWhen: (previous, current) =>
            previous.logout.isLoading && !current.logout.isLoading,
        listener: (context, state) => context.pushNamedAndRemoveUntil(
          AppRoutes.signIn,
          predicate: (_) => false,
        ),
        child: BlocSelector<AuthViewModel, AuthState, bool>(
          selector: (state) => state.logout.isLoading,
          builder: (context, isLoading) => ProfileLogoutButton(
            isLoading: isLoading,
            onConfirmLogout: () => _logout(context),
          ),
        ),
      ),
    );
  }
}
