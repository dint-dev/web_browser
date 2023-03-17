// Copyright 2020-2023 Gohilla.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:web_browser/src/web_browser/browser.dart';

/// Localizations for [Browser].
///
/// ## Example
/// ```dart
/// void main() {
///   runApp(MaterialApp(
///     localizations: [
///       ...browserLocalizationsList,
///       // ...
///     ],
///     // ...
///   ));
/// }
///
///
/// final browserLocalizationsList = [
///   // Spanish localization
///   BrowserLocalizations.forLocale(
///     locale: Locale('es'),
///     load: (locale) async => BrowserLocalizations(
///       couldNotReach: 'No se pudo acceder al sitio web.',
///       // ...
///     ),
///   ),
/// ];
/// ```
class BrowserLocalizations {
  /// Tooltip for back button.
  final String back;

  /// Tooltip for forward button.
  final String forward;

  /// Tooltip for refresh button.
  final String refresh;

  /// Tooltip for sharing button.
  final String share;

  /// Text that is displayed when an error occurs.
  final String couldNotReach;

  /// Text for a button displayed when an error occurs.
  final String tryAgain;

  const BrowserLocalizations({
    this.back = 'Back',
    this.forward = 'Forward',
    this.refresh = 'Refresh',
    this.share = 'Share',
    this.couldNotReach = 'Could not reach the website.',
    this.tryAgain = 'Try again.',
  });

  /// Constructs [LocalizationsDelegate] for the locale.
  static LocalizationsDelegate<BrowserLocalizations> forLocale({
    required Locale locale,
    required FutureOr<BrowserLocalizations> Function(Locale locale) load,
  }) {
    return _BrowserLocalizationsDelegate(locale, load);
  }
}

class _BrowserLocalizationsDelegate
    extends LocalizationsDelegate<BrowserLocalizations> {
  final Locale locale;
  final FutureOr<BrowserLocalizations> Function(Locale locale) localizations;

  _BrowserLocalizationsDelegate(this.locale, this.localizations);

  @override
  bool isSupported(Locale locale) {
    return locale == this.locale ||
        (locale.languageCode == this.locale.languageCode &&
            this.locale.countryCode == null);
  }

  @override
  Future<BrowserLocalizations> load(Locale locale) async {
    return await localizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<BrowserLocalizations> old) {
    return false;
  }
}
