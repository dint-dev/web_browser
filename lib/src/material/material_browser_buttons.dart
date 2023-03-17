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
import 'package:web_browser/web_browser.dart';

/// A Material design "Back" button used by [MaterialBrowserBar].
class MaterialBrowserBackButton extends StatelessWidget {
  const MaterialBrowserBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Browser.of(context).controller;
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        size: 20,
      ),
      onPressed: controller.canGoBack
          ? () {
              controller.goBack(fixRedirectIssues: true);
            }
          : null,
    );
  }
}

/// A Material design "Forward" button used by [MaterialBrowserBar].
class MaterialBrowserForwardButton extends StatelessWidget {
  const MaterialBrowserForwardButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Browser.of(context).controller;
    return IconButton(
      icon: const Icon(
        Icons.arrow_forward,
        size: 20,
      ),
      onPressed: controller.canGoForward ? controller.goForward : null,
    );
  }
}

/// A Material design "refresh" button used by [MaterialBrowserBottomBar].
class MaterialBrowserRefreshButton extends StatelessWidget {
  const MaterialBrowserRefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Browser.of(context).controller;
    return MaterialButton(
      child: const Icon(Icons.refresh),
      onPressed: () {
        controller.refresh();
      },
    );
  }
}

/// A Material design "share" button used by [MaterialBrowserBar].
class MaterialBrowserShareButton extends StatelessWidget {
  const MaterialBrowserShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    final browser = Browser.of(context);
    final callback = browser.widget.onShare;
    return MaterialButton(
      child: const Icon(
        Icons.share,
        size: 20,
      ),
      onPressed: () {
        callback!(context, browser.controller);
      },
    );
  }
}
