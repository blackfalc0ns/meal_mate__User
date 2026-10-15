class FamilyMemberPlanWriteRequestDto {
  const FamilyMemberPlanWriteRequestDto({
    this.programId,
    this.bundleId,
    this.tier,
    this.durationDays,
    this.includeFriday,
    this.startDate,
    this.clearProgramId = false,
    this.clearBundleId = false,
    this.clearTier = false,
    this.clearDurationDays = false,
    this.clearStartDate = false,
  }) : _clearAll = false;

  const FamilyMemberPlanWriteRequestDto.clear()
    : programId = null,
      bundleId = null,
      tier = null,
      durationDays = null,
      includeFriday = null,
      startDate = null,
      clearProgramId = true,
      clearBundleId = true,
      clearTier = true,
      clearDurationDays = true,
      clearStartDate = false,
      _clearAll = true;

  final String? programId;
  final String? bundleId;
  final int? tier;
  final int? durationDays;
  final bool? includeFriday;
  final String? startDate;
  final bool clearProgramId;
  final bool clearBundleId;
  final bool clearTier;
  final bool clearDurationDays;
  final bool clearStartDate;
  final bool _clearAll;

  Map<String, dynamic> toJson() {
    if (_clearAll) {
      return <String, dynamic>{
        'programId': null,
        'bundleId': null,
        'tier': null,
        'durationDays': null,
      };
    }

    final map = <String, dynamic>{};
    if (clearProgramId) {
      map['programId'] = null;
    } else if (programId != null) {
      map['programId'] = programId;
    }

    if (clearBundleId) {
      map['bundleId'] = null;
    } else if (bundleId != null) {
      map['bundleId'] = bundleId;
    }

    if (clearTier) {
      map['tier'] = null;
    } else if (tier != null) {
      map['tier'] = tier;
    }

    if (clearDurationDays) {
      map['durationDays'] = null;
    } else if (durationDays != null && durationDays! > 0) {
      map['durationDays'] = durationDays;
    }

    if (includeFriday != null) {
      map['includeFriday'] = includeFriday;
    }

    if (clearStartDate) {
      map['startDate'] = null;
    } else if (startDate != null && startDate!.isNotEmpty) {
      map['startDate'] = startDate;
    }

    return map;
  }
}
