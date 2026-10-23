import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/network/api_results.dart';
import '../../domain/entities/native_call_snapshot_entity.dart';
import '../../domain/repo/native_voice_repository.dart';
import 'voice_permission_setup_event.dart';
import 'voice_permission_setup_state.dart';

@injectable
class VoicePermissionSetupViewModel
    extends Bloc<VoicePermissionSetupEvent, VoicePermissionSetupState> {
  final NativeVoiceRepository _repository;

  VoicePermissionSetupViewModel(this._repository)
      : super(const VoicePermissionSetupState()) {
    on<CheckPermissionEvent>(_onCheckPermission);
    on<RequestPermissionEvent>(_onRequestPermission);
    on<DismissPermissionExplainerEvent>(_onDismissExplainer);
    on<OpenPermissionSettingsEvent>(_onOpenSettings);
  }

  Future<void> _onCheckPermission(
    CheckPermissionEvent event,
    Emitter<VoicePermissionSetupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.getMicrophonePermission();
    if (result is ApiSuccessResult<NativeMicrophonePermission>) {
      emit(state.copyWith(permission: result.data, isLoading: false));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onRequestPermission(
    RequestPermissionEvent event,
    Emitter<VoicePermissionSetupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.requestMicrophonePermission();
    if (result is ApiSuccessResult<NativeMicrophonePermission>) {
      emit(state.copyWith(permission: result.data, isLoading: false));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onDismissExplainer(
    DismissPermissionExplainerEvent event,
    Emitter<VoicePermissionSetupState> emit,
  ) {
    emit(state.copyWith(isDeferred: true));
  }

  Future<void> _onOpenSettings(
    OpenPermissionSettingsEvent event,
    Emitter<VoicePermissionSetupState> emit,
  ) async {
    await _repository.openAppSettings();
  }
}
