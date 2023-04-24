import 'dart:io';

import 'package:mineral_contract/mineral_contract.dart';
import 'package:path/path.dart';

class SetupCommand extends CliCommandContract {
  SetupCommand(ConsoleServiceContract console): super(console, 'i18n:setup', 'Setup i18n module', []);

  @override
  Future<void> handle(Map args) async {
    final directory = await Directory(join(Directory.current.path, 'lang')).create();
    await File(join(directory.path, 'fr.yaml')).create();
    await File(join(directory.path, 'en.yaml')).create();

    console.success('The language directory has been initialized');
  }
}