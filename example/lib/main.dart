import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_browser/web_browser.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Example',
      home: Scaffold(
        body: SafeArea(
          child: WebBrowser(
            initialUrl: 'https://dart.dev/',
          ),
        ),
      ),
    ),
  );
}
