import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

extension HideKeyboardExt on BuildContext {
  void hideKeyboard() {
    final FocusScopeNode currentScope = FocusScope.of(this);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
    if (!kIsWeb) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }
}
