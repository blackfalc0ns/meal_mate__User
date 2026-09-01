class DeviceTokenRegisterRequestEntity {
  const DeviceTokenRegisterRequestEntity({
    required this.token,
    required this.platform,
    required this.deviceId,
  });

  final String token;
  final int platform;
  final String deviceId;
}
