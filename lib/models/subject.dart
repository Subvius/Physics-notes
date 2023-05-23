class Subject {
  final String title;
  final List images;

  factory Subject.fromJson(Map data) {
    final title = data["name"];
    final List images = data["images"];
    final String docID = data["docID"];

    return Subject(title: title, images: images);
  }

  const Subject({required this.title, required this.images});
}
