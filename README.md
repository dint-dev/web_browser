[![Pub Package](https://img.shields.io/pub/v/web_browser.svg)](https://pub.dartlang.org/packages/web_browser)
[![Github Actions CI](https://github.com/dint-dev/web_browser/workflows/Dart%20CI/badge.svg)](https://github.com/dint-dev/web_browser/actions?query=workflow%3A%22Dart+CI%22)

# Overview
[Browser](https://pub.dev/documentation/web_browser/latest/web_browser/WebBrowser-class.html) is
a Flutter widget for browsing websites.
* Works in Android, iOS, and browsers. Various cross-platform differences are handled correctly by
  the package so you don't need to deal with details of the underlying
  [webview_flutter](https://pub.dev/packages/webview_flutter). You can still access 
* Has a customizable top bar that displays the domain so that end-users have some protection against
  phishing websites.
* Has customizable bottom bar with buttons for "back", "forward", "refresh", and URL sharing.
* Displays website loading error messages using Flutter widgets. The errors look nicer and are
  easier to decipher by non-technical users.

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
  web_browser: ^0.7.0
```

## 2.Display web browser
```dart
import 'package:flutter/material.dart';
import 'package:web_browser/web_browser.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: Browser(
          initialUriString: 'https://flutter.dev/',
        ),
      ),
    ),
  ));
}
```

# Manual
## Designs available in this package
The package contains two designs:
* [web_browser.cupertino](https://pub.dev/documentation/web_browser/latest/web_browser.cupertino/web_browser.cupertino-library.html)
* [web_browser.material](https://pub.dev/documentation/web_browser/latest/web_browser.cupertino/web_browser.material-library.html)

By default, the package chooses a Cupertino or Material design based on whether the app is _CupertinoApp_ or _MaterialApp_.

The navigation buttons look like this:

![](screenshots/cupertino.png)

![](screenshots/material.png)

## Localization
Use [BrowserLocalizations](https://pub.dev/documentation/web_browser/latest/web_browser/BrowserLocalizations-class.html)
to localize the widgets.

```dart
void main() {
  runApp(MaterialApp(
    localizations: [
      ...browserLocalizationsList,
      // ...
    ],
    // ...
  ));
}

final browserLocalizationsList = [
  // Spanish localization
  BrowserLocalizations.forLocale(
    locale: Locale('es'),
    load: (locale) async => BrowserLocalizations(
      couldNotReach: 'No se pudo acceder al sitio web.',
      // ...
    ),
  ),
];
```

## Setting user agent
```dart
import 'package:flutter/material.dart';
import 'package:web_browser/web_browser.dart';

void main() {
  runApp(const MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: Browser(
          initialUriString: 'https://flutter.dev/',
          controller: BrowserController(
            userAgent: 'Your user agent',
          )
        ),
      ),
    ),
  ));
}
```

## Accessing WebViewController
To access [WebViewController](https://pub.dev/documentation/webview_flutter/latest/webview_flutter/WebViewController-class.html)
by using [browserController.webViewController](https://pub.dev/documentation/web_browser/latest/web_browser/BrowserController/webViewController.html).