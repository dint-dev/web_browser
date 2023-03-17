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

import '../../material.dart';
import '../../web_browser.dart';

/// A Material design web browser navigation bar.
class MaterialBrowserBottomBar extends StatefulWidget {
  final List<Widget>? leadingButtons;
  final List<Widget>? trailingButtons;
  final EdgeInsets buttonPadding;

  const MaterialBrowserBottomBar({
    super.key,
    this.leadingButtons,
    this.trailingButtons,
    this.buttonPadding = const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 3,
    ),
  });

  @override
  State<StatefulWidget> createState() {
    return _MaterialBrowserBottomBarState();
  }
}

class _MaterialBrowserBottomBarState extends State<MaterialBrowserBottomBar> {
  @override
  Widget build(BuildContext context) {
    final leadingButtons = widget.leadingButtons ??
        const [
          if (!kIsWeb) MaterialBrowserBackButton(),
          if (!kIsWeb) MaterialBrowserForwardButton(),
          MaterialBrowserRefreshButton(),
        ];
    final trailingButtons = widget.trailingButtons ??
        [
          if (Browser.of(context).widget.onShare != null)
            const MaterialBrowserShareButton(),
        ];
    final row = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...leadingButtons.map((button) {
          return Padding(
            padding: widget.buttonPadding,
            child: button,
          );
        }),
        const Spacer(),
        ...trailingButtons.map((button) {
          return Padding(
            padding: widget.buttonPadding,
            child: button,
          );
        }),
      ],
    );
    if (!kIsWeb) {
      return row;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MaterialBrowserBottomShareDialog(
          isOpen: Browser.of(context).isBottomShareDialogOpen,
        ),
        row,
      ],
    );
  }
}
