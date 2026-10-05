enum SubscriptionTierDesign { current, classic, aurora }

SubscriptionTierDesign resolveSubscriptionTierDesign(
  int? designId, {
  required bool supportsClassic,
  required bool supportsAurora,
}) => switch (designId) {
  1 when supportsClassic => SubscriptionTierDesign.classic,
  2 when supportsAurora => SubscriptionTierDesign.aurora,
  _ => SubscriptionTierDesign.current,
};
