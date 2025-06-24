import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:you_app/controller/profile/interest_form_controller.dart';
import 'package:you_app/model/tagging_model.dart';
import 'package:you_app/model/user/user_model.dart';
import 'package:you_app/service/profile/profile_service.dart';
import 'package:you_app/utils/utils.dart';

import '../../widgets/widgets.dart';

class InterestFormView extends StatefulWidget {
  final UserModel? user;
  const InterestFormView({super.key, required this.user});

  @override
  State<InterestFormView> createState() => _InterestFormViewState();
}

class _InterestFormViewState extends State<InterestFormView> {
  final SuggestionsController<TaggingModel> mySuggestionsController =
      SuggestionsController();
  final controller = Get.put(
    InterestFormController(profileService: ProfileService()),
  );
  @override
  void initState() {
    super.initState();
    controller.init(widget.user);
  }

  @override
  void dispose() {
    super.dispose();
    mySuggestionsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: context.hideKeyboard,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppAppbar(
                      withBackButton: true,
                      action: TextButton(
                        onPressed: () {
                          context.hideKeyboard();
                          DialogHelper.showConfirmation(
                            message: "Are you sure save this interest?",
                            onOk: () async =>
                                await controller.save(widget.user),
                          );
                        },
                        child: GradientText(
                          "Save",
                          colors: AppColors.listdarkBlue,
                          style: AppTextStyle.h4,
                        ),
                      ),
                    ),
                    SpaceHeight(40.0),
                    Padding(
                      padding: AppPadding.normal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GradientText(
                            "Tell everyone about yourself",
                            colors: AppColors.listGold,
                            style: AppTextStyle.h4,
                          ),
                          SpaceHeight(15.0),
                          AppText(
                            text: "What interest you?",
                            textStyle: AppTextStyle.h1,
                          ),

                          SpaceHeight(30.0),
                          Obx(
                            () => AppMultiTagging(
                              datas: TaggingModel.listDummy,
                              selectedItems: controller.selectedInterests.value,
                              onChanged: (value) =>
                                  controller.setSelectedInterests(value),
                              mySuggestionsController: mySuggestionsController,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
