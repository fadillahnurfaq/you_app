import 'package:flutter/material.dart';
import 'package:get/get.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class Go {
  static void back<T>({
    T? result,
    bool closeOverlays = false,
    bool canPop = true,
    int? id,
  }) async {
    return Get.back(
      result: result,
      closeOverlays: closeOverlays,
      canPop: canPop,
      id: id,
    );
  }

  static Future<T?> to<T>(dynamic page, {final String? routeName}) async {
    return await Get.to<T>(
      page,
      duration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeftWithFade,
      opaque: false,
      routeName: routeName,
    );
  }

  static Future<dynamic> off(dynamic page) async {
    Get.off(
      page,
      duration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeftWithFade,
      opaque: false,
    );
  }

  static Future<dynamic> offAll(dynamic page) async {
    Get.offAll(
      page,
      duration: const Duration(milliseconds: 300),
      transition: Transition.rightToLeftWithFade,
      opaque: false,
    );
  }
}
