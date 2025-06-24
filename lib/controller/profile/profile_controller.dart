import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:you_app/model/model_parser.dart';
import 'package:you_app/model/select_data_model.dart';
import 'package:you_app/model/user/user_model.dart';
import 'package:you_app/service/local/local_service.dart';
import 'package:you_app/service/profile/profile_service.dart';
import 'package:you_app/view/splash_view.dart';

import '../../service/auth/auth_service.dart';
import '../../utils/utils.dart';

class ProfileController extends GetxController {
  final AuthService authService;
  final ProfileService profileService;

  ProfileController({required this.authService, required this.profileService});

  Rx<RequestState<UserModel?>> stateUser = Rx(RequestStateInitial());

  RxBool isEditAbout = false.obs;

  final TextEditingController nameController = TextEditingController();
  Rx<SelectDataModel?> selectedGender = Rx(null);
  Rx<DateTime?> selectedBirthDay = Rx(null);
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  Future<void> get() async {
    stateUser.value = RequestStateLoading();
    stateUser.refresh();
    isEditAbout.value = false;
    final result = await authService.getUserDetail();
    result.fold(
      (l) {
        stateUser.value = RequestStateError(message: l.message);
      },
      (r) {
        stateUser.value = r == null
            ? RequestStateEmpty()
            : RequestStateLoaded(result: r);
      },
    );
    stateUser.refresh();
  }

  void setIsEditAbout() {
    isEditAbout.value = true;
    isEditAbout.refresh();
    nameController.text = stateUser.value.result?.name ?? "";
    setSelectedGender(null);
    setSelectedBirthDay(stateUser.value.result?.birthDay);
    heightController.text = (stateUser.value.result?.height)?.toString() ?? "";
    weightController.text = (stateUser.value.result?.weight)?.toString() ?? "";
  }

  void setSelectedGender(SelectDataModel? value) {
    selectedGender.value = value;
    selectedGender.refresh();
  }

  void setSelectedBirthDay(DateTime? value) {
    selectedBirthDay.value = value;
    selectedBirthDay.refresh();
  }

  Future<void> saveOrEditAbout() async {
    DialogHelper.showLoading();
    final result = stateUser.value.result?.name.isEmpty ?? true
        ? await profileService.create(
            name: nameController.text.trim(),
            birthDay: ModelParser.formatDate(
              date: selectedBirthDay.value,
              pattern: "dd MM yyyy",
            ),
            height: ModelParser.intFromJson(heightController.text.trim()) ?? 0,
            weight: ModelParser.intFromJson(weightController.text.trim()) ?? 0,
            interests: stateUser.value.result?.interests ?? [],
          )
        : await profileService.update(
            name: nameController.text.trim(),
            birthDay: ModelParser.formatDate(
              date: selectedBirthDay.value,
              pattern: "dd MM yyyy",
            ),
            height: ModelParser.intFromJson(heightController.text.trim()) ?? 0,
            weight: ModelParser.intFromJson(weightController.text.trim()) ?? 0,
            interests: stateUser.value.result?.interests ?? [],
          );
    DialogHelper.hideLoading();
    result.fold(
      (l) => DialogHelper.showMessage(title: "Error", message: l.message),
      (r) => DialogHelper.showSuccess().then((_) async => await get()),
    );
  }

  Future<void> logout() async {
    DialogHelper.showLoading();
    await LocalService.deleteToken();
    DialogHelper.hideLoading();
    DialogHelper.showSuccess().then((_) => Go.offAll(SplashView()));
  }
}
