import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../utils/utils.dart';
import '../../../widgets/widgets.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppPadding.normal,
      sliver: SliverToBoxAdapter(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer(
                color: AppColors.black,
                child: AppCard(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 60.0),
                  child: SizedBox(),
                ),
              ),
              SpaceHeight(30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer(
                    color: AppColors.black,
                    child: AppCard(width: Get.width / 4, child: SizedBox()),
                  ),
                  Shimmer(
                    color: AppColors.black,
                    child: AppCard(width: Get.width / 3, child: SizedBox()),
                  ),
                ],
              ),
              SpaceHeight(30.0),
              Row(
                children: [
                  Shimmer(
                    color: AppColors.black,
                    child: AppCard(
                      width: 60.0,
                      height: 60.0,
                      padding: EdgeInsets.zero,
                      child: SizedBox(),
                    ),
                  ),
                  SpaceWidth(10.0),
                  Shimmer(
                    color: AppColors.black,
                    child: AppCard(width: Get.width / 3, child: SizedBox()),
                  ),
                ],
              ),
              SpaceHeight(30.0),
              Column(
                spacing: 10.0,
                children: List.generate(
                  7,
                  (index) => Row(
                    children: [
                      Shimmer(
                        color: AppColors.black,
                        child: AppCard(
                          width: Get.width / 4,
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: SizedBox(),
                        ),
                      ),
                      SpaceWidth(20.0),
                      Expanded(
                        child: Shimmer(
                          color: AppColors.black,
                          child: const AppCard(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: SizedBox(),
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
