import 'package:flutter/material.dart';
import 'package:web_browser/web_browser.dart';

void main() {
  // const app = CupertinoApp(
  //   title: 'Example',
  //   home: CupertinoPageScaffold(
  //     child: SafeArea(
  //       child: Browser(
  //         initialUriString: 'https://dart.dev/',
  //         policy: BrowserPolicy(
  //           allowedDomains: {
  //             // Allow navigation to flutter.dev and any subdomain.
  //             // Other websites will be opened in the user's browser.
  //             '**.flutter.dev',
  //
  //             // And some other websites...
  //             '**.dart.dev',
  //             '**.youtube.com',
  //           },
  //         ),
  //       ),
  //     ),
  //   ),
  // );
  const app = MaterialApp(
    title: 'Example',
    home: Scaffold(
      body: SafeArea(
        child: Browser(
          initialUriString: 'https://dart.dev/',
          policy: BrowserPolicy(
            allowedDomains: {
              // Allow navigation to flutter.dev and any subdomain.
              // Other websites will be opened in the user's browser.
              '**.flutter.dev',

              // And some other websites...
              '**.dart.dev',
              '**.youtube.com',
            },
          ),
        ),
      ),
    ),
  );

  runApp(app);
}
