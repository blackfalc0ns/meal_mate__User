class FamilyCheckoutSelectionRequestDto {
  const FamilyCheckoutSelectionRequestDto({required this.subscribeNow});

  final bool subscribeNow;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'subscribeNow': subscribeNow,
      };
}
