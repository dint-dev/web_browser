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

import 'package:flutter/cupertino.dart';
import 'package:web_browser/src/web_browser/browser.dart';

/// Localizations for [Browser].
class BrowserLocalizations {
  final String back;

  final String forward;
  final String refresh;
  final String copy;

  const BrowserLocalizations({
    this.back = 'Back',
    this.forward = 'Forward',
    this.copy = 'Copy',
    this.refresh = 'Refresh',
  });

  /// Constructs [LocalizationsDelegate] for the localization.
  static LocalizationsDelegate<BrowserLocalizations> newDelegate(
      Locale locale, BrowserLocalizations localizations) {
    return _BrowserLocalizationsDelegate(locale, localizations);
  }
}

class _BrowserLocalizationsDelegate
    extends LocalizationsDelegate<BrowserLocalizations> {
  final Locale locale;
  final BrowserLocalizations localizations;

  _BrowserLocalizationsDelegate(this.locale, this.localizations);

  @override
  bool isSupported(Locale locale) {
    return locale == this.locale ||
        locale.languageCode == this.locale.languageCode &&
            this.locale.countryCode == null;
  }

  @override
  Future<BrowserLocalizations> load(Locale locale) async {
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<BrowserLocalizations> old) {
    return false;
  }
}
