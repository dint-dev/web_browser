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
  /// How often to cookies and other caches are cleared by default (for privacy
  /// reasons).
  ///
  /// If null, the cache is never cleaned. The default is currently 1 day, but
  /// we could make it shorter or longer in a future version.
  ///
  /// This is a global variable because the underlying platform APIs don't have
  /// good support for per-browser clearing.
  static Duration? globalStateExpiration = const Duration(days: 1);
  static final _globalStateExpirationStopwatch = Stopwatch()..start();
  static bool resetGlobalStateAtStart = true;
  static int _globalStateVersion = 0;
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

  /// If this is less than [_globalStateVersion], we need to clear cache.
  int _stateVersion = _globalStateVersion;

  BrowserController({
    String uriString = '',
    String? userAgent,
    WebViewController? webViewController,
    this.webViewNavigationDelegate,
    bool isZoomEnabled = true,
  })  : _uriString = uriString,
        _userAgent = userAgent,
        _webViewController = webViewController ?? WebViewController() {
    _maybeClearState();
    try {
      _webViewController.setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) async {
          await _maybeClearState();
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
      _isZoomEnabled = isZoomEnabled;
      _webViewController.enableZoom(isZoomEnabled);
    } catch (error) {
      // Ignore error
    }
  }

  /// Whether [goBack] may succeed.
  bool get canGoBack => !kIsWeb && _canGoBack;

  /// Whether [goForward] may succeed.
  bool get canGoForward => !kIsWeb && _canGoForward;

  /// Returns the current error (if any).
  WebResourceError? get error => _error;

  /// Tells whether the controller is loading a page.
  ///
  /// This is ignored in browsers.
  bool get isLoading => _isLoading;

  /// Tells whether real navigation events are received.
  bool get isNavigationEventsReceived => !kIsWeb;

  /// Determines whether zooming is enabled.
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

  /// Makes browser go back in the browser history.
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

  /// Makes browser go forward in the browser history.
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

  /// Makes browser go to the specified URI.
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

  /// Checks whether the cache should be cleared.
  Future<void> _maybeClearState() async {
    if (_globalStateVersion == 0 && resetGlobalStateAtStart) {
      clearEverything();
    } else {
      final stopwatch = _globalStateExpirationStopwatch;
      final expiration = globalStateExpiration;
      if (expiration != null &&
          stopwatch.elapsedMilliseconds > expiration.inMilliseconds) {
        await clearEverything();
      }
    }
    if (_stateVersion < _globalStateVersion) {
      _stateVersion = _globalStateVersion;
      try {
        _webViewController.clearLocalStorage();
      } catch (e) {
        // Ignore error
      }
      try {
        _webViewController.clearCache();
      } catch (e) {
        // Ignore error
      }
    }
  }

  void _maybeFakeNavigationEvents(String uri) {
    if (!isNavigationEventsReceived) {
      _onPageStarted.add(uri);
      _onPageFinished.add(uri);
    }
  }

  /// Clears all persistent state, including cookies, caches, and local
  /// storage.
  static Future<void> clearEverything() async {
    // Increment state so caches will be cleared
    _globalStateVersion++;

    // Reset stopwatch
    _globalStateExpirationStopwatch.reset();

    // Clear cookies in all web view instances.
    try {
      final instance = WebViewPlatform.instance;
      if (instance != null) {
        final cookieManager = instance.createPlatformCookieManager(
          const PlatformWebViewCookieManagerCreationParams(),
        );
        await cookieManager.clearCookies();
      }
    } catch (error, stackTrace) {
      assert(false, '$error\n\n$stackTrace');
      // Ignore error
    }
  }
}
