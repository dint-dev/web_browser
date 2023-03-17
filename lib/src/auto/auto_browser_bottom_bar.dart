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

import '../cupertino/cupertino_browser_bottom_bar.dart';
import '../material/material_browser_bottom_bar.dart';

/// Determines whether Cupertino design should be used.
bool isCupertinoDesignPreferred(BuildContext context) {
  return context.findAncestorWidgetOfExactType<CupertinoApp>() != null;
}

/// Browser bar that automatically chooses either [CupertinoBrowserBottomBar] or
/// [MaterialBrowserBottomBar] depending on the ancestor widgets.
///
/// If your app uses [CupertinoApp], [CupertinoBrowserBottomBar] will be selected.
/// Otherwise [MaterialBrowserBottomBar] will be selected.
class AutoBrowserBottomBar extends StatelessWidget {
  const AutoBrowserBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    if (isCupertinoDesignPreferred(context)) {
      return const CupertinoBrowserBottomBar();
    }
    return const MaterialBrowserBottomBar();
  }
}
