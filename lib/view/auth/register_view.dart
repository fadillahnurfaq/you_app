import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:you_app/controller/auth/register_controller.dart';
import 'package:you_app/service/auth/auth_service.dart';
import 'package:you_app/view/auth/login_view.dart';
import 'package:you_app/widgets/widgets.dart';

import '../../utils/utils.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final controller = Get.put(RegisterController(authService: AuthService()));
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.darkRadialGradient),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: context.hideKeyboard,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppAppbar(withBackButton: true),
                      SpaceHeight(40.0),
                      Padding(
                        padding: AppPadding.normal,
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: AppText(
                                  text: "Register",
                                  textStyle: AppTextStyle.h1.copyWith(
                                    fontSize: 24.0,
                                  ),
                                ),
                              ),
                              SpaceHeight(20.0),
                              AppForm(
                                hintText: "Enter Email",
                                onChanged: (value) {
                                  controller.email.value = value;
                                },
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) =>
                                    Validator.email(value, isRequired: true),
                              ),
                              SpaceHeight(15.0),
                              AppForm(
                                hintText: "Create Username",
                                onChanged: (value) {
                                  controller.username.value = value;
                                },
                                validator: (value) => Validator.cannotSpace(
                                  value,
                                  isRequired: true,
                                ),
                              ),
                              SpaceHeight(15.0),
                              AppForm(
                                hintText: "Create Password",
                                isPassword: true,
                                onChanged: (value) {
                                  controller.password.value = value;
                                },

                                validator: (value) =>
                                    Validator.password(value, isRequired: true),
                              ),
                              SpaceHeight(15.0),
                              AppForm(
                                hintText: "Confirm Password",
                                isPassword: true,
                                onChanged: (value) {
                                  controller.confPassword.value = value;
                                },
                                validator: (value) =>
                                    Validator.password(value, isRequired: true),
                                isLastForm: true,
                              ),
                              SpaceHeight(20.0),
                              Obx(
                                () => AppButton.filled(
                                  onPressed: () {
                                    context.hideKeyboard();
                                    final isValid =
                                        controller.formKey.currentState
                                            ?.validate() ??
                                        false;
                                    if (!isValid) {
                                      return DialogHelper.showMessage(
                                        title: "Information",
                                        message:
                                            "Please double check your form!",
                                      );
                                    }
                                    if (controller.password.value.trim() ==
                                        controller.confPassword.value.trim()) {
                                      return DialogHelper.showConfirmation(
                                        message:
                                            "Are you sure register with this information?",
                                        onOk: () async =>
                                            await controller.submit(),
                                      );
                                    } else {
                                      return DialogHelper.showMessage(
                                        title: "Information",
                                        message: "Password doesn't match",
                                      );
                                    }
                                  },
                                  disabled:
                                      controller.email.value.isEmpty ||
                                      controller.username.value.isEmpty ||
                                      controller.password.value.isEmpty ||
                                      controller.confPassword.value.isEmpty,
                                  label: "Register",
                                ),
                              ),
                              SpaceHeight(40.0),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: "Have an account? ",
                                    children: [
                                      WidgetSpan(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () => Go.off(LoginView()),
                                          child: GradientText(
                                            "Login here",
                                            colors: AppColors.listGold,
                                          ),
                                        ),
                                        style: AppTextStyle.regularStyle
                                            .copyWith(
                                              decoration:
                                                  TextDecoration.underline,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
