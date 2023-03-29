import 'package:mineral_i18n/mineral_i18n.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:test/test.dart';

class Foo with Translation {
  Function get translator => t;
}

void main() {
  final foo = Foo();
  final String targetTranslation = 'foo.bar';
  final i18n = I18n(['fr', 'en'])
    ..registerLanguages();

  i18n.translationManager
    ..addTranslations('fr', { targetTranslation: 'Salut {user}' })
    ..addTranslations('en', { targetTranslation: 'Hello {user}' });

  test('can register i18n into mineral ioc', () {
    ioc.bind((ioc) => I18n(['fr', 'en']));

    expect(ioc.use<I18n>(), equals(i18n));
  });

  test('registered lang is two', () {
    expect(i18n.languages.length, equals(2));
    expect(i18n.languages.first, equals('fr'));
  });

  test('can translate sentence without variables', () {
    expect(foo.translator('fr', targetTranslation), equals('Salut {user}'));
    expect(foo.translator('en', targetTranslation), equals('Hello {user}'));
  });

  test('can translate sentence with variables', () {
    expect(foo.translator('fr', targetTranslation, replacers: { 'user': 'Freeze' }), equals('Salut Freeze'));
    expect(foo.translator('en', targetTranslation, replacers: { 'user': 'Freeze' }), equals('Hello Freeze'));
  });
}
