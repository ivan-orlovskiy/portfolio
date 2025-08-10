import 'package:swipehr/src/domain/entities/application.dart';

class ApplicationModel {
  final String id;
  final String employeeId;
  final String vacancyId;
  final Map<String, String> tags;
  final String pdfPath;

  ApplicationModel({
    required this.id,
    required this.employeeId,
    required this.vacancyId,
    required this.tags,
    required this.pdfPath,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'employee_id': employeeId,
      'vacancy_id': vacancyId,
      'tags': tags,
      'pdf_path': pdfPath,
    };
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      id: map['id'] as String,
      employeeId: map['employee_id'] as String,
      vacancyId: map['vacancy_id'] as String,
      tags:
          (map['tags'] as Map<String, dynamic>).map((key, value) => MapEntry(key, value as String)),
      pdfPath: map['pdf_path'] as String,
    );
  }

  factory ApplicationModel.fromEntity(Application entity) {
    return ApplicationModel(
      id: entity.id,
      employeeId: entity.employeeId,
      vacancyId: entity.vacancyId,
      tags: entity.tags,
      pdfPath: entity.pdfPath,
    );
  }

  Application toEntity() {
    return Application(
      id: id,
      employeeId: employeeId,
      vacancyId: vacancyId,
      tags: tags,
      pdfPath: pdfPath,
    );
  }
}
