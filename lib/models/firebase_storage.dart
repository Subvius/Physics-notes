import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(
      String storagePath, String filePath, String filename) async {
    File file = File(filePath);

    try {
      firebase_storage.Reference ref = storage.ref(storagePath);
      await ref.putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<firebase_storage.ListResult> listFiles(String storagePath) async {
    firebase_storage.ListResult result =
        await storage.ref(storagePath).listAll();

    return result;
  }

  Future<String> getDownloadURL(String storagePath) async {
    String downloadURL = await storage.ref(storagePath).getDownloadURL();

    return downloadURL;
  }
}
