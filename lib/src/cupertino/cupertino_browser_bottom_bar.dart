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
import 'package:flutter/foundation.dart';

import '../../cupertino.dart';
import '../../web_browser.dart';

/// A Cupertino design web browser navigation bar.
class CupertinoBrowserBottomBar extends StatefulWidget {
  final List<Widget>? leadingButtons;
  final List<Widget>? trailingButtons;
  final EdgeInsets buttonPadding;

  const CupertinoBrowserBottomBar({
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
    return _CupertinoBrowserBottomBarState();
  }
}

class _CupertinoBrowserBottomBarState extends State<CupertinoBrowserBottomBar> {
  @override
  Widget build(BuildContext context) {
    final leadingButtons = widget.leadingButtons ??
        const [
          if (!kIsWeb) CupertinoBrowserBackButton(),
          if (!kIsWeb) CupertinoBrowserForwardButton(),
          CupertinoBrowserRefreshButton(),
        ];
    final trailingButtons = widget.trailingButtons ??
        [
          if (Browser.of(context).widget.onShare != null)
            const CupertinoBrowserShareButton(),
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
        CupertinoBrowserBottomShareDialog(
          isOpen: Browser.of(context).isBottomShareDialogOpen,
        ),
        row,
      ],
    );
  }
}
