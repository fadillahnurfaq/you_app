import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';
import '../widgets/widgets.dart';
import 'utils.dart';

class DialogHelper {
  DialogHelper._();
  static showLoading({String? message}) {
    return showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: AppColors.white,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator(color: AppColors.primary)],
            ),
          ),
        );
      },
    );
  }

  static hideLoading() {
    return Navigator.pop(Get.context!);
  }

  static showMessage({
    required final String title,
    required final String message,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.primary,
      colorText: AppColors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.zero,
      borderRadius: 0,
    );
  }

  static Future<void> showSuccess() async {
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            elevation: 0.0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Assets.images.success.image(height: 100.0, width: 100.0),
          ),
        );
      },
    );
    await Future.delayed(const Duration(seconds: 2)).then((value) => Go.back());
  }

  static Future<void> showBottomSheet({
    required final List<Widget> children,
    final bool isDimissible = true,
    final Color backgroundColor = AppColors.primary,
    final Color hideColor = AppColors.grey,
    final bool showCloseButton = true,
    final void Function()? onclose,
    final EdgeInsetsGeometry? padding,
  }) async {
    final FocusScopeNode currentScope = FocusScope.of(Get.context!);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
    if (!kIsWeb) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
    return await showModalBottomSheet(
      context: Get.context!,
      isDismissible: isDimissible,
      isScrollControlled: true,
      enableDrag: isDimissible,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
      ),
      builder: (context) {
        return PopScope(
          canPop: isDimissible,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => context.hideKeyboard(),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isDimissible) ...[
                        const SpaceHeight(10.0),
                        Divider(
                          thickness: 4,
                          indent: Get.width * 0.35,
                          endIndent: Get.width * 0.35,
                          color: hideColor,
                        ),
                      ],
                      const SpaceHeight(20.0),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.6,
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          padding:
                              padding ??
                              const EdgeInsets.only(
                                right: 16.0,
                                left: 16.0,
                                bottom: 10.0,
                              ),
                          children: children,
                        ),
                      ),
                    ],
                  ),
                  if (showCloseButton)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Go.back();
                          onclose?.call();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 30.0,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showConfirmation({
    required final String message,
    final String? title,
    required final VoidCallback onOk,
  }) async {
    return showBottomSheet(
      children: [
        Center(
          child: AppText(
            text: title ?? "Confirmation",
            textStyle: AppTextStyle.h3.copyWith(
              fontWeight: AppTextStyle.extraBold,
            ),
          ),
        ),
        SpaceHeight(20.0),
        AppText(
          text: message,
          align: TextAlign.center,
          textStyle: AppTextStyle.regularStyle.copyWith(fontSize: 14.0),
        ),
        SpaceHeight(20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AppButton.filled(
                label: "Yes",
                onPressed: () {
                  Go.back();
                  onOk();
                },
              ),
            ),
            SpaceWidth(15.0),
            Expanded(
              child: AppButton.filled(label: "No", onPressed: () => Go.back()),
            ),
          ],
        ),
      ],
    );
  }
}
