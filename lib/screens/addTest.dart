import 'package:flutter/material.dart';
import 'package:physics_notes/functions/declinationFormatter.dart';
import 'package:physics_notes/functions/goToScreen.dart';
import 'package:physics_notes/models/firebase_firestore.dart';
import 'package:physics_notes/models/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:physics_notes/screens/home.dart';

import '../constants/colors.dart';

class AddTestPage extends StatefulWidget {
  const AddTestPage({Key? key}) : super(key: key);

  @override
  State<AddTestPage> createState() => _AddTestPageState();
}

class _AddTestPageState extends State<AddTestPage> {
  final colors = DarkTheme;
  Storage storage = Storage();
  DBFirestore dbFirestore = DBFirestore();
  List<List> images = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController indexController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Добавить Зачёт",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: colors.header,
        actions: [
          IconButton(
              onPressed: _createTest,
              icon: const Icon(
                Icons.done_rounded,
                color: Colors.white,
              ))
        ],
      ),
      backgroundColor: colors.background,
      body: Column(
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
    );
  }

  _createTest() async {
    String name = nameController.text.trim();
    String docID =
        await dbFirestore.addDocument(collectionPath: "notes", data: {
      "name": name,
      "index": int.parse(indexController.text.trim()),
    });

    List downloadURLs = [];
    for (var element in images) {
      await storage.uploadFile(
          "$name/${element.last}", element.first, element.last);

      String url = await storage.getDownloadURL("$name/${element.last}");
      downloadURLs.add(url);
    }
    await dbFirestore.setDocument(
        collectionPath: "notes",
        documentId: docID,
        data: {"images": downloadURLs, "docID": docID});
    // ignore: use_build_context_synchronously
    goToScreenAsReplacement(const HomePage(adminMode: true), context);
  }
}
