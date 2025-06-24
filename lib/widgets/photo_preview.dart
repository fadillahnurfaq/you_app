import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import '../utils/utils.dart';
import 'widgets.dart';

class PhotoPreview extends StatelessWidget {
  final String? title;
  final File? file;
  final String? url;
  const PhotoPreview({super.key, this.title, this.file, this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: title ?? "Photo Preview",
          textStyle: AppTextStyle.h2.copyWith(color: AppColors.white),
        ),
      ),
      body: url != null
          ? CachedNetworkImage(
              imageUrl: url!,
              imageBuilder: (context, imageProvider) =>
                  PhotoView(imageProvider: imageProvider),
              placeholder: (_, url) => SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              errorWidget: (_, url, error) => SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(child: Icon(Icons.error)),
              ),
            )
          : file != null
          ? PhotoView(
              imageProvider: FileImage(file!),
              loadingBuilder: (context, event) => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          : const SizedBox(),
    );
  }
}
