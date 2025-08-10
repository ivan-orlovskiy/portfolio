class Employer {
  final String id;
  final String email;
  final String companyName;
  final String photoPath;
  final DateTime subscriptionExpirationDateTime;

  Employer({
    required this.id,
    required this.email,
    required this.companyName,
    required this.photoPath,
    required this.subscriptionExpirationDateTime,
  });
}
