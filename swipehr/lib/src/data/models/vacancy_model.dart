import 'package:swipehr/src/domain/entities/vacancy.dart';

class VacancyModel {
  final String id;
  final String name;
  final String employerId;
  final String salary;
  final String description;
  final Map<String, String> requiredTags;
  final String photoPath;

  VacancyModel({
    required this.id,
    required this.name,
    required this.employerId,
    required this.salary,
    required this.description,
    required this.requiredTags,
    required this.photoPath,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'employer_id': employerId,
      'salary': salary,
      'description': description,
      'required_tags': requiredTags,
      'photo_path': photoPath,
    };
  }

  factory VacancyModel.fromMap(Map<String, dynamic> map) {
    return VacancyModel(
      id: map['id'] as String,
      name: map['name'] as String,
      employerId: map['employer_id'] as String,
      salary: map['salary'] as String,
      description: map['description'] as String,
      requiredTags: (map['required_tags'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value as String)),
      photoPath: map['photo_path'] as String,
    );
  }

  factory VacancyModel.fromEntity(Vacancy entity) {
    return VacancyModel(
      id: entity.id,
      name: entity.name,
      employerId: entity.employerId,
      salary: entity.salary,
      description: entity.description,
      requiredTags: entity.requiredTags,
      photoPath: entity.photoPath,
    );
  }

  Vacancy toEntity() {
    return Vacancy(
      id: id,
      name: name,
      employerId: employerId,
      salary: salary,
      description: description,
      requiredTags: requiredTags,
      photoPath: photoPath,
    );
  }
}
