import 'package:flutter/material.dart';

enum InfluencerSocialPlatform {
  tiktok,
  instagram,
  whatsapp,
  telegram,
  youtube,
  snapchat,
}

class InfluencerSocialItemViewData {
  const InfluencerSocialItemViewData({
    required this.platform,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    this.handle,
    this.onTap,
  });

  final InfluencerSocialPlatform platform;
  final String title;
  final String subtitle;
  final String iconAsset;
  final String? handle;
  final VoidCallback? onTap;

  bool get isConnected => handle != null && handle!.trim().isNotEmpty;
}
