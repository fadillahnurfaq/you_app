import 'package:flutter/material.dart';

import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class ProfileInfo extends StatelessWidget {
  final String title, subtitle;
  const ProfileInfo({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          text: "$title:",
          textStyle: AppTextStyle.regularStyle.copyWith(
            color: AppColors.white.withValues(alpha: 0.3),
          ),
        ),
        SpaceWidth(5.0),
        Expanded(child: AppText(text: subtitle)),
      ],
    );
  }
}
