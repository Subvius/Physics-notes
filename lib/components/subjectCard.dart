import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:physics_notes/constants/colors.dart';
import 'package:physics_notes/functions/declinationFormatter.dart';
import 'package:physics_notes/functions/gallery.dart';
import 'package:physics_notes/functions/goToScreen.dart';
import 'package:physics_notes/functions/navigateToSubject.dart';
import 'package:physics_notes/models/subject.dart';
import 'package:physics_notes/screens/editTest.dart';

_saveImagesFromTest(Subject test, BuildContext context) {
  final images = test.images;
  for (var url in images) {
    saveNetworkImage(url);
  }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: const Text(
      "Сохранено в галерею!",
    ),
    margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
    behavior: SnackBarBehavior.floating,
    backgroundColor: DarkTheme.title,
    shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
        // BorderRadius.only(
        //     topLeft: Radius.circular(15), topRight: Radius.circular(15))
    ),
  ));
}

Widget renderSubjectCard(
    String title, List images, String? url, BuildContext context, Subject test,
    {bool adminPanel = false}) {
  final int amountOfImages = images.length;
  return Padding(
    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
    child: ListTile(
      onTap: () {
        if (!adminPanel) {
          navigateToSubject(title, images, context);
          return;
        }
        goToScreen(EditTestPage(test: test), context);
      },
      tileColor: const Color(0xff3d6a97),
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      trailing: IconButton(
          onPressed: () => _saveImagesFromTest(test, context),
          icon: const Icon(
            Icons.save_alt_rounded,
            color: Colors.white,
          )),
      leading: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black54, width: 1),
            borderRadius: BorderRadius.circular(5)),
        child: renderSubjectIcon(title, url),
      ),
      title: Text(
        title,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        declination(
            amountOfImages,
            Declination(
                first: "Фотография",
                second: "Фотографии",
                fifth: "Фотографий")),
        style: const TextStyle(color: Colors.white70),
      ),
    ),
  );
}

Widget renderSubjectIcon(String title, String? url) {
  if (url != null && url != "") {
    return CachedNetworkImage(
      imageUrl: url,
      width: 35,
      height: 35,
      fit: BoxFit.cover,
    );
  } else {
    return SizedBox(
      width: 35,
      height: 35,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white70, fontWeight: FontWeight.w400, fontSize: 10),
        ),
      ),
    );
  }
}
