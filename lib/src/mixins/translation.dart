import 'package:mineral_i18n/mineral_i18n.dart';
import 'package:mineral_ioc/ioc.dart';

mixin Translation {
  /// Translates the sentence defined by the key set into the requested language.
  /// Replacement parameters can be injected.
  /// ```dart
  /// final String sentence = t('en', 'foo.bar');
  /// print(sentence); 👈 'Hello {user}'
  ///
  /// final String sentence = t('en', 'foo.bar', replacers { 'user': 'Freeze' });
  /// print(sentence); 👈 'Hello Freeze'
  /// ```
  String t (String lang, String key, { Map<String, dynamic>? replacers }) {
    dynamic target = ioc.use<I18n>().translationManager.cache[lang];
    for (final element in key.split('.')) {
      target = target[element];
    }

    if (replacers != null) {
      for (final replacer in replacers.entries) {
        target = target.toString().replaceAll('{${replacer.key}}', replacer.value);
      }
    }

    return target;
  }
}
