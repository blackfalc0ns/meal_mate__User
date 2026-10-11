class SubscriptionTierThemeEntity {
  const SubscriptionTierThemeEntity({this.designId, this.designName});

  final int? designId;
  final String? designName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionTierThemeEntity &&
          runtimeType == other.runtimeType &&
          designId == other.designId &&
          designName == other.designName;

  @override
  int get hashCode => Object.hash(designId, designName);
}
