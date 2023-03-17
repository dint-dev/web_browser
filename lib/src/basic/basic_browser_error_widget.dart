import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A widget that may be used to replace [WebViewWidget] when an error occurs.
class BasicBrowserErrorWidget extends StatelessWidget {
  final Widget? title;
  final Widget? body;
  final Widget? refreshButton;

  const BasicBrowserErrorWidget({
    required this.title,
    required this.body,
    this.refreshButton,
    super.key,
  });

  factory BasicBrowserErrorWidget.fromError({
    required BuildContext context,
    required WebResourceError error,
    required Widget? refreshButton,
  }) {
    return BasicBrowserErrorWidget(
      title: const Text(
        'Could not reach the website :(',
        textAlign: TextAlign.center,
      ),
      body: Column(
        children: [
          if (kDebugMode)
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'For debugging:\n${error.description}',
                  textAlign: TextAlign.center,
                )),
          if (refreshButton != null) refreshButton,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = this.title;
    final body = this.body;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 60,
      ),
      child: Column(
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: DefaultTextStyle(
                style: theme.textTheme.headlineSmall ?? const TextStyle(),
                child: title,
              ),
            ),
          if (body != null) body,
        ],
      ),
    );
  }
}
