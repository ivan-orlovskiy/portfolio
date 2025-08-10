import 'package:swipehr/src/domain/entities/employer.dart';

class EmployerModel {
  final String id;
  final String email;
  final String companyName;
  final String photoPath;
  final DateTime subscriptionExpirationDateTime;

  EmployerModel({
    required this.id,
    required this.email,
    required this.companyName,
    required this.photoPath,
    required this.subscriptionExpirationDateTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'company_name': companyName,
      'photo_path': photoPath,
      'subscription_expiration_datetime': subscriptionExpirationDateTime.toIso8601String(),
    };
  }

  factory EmployerModel.fromMap(Map<String, dynamic> map) {
    return EmployerModel(
      id: map['id'] as String,
      email: map['email'] as String,
      companyName: map['company_name'] as String,
      photoPath: map['photo_path'] as String,
      subscriptionExpirationDateTime:
          DateTime.parse(map['subscription_expiration_datetime'] as String),
    );
  }

  factory EmployerModel.fromEntity(Employer entity) {
    return EmployerModel(
      id: entity.id,
      email: entity.email,
      companyName: entity.companyName,
      photoPath: entity.photoPath,
      subscriptionExpirationDateTime: entity.subscriptionExpirationDateTime,
    );
  }

  Employer toEntity() {
    return Employer(
      id: id,
      email: email,
      companyName: companyName,
      photoPath: photoPath,
      subscriptionExpirationDateTime: subscriptionExpirationDateTime,
    );
  }
}
