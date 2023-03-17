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

import '../../cupertino.dart';
import '../../material.dart';

/// Browser bar that automatically chooses either [CupertinoBrowserBottomDialog] or
/// [MaterialBrowserBottomDialog] depending on the ancestor widgets.
///
/// If your app uses [CupertinoApp], [CupertinoBrowserBottomDialog] will be
/// selected. Otherwise [MaterialBrowserBottomDialog] will be selected.
class AutoBrowserBottomShareDialog extends StatelessWidget {
  final bool isOpen;

  const AutoBrowserBottomShareDialog({
    super.key,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    final isCupertino =
        context.findAncestorWidgetOfExactType<CupertinoApp>() != null;
    if (isCupertino) {
      return CupertinoBrowserBottomShareDialog(
        isOpen: isOpen,
      );
    }
    return MaterialBrowserBottomShareDialog(
      isOpen: isOpen,
    );
  }
}
