import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_app/service/auth/auth_service.dart';
import 'package:you_app/utils/utils.dart';
import 'package:you_app/view/auth/login_view.dart';

class RegisterController extends GetxController {
  final AuthService authService;

  RegisterController({required this.authService});

  RxString email = "".obs;
  RxString username = "".obs;
  RxString password = "".obs;
  RxString confPassword = "".obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> submit() async {
    DialogHelper.showLoading();
    final result = await authService.register(
      email: email.value.trim(),
      username: username.value.trim(),
      password: password.value.trim(),
    );
    DialogHelper.hideLoading();
    result.fold(
      (l) => DialogHelper.showMessage(title: "Error", message: l.message),
      (r) => DialogHelper.showSuccess().then((_) => Go.off(LoginView())),
    );
  }
}
