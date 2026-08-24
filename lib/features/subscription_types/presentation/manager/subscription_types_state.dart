import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_flow_current_entity.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/conversion_options_model.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/subscription_type_entity.dart';

class SubscriptionTypesState {
  const SubscriptionTypesState({
    this.isLoading = false,
    this.isConversionLoading = false,
    this.isConversionSuccess = false,
    this.isConvertFromIndividualLoading = false,
    this.isConvertFromIndividualSuccess = false,
    this.isSuccess = false,
    this.types = const [],
    this.conversionOptions,
    this.selectedConversionOption,
    this.convertedFamilyFlow,
    this.failure,
    this.conversionFailure,
    this.convertFromIndividualFailure,
  });

  final bool isLoading;
  final bool isConversionLoading;
  final bool isConversionSuccess;
  final bool isConvertFromIndividualLoading;
  final bool isConvertFromIndividualSuccess;
  final bool isSuccess;
  final List<SubscriptionTypeEntity> types;
  final ConversionOptionsModel? conversionOptions;
  final ConversionOptionModel? selectedConversionOption;
  final FamilyFlowCurrentEntity? convertedFamilyFlow;
  final Failure? failure;
  final Failure? conversionFailure;
  final Failure? convertFromIndividualFailure;

  SubscriptionTypesState copyWith({
    bool? isLoading,
    bool? isConversionLoading,
    bool? isConversionSuccess,
    bool? isConvertFromIndividualLoading,
    bool? isConvertFromIndividualSuccess,
    bool? isSuccess,
    List<SubscriptionTypeEntity>? types,
    ConversionOptionsModel? conversionOptions,
    ConversionOptionModel? selectedConversionOption,
    FamilyFlowCurrentEntity? convertedFamilyFlow,
    Failure? failure,
    Failure? conversionFailure,
    Failure? convertFromIndividualFailure,
    bool clearFailure = false,
    bool clearConversionFailure = false,
    bool clearConvertFromIndividualFailure = false,
    bool clearSelectedConversionOption = false,
  }) {
    return SubscriptionTypesState(
      isLoading: isLoading ?? this.isLoading,
      isConversionLoading: isConversionLoading ?? this.isConversionLoading,
      isConversionSuccess: isConversionSuccess ?? this.isConversionSuccess,
      isConvertFromIndividualLoading:
          isConvertFromIndividualLoading ?? this.isConvertFromIndividualLoading,
      isConvertFromIndividualSuccess:
          isConvertFromIndividualSuccess ?? this.isConvertFromIndividualSuccess,
      isSuccess: isSuccess ?? this.isSuccess,
      types: types ?? this.types,
      conversionOptions: conversionOptions ?? this.conversionOptions,
      selectedConversionOption: clearSelectedConversionOption
          ? null
          : selectedConversionOption ?? this.selectedConversionOption,
      convertedFamilyFlow: convertedFamilyFlow ?? this.convertedFamilyFlow,
      failure: clearFailure ? null : failure ?? this.failure,
      conversionFailure: clearConversionFailure
          ? null
          : conversionFailure ?? this.conversionFailure,
      convertFromIndividualFailure: clearConvertFromIndividualFailure
          ? null
          : convertFromIndividualFailure ?? this.convertFromIndividualFailure,
    );
  }
}
