import 'package:mineral_i18n/mineral_i18n.dart';
import 'package:mineral_ioc/ioc.dart';

mixin Translation {
  I18n _getPlugin () {
    final dynamic pluginManager = ioc.services.entries.firstWhere((element) => element.key.toString() == 'PluginManagerCraft').value;
    return pluginManager.use<I18n>();
  }

  /// Translates the sentence defined by the key set into the requested language.
  /// Replacement parameters can be injected.
  /// ```dart
  /// final String sentence = t(Lang.enGB, 'foo.bar');
  /// print(sentence) 👈 'Hello {user}'
  ///
  /// final String sentence = t(Lang.enGB, 'foo.bar', { 'user': 'Freeze' });
  /// print(sentence) 👈 'Hello Freeze'
  /// ```
  String t (Lang lang, String key, { Map<String, dynamic>? replacers }) {
    dynamic target = _getPlugin().translationManager.cache[lang.normalize];
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
