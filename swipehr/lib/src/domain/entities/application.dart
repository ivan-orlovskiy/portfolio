class Application {
  final String id;
  final String employeeId;
  final String vacancyId;
  final Map<String, String> tags;
  final String pdfPath;

  Application({
    required this.id,
    required this.employeeId,
    required this.vacancyId,
    required this.tags,
    required this.pdfPath,
  });
}
