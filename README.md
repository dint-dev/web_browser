[![Pub Package](https://img.shields.io/pub/v/web_browser.svg)](https://pub.dartlang.org/packages/web_browser)
[![Github Actions CI](https://github.com/dint-dev/web_browser/workflows/Dart%20CI/badge.svg)](https://github.com/dint-dev/web_browser/actions?query=workflow%3A%22Dart+CI%22)

# Overview
[Browser](https://pub.dev/documentation/web_browser/latest/web_browser/WebBrowser-class.html) is
a Flutter widget for browsing websites in Android, iOS, and browsers. It's provides all sorts of
functionality on top of the standard [webview_flutter](https://pub.dev/packages/webview_flutter)
(by Flutter team), including:
  * Back / forward / refresh buttons
  * Address displaying bar.
  * Various other UI features.
  * Frees you from thinking various cross-platform differences and security issues. For example,
    we have paid attention to how to make users notice phishing attack URLs. Unless the app is
    running inside browser, we show suffix of the current domain above the content.

Licensed under the [Apache License 2.0](LICENSE).

## Links
  * [Github project](https://github.com/dint-dev/web_browser)
  * [Issue tracker](https://github.com/dint-dev/web_browser/issues)
  * [API Reference](https://pub.dev/documentation/web_browser/latest/index.html)

# Setting up
## 1.Setup
In _pubspec.yaml_:
```yaml
dependencies:
  web_browser: ^0.6.0
```

## 2.Display web browser
```dart
import 'package:flutter/material.dart';
import 'package:web_browser/web_browser.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: WebBrowser(
          initialUrl: 'https://flutter.dev/',
          policy: BrowserPolicy(
            allowedDomains: {
              // Allow navigation to "flutter.dev" and any subdomain.
              // Other websites will be opened in the user's browser.
              '**.flutter.dev',

              // And some other websites...
              '**.dart.dev',
              '**.youtube.com',
            },
          )
        ),
      ),
    ),
  ));
}
```

# Designs available in this package
### Material design
* [MaterialBrowserTopBar](https://pub.dev/documentation/web_browser/latest/web_browser.material/MaterialBrowserTopBar-class.html)
* [MaterialBrowserBottomBar](https://pub.dev/documentation/web_browser/latest/web_browser.material/MaterialBrowserBottomBar-class.html)
  with:
    * [MaterialBrowserBackButton](https://pub.dev/documentation/web_browser/latest/web_browser.material/MaterialBrowserBackButton-class.html)
    * [MaterialBrowserForwardButton](https://pub.dev/documentation/web_browser/latest/web_browser.material/MaterialBrowserForwardButton-class.html)
    * [MaterialBrowserRefreshButton](https://pub.dev/documentation/web_browser/latest/web_browser.material/MaterialBrowserRefreshButton-class.html)

### Cupertino design
* [CupertinoBrowserTopBar](https://pub.dev/documentation/web_browser/latest/web_browser.cupertino/CupertinoBrowserTopBar-class.html)
* [CupertinoBrowserBottomBar](https://pub.dev/documentation/web_browser/latest/web_browser.cupertino/CupertinoBrowserBottomBar-class.html)
  with:
  * [CupertinoBrowserBackButton](https://pub.dev/documentation/web_browser/latest/web_browser.cupertino/CupertinoBrowserBackButton-class.html)
  * [CupertinoBrowserForwardButton](https://pub.dev/documentation/web_browser/latest/web_browser.cupertino/CupertinoBrowserForwardButton-class.html)
  * [CupertinoBrowserRefreshButton](https://pub.dev/documentation/web_browser/latest/web_browser.cupertino/CupertinoBrowserRefreshButton-class.html)

## Auto-design (default)
By default, the package chooses Material or Cupertino design based on whether the app is
`CupertinoApp` or `MaterialApp`.

# Customization
## Top/bottom bars
```dart
import 'package:flutter/material.dart';
import 'package:web_browser/material.dart';
import 'package:web_browser/web_browser.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: WebBrowser(
          topBar: MaterialBrowserTopBar(
            addressField: MaterialBrowserAddressField(
              trailingButtons: [
                MyHomeButton(),
              ],
            ),
          ),
        ),
      ),
    ),
  ));
}
```

## BrowserController inside the widget subtree
Widgets inside the top/bottom bars can use the following pattern:
```dart
class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});
  
  @override
  Widget build(BuildContext context) {
    final controller = Browser.of(context).controller;
    return MaterialButton(
      // ...
      onTap: () {
        controller.goBack();
      },
    );
  }
}
```