import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../utils/utils.dart';

class FlutterTagging<T> extends StatefulWidget {
  final ValueChanged<List<T>> onChanged;

  final SuggestionsController<T> mySuggestionsController;

  final FutureOr<List<T>> Function(String) findSuggestions;

  final ChipConfiguration Function(T) configureChip;

  final SuggestionConfiguration Function(T) configureSuggestion;

  final WrapConfiguration wrapConfiguration;

  final T Function(String)? additionCallback;

  final FutureOr<T> Function(T)? onAdded;

  final Widget Function(BuildContext)? loadingBuilder;

  final Widget Function(BuildContext)? emptyBuilder;

  final Widget Function(BuildContext, Object?)? errorBuilder;

  final Widget Function(BuildContext, Animation<double>, Widget)?
  transitionBuilder;

  final SuggestionsBoxConfiguration<T> suggestionsBoxConfiguration;

  final double interiorSpacing;

  final Duration animationDuration;

  final double animationStart;

  final bool hideOnLoading;

  final bool hideOnEmpty;

  final bool hideOnError;

  final T? placeholderItem;

  final Duration debounceDuration;

  final bool enableImmediateSuggestion;

  final List<T> initialItems;

  final String hintText;

  const FlutterTagging({
    super.key,
    required this.findSuggestions,
    required this.configureChip,
    required this.configureSuggestion,
    required this.onChanged,
    required this.mySuggestionsController,
    this.initialItems = const [],
    this.additionCallback,
    this.enableImmediateSuggestion = false,
    this.errorBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.placeholderItem,
    this.wrapConfiguration = const WrapConfiguration(),
    this.suggestionsBoxConfiguration = const SuggestionsBoxConfiguration(),
    this.interiorSpacing = 8.0,
    this.transitionBuilder,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.hideOnEmpty = false,
    this.hideOnError = false,
    this.hideOnLoading = false,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationStart = 0.25,
    this.onAdded,
    this.hintText = "",
  });

  @override
  State<FlutterTagging<T>> createState() => _FlutterTaggingState<T>();
}

class _FlutterTaggingState<T> extends State<FlutterTagging<T>> {
  late final TextEditingController _textController;
  late final FocusNode _focusNode;
  final Set<T> _values = <T>{};
  T? _additionItem;

  @override
  void initState() {
    super.initState();
    _values.addAll(widget.initialItems);
    _textController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TypeAheadField<T>(
          debounceDuration: widget.debounceDuration,
          hideOnEmpty: widget.hideOnEmpty,
          hideOnError: widget.hideOnError,
          hideOnLoading: widget.hideOnLoading,
          animationDuration: widget.animationDuration,
          autoFlipDirection:
              widget.suggestionsBoxConfiguration.autoFlipDirection,
          direction: widget.suggestionsBoxConfiguration.direction,
          hideWithKeyboard:
              widget.suggestionsBoxConfiguration.hideSuggestionsOnKeyboardHide,
          retainOnLoading:
              widget.suggestionsBoxConfiguration.keepSuggestionsOnLoading,
          hideOnSelect: widget
              .suggestionsBoxConfiguration
              .keepSuggestionsOnSuggestionSelected,
          suggestionsController: widget.mySuggestionsController,
          decorationBuilder:
              widget.suggestionsBoxConfiguration.decorationBuilder,
          offset:
              widget.suggestionsBoxConfiguration.suggestionsBoxVerticalOffset,
          errorBuilder: widget.errorBuilder,
          transitionBuilder: widget.transitionBuilder,
          loadingBuilder: (context) =>
              widget.loadingBuilder?.call(context) ??
              const SizedBox(height: 3.0, child: LinearProgressIndicator()),
          emptyBuilder: widget.emptyBuilder,
          controller: _textController,
          focusNode: _focusNode,
          builder: (context, controller, focusNode) {
            return TextField(
              controller: _textController,
              focusNode: _focusNode,
              autofocus: false,
              style: AppTextStyle.regularStyle.copyWith(
                color: AppColors.primary,
                fontSize: 12.0,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                fillColor: AppColors.white.withValues(alpha: 0.06),
                hintText: widget.hintText,
                contentPadding: const EdgeInsets.all(10),
                enabledBorder: _border(color: Colors.transparent),
                focusedBorder: _border(color: Colors.transparent),
              ),
            );
          },
          suggestionsCallback: (query) async {
            List<T> suggestions = await widget.findSuggestions(query);
            suggestions = suggestions
                .where((item) => !_values.contains(item))
                .toList();
            suggestions = suggestions
                .where((r) => !_values.contains(r))
                .toList();
            if (widget.additionCallback != null && query.isNotEmpty) {
              final additionItem = widget.additionCallback!(query);
              if (!suggestions.contains(additionItem) &&
                  !_values.contains(additionItem)) {
                _additionItem = additionItem;
                suggestions.insert(0, additionItem);
              } else {
                _additionItem = null;
              }
            }
            //

            return suggestions;
          },
          itemBuilder: (context, item) {
            final conf = widget.configureSuggestion(item);
            return ListTile(
              title: conf.title,
              subtitle: conf.subtitle,
              leading: conf.leading,
              trailing: InkWell(
                splashColor: conf.splashColor ?? Theme.of(context).splashColor,
                borderRadius: conf.splashRadius,
                onTap: () async {
                  final itemItem = widget.onAdded != null
                      ? await widget.onAdded!(item)
                      : item;
                  setState(() {
                    _values.add(itemItem);
                  });
                  widget.onChanged.call(_values.toList(growable: false));
                  widget.mySuggestionsController.refresh();
                  _textController.clear();
                },
                child: Builder(
                  builder: (context) {
                    if (conf.additionWidget != null && _additionItem == item) {
                      return conf.additionWidget!;
                    } else {
                      return const SizedBox(width: 0);
                    }
                  },
                ),
              ),
            );
          },
          onSelected: (suggestion) {
            if (_additionItem != suggestion) {
              setState(() {
                _values.add(suggestion);
              });
              widget.onChanged.call(_values.toList(growable: false));
              _textController.clear();
              widget.mySuggestionsController.refresh();
              // focus change must happen after this task completes
              Future.delayed(Duration.zero, () {
                _focusNode.requestFocus();
              });
            }
          },
        ),
        if (widget.interiorSpacing > 0)
          SizedBox(height: widget.interiorSpacing),
        Wrap(
          alignment: widget.wrapConfiguration.alignment,
          crossAxisAlignment: widget.wrapConfiguration.crossAxisAlignment,
          runAlignment: widget.wrapConfiguration.runAlignment,
          runSpacing: widget.wrapConfiguration.runSpacing,
          spacing: widget.wrapConfiguration.spacing,
          direction: widget.wrapConfiguration.direction,
          textDirection: widget.wrapConfiguration.textDirection,
          verticalDirection: widget.wrapConfiguration.verticalDirection,
          children: _values.isEmpty && widget.placeholderItem != null
              ? _buildPlaceholder(
                  context,
                  // ignore: null_check_on_nullable_type_parameter
                  widget.configureChip(widget.placeholderItem!),
                )
              : _values.map<Widget>((item) {
                  final conf = widget.configureChip(item);
                  return Chip(
                    label: conf.label,
                    shape: conf.shape,
                    avatar: conf.avatar,
                    backgroundColor: conf.backgroundColor,
                    clipBehavior: conf.clipBehavior,
                    deleteButtonTooltipMessage: conf.deleteButtonTooltipMessage,
                    deleteIcon: conf.deleteIcon,
                    deleteIconColor: conf.deleteIconColor,
                    elevation: conf.elevation,
                    labelPadding: conf.labelPadding,
                    labelStyle: conf.labelStyle,
                    materialTapTargetSize: conf.materialTapTargetSize,
                    padding: conf.padding,
                    shadowColor: conf.shadowColor,
                    onDeleted: () {
                      setState(() {
                        _values.remove(item);
                      });
                      widget.onChanged.call(_values.toList(growable: false));
                    },
                  );
                }).toList(),
        ),
      ],
    );
  }

  OutlineInputBorder _border({final double? indent, final Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        width: indent ?? 1,
        color: color ?? AppColors.primary,
      ),
    );
  }
}

List<Widget> _buildPlaceholder(BuildContext context, ChipConfiguration conf) {
  return [
    Visibility(
      visible: false,
      maintainAnimation: true,
      maintainSize: true,
      maintainState: true,
      child: Chip(
        label: conf.label,
        shape: conf.shape,
        avatar: conf.avatar,
        clipBehavior: conf.clipBehavior,
        deleteIcon: conf.deleteIcon,
        elevation: conf.elevation,
        labelPadding: conf.labelPadding,
        labelStyle: conf.labelStyle,
        padding: conf.padding,
      ),
    ),
  ];
}

class SuggestionConfiguration {
  final Widget? leading;

  final Widget title;

  final Widget? subtitle;

  final bool isThreeLine;

  final bool dense;

  final EdgeInsetsGeometry contentPadding;

  final Widget? additionWidget;

  final Color? splashColor;

  final BorderRadius splashRadius;

  const SuggestionConfiguration({
    required this.title,
    this.subtitle,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.dense = false,
    this.isThreeLine = false,
    this.leading,
    this.additionWidget,
    this.splashColor,
    this.splashRadius = BorderRadius.zero,
  });
}

///
class ChipConfiguration {
  final Widget label;

  final Widget? avatar;

  final TextStyle? labelStyle;

  final OutlinedBorder? shape;

  final Clip clipBehavior;

  final Color? backgroundColor;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? labelPadding;

  final MaterialTapTargetSize? materialTapTargetSize;

  final double elevation;

  final Color shadowColor;

  final Widget? deleteIcon;

  final Color? deleteIconColor;

  final String? deleteButtonTooltipMessage;

  const ChipConfiguration({
    required this.label,
    this.avatar,
    this.labelStyle,
    this.labelPadding,
    this.deleteIcon,
    this.deleteIconColor,
    this.deleteButtonTooltipMessage,
    this.shape,
    this.clipBehavior = Clip.none,
    this.backgroundColor,
    this.padding,
    this.materialTapTargetSize,
    this.elevation = 0,
    this.shadowColor = Colors.black,
  });
}

///
class WrapConfiguration {
  final Axis direction;

  final WrapAlignment alignment;

  final double spacing;

  final WrapAlignment runAlignment;

  final double runSpacing;

  final WrapCrossAlignment crossAxisAlignment;

  final TextDirection? textDirection;

  final VerticalDirection verticalDirection;

  const WrapConfiguration({
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 8.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 8.0,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
  });
}

///
class SuggestionsBoxConfiguration<T> {
  final bool hideSuggestionsOnKeyboardHide;

  final bool keepSuggestionsOnLoading;

  final bool keepSuggestionsOnSuggestionSelected;

  final bool autoFlipDirection;

  final Offset suggestionsBoxVerticalOffset;

  final Widget Function(BuildContext, Widget)? decorationBuilder;

  final SuggestionsController<T>? suggestionsBoxController;

  final VerticalDirection direction;

  const SuggestionsBoxConfiguration({
    this.direction = VerticalDirection.down,
    this.autoFlipDirection = false,
    this.hideSuggestionsOnKeyboardHide = true,
    this.keepSuggestionsOnLoading = true,
    this.keepSuggestionsOnSuggestionSelected = true,
    this.suggestionsBoxController,
    this.decorationBuilder,
    this.suggestionsBoxVerticalOffset = const Offset(5.0, 5.0),
  });
}
