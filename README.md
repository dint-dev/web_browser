[![Pub Package](https://img.shields.io/pub/v/web_browser.svg)](https://pub.dartlang.org/packages/web_browser)
[![Github Actions CI](https://github.com/dint-dev/web_browser/workflows/Dart%20CI/badge.svg)](https://github.com/dint-dev/web_browser/actions?query=workflow%3A%22Dart+CI%22)

# Overview
Gives you a cross-platform Flutter widget for displaying websites and other web content.

Licensed under the [Apache License 2.0](LICENSE).

## Links
  * [Github project](https://github.com/dint-dev/web_browser)
  * [Issue tracker](https://github.com/dint-dev/web_browser/issues)
  * [API Reference](https://pub.dev/documentation/web_browser/latest/index.html)

## Cross-platform
[WebBrowser](https://pub.dev/documentation/web_browser/latest/web_browser/WebBrowser-class.html)
widget is cross-platform:
  * In Android and iOS, this package uses [webview_flutter](https://pub.dev/packages/webview_flutter),
    which is maintained by Google.
      * However, _webview_flutter_ does not support browsers.
  * In browsers, the package uses [package:web_node](https://pub.dev/packages/web_node) to display web
    content inside `<iframe>`.
     * Only works for websites that allow iframes.
     * Only some navigation features are supported (because of iframe limitations).

## Optional navigation widgets
 * Address bar
 * Share button
 * Back button
 * Forward button

# Setting up
## 1.Setup
In _pubspec.yaml_:
```yaml
dependencies:
  web_browser: ^0.5.0
```

## 2.Display web browser
```dart
import 'package:flutter/material.dart';
import 'package:web_browser/web_browser.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: WebBrowser(
          initialUrl: 'https://flutter.dev/',
          javascriptEnabled: true,
        ),
      ),
    ),
  ));
}
```