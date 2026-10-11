import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_conversion_draft_session.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/conversion_options_model.dart';
import 'package:meal_meat_user/features/subscription_types/domain/usecase/convert_from_individual_usecase.dart';
import 'package:meal_meat_user/features/subscription_types/domain/usecase/get_subscription_conversion_options_usecase.dart';
import 'package:meal_meat_user/features/subscription_types/domain/usecase/get_subscription_types_usecase.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/manager/subscription_types_event.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/manager/subscription_types_state.dart';

@injectable
class SubscriptionTypesViewModel extends Cubit<SubscriptionTypesState> {
  SubscriptionTypesViewModel(
    this._getSubscriptionTypesUseCase,
    this._getSubscriptionConversionOptionsUseCase,
    this._convertFromIndividualUseCase,
  ) : super(const SubscriptionTypesState());

  final GetSubscriptionTypesUseCase _getSubscriptionTypesUseCase;
  final GetSubscriptionConversionOptionsUseCase
  _getSubscriptionConversionOptionsUseCase;
  final ConvertFromIndividualUseCase _convertFromIndividualUseCase;

  void doIntent(SubscriptionTypesEvent event) {
    switch (event) {
      case GetSubscriptionTypesEvent():
        unawaited(_getSubscriptionTypes());
      case GetSubscriptionConversionOptionsEvent():
        unawaited(_getSubscriptionConversionOptions());
      case ConvertFromIndividualEvent():
        unawaited(_convertFromIndividual());
      case InitializeConversionOptionSelectionEvent():
        _initializeConversionOptionSelection(event.options);
      case SelectConversionOptionEvent():
        _selectConversionOption(event.option);
    }
  }

  void _initializeConversionOptionSelection(ConversionOptionsModel options) {
    final defaultOption =
        options.convertToFamilyManagerOption?.available == true
        ? options.convertToFamilyManagerOption
        : null;

    emit(
      state.copyWith(
        selectedConversionOption: defaultOption,
        clearSelectedConversionOption: defaultOption == null,
      ),
    );
  }

  void _selectConversionOption(ConversionOptionModel option) {
    emit(state.copyWith(selectedConversionOption: option));
  }

  Future<void> _getSubscriptionTypes() async {
    emit(
      state.copyWith(
        isLoading: true,
        isSuccess: false,
        isConversionSuccess: false,
        isConvertFromIndividualSuccess: false,
        clearFailure: true,
      ),
    );

    final result = await _getSubscriptionTypesUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            types: result.data.where((type) => type.code.isNotEmpty).toList(),
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _getSubscriptionConversionOptions() async {
    emit(
      state.copyWith(
        isConversionLoading: true,
        isConversionSuccess: false,
        isConvertFromIndividualSuccess: false,
        clearConversionFailure: true,
      ),
    );

    final result = await _getSubscriptionConversionOptionsUseCase();

    switch (result) {
      case ApiSuccessResult():
        emit(
          state.copyWith(
            isConversionLoading: false,
            isConversionSuccess: true,
            conversionOptions: result.data,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isConversionLoading: false,
            isConversionSuccess: false,
            conversionFailure: result.failure,
          ),
        );
    }
  }

  Future<void> _convertFromIndividual() async {
    final selectedOption = state.selectedConversionOption;
    if (selectedOption?.isConvertToFamilyManager != true ||
        selectedOption?.available != true) {
      return;
    }

    emit(
      state.copyWith(
        isConvertFromIndividualLoading: true,
        isConvertFromIndividualSuccess: false,
        clearConvertFromIndividualFailure: true,
      ),
    );

    final result = await _convertFromIndividualUseCase();

    switch (result) {
      case ApiSuccessResult():
        FamilyConversionDraftSession.markConvertedFamilyDraft();
        emit(
          state.copyWith(
            isConvertFromIndividualLoading: false,
            isConvertFromIndividualSuccess: true,
            convertedFamilyFlow: result.data,
          ),
        );
      case ApiErrorResult():
        emit(
          state.copyWith(
            isConvertFromIndividualLoading: false,
            isConvertFromIndividualSuccess: false,
            convertFromIndividualFailure: result.failure,
          ),
        );
    }
  }
}
