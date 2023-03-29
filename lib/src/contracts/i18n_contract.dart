import 'dart:io';

abstract class I18nContract {
  List<String> get languages;
  Directory get langPath;
}
