import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/upload_file/domain/entities/upload_file_request_entity.dart';
import 'package:meal_meat_user/core/widget/app_image_source_sheet.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_image_request_entity.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_event.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_state.dart';
import 'package:meal_meat_user/features/profile/presentation/manager/profile_view_model.dart';

class ProfileImageUploadBuilder extends StatelessWidget {
  const ProfileImageUploadBuilder({super.key, required this.builder});

  final Widget Function(
    BuildContext context,
    bool isImageActionLoading,
    VoidCallback onEditImagePressed,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileViewModel, ProfileState>(
          listenWhen: (previous, current) =>
              previous.upload.data != current.upload.data &&
              current.upload.isSuccess &&
              current.upload.data != null,
          listener: _updateProfileImageAfterUpload,
        ),
        BlocListener<ProfileViewModel, ProfileState>(
          listenWhen: (previous, current) =>
              previous.upload.errorMessage != current.upload.errorMessage &&
              current.upload.errorMessage != null,
          listener: (context, state) => _showErrorMessage(
            context,
            state.upload.errorMessage ?? locale.profile_photo_upload_error,
          ),
        ),
        BlocListener<ProfileViewModel, ProfileState>(
          listenWhen: (previous, current) =>
              previous.action.errorMessage != current.action.errorMessage &&
              current.action.errorMessage != null,
          listener: (context, state) => _showErrorMessage(
            context,
            state.action.errorMessage ?? locale.profile_photo_upload_error,
          ),
        ),
        BlocListener<ProfileViewModel, ProfileState>(
          listenWhen: (previous, current) =>
              previous.action.isSuccess != current.action.isSuccess &&
              current.action.isSuccess,
          listener: (context, state) =>
              _showSuccessMessage(context, locale.profile_photo_upload_success),
        ),
      ],
      child: BlocBuilder<ProfileViewModel, ProfileState>(
        buildWhen: (previous, current) =>
            previous.upload.isLoading != current.upload.isLoading ||
            previous.action.isLoading != current.action.isLoading,
        builder: (context, state) {
          return builder(
            context,
            state.upload.isLoading || state.action.isLoading,
            () => _showImageSourceSheet(context, color.surface),
          );
        },
      ),
    );
  }

  Future<void> _showImageSourceSheet(
    BuildContext context,
    Color surfaceColor,
  ) async {
    final locale = context.localization;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
      ),
      builder: (_) => const AppImageSourceSheet(),
    );

    if (source == null || !context.mounted) return;

    try {
      final pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile == null || !context.mounted) return;

      context.read<ProfileViewModel>().doIntent(
        UploadFileEvent(UploadFileRequestEntity(filePath: pickedFile.path)),
      );
    } catch (_) {
      if (!context.mounted) return;
      _showErrorMessage(context, locale.profile_photo_permission_error);
    }
  }

  void _updateProfileImageAfterUpload(
    BuildContext context,
    ProfileState state,
  ) {
    final uploadData = state.upload.data;

    if (uploadData == null) return;

    context.read<ProfileViewModel>().doIntent(
      UpdateCustomerProfileImageEvent(
        ProfileImageRequestEntity(storageKey: uploadData.storageKey),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) =>
      CustomSnackbar.showError(context: context, message: message);

  void _showSuccessMessage(BuildContext context, String message) =>
      CustomSnackbar.showSuccess(context: context, message: message);
}
