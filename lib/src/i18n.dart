import 'dart:io';

import 'package:mineral_i18n/src/lang.dart';
import 'package:mineral_i18n/src/translation.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

class I18n {
  final String label = 'I18n';
  static String get namespace => 'Mineral/Plugins/I18n';
  late final Directory root;

  Translation translation = Translation();
  final List<Lang> _languages;
  final String folder;

  I18n(this._languages, { this.folder = 'lang' });

  /// ## Languages allowed
  /// ```dart
  /// final List<Lang> allowedLanguages = i18n.languages;
  /// ```
  List<Lang> get languages => _languages;

  /// ## Languages root directory
  /// ```dart
  /// final Directory folder = i18n.langDirectory;
  /// ```
  Directory get langDirectory => Directory(join(root.path, folder));

  /// Insert languages into i18n instance
  void registerLanguages() {
    for (final Lang lang in _languages) {
      translation.cache.putIfAbsent(lang.normalize, () => {});
    }
  }

  /// Initialize i18n package
  Future<void> init () async {
    if (!await langDirectory.exists()) {
      throw Exception('Missing $folder folder');
    }

    registerLanguages();
    _walk(langDirectory);
  }

  /// Recursively browses folders to extract translations
  _walk (Directory directory) {
    final location = directory.path.split(separator).last;
    List<FileSystemEntity> items = directory.listSync();

    for (final item in items) {
      if (item is Directory) {
        translation.cache.putIfAbsent(location, () => {});
        _walk(item);
      }

      if (item is File) {
        final filename = item.path.split(separator).last.split('.').first;
        final content = loadYaml(item.readAsStringSync());

        if (translation.cache[filename] is Map) {
          if (item.parent.path == langDirectory.path) {
            translation.cache[location] = content;
          } else {
            translation.cache[filename].putIfAbsent(location, () => content);
          }
        }
      }
    }
  }
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
  final I18n i18n = ioc.singleton(I18n.namespace);
  dynamic target = i18n.translation.cache[lang.normalize];

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
