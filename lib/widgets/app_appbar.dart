import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'widgets.dart';

class AppAppbar extends StatelessWidget {
  final bool withBackButton;
  final Widget? title, action;
  const AppAppbar({
    super.key,
    this.withBackButton = false,
    this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          if (withBackButton)
            GestureDetector(
              onTap: () => Go.back(),
              behavior: HitTestBehavior.translucent,
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    size: 20.0,
                    color: AppColors.white,
                  ),
                  SpaceWidth(5.0),
                  AppText(
                    text: 'Back',
                    textStyle: AppTextStyle.regularStyle.copyWith(
                      fontWeight: AppTextStyle.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          if (title != null) ...[
            SizedBox(width: withBackButton ? 0 : 60),
            const Spacer(),
            title!,
            const Spacer(),
            SizedBox(width: action != null ? 40 : 60),
          ],
          if (action != null) ...[if (title == null) const Spacer(), action!],
        ],
      ),
    );
  }
}
