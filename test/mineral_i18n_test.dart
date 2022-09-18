import 'package:mineral_i18n/i18n.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:test/test.dart';

void main() {
  final String targetTranslation = 'foo.bar';
  final i18n = I18n([Lang.fr, Lang.enGB])
    ..registerLanguages();

  i18n.translation
    ..addTranslations(Lang.fr, { targetTranslation: 'Salut {user}' })
    ..addTranslations(Lang.enGB, { targetTranslation: 'Hello {user}' });

  test('can register i18n into mineral ioc', () {
    ioc.bind(namespace: I18n.namespace, service: i18n);
    expect(ioc.singleton(I18n.namespace), equals(i18n));
  });

  test('registered lang is two', () {
    expect(i18n.languages.length, equals(2));
    expect(i18n.languages.first, equals(Lang.fr));
  });

  test('can translate sentence without variables', () {
    expect(t(Lang.fr, targetTranslation), equals('Salut {user}'));
    expect(t(Lang.enGB, targetTranslation), equals('Hello {user}'));
  });

  test('can translate sentence with variables', () {
    expect(t(Lang.fr, targetTranslation, replacers: { 'user': 'Freeze' }), equals('Salut Freeze'));
    expect(t(Lang.enGB, targetTranslation, replacers: { 'user': 'Freeze' }), equals('Hello Freeze'));
  });
}
