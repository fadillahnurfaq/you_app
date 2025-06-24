import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_app/service/auth/auth_service.dart';
import 'package:you_app/service/local/local_service.dart';
import 'package:you_app/utils/utils.dart';
import 'package:you_app/view/profile/profile_view.dart';

class LoginController extends GetxController {
  final AuthService authService;

  LoginController({required this.authService});

  RxString emailOrUsername = "".obs;
  RxString password = "".obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    DialogHelper.showLoading();
    final result = await authService.login(
      emailOrUsername: emailOrUsername.value.trim(),
      password: password.value.trim(),
    );
    await result.fold(
      (l) {
        DialogHelper.hideLoading();
        DialogHelper.showMessage(title: "Error", message: l.message);
      },
      (r) async {
        await LocalService.setToken(r);
        DialogHelper.hideLoading();
        DialogHelper.showSuccess().then((_) => Go.offAll(ProfileView()));
      },
    );
  }
}
