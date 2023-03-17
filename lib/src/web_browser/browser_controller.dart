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

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../web_browser.dart';

/// Controls [Browser].
class BrowserController extends ChangeNotifier {
  static bool get _isAndroid => !kIsWeb && Platform.isAndroid;
  final _onPageStarted = StreamController<String>.broadcast();

  final _onPageFinished = StreamController<String>.broadcast();
  bool _isLoading = false;
  String? _userAgent;
  String _uriString = '';
  Uri? _uri;
  bool _canGoBack = true;
  bool _canGoForward = true;

  final WebViewController _webViewController;

  /// Optional delegate for listening to navigation events.
  @protected
  final NavigationDelegate? webViewNavigationDelegate;

  WebResourceError? _error;

  BrowserPolicy? policy;
  bool _isZoomEnabled = true;

  BrowserController({
    String uriString = '',
    String? userAgent,
    WebViewController? webViewController,
    this.webViewNavigationDelegate,
  })  : _uriString = uriString,
        _userAgent = userAgent,
        _webViewController = webViewController ?? WebViewController() {
    try {
      _webViewController.setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) async {
          final result = await webViewNavigationDelegate?.onNavigationRequest
              ?.call(request);
          if (result != null && result == NavigationDecision.prevent) {
            return result;
          }
          final policy = this.policy;
          if (policy != null && request.isMainFrame) {
            final parsedUri = Uri.tryParse(request.url);
            if (parsedUri == null) {
              return NavigationDecision.navigate;
            }
            if (!policy.isUriAllowed(parsedUri)) {
              return NavigationDecision.prevent;
            }
          }
          return NavigationDecision.navigate;
        },
        onPageStarted: (uri) {
          _uriString = uri;
          _isLoading = true;

          // By default, assume this was a navigation to a new page.
          _canGoBack = true;
          _canGoForward = false;

          if (!kIsWeb) {
            try {
              if (_isAndroid) {
                _webViewController.canGoBack().then((value) {
                  if (value != _canGoBack) {
                    _canGoBack = value;
                    notifyListeners();
                  }
                }, onError: (error) {});
              }
              _webViewController.canGoForward().then((value) {
                if (value != _canGoForward) {
                  _canGoForward = value;
                  notifyListeners();
                }
              }, onError: (error) {});
            } catch (error) {
              // Ignore error
            }
          }

          notifyListeners();

          webViewNavigationDelegate?.onPageStarted?.call(uri);
        },
        onProgress: (progress) {
          notifyListeners();
          webViewNavigationDelegate?.onProgress?.call(progress);
        },
        onPageFinished: (uri) {
          _uriString = uri;
          _isLoading = false;
          notifyListeners();
          webViewNavigationDelegate?.onPageFinished?.call(uri);
        },
        onWebResourceError: (error) {
          if (error.isForMainFrame ?? true) {
            _error = error;
            _isLoading = false;
            notifyListeners();
          }
          webViewNavigationDelegate?.onWebResourceError?.call(error);
        },
      ));
    } catch (error) {
      // Ignore
    }
    try {
      _webViewController.setJavaScriptMode(
        JavaScriptMode.unrestricted,
      );
    } on UnimplementedError {
      // Ignore errors in browser
    }
    try {
      _webViewController.enableZoom(true);
    } catch (error) {
      // Ignore error
    }
  }

  /// Whether [goBack] may succeed.
  bool get canGoBack => !kIsWeb && _canGoBack;

  /// Whether [goForward] may succeed.
  bool get canGoForward => !kIsWeb && _canGoForward;

  WebResourceError? get error => _error;

  bool get isLoading => _isLoading;

  /// Whether real navigation events are received from the browser.
  bool get isNavigationEventsReceivedFromBrowser => !kIsWeb;

  bool get isZoomEnabled => _isZoomEnabled;

  set isZoomEnabled(bool newValue) {
    if (newValue != _isZoomEnabled) {
      _isZoomEnabled = newValue;
      _webViewController.enableZoom(newValue);
      notifyListeners();
    }
  }

  /// Broadcast stream of page loads that finished.
  ///
  /// The stream will be closed when [dispose] is called.
  Stream<String> get onPageFinished => _onPageFinished.stream;

  /// Broadcast stream of page loads that started.
  ///
  /// The stream will be closed when [dispose] is called.
  Stream<String> get onPageStarted => _onPageStarted.stream;

  /// Parsed [uriString].
  Uri get uri => _uri ??= Uri.parse(uriString);

  /// Current URI string.
  String get uriString => _uriString;

  /// User agent string.
  ///
  /// This is ignored in browsers.
  String? get userAgent => _userAgent;

  set userAgent(String? newValue) {
    _userAgent = newValue;
    try {
      _webViewController.setUserAgent(newValue);
    } catch (error) {
      // Ignore error
    }
    notifyListeners();
  }

  /// Web view controller NOT meant to be used developers directly.
  WebViewController get webViewController => _webViewController;

  @override
  void dispose() {
    super.dispose();
    _onPageStarted.close();
    _onPageFinished.close();
  }

  /// Go back in the browser history.
  bool goBack({bool fixRedirectIssues = false}) {
    final result = canGoBack;
    try {
      _webViewController.goBack();
    } catch (error) {
      // Ignore error
    }
    _canGoBack = true;
    _canGoForward = true;
    notifyListeners();
    return result;
  }

  /// Go forward in the browser history.
  bool goForward() {
    final result = canGoForward;
    try {
      _webViewController.goForward();
    } catch (error) {
      // Ignore error
    }
    _canGoBack = true;
    _canGoForward = true;
    notifyListeners();
    return result;
  }

  /// Go to the specified URI.
  ///
  /// If the URL is the same, does nothing.
  void goTo(String uri) {
    if (uri != uriString) {
      if (kIsWeb) {
        _error = null;
      }
      _isLoading = true;
      final parsedUri = Uri.parse(uri);
      _webViewController.loadRequest(parsedUri);
      _uriString = uri;
      _canGoBack = true;
      _canGoForward = false;
      _maybeFakeNavigationEvents(uri);
      notifyListeners();
    }
  }

  /// Refreshes the current page.
  void refresh() {
    if (kIsWeb) {
      _error = null;
    }
    _isLoading = true;
    if (kIsWeb) {
      webViewController.loadRequest(uri);
    } else {
      webViewController.reload();
    }
    _maybeFakeNavigationEvents(uriString);
    notifyListeners();
  }

  void _maybeFakeNavigationEvents(String uri) {
    if (!isNavigationEventsReceivedFromBrowser) {
      _onPageStarted.add(uri);
      _onPageFinished.add(uri);
    }
  }
}
