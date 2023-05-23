import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../constants/colors.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({Key? key, required this.title, required this.images})
      : super(key: key);

  final String title;
  final List images;

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  late final title = widget.title;
  late final images = widget.images;
  final colors = DarkTheme;
  bool rotated = false;
  PhotoViewController controller = PhotoViewController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          backgroundColor: colors.header,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    rotated = !rotated;
                  });
                  controller.rotation = rotated ? 3.14 / 2 : 0;
                },
                icon: const Icon(Icons.rotate_right))
          ],
        ),
        backgroundColor: colors.background,
        body: PhotoViewGallery.builder(
          itemCount: images.length,
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              controller: controller,
              filterQuality: FilterQuality.high,
              imageProvider: CachedNetworkImageProvider(images[index], scale: 1.2),
              initialScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 2,
              heroAttributes: PhotoViewHeroAttributes(tag: index),
            );
          },
          scrollPhysics: const BouncingScrollPhysics(),
          loadingBuilder: (context, event) => const Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(),
            ),
          ),
          backgroundDecoration: BoxDecoration(
            color: colors.background,
          ),
        ));
  }
}
