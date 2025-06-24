import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../model/tagging_model.dart';
import '../utils/utils.dart';
import 'widgets.dart';

class AppMultiTagging extends StatelessWidget {
  final List<TaggingModel> datas;
  final List<TaggingModel> selectedItems;
  final void Function(List<TaggingModel>) onChanged;
  final SuggestionsController<TaggingModel> mySuggestionsController;
  const AppMultiTagging({
    super.key,
    required this.datas,
    required this.selectedItems,
    required this.onChanged,
    required this.mySuggestionsController,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterTagging(
      initialItems: selectedItems,
      findSuggestions: (query) => datas
          .where((e) => !selectedItems.any((s) => s.value == e.value))
          .toList()
          .where((e) => e.value.toLowerCase().contains(query.toLowerCase()))
          .toList(),
      additionCallback: (value) => TaggingModel(value: value),
      mySuggestionsController: mySuggestionsController,
      onChanged: onChanged,
      configureSuggestion: (data) {
        return SuggestionConfiguration(
          title: Text(data.value),
          additionWidget: selectedItems.any((e) => e.value == data.value)
              ? null
              : Chip(
                  avatar: const Icon(Icons.add_circle, color: Colors.white),
                  label: const Text("Add New Tag"),
                  labelStyle: AppTextStyle.regularStyle.copyWith(
                    color: Colors.white,
                  ),
                  backgroundColor: AppColors.primary,
                ),
        );
      },
      configureChip: (data) {
        return ChipConfiguration(
          label: AppText(
            text: data.value,
            textStyle: AppTextStyle.regularStyle.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          deleteIconColor: Colors.white,
        );
      },
    );
  }
}
