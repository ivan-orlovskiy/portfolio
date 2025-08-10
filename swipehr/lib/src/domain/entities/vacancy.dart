class Vacancy {
  final String id;
  final String name;
  final String employerId;
  final String salary;
  final String description;
  final Map<String, String> requiredTags;
  final String photoPath;

  Vacancy({
    required this.id,
    required this.name,
    required this.employerId,
    required this.salary,
    required this.description,
    required this.requiredTags,
    required this.photoPath,
  });
}
