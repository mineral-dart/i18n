import 'dart:io';

import 'package:mineral_i18n/src/lang.dart';

abstract class I18nContract {
  List<Lang> get languages;
  Directory get langPath;
}
