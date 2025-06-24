import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:you_app/controller/auth/login_controller.dart';
import 'package:you_app/service/auth/auth_service.dart';
import 'package:you_app/utils/utils.dart';
import 'package:you_app/view/auth/register_view.dart';
import 'package:you_app/widgets/widgets.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final controller = Get.put(LoginController(authService: AuthService()));
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.darkRadialGradient),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: context.hideKeyboard,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: DoubleBackToCloseApp(
            snackBar: SnackBar(
              content: AppText(
                text: "Press back again to exit the app.",
                textStyle: AppTextStyle.h4.copyWith(color: AppColors.white),
              ),
              closeIconColor: Colors.white,
              backgroundColor: AppColors.primary,
              showCloseIcon: true,
            ),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: AppPadding.normal,
                  sliver: SliverFillRemaining(
                    hasScrollBody: false,
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: AppText(
                              text: "Login",
                              textStyle: AppTextStyle.h1.copyWith(
                                fontSize: 24.0,
                              ),
                            ),
                          ),
                          SpaceHeight(20.0),
                          AppForm(
                            hintText: "Enter Username/Email",
                            onChanged: (value) {
                              controller.emailOrUsername.value = value;
                            },
                            validator: Validator.required,
                          ),
                          SpaceHeight(15.0),
                          AppForm(
                            hintText: "Enter Password",
                            isPassword: true,
                            onChanged: (value) {
                              controller.password.value = value;
                            },
                            validator: (value) =>
                                Validator.password(value, isRequired: true),
                            isLastForm: true,
                          ),
                          SpaceHeight(20.0),
                          Obx(
                            () => AppButton.filled(
                              onPressed: () async {
                                context.hideKeyboard();
                                final isValid =
                                    controller.formKey.currentState
                                        ?.validate() ??
                                    false;
                                if (!isValid) {
                                  return DialogHelper.showMessage(
                                    title: "Information",
                                    message: "Please double check your form!",
                                  );
                                }
                                await controller.submit();
                              },
                              disabled:
                                  controller.emailOrUsername.value.isEmpty ||
                                  controller.password.value.isEmpty,
                              label: "Login",
                            ),
                          ),
                          SpaceHeight(40.0),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: "No account? ",
                                children: [
                                  WidgetSpan(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () => Go.to(RegisterView()),
                                      child: GradientText(
                                        "Register here",
                                        colors: AppColors.listGold,
                                      ),
                                    ),
                                    style: AppTextStyle.regularStyle.copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
