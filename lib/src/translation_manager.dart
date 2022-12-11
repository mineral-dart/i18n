import 'package:mineral_i18n/src/lang.dart';

class TranslationManager {
  final Map<String, dynamic> _cache = {};

  Map<String, dynamic> get cache => _cache;

  void addTranslations (Lang lang, Map<String, String> translations) {
    for (final translation in translations.entries) {
      dynamic location = _cache[lang.normalize];
      List<String> keys = translation.key.split('.');

      for (final key in keys) {
        if (keys.last == key) {
          location[key] = translation.value;
          return;
        }

        if (location[key] == null) {
          location[key] = {};
          location = location[key];
        }
      }
    }
  }
}
