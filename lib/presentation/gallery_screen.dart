import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryScreen extends StatefulWidget {
  final List<String> base64Images;
  final int index;

  const GalleryScreen({Key? key, required this.base64Images, this.index = 0})
      :
        super(key: key);

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late int index;
  late final PageController pageController;

  @override
  void initState() {
    index = widget.index;
    pageController = PageController(initialPage: index);

    super.initState();
  }


  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PhotoViewGallery.builder(
            pageController: pageController,
            itemCount: widget.base64Images.length,
            gaplessPlayback: true,
            wantKeepAlive: true,
            builder: (context, index) {
              final image = widget.base64Images[index];
              return PhotoViewGalleryPageOptions(
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 4.1,
                  heroAttributes: PhotoViewHeroAttributes(tag: index),
                  imageProvider: MemoryImage(base64Decode(image)
                  ));
            },
            onPageChanged: (index) => setState(() => this.index = index),
          ),
          Container(
            padding: const EdgeInsets.all(22),
            child: Text(
              '${index + 1}/${widget.base64Images.length}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
