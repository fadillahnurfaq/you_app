import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../model/select_data_model.dart';
import '../utils/utils.dart';
import 'widgets.dart';

class AppDropdown extends StatelessWidget {
  final String? title;
  final String? hintText;
  final String? labelText;
  final bool isMandatory;
  final String? Function(String?)? validator;
  final SelectDataModel? selectedData;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffix;
  final TextAlign textAlign;
  const AppDropdown({
    super.key,
    this.title,
    this.hintText,
    this.labelText,
    required this.selectedData,
    this.isMandatory = false,
    this.validator,
    this.contentPadding,
    this.fillColor,
    this.readOnly = false,
    this.onTap,
    this.suffix,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: AppText(text: title!, textStyle: AppTextStyle.h4),
              ),
              if (isMandatory)
                AppText(
                  text: " *",
                  textStyle: AppTextStyle.h4.copyWith(color: AppColors.red),
                ),
            ],
          ),
          const SpaceHeight(10.0),
        ],
        AppForm(
          readOnly: true,
          validator: validator,
          isSelectForm: true,
          controller: TextEditingController(text: selectedData?.title),
          hintText: hintText,
          labelText: labelText,
          isMandatory: isMandatory,
          suffix:
              suffix ??
              const Icon(Icons.keyboard_arrow_down, color: AppColors.white),
          fillColor: fillColor ?? AppColors.white.withValues(alpha: 0.06),
          contentPadding: contentPadding,
          textAlign: textAlign,
          onTap: readOnly ? null : onTap,
        ),
      ],
    );
  }
}

class CustomSelect {
  static Future<void> single({
    required final BuildContext context,
    List<SelectDataModel>? datas,
    final Future<List<SelectDataModel>>? futureDatas,
    required SelectDataModel? selectedData,
    required titleSearch,
    required Function(SelectDataModel) onChanged,
    final VoidCallback? onReset,
    bool withReset = true,
    bool withSearch = false,
    bool onlySelect = false,
  }) async {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
    if (!kIsWeb) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
    await Future.delayed(Duration.zero, () async {
      return showModalBottomSheet<void>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: Get.context!,
        builder: (BuildContext context) => _SelectBase(
          withSearch: withSearch,
          datas: datas,
          futureDatas: futureDatas,
          selectedData: selectedData,
          titleSearch: titleSearch,
          onChanged: onChanged,
          onReset: onReset,
          withReset: withReset,
        ),
      );
    });
  }
}

class _SelectBase extends StatefulWidget {
  final List<SelectDataModel>? datas;
  final String titleSearch;
  final SelectDataModel? selectedData;
  final bool withSearch;
  final Function(SelectDataModel) onChanged;
  final Future<List<SelectDataModel>>? futureDatas;
  final VoidCallback? onReset;
  final bool withReset;

  const _SelectBase({
    this.datas,
    this.futureDatas,
    required this.titleSearch,
    required this.onChanged,
    required this.selectedData,
    this.onReset,
    this.withReset = true,
    this.withSearch = true,
  });

  @override
  State<_SelectBase> createState() => _SelectBaseState();
}

class _SelectBaseState extends State<_SelectBase> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.hideKeyboard(),
      behavior: HitTestBehavior.translucent,
      child: SafeArea(
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),
                Divider(
                  thickness: 2,
                  indent: MediaQuery.of(context).size.width * 0.35,
                  endIndent: MediaQuery.of(context).size.width * 0.35,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AppText(
                          text: widget.titleSearch,
                          textStyle: AppTextStyle.h3.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      if (widget.withReset)
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Navigator.pop(context);
                            if (widget.onReset != null) {
                              widget.onReset!();
                            }
                          },
                          child: AppText(
                            text: "Reset",
                            textStyle: AppTextStyle.regularStyle.copyWith(
                              color: AppColors.red,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                widget.withSearch
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            child: AppForm(
                              onChanged: (value) {
                                searchController.text = value;
                                setState(() {});
                              },
                              prefix: const Icon(
                                Icons.search,
                                color: AppColors.primary,
                              ),
                              hintText: "Cari",
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                FutureBuilder<List<SelectDataModel>>(
                  future: widget.futureDatas,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('${snapshot.error}'),
                        ),
                      );
                    }
                    final List<SelectDataModel> datas = snapshot.data != null
                        ? snapshot.data!
                        : widget.datas ?? [];
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: datas
                              .where(
                                (SelectDataModel value) =>
                                    "${value.title} ${value.subTitle}"
                                        .toUpperCase()
                                        .contains(
                                          searchController.text.toUpperCase(),
                                        ),
                              )
                              .length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (c, i) {
                            final SelectDataModel data = datas
                                .where(
                                  (SelectDataModel value) =>
                                      "${value.title} ${value.subTitle}"
                                          .toUpperCase()
                                          .contains(
                                            searchController.text.toUpperCase(),
                                          ),
                                )
                                .toList()[i];

                            return ListTile(
                              trailing: Icon(
                                Icons.check,
                                color: widget.selectedData?.id == data.id
                                    ? AppColors.primary
                                    : Colors.transparent,
                              ),
                              dense: true,
                              title: AppText(
                                text: "${data.title} ${data.subTitle}",
                                textStyle: AppTextStyle.regularStyle.copyWith(
                                  color: AppColors.black,
                                  fontSize: 14.0,
                                  fontWeight: widget.selectedData?.id == data.id
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                widget.onChanged(data);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
