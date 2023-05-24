class Subject {
  final String title;
  final List images;
  final String docID;
  final int index;

  factory Subject.fromJson(Map data) {
    final title = data["name"];
    final List images = data["images"];
    final String docID = data["docID"];
    final int index = data["index"];

    return Subject(title: title, images: images, docID: docID, index: index);
  }

  const Subject(
      {required this.title,
      required this.images,
      required this.docID,
      required this.index});
}
