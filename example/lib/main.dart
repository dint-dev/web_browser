import 'package:flutter/cupertino.dart';
import 'package:web_browser/web_browser.dart';

void main() {
  const app = CupertinoApp(
    title: 'Example',
    debugShowCheckedModeBanner: false,
    home: CupertinoPageScaffold(
      child: SafeArea(
        child: Browser(
          initialUriString: 'https://flutter.dev/',
        ),
      ),
    ),
  );
  // const app = MaterialApp(
  //   title: 'Example',
  //   debugShowCheckedModeBanner: false,
  //   home: Scaffold(
  //     body: SafeArea(
  //       child: Browser(
  //         initialUriString: 'https://flutter.dev/',
  //       ),
  //     ),
  //   ),
  // );

  runApp(app);
}
