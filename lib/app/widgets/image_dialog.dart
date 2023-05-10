import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;
import 'package:image_zoom_on_move/image_zoom_on_move.dart';

/// Display an image in dialog with zoom effect
// ignore: must_be_immutable
class ImageDialog extends StatelessWidget {
  ImageDialog({super.key, required this.urlImage});

  String urlImage;

  @override
  Widget build(BuildContext context) {
    return material.Dialog(
        child: ImageZoomOnMove(
      width: 350,
      height: 350,
      image: Image.file(
        File(urlImage),
        width: 350,
        height: 350,
        filterQuality: FilterQuality.high,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Center(
            child: Card(
          borderRadius: BorderRadius.circular(250),
          child: const Center(
            child: Icon(
              FluentIcons.error,
              size: 40,
            ),
          ),
        )),
      ),
    ));
  }
}
