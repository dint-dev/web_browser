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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../web_browser.dart';

/// A Cupertino design "share" dialog.
class CupertinoBrowserBottomShareDialog extends StatelessWidget {
  final bool isOpen;

  const CupertinoBrowserBottomShareDialog({
    super.key,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    final browser = Browser.of(context);
    final uri = browser.controller.uriString;
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: browser.isBottomShareDialogOpen ? null : 0,
          alignment: Alignment.topRight,
          padding: const EdgeInsets.all(10),
          child: CupertinoButton(
            child: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: uri));
            },
          ),
        ),
      ),
    );
  }
}
