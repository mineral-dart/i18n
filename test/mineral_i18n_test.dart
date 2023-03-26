import 'package:mineral_i18n/mineral_i18n.dart';
import 'package:mineral_i18n/src/mixins/translation.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:test/test.dart';

class Foo with Translation {
  Function get translator => t;
}

void main() {
  final foo = Foo();
  final String targetTranslation = 'foo.bar';
  final i18n = I18n([Lang.fr, Lang.enGB])
    ..registerLanguages();

  i18n.translationManager
    ..addTranslations(Lang.fr, { targetTranslation: 'Salut {user}' })
    ..addTranslations(Lang.enGB, { targetTranslation: 'Hello {user}' });

  test('can register i18n into mineral ioc', () {
    final dynamic pluginManager = ioc.services.entries.firstWhere((element) => element.key.toString() == 'PluginManagerCraft').value;
    pluginManager.bind((ioc) => I18n([Lang.fr, Lang.enGB]));

    expect(pluginManager.use(), equals(i18n));
  });

  test('registered lang is two', () {
    expect(i18n.languages.length, equals(2));
    expect(i18n.languages.first, equals(Lang.fr));
  });

  test('can translate sentence without variables', () {
    expect(foo.translator(Lang.fr, targetTranslation), equals('Salut {user}'));
    expect(foo.translator(Lang.enGB, targetTranslation), equals('Hello {user}'));
  });

  test('can translate sentence with variables', () {
    expect(foo.translator(Lang.fr, targetTranslation, replacers: { 'user': 'Freeze' }), equals('Salut Freeze'));
    expect(foo.translator(Lang.enGB, targetTranslation, replacers: { 'user': 'Freeze' }), equals('Hello Freeze'));
  });
}
