import 'package:swipehr/src/domain/entities/employee.dart';

class EmployeeModel {
  final String id;
  final String email;
  final String photoPath;
  final DateTime subscriptionExpirationDateTime;

  EmployeeModel({
    required this.id,
    required this.email,
    required this.photoPath,
    required this.subscriptionExpirationDateTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'photo_path': photoPath,
      'subscription_expiration_datetime': subscriptionExpirationDateTime.toIso8601String(),
    };
  }

  factory EmployeeModel.fromMap(Map<String, dynamic> map) {
    return EmployeeModel(
      id: map['id'] as String,
      email: map['email'] as String,
      photoPath: map['photo_path'] as String,
      subscriptionExpirationDateTime:
          DateTime.parse(map['subscription_expiration_datetime'] as String),
    );
  }

  factory EmployeeModel.fromEntity(Employee entity) {
    return EmployeeModel(
      id: entity.id,
      email: entity.email,
      photoPath: entity.photoPath,
      subscriptionExpirationDateTime: entity.subscriptionExpirationDateTime,
    );
  }

  Employee toEntity() {
    return Employee(
      id: id,
      email: email,
      photoPath: photoPath,
      subscriptionExpirationDateTime: subscriptionExpirationDateTime,
    );
  }
}
