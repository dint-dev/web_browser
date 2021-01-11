[![Pub Package](https://img.shields.io/pub/v/web_browser.svg)](https://pub.dartlang.org/packages/web_browser)
[![Github Actions CI](https://github.com/dint-dev/web_browser/workflows/Dart%20CI/badge.svg)](https://github.com/dint-dev/web_browser/actions?query=workflow%3A%22Dart+CI%22)

# Overview
Web browser and HTML rendering widgets for Flutter application. Licensed under the
[Apache License 2.0](LICENSE).

In Android and iOS, this package uses [webview_flutter](https://pub.dev/packages/webview_flutter),
which is maintained by Google. However, _webview_flutter_ works only in Android and iOS. This
package works in browsers too by using `<iframe>` and other HTML elements. The iframe relies on a
_dart:ui_ API that is currently undocumented.

The main widgets in this package are:
  * [WebBrowser](https://pub.dev/documentation/web_browser/latest/web_browser/WebBrowser-class.html)
    * Shows any web page.
    * By default, the widget gives you:
      * Address bar
      * "Share link" button
      * "Back" button
      * "Forward" button
  * [WebNode](https://pub.dev/documentation/web_browser/latest/web_browser/WebNode-class.html)
    * Shows any DOM node. DOM nodes work in Android and iOS too, thanks to
      [universal_html](https://pub.dev/packages/universal_html).

Pull request are welcome! Please test your changes manually with the example application.

## Links
  * [Github project](https://github.com/dint-dev/web_browser)
  * [Issue tracker](https://github.com/dint-dev/web_browser/issues)
  * [API Reference](https://pub.dev/documentation/web_browser/latest/index.html)

## Known issues
  * Flickering in browsers ([Flutter issue #51865](https://github.com/flutter/flutter/issues/51865))

# Setting up
## 1.Setup
In _pubspec.yaml_:
```yaml
dependencies:
  universal_html: ^1.2.3
  web_browser: ^0.3.1
```

For iOS support, you should follow the usual [webview_flutter](https://pub.dev/packages/webview_flutter)
instructions, which means adding the following snippet in `ios/Runner/Info.plist`:
```xml
<key>io.flutter.embedded_views_preview</key>
<true />
```

## 2.Display DOM nodes
```dart
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' show html;
import 'package:web_browser/web_browser.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: WebNode(
          node: html.HeadingElement.h1()..appendText('Hello'),
        ),
      ),
    ),
  ));
}
```

## 3.Display web browser
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