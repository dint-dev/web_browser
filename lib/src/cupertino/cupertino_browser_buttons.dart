// Copyright 2020-2023 Gohilla Ltd.
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
import 'package:web_browser/web_browser.dart';

import '../../cupertino.dart';

/// A Cupertino design "Back" button used by [CupertinoBrowserBottomBar].
class CupertinoBrowserBackButton extends StatelessWidget {
  const CupertinoBrowserBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Browser.of(context).controller;
    return CupertinoButton(
      onPressed: controller.canGoBack
          ? () {
              controller.goBack(fixRedirectIssues: true);
            }
          : null,
      child: const Icon(CupertinoIcons.back),
    );
  }
}

/// A Cupertino design "Forward" button used by [CupertinoBrowserBottomBar].
class CupertinoBrowserForwardButton extends StatelessWidget {
  const CupertinoBrowserForwardButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Browser.of(context).controller;
    return CupertinoButton(
      onPressed: controller.canGoForward
          ? () {
              controller.goForward();
            }
          : null,
      child: const Icon(CupertinoIcons.forward),
    );
  }
}

/// A Cupertino design "refresh" button used by [CupertinoBrowserBottomBar].
class CupertinoBrowserRefreshButton extends StatelessWidget {
  const CupertinoBrowserRefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Browser.of(context).controller;
    return CupertinoButton(
      child: const Icon(CupertinoIcons.refresh),
      onPressed: () {
        controller.refresh();
      },
    );
  }
}

/// A Cupertino design "share" button used by [CupertinoBrowserBottomBar].
class CupertinoBrowserShareButton extends StatelessWidget {
  const CupertinoBrowserShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    final browser = Browser.of(context);
    final callback = browser.widget.onShare;
    return CupertinoButton(
      child: const Icon(CupertinoIcons.share),
      onPressed: () {
        callback!(context, browser.controller);
      },
    );
  }
}
