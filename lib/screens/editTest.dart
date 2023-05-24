import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:physics_notes/constants/colors.dart';
import 'package:physics_notes/models/firebase_firestore.dart';
import 'package:physics_notes/models/firebase_storage.dart';
import 'package:physics_notes/models/subject.dart';
import 'package:physics_notes/screens/home.dart';

import '../functions/declinationFormatter.dart';
import '../functions/goToScreen.dart';

class EditTestPage extends StatefulWidget {
  const EditTestPage({Key? key, required this.test}) : super(key: key);

  final Subject test;

  @override
  State<EditTestPage> createState() => _EditTestPageState();
}

class _EditTestPageState extends State<EditTestPage> {
  late final Subject test = widget.test;
  final colors = DarkTheme;
  Storage storage = Storage();
  DBFirestore dbFirestore = DBFirestore();
  late List images = test.images;
  bool imagesChanged = false;

  late TextEditingController nameController =
      TextEditingController(text: test.title);
  late TextEditingController indexController =
      TextEditingController(text: test.index.toString());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Изменить Зачёт",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: colors.header,
        actions: [
          IconButton(
              onPressed: _editTest,
              icon: const Icon(
                Icons.done_rounded,
                color: Colors.white,
              ))
        ],
      ),
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: width * .9,
                height: 50,
                padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        autofocus: true,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blue.shade300, width: 2)),
                          hintText: "Название",
                          hintStyle: const TextStyle(color: Colors.white24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: width * .9,
                height: 50,
                padding: const EdgeInsets.only(top: 8.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: indexController,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blue.shade300, width: 2)),
                          hintText: "Индекс",
                          hintStyle: const TextStyle(color: Colors.white24),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 15),
                child: ElevatedButton(
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.custom,
                          allowedExtensions: ["png", "jpg", "jpeg", "webp"]);

                      if (result == null) {
                        return;
                      }
                      images = [];
                      imagesChanged = true;
                      result.files.forEach((element) {
                        images.add([element.path, element.name]);
                      });

                      setState(() {});
                    },
                    child: const Text(
                      "Выбрать фотографии",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            images.isNotEmpty
                ? Center(
                    child: Text(
                      declination(
                          images.length,
                          Declination(
                              first: "Фотография",
                              second: "Фотографии",
                              fifth: "Фотографий")),
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  _editTest() async {
    String name = nameController.text.trim();
    List downloadURLs = [];
    if (!imagesChanged) {
      downloadURLs = images;
    } else {
      for (var element in images) {
        await storage.uploadFile(
            "$name/${element.last}", element.first, element.last);

        String url = await storage.getDownloadURL("$name/${element.last}");
        downloadURLs.add(url);
      }
    }
    print(downloadURLs);
    await dbFirestore
        .setDocument(collectionPath: "notes", documentId: test.docID, data: {
      "images": downloadURLs,
      "name": nameController.text.trim(),
      "index": int.parse(indexController.text.trim()),
    });
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }
}
