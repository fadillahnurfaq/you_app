import 'package:flutter/material.dart';
import 'package:you_app/view/auth/login_view.dart';
import 'package:you_app/view/profile/profile_view.dart';
import 'package:you_app/widgets/widgets.dart';
import '../service/local/local_service.dart';
import '../utils/utils.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await LocalService.getToken();
      if (token.isNotEmpty) {
        Go.offAll(const ProfileView());
      } else {
        Go.offAll(const LoginView());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: AppText(text: "YouApp", textStyle: AppTextStyle.h1),
          ),
          const Spacer(),
          const CircularProgressIndicator(color: AppColors.primary),
          const SpaceHeight(20.0),
        ],
      ),
    );
  }
}
