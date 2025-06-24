import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'widgets.dart';

class AppCachedImage extends StatelessWidget {
  final String? url;
  final File? file;

  final double height, width;
  final double? radius, elevation;
  final Widget emptyWidget;
  final Color? backgroundColor;
  final bool isCircleBorder;
  final bool withCard;
  const AppCachedImage({
    super.key,
    required this.height,
    required this.width,
    required this.emptyWidget,
    this.url,
    this.file,
    this.radius,
    this.elevation,
    this.backgroundColor,
    this.isCircleBorder = false,
    this.withCard = true,
  });

  @override
  Widget build(BuildContext context) {
    return file != null
        ? withCard == false
              ? GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => Go.to(PhotoPreview(file: file)),
                  child: SizedBox(
                    height: height,
                    width: width,
                    child: Image(image: FileImage(file!), fit: BoxFit.cover),
                  ),
                )
              : AppCard(
                  padding: EdgeInsets.zero,
                  height: height,
                  width: width,
                  radius: radius,
                  backgroundColor: backgroundColor,
                  elevation: elevation,
                  isCircleBorder: isCircleBorder,
                  onTap: () => Go.to(PhotoPreview(file: file)),
                  child: Image(image: FileImage(file!), fit: BoxFit.cover),
                )
        : url?.isNotEmpty == true
        ? CachedNetworkImage(
            imageUrl: url!,
            imageBuilder: (context, imageProvider) => withCard == false
                ? GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => Go.to(PhotoPreview(url: url)),
                    child: SizedBox(
                      height: height,
                      width: width,
                      child: Image(image: imageProvider, fit: BoxFit.cover),
                    ),
                  )
                : AppCard(
                    padding: EdgeInsets.zero,
                    height: height,
                    width: width,
                    radius: radius,
                    backgroundColor: backgroundColor,
                    elevation: elevation,
                    isCircleBorder: isCircleBorder,
                    onTap: () => Go.to(PhotoPreview(url: url)),
                    child: Image(image: imageProvider, fit: BoxFit.cover),
                  ),
            placeholder: (context, url) => withCard == false
                ? SizedBox(
                    height: height,
                    width: width,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.primary),
                      ],
                    ),
                  )
                : AppCard(
                    padding: EdgeInsets.zero,
                    height: height,
                    width: width,
                    radius: radius,
                    backgroundColor: backgroundColor,
                    elevation: elevation,
                    isCircleBorder: isCircleBorder,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.primary),
                      ],
                    ),
                  ),
            errorWidget: (context, url, error) {
              return withCard == false
                  ? SizedBox(
                      height: height,
                      width: width,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.error, size: 14.0)],
                      ),
                    )
                  : AppCard(
                      padding: EdgeInsets.zero,
                      height: height,
                      width: width,
                      radius: radius,
                      backgroundColor: backgroundColor,
                      elevation: elevation,
                      isCircleBorder: isCircleBorder,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.error, size: 14.0)],
                      ),
                    );
            },
          )
        : withCard == false
        ? SizedBox(height: height, width: width, child: emptyWidget)
        : AppCard(
            padding: EdgeInsets.zero,
            height: height,
            width: width,
            radius: radius,
            backgroundColor: backgroundColor,
            elevation: elevation,
            isCircleBorder: isCircleBorder,
            child: emptyWidget,
          );
  }
}
