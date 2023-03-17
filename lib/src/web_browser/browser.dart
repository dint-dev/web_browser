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
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import 'package:webview_flutter/webview_flutter.dart';

import '../../auto.dart';
import '../../basic.dart';
import '../../web_browser.dart';

/// A web browser widget with navigation buttons and other features.
///
/// ## Example
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:web_browser/web_browser.dart';
///
/// void main() {
///   runApp(
///     const MaterialApp(
///       title: 'Example',
///       home: Scaffold(
///         body: SafeArea(
///           child: Browser(
///             initialUriString: 'https://dart.dev/',
///           ),
///         ),
///       ),
///     ),
///   );
/// }
/// ```
class Browser extends StatefulWidget {
  /// Initial URL.
  final String? initialUriString;

  /// Browser controller.
  final BrowserController? controller;

  /// A whitelist for restricting navigation to specific domains.
  final BrowserPolicy? policy;

  /// Widget above the browser.
  final Widget? topBar;

  /// Enables you to replace the browser content with any Flutter widget for
  /// specific URLs.
  ///
  /// If null, the normal behavior is not changed.
  final Widget Function(
    BuildContext context,
    BrowserController controller,
    Widget webView,
  )? contentBuilder;

  /// Enables you to replace the default error displaying function.
  ///
  /// The default is [defaultOnError].
  final Widget Function(BuildContext context, BrowserController controller,
      WebResourceError error) onError;

  /// Widget below the browser.
  final Widget? bottomBar;

  /// Callback when user presses a "share" button.
  ///
  /// If null, no share button should be shown.
  ///
  /// The default is [defaultOnShare].
  final void Function(BuildContext context, BrowserController controller)?
      onShare;

  const Browser({
    Key? key,
    required this.initialUriString,
    this.controller,
    this.policy,
    this.topBar = const AutoBrowserTopBar(),
    this.contentBuilder,
    this.bottomBar = const AutoBrowserBottomBar(),
    this.onShare = defaultOnShare,
    this.onError = defaultOnError,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BrowserState();
  }

  /// Default callback for [onError].
  static Widget defaultOnError(BuildContext context,
      BrowserController controller, WebResourceError error) {
    final localizations = Localizations.of<BrowserLocalizations>(
          context,
          BrowserLocalizations,
        ) ??
        const BrowserLocalizations();
    final label = Text(localizations.tryAgain);
    void onPressed() {
      Browser.of(context).controller.refresh();
    }

    return BasicBrowserErrorWidget.fromError(
      context: context,
      error: error,
      refreshButton: isCupertinoDesignPreferred(context)
          ? CupertinoButton(
              onPressed: onPressed,
              child: label,
            )
          : MaterialButton(
              onPressed: onPressed,
              child: label,
            ),
    );
  }

  /// Default callback for [onShare].
  static void defaultOnShare(
      BuildContext context, BrowserController controller) {
    if (kIsWeb) {
      final browser = Browser.of(context);
      browser.isBottomShareDialogOpen = !browser.isBottomShareDialogOpen;
      return;
    }
    final box = context.findRenderObject() as RenderBox?;
    share_plus.Share.share(
      controller.uriString,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  /// Returns [BrowserState] of the ancestor.
  ///
  /// Useful for navigation buttons and other parts of the browser UI.
  ///
  /// The methods also makes the context depend on the browser URL.
  static BrowserState of(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<_BrowserInherited>();
    return context.findAncestorStateOfType<BrowserState>()!;
  }
}

/// State of [Browser].
class BrowserState extends State<Browser> {
  /// [BrowserController] of this widget.
  late BrowserController controller;

  final _webViewWidgetKey = GlobalKey();
  Object _stateKey = Object();
  bool _isBottomShareDialogOpen = false;
  bool get isBottomShareDialogOpen => _isBottomShareDialogOpen;

  set isBottomShareDialogOpen(bool newValue) {
    setState(() {
      _isBottomShareDialogOpen = newValue;
      _stateKey = Object();
    });
  }

  @override
  Widget build(BuildContext context) {
    final topBar = widget.topBar;
    final bottomBar = widget.bottomBar;

    Widget result = _BrowserInherited(
      state: _stateKey,
      child: Column(
        children: [
          // Top bar
          if (topBar != null) topBar,

          // Actual browser
          Expanded(
            key: const ValueKey(#webView),
            child: _webView(context),
          ),

          // Bottom bar
          if (bottomBar != null) bottomBar,
        ],
      ),
    );
    return result;
  }

  @override
  void didUpdateWidget(covariant Browser oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!identical(widget.controller, oldWidget.controller)) {
      controller = widget.controller ?? controller;
      controller.policy = widget.policy;

      final oldWidgetController = oldWidget.controller;
      final newWidgetController = widget.controller;
      if (oldWidgetController != null && newWidgetController != null) {
        oldWidgetController.removeListener(_controllerListener);
        newWidgetController.addListener(_controllerListener);
      }
    }

    // Does this behavior make sense?
    // I'm not sure.
    final initialUri = widget.initialUriString;
    if (initialUri != null && initialUri != oldWidget.initialUriString) {
      controller.goTo(initialUri);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_controllerListener);
  }

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? BrowserController();
    controller.policy = widget.policy;
    final initialUri = widget.initialUriString;
    if (initialUri != null) {
      controller.goTo(initialUri);
    }
    controller.addListener(_controllerListener);
  }

  void _controllerListener() {
    setState(() {
      _stateKey = Object();
    });
  }

  Widget _webView(BuildContext context) {
    final error = controller.error;
    if (error != null) {
      return Builder(
        builder: (context) => widget.onError(context, controller, error),
      );
    }
    Widget webView = WebViewWidget(
      key: _webViewWidgetKey,
      controller: controller.webViewController,
    );

    final contentBuilder = widget.contentBuilder;
    if (contentBuilder != null) {
      webView = contentBuilder(context, controller, webView);
    }

    return webView;
  }
}

/// Makes [Browser.of] callers depend on the URL.
class _BrowserInherited extends InheritedWidget {
  final Object state;

  const _BrowserInherited({
    Key? key,
    required Widget child,
    required this.state,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant _BrowserInherited oldWidget) {
    return state != oldWidget.state;
  }
}
