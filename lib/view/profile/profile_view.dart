import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:you_app/controller/profile/profile_controller.dart';
import 'package:you_app/gen/assets.gen.dart';
import 'package:you_app/model/model_parser.dart';
import 'package:you_app/model/select_data_model.dart';
import 'package:you_app/service/auth/auth_service.dart';
import 'package:you_app/service/profile/profile_service.dart';
import 'package:you_app/view/profile/interest_form_view.dart';
import 'package:you_app/view/profile/widgets/profile_info.dart';
import 'package:you_app/view/profile/widgets/profile_skeleton.dart';
import 'package:you_app/widgets/app_dropdown.dart';
import 'package:you_app/widgets/widgets.dart';
import '../../model/user/user_model.dart';
import '../../utils/utils.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final controller = Get.put(
    ProfileController(
      authService: AuthService(),
      profileService: ProfileService(),
    ),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: context.hideKeyboard,
      child: Scaffold(
        body: Obx(
          () => WidgetAnimatorSliver<UserModel?>(
            onRefresh: controller.get,
            requestState: controller.stateUser.value,
            loadingSliver: ProfileSkeleton(),
            successSliver: (result) {
              return [
                SliverToBoxAdapter(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppAppbar(
                          title: AppText(
                            text: "@${result?.username ?? ""}",
                            textStyle: AppTextStyle.regularStyle.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        SpaceHeight(20.0),
                        Padding(
                          padding: AppPadding.normal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  AppCard(
                                    height: 190,
                                    width: double.infinity,
                                    child: SizedBox(),
                                  ),
                                  Positioned(
                                    left: 16.0,
                                    bottom: 16.0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text:
                                              "@${result?.username ?? ""}, ${AppGlobalFunc.getAge(result?.birthDay)}",
                                          textStyle: AppTextStyle.h3,
                                        ),
                                        SpaceHeight(10.0),
                                        AppText(
                                          text: "Male",
                                          textStyle: AppTextStyle.regularStyle
                                              .copyWith(fontSize: 14.0),
                                        ),

                                        if (AppGlobalFunc.getHoroscope(
                                          result?.birthDay,
                                        ).isNotEmpty) ...[
                                          SpaceHeight(10.0),
                                          Row(
                                            spacing: 15.0,
                                            children: [
                                              Row(
                                                children: [
                                                  AppCard(
                                                    backgroundColor: AppColors
                                                        .white
                                                        .withValues(
                                                          alpha: 0.06,
                                                        ),
                                                    radius: 16.0,
                                                    child: Row(
                                                      children: [
                                                        Assets.icons.icHoroscope
                                                            .svg(),
                                                        SpaceWidth(10.0),
                                                        AppText(
                                                          text:
                                                              AppGlobalFunc.getHoroscope(
                                                                result
                                                                    ?.birthDay,
                                                              ),
                                                          textStyle:
                                                              AppTextStyle
                                                                  .regularStyle
                                                                  .copyWith(
                                                                    fontSize:
                                                                        14.0,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (AppGlobalFunc.getZodiac(
                                                result?.birthDay,
                                              ).isNotEmpty)
                                                Row(
                                                  children: [
                                                    AppCard(
                                                      backgroundColor: AppColors
                                                          .white
                                                          .withValues(
                                                            alpha: 0.06,
                                                          ),
                                                      radius: 16.0,
                                                      child: Row(
                                                        children: [
                                                          Assets.icons.icZodiac
                                                              .svg(),
                                                          SpaceWidth(10.0),
                                                          AppText(
                                                            text:
                                                                AppGlobalFunc.getZodiac(
                                                                  result
                                                                      ?.birthDay,
                                                                ),
                                                            textStyle:
                                                                AppTextStyle
                                                                    .regularStyle
                                                                    .copyWith(
                                                                      fontSize:
                                                                          14.0,
                                                                    ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SpaceHeight(15.0),
                              AppCard(
                                padding: EdgeInsets.all(16.0),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppText(
                                            text: "About",
                                            textStyle: AppTextStyle.h4,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            context.hideKeyboard();
                                            if (controller
                                                .isEditAbout
                                                .isFalse) {
                                              controller.setIsEditAbout();
                                            } else {
                                              return DialogHelper.showConfirmation(
                                                message:
                                                    "Are you sure save this about?",
                                                onOk: () async =>
                                                    await controller
                                                        .saveOrEditAbout(),
                                              );
                                            }
                                          },
                                          icon: Obx(
                                            () => controller.isEditAbout.isFalse
                                                ? Assets.icons.icEdit.svg()
                                                : GradientText(
                                                    "Save & Update",
                                                    style: AppTextStyle
                                                        .regularStyle,
                                                    colors: AppColors.listGold,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SpaceHeight(20.0),
                                    Obx(() {
                                      final UserModel? user = result;
                                      final isNameEmpty =
                                          user?.name.isEmpty ?? true;
                                      final isEditing =
                                          controller.isEditAbout.isTrue;
                                      if (isEditing) {
                                        return Column(
                                          children: [
                                            ExpandedView2Row(
                                              flex1: 40,
                                              flex2: 60,
                                              child1: AppText(
                                                text: "Display Name:",
                                                textStyle: AppTextStyle
                                                    .regularStyle
                                                    .copyWith(
                                                      color: AppColors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                    ),
                                              ),
                                              child2: AppForm(
                                                hintText: "Enter name",
                                                textAlign: TextAlign.end,
                                                controller:
                                                    controller.nameController,
                                              ),
                                            ),
                                            SpaceHeight(20.0),
                                            ExpandedView2Row(
                                              flex1: 40,
                                              flex2: 60,
                                              child1: AppText(
                                                text: "Gender:",
                                                textStyle: AppTextStyle
                                                    .regularStyle
                                                    .copyWith(
                                                      color: AppColors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                    ),
                                              ),
                                              child2: Obx(
                                                () => AppDropdown(
                                                  hintText: "Select Gender",
                                                  textAlign: TextAlign.end,
                                                  selectedData: controller
                                                      .selectedGender
                                                      .value,
                                                  onTap: () =>
                                                      CustomSelect.single(
                                                        context: context,
                                                        selectedData: controller
                                                            .selectedGender
                                                            .value,
                                                        datas: SelectDataModel
                                                            .listGender,
                                                        titleSearch:
                                                            "Select Gender",
                                                        onChanged: controller
                                                            .setSelectedGender,
                                                        onReset: () => controller
                                                            .setSelectedGender(
                                                              null,
                                                            ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                            SpaceHeight(20.0),
                                            ExpandedView2Row(
                                              flex1: 40,
                                              flex2: 60,
                                              child1: AppText(
                                                text: "Birthday:",
                                                textStyle: AppTextStyle
                                                    .regularStyle
                                                    .copyWith(
                                                      color: AppColors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                    ),
                                              ),
                                              child2: Obx(
                                                () => AppForm(
                                                  hintText: "DD MM YYYY",
                                                  textAlign: TextAlign.end,
                                                  readOnly: true,
                                                  isSelectForm: true,
                                                  controller: TextEditingController(
                                                    text:
                                                        ModelParser.formatDate(
                                                          date: controller
                                                              .selectedBirthDay
                                                              .value,
                                                          pattern: "dd MM yyyy",
                                                        ),
                                                  ),
                                                  onTap: () async {
                                                    final selected =
                                                        await AppGlobalFunc.calendarPicker(
                                                          controller
                                                                  .selectedBirthDay
                                                                  .value ??
                                                              DateTime.now(),
                                                          lastDate: DateTime(
                                                            2100,
                                                          ),
                                                        );
                                                    if (selected != null) {
                                                      controller
                                                          .setSelectedBirthDay(
                                                            selected,
                                                          );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            SpaceHeight(20.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              spacing: 20.0,
                                              children: [
                                                ExpandedView2Row(
                                                  flex1: 40,
                                                  flex2: 60,
                                                  child1: AppText(
                                                    text: "Horoscope:",
                                                    textStyle: AppTextStyle
                                                        .regularStyle
                                                        .copyWith(
                                                          color: AppColors.white
                                                              .withValues(
                                                                alpha: 0.3,
                                                              ),
                                                        ),
                                                  ),
                                                  child2: AppForm(
                                                    controller: TextEditingController(
                                                      text:
                                                          AppGlobalFunc.getHoroscope(
                                                            controller
                                                                .selectedBirthDay
                                                                .value,
                                                            nullText: "--",
                                                          ),
                                                    ),
                                                    readOnly: true,
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                                ExpandedView2Row(
                                                  flex1: 40,
                                                  flex2: 60,
                                                  child1: AppText(
                                                    text: "Zodiac:",
                                                    textStyle: AppTextStyle
                                                        .regularStyle
                                                        .copyWith(
                                                          color: AppColors.white
                                                              .withValues(
                                                                alpha: 0.3,
                                                              ),
                                                        ),
                                                  ),
                                                  child2: AppForm(
                                                    controller: TextEditingController(
                                                      text:
                                                          AppGlobalFunc.getZodiac(
                                                            controller
                                                                .selectedBirthDay
                                                                .value,
                                                            nullText: "--",
                                                          ),
                                                    ),
                                                    readOnly: true,
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SpaceHeight(20.0),
                                            ExpandedView2Row(
                                              flex1: 40,
                                              flex2: 60,
                                              child1: AppText(
                                                text: "Height:",
                                                textStyle: AppTextStyle
                                                    .regularStyle
                                                    .copyWith(
                                                      color: AppColors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                    ),
                                              ),
                                              child2: AppForm(
                                                hintText: "Add height",
                                                textAlign: TextAlign.end,
                                                controller:
                                                    controller.heightController,
                                                isNumberOnly: true,
                                              ),
                                            ),
                                            SpaceHeight(20.0),
                                            ExpandedView2Row(
                                              flex1: 40,
                                              flex2: 60,
                                              child1: AppText(
                                                text: "Weight:",
                                                textStyle: AppTextStyle
                                                    .regularStyle
                                                    .copyWith(
                                                      color: AppColors.white
                                                          .withValues(
                                                            alpha: 0.3,
                                                          ),
                                                    ),
                                              ),
                                              child2: AppForm(
                                                hintText: "Add weight",
                                                textAlign: TextAlign.end,
                                                controller:
                                                    controller.weightController,
                                                isNumberOnly: true,
                                                isLastForm: true,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      if (isNameEmpty) {
                                        return AppText(
                                          text:
                                              "Add in your name to help others know you better",
                                          textStyle: AppTextStyle.regularStyle
                                              .copyWith(
                                                fontSize: 14.0,
                                                color: AppColors.white
                                                    .withValues(alpha: 0.14),
                                              ),
                                        );
                                      }
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        spacing: 15.0,
                                        children: [
                                          ProfileInfo(
                                            title: "Display Name",
                                            subtitle: result?.name ?? "",
                                          ),
                                          ProfileInfo(
                                            title: "Birthday",
                                            subtitle:
                                                "${ModelParser.formatDate(date: result?.birthDay, pattern: "dd / MM / yyyy")} (Age ${AppGlobalFunc.getAge(result?.birthDay)})",
                                          ),
                                          ProfileInfo(
                                            title: "Horoscope",
                                            subtitle:
                                                AppGlobalFunc.getHoroscope(
                                                  result?.birthDay,
                                                  nullText: "--",
                                                ),
                                          ),
                                          ProfileInfo(
                                            title: "Zodiac",
                                            subtitle: AppGlobalFunc.getZodiac(
                                              result?.birthDay,
                                              nullText: "--",
                                            ),
                                          ),
                                          ProfileInfo(
                                            title: "Height",
                                            subtitle:
                                                "${result?.height ?? 0} cm",
                                          ),
                                          ProfileInfo(
                                            title: "Weight",
                                            subtitle:
                                                "${result?.weight ?? 0} kg",
                                          ),
                                        ],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              SpaceHeight(15.0),
                              AppCard(
                                padding: EdgeInsets.all(16.0),
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: AppText(
                                            text: "Interest",
                                            textStyle: AppTextStyle.h4,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            context.hideKeyboard();
                                            Go.to(
                                              InterestFormView(
                                                user: controller
                                                    .stateUser
                                                    .value
                                                    .result,
                                              ),
                                            );
                                          },
                                          icon: Assets.icons.icEdit.svg(),
                                        ),
                                      ],
                                    ),
                                    SpaceHeight(20.0),
                                    if (result?.interests.isEmpty ?? true)
                                      AppText(
                                        text:
                                            "Add in your interest to find a better match",
                                        textStyle: AppTextStyle.regularStyle
                                            .copyWith(
                                              fontSize: 14.0,
                                              color: AppColors.white.withValues(
                                                alpha: 0.14,
                                              ),
                                            ),
                                      )
                                    else
                                      Wrap(
                                        spacing: 10.0,
                                        runSpacing: 10.0,
                                        children: result!.interests
                                            .map(
                                              (e) => AppCard(
                                                radius: 16.0,
                                                backgroundColor: AppColors.white
                                                    .withValues(alpha: 0.06),
                                                child: AppText(text: e),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                  ],
                                ),
                              ),
                              SpaceHeight(20.0),
                              Center(
                                child: AppButton.filled(
                                  onPressed: () {
                                    context.hideKeyboard();
                                    DialogHelper.showConfirmation(
                                      message: "Are you sure logout?",
                                      onOk: () async =>
                                          await controller.logout(),
                                    );
                                  },
                                  label: "Logout",
                                  width: Get.width / 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
          ),
        ),
      ),
    );
  }
}
