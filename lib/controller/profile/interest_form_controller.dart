// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:get/get.dart';
import 'package:you_app/controller/profile/profile_controller.dart';
import 'package:you_app/model/model_parser.dart';

import 'package:you_app/model/tagging_model.dart';
import 'package:you_app/model/user/user_model.dart';
import 'package:you_app/service/profile/profile_service.dart';

import '../../utils/utils.dart';

class InterestFormController extends GetxController {
  final ProfileService profileService;
  InterestFormController({required this.profileService});

  Rx<List<TaggingModel>> selectedInterests = Rx([]);

  void init(UserModel? user) {
    selectedInterests.value =
        user?.interests.map((e) => TaggingModel(value: e)).toList() ?? [];
    selectedInterests.refresh();
  }

  void setSelectedInterests(List<TaggingModel> values) {
    selectedInterests.value = values;
    selectedInterests.refresh();
  }

  Future<void> save(UserModel? user) async {
    DialogHelper.showLoading();
    final result = user?.name.isEmpty ?? true
        ? await profileService.create(
            name: user?.name ?? "",
            birthDay: ModelParser.formatDate(
              date: user?.birthDay,
              pattern: "dd MM yyyy",
            ),
            height: user?.height ?? 0,
            weight: user?.weight ?? 0,
            interests: selectedInterests.value.map((e) => e.value).toList(),
          )
        : await profileService.update(
            name: user?.name ?? "",
            birthDay: ModelParser.formatDate(
              date: user?.birthDay,
              pattern: "dd MM yyyy",
            ),
            height: user?.height ?? 0,
            weight: user?.weight ?? 0,
            interests: selectedInterests.value.map((e) => e.value).toList(),
          );
    DialogHelper.hideLoading();
    result.fold(
      (l) => DialogHelper.showMessage(title: "Error", message: l.message),
      (r) => DialogHelper.showSuccess().then((_) async {
        Go.back();
        await Get.find<ProfileController>().get();
      }),
    );
  }
}
