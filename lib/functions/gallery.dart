import 'package:gallery_saver/gallery_saver.dart';

// ignore: unused_element
void saveNetworkImage(String url) async {
  GallerySaver.saveImage(url).then((bool? success) {});
}
