# 🌐 I18n

The i18n module has been designed exclusively for the Mineral framework, it allows you to translate your textual content through yaml files.

## Register the module

After installing the module, please register it within `./src/main.dart` following the scheme below :
```dart
import 'package:mineral/core.dart';
import 'package:mineral/core/services.dart';
import 'package:mineral_i18n/mineral_i18n.dart';

void main () async {
  final kernel = Kernel(
    intents: IntentService(all: true),
    packages: PackageService([
      I18n(['fr', 'en'])
    ]),
  );

  await kernel.init();
}
```

## Translate your textual content
As a first step, please create a `lang` folder containing `{lang}.yaml` translation files.

We consider the following software structure :
```
lang/
  foo/
    fr.yaml
    en.yaml
```
The files will contain the following keys :
```yaml
# lang/foo/fr.yaml
bar: bar en français !
```
```yaml
# lang/foo/en.yaml
bar: bar in english !
```

Then we can use the `t()` function to translate our key path.

```dart
import 'package:mineral_i18n/mineral_i18n.dart';

class Foo extends MineralEvent<Ready> with Translation {
  Future<void> handle (Ready event) async {
    final String sentence = t(Lang.fr, 'foo.bar');
    print(sentence); // bar en français !

    final String sentence = t(Lang.en_GB, 'foo.bar');
    print(sentence); // bar in english !
  }
}
```

## Injecting variables
The i18n module integrates the possibility of using variables thanks to special characters which will be replaced by the associated variable.

We consider the file `lang/foo/en.yaml` as containing the following key set :
```yaml
bar: {framework} is my favourite framework ! 
```

Our string is now waiting for a variable named xx which we will give it when we call the `t()` function.
```dart
import 'package:mineral_i18n/mineral_i18n.dart';

class Foo extends MineralEvent<Ready> with Translation {
  Future<void> handle (Ready event) async {
    final String sentence = t(Lang.en_GB, 'foo.bar', { 'framework': 'Mineral' });
    print(sentence); // Mineral is my favourite framework ! 
  }
}
```

## Using package commands
The i18n package provides you with a series of commands that you can discover via the help menu.
In order to use these commands, you will need to add the package to the CLI as follows:
```dart
// mineral file
import 'package:mineral/cli.dart';
import 'package:mineral_i18n/mineral_i18n.dart';

Future<void> main (List<String> arguments) async {
  final i18n = I18n(['fr', 'en']);
  final cli = CommandLineInterface(packages: [i18n]);
  
  await cli.handle(arguments);
}
```
The commands issued by the package are now available
