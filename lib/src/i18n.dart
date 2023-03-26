import 'dart:io';

import 'package:mineral_i18n/src/contracts/i18n_contract.dart';
import 'package:mineral_i18n/src/lang.dart';
import 'package:mineral_i18n/src/translation_manager.dart';
import 'package:mineral_package/mineral_package.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

class I18n extends MineralPackage implements I18nContract {
  @override
  String namespace = 'Mineral/Plugins/I18n';

  @override
  String label = 'I18n';

  @override
  String description = '';

  TranslationManager translationManager = TranslationManager();
  final List<Lang> _languages;
  final String folder;

  I18n(this._languages, { this.folder = 'lang' });

  /// ## Languages allowed
  /// ```dart
  /// final List<Lang> allowedLanguages = i18n.languages;
  /// ```
  @override
  List<Lang> get languages => _languages;


  /// ## Languages root directory
  /// ```dart
  /// final Directory folder = i18n.langPath;
  /// ```
  @override
  Directory get langPath => Directory(join(root.path, folder));

  /// Insert languages into i18n instance
  void registerLanguages() {
    for (final Lang lang in _languages) {
      translationManager.cache.putIfAbsent(lang.normalize, () => {});
    }
  }

  /// Initialize i18n package
  @override
  Future<void> init () async {
    if (!await langPath.exists()) {
      throw Exception('Missing $folder folder');
    }

    registerLanguages();
    _walk(langPath);
  }

  /// Recursively browses folders to extract translations
  _walk (Directory directory) {
    final location = directory.path.split(separator).last;
    List<FileSystemEntity> items = directory.listSync();

    for (final item in items) {
      if (item is Directory) {
        translationManager.cache.putIfAbsent(location, () => {});
        _walk(item);
      }

      if (item is File) {
        final filename = item.path.split(separator).last.split('.').first;
        final content = loadYaml(item.readAsStringSync());

        if (translationManager.cache[filename] is Map) {
          if (item.parent.path == langPath.path) {
            translationManager.cache[location] = content;
          } else {
            translationManager.cache[filename].putIfAbsent(location, () => content);
          }
        }
      }
    }
  }
}
