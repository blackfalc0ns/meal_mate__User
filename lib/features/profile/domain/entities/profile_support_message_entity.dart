enum ProfileSupportMessageKind { contact, complaint }

class ProfileSupportMessageEntity {
  const ProfileSupportMessageEntity({
    required this.kind,
    required this.subject,
    required this.message,
    this.replyEmail,
    this.category,
  });

  final ProfileSupportMessageKind kind;
  final String subject;
  final String message;
  final String? replyEmail;
  final String? category;
}
