import 'package:flutter/cupertino.dart';
import 'package:fluttermulticity/provider/gallery/gallery_provider.dart';

class GalleryListIntentHolder {
  const GalleryListIntentHolder({
    @required this.itemId,
    @required this.galleryProvider,
  });
  final String itemId;
  final GalleryProvider galleryProvider;
}
