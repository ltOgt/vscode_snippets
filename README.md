# vscode_snippets

Generate snippet files for vscode from actual separat source files.

Run `generate.py` to loop over all folders in `src/` and all files in each folder.

Each `src/<folder>` will generate a `out/<folder>.json` containing each `src/<folder>/<file>.<type>` as a snippet with the prefix and description `<file>`.

Optionally add the path to your vscode snippet directory into a file named `snippets.path`.

E.g. on mac:
```
/Users/<user>/Library/Application Support/Code/User/snippets/
```


# Example Output

```
myPath/ $ ./generate.py
[dart] Generating map from files...
 > docstringTemplate.dart
 > moor.dart
 > proxyRenderObject.dart
 > mainDart.dart
 > equalsCollection.dart
 > leafRenderObject.dart
 > fab.dart
 > fori.dart
 > req.txt
 > test.dart
 > cmdBase.dart
 > canvas.dart
 > containerDecorated.dart
 = Generating single json from src snippets ...
 = Writing snippet to myPath/out/dart.json
```

# Example Resulting File
```json
{
  "docstringTemplate": {
    "prefix": "docstringTemplate",
    "description": "docstringTemplate",
    "body": [
      "/// {@template $1}",
      "/// ...",
      "/// {@endtemplate}",
      "",
      "/// {@macro $1"
    ]
  },
  "moor": {
    "prefix": "moor",
    "description": "moor",
    "body": [
      // ...
    ]
  },
  "proxyRenderObject": {
    "prefix": "proxyRenderObject",
    "description": "proxyRenderObject",
    "body": [
      // ...
    ]
  },
  "mainDart": {
    "prefix": "mainDart",
    "description": "mainDart",
    "body": [
      // ...
    ]
  },
  "equalsCollection": {
    "prefix": "equalsCollection",
    "description": "equalsCollection",
    "body": [
      "import 'package:collection/collection.dart';",
      "final listEquals = const DeepCollectionEquality().equals;",
      "final listHash = const DeepCollectionEquality().hash"
    ]
  },
  "leafRenderObject": {
    "prefix": "leafRenderObject",
    "description": "leafRenderObject",
    "body": [
      // ...
    ]
  },
  "fab": {
    "prefix": "fab",
    "description": "fab",
    "body": [
      // ...
    ]
  },
  "fori": {
    "prefix": "fori",
    "description": "fori",
    "body": [
      "\"for (int i=0; i < $1.length; i++) {final item = $1[i];}\","
    ]
  },
  "req": {
    "prefix": "req",
    "description": "req",
    "body": [
      "@required"
    ]
  },
  "test": {
    "prefix": "test",
    "description": "test",
    "body": [
      // ...
    ]
  },
  "cmdBase": {
    "prefix": "cmdBase",
    "description": "cmdBase",
    "body": [
      // ...
    ]
  },
  "canvas": {
    "prefix": "canvas",
    "description": "canvas",
    "body": [
      // ...
    ]
  },
  "containerDecorated": {
    "prefix": "containerDecorated",
    "description": "containerDecorated",
    "body": [
      // ...
    ]
  }
}

```