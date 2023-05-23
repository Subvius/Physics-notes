import 'package:flutter/cupertino.dart';
import 'package:physics_notes/functions/goToScreen.dart';
import 'package:physics_notes/screens/subjectPage.dart';

void navigateToSubject(String title, List images, BuildContext context) {
  goToScreen(
      SubjectPage(
        title: title,
        images: images,
      ),
      context);
}
