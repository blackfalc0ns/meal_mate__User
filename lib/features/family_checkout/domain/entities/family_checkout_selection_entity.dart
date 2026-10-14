class FamilyCheckoutSelectionEntity {
  final String batchId;
  final int batchVersion;
  final String memberId;
  final bool checkoutSelected;
  final int selectedNewSubscriberCount;

  const FamilyCheckoutSelectionEntity({
    required this.batchId,
    required this.batchVersion,
    required this.memberId,
    required this.checkoutSelected,
    required this.selectedNewSubscriberCount,
  });
}
