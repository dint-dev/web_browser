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

import 'package:flutter/material.dart';

import '../../web_browser.dart';

String _maybeStartWithEllipsis(String host, int n) {
  if (host.length > n) {
    return '…${host.substring(host.length - n, host.length)}';
  }
  return host;
}

/// A helper for building web browser address bars.
///
/// The widget displays only the domain of the website in the top bar,
/// which helps protect users if they navigate to pages such as
/// "https://www.your-trustworthy-bank.com.before.invisible.phishing-domain.com/".
class BasicBrowserAddressField extends StatelessWidget {
  /// Padding.
  final EdgeInsetsGeometry padding;
  final int maxDomainCodePoints;

  const BasicBrowserAddressField({
    Key? key,
    this.padding = const EdgeInsets.symmetric(
      vertical: 5,
    ),
    this.maxDomainCodePoints = 32,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(
        vertical: 3,
      ),
      padding: padding,
      child: _text(context),
    );
  }

  String _displayableUri(String s) {
    var uri = Uri.parse(s);
    var host = uri.host;
    final n = maxDomainCodePoints;
    if (host.isEmpty || uri.scheme != 'https') {
      return _maybeStartWithEllipsis(s, n);
    }
    // We can remove the common "www" prefix in some cases.
    // The full public suffix is very long and has things like three-part
    // suffixes.
    if (host.startsWith('www')) {
      const wwwSafeSuffixes = [
        '.co.br',
        '.co.id',
        '.co.in',
        '.co.jp',
        '.co.kr',
        '.co.uk',
        '.com.au',
        '.com.sg',
        '.com',
        '.de',
        '.dev',
        '.fi',
        '.it',
        '.gov',
        '.net',
        '.nl',
        '.org',
        '.se',
      ];
      for (var suffix in wwwSafeSuffixes) {
        if (host.endsWith(suffix) && host.length > 3 + suffix.length) {
          host = host.substring(4);
        }
      }
    }
    return _maybeStartWithEllipsis(host, n);
  }

  Widget _text(BuildContext context) {
    final controller = Browser.of(context).controller;
    final displayedUri = _displayableUri(
      controller.uriString,
    );
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SizedBox(
            width: 15,
            height: 15,
            child:
                controller.isLoading ? const CircularProgressIndicator() : null,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 25),
          child: Text(
            displayedUri,
            style: (theme.textTheme.labelMedium ?? const TextStyle())
                .copyWith(fontWeight: FontWeight.bold),
            // We don't want the system's preferred text size to impact the
            // size.
            textScaleFactor: 1.2,

            // Is there a way to have ellipsis in the start?
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class BrowserAddressFieldDetails {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onEditingComplete;
  final void Function(String value) onSubmitted;
  final void Function(PointerDownEvent event) onTapOutside;

  BrowserAddressFieldDetails({
    required this.controller,
    required this.focusNode,
    required this.onEditingComplete,
    required this.onSubmitted,
    required this.onTapOutside,
  });
}
