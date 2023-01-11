# vscode_snippets

Generate snippet files for vscode from actual separat source files.

Run `generate.py` to loop over all folders in `src/` and all files in each folder.

Each `src/<folder>` will generate a `out/<folder>.json` containing each `src/<folder>/<file>.<type>` as a snippet with the prefix and description `<file>`.


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
