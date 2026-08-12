class UploadFileRequestEntity {
  const UploadFileRequestEntity({
    required this.filePath,
    this.scope = 'customers',
    this.folder = 'profile',
  });

  final String filePath;
  final String scope;
  final String folder;
}
