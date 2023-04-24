import 'dart:io';

import 'package:mineral_contract/mineral_contract.dart';
import 'package:mineral_i18n/src/commands/setup.dart';
import 'package:mineral_i18n/src/contracts/i18n_contract.dart';
import 'package:mineral_i18n/src/managers/translation_manager.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';

class I18n extends MineralPackageContract implements I18nContract {
  TranslationManager translationManager = TranslationManager();

  final List<String> _languages;
  final String folder;

  I18n(this._languages, { this.folder = 'lang' }): super('I18n', 'Official package');

  /// ## Languages allowed
  /// ```dart
  /// final List<Lang> allowedLanguages = i18n.languages;
  /// ```
  @override
  List<String> get languages => _languages;


  /// ## Languages root directory
  /// ```dart
  /// final Directory folder = i18n.langPath;
  /// ```
  @override
  Directory get langPath => Directory(join(root.path, folder));

  @override
  List<CliCommandContract> injectCommands () => [
    SetupCommand(console),
  ];

  @override
  Future<void> init () async {
    if (!await langPath.exists()) {
      throw Exception('Missing $folder folder');
    }

    registerLanguages();
    _walk(langPath);
  }

  /// Insert languages into i18n instance
  void registerLanguages() {
    for (final lang in _languages) {
      translationManager.cache.putIfAbsent(lang, () => {});
    }
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
