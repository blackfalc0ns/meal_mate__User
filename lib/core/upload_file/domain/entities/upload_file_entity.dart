class UploadFileEntity {
  const UploadFileEntity({
    required this.storageKey,
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
    required this.readUrl,
    required this.folder,
    required this.scope,
  });

  final String storageKey;
  final String fileName;
  final String contentType;
  final int sizeBytes;
  final String readUrl;
  final String folder;
  final String scope;
}
