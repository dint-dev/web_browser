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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web_browser/cupertino.dart';

/// A Cupertino design web browser navigation bar.
class CupertinoBrowserTopBar extends StatefulWidget {
  final List<Widget> leadingButtons;
  final List<Widget> trailingButtons;

  /// Whether to show address when using iframe (default: false).
  ///
  /// Because we don't get navigation events from iframe and therefore don't
  /// know the real URI, displaying the URI could make users vulnerable to
  /// phishing.
  final bool showAddressWhenUsingIframe;

  const CupertinoBrowserTopBar({
    super.key,
    this.leadingButtons = const [],
    this.trailingButtons = const [],
    this.showAddressWhenUsingIframe = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _CupertinoBrowserTopBarState();
  }
}

class _CupertinoBrowserTopBarState extends State<CupertinoBrowserTopBar> {
  @override
  Widget build(BuildContext context) {
    if (kIsWeb && !widget.showAddressWhenUsingIframe) {
      return const SizedBox();
    }
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...widget.leadingButtons,
          const Expanded(
            child: CupertinoBrowserAddressField(),
          ),
          ...widget.trailingButtons,
        ],
      ),
    );
  }
}
