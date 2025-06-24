import 'package:flutter/material.dart';
import '../utils/utils.dart';

class AppRefresher extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  const AppRefresher({super.key, required this.onRefresh, required this.child});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: child,
    );
  }
}
