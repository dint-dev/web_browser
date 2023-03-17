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

/// A policy that determines whether a navigation request should be allowed.
///
/// ## Supported URI patterns
///   * "example.com" (domain)
///   * "*.example.com" (subdomain)
///   * "**.example.com" (domain or any depth subdomain)
///
/// ## Example
/// ```dart
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return const Browser(
///       policy: BrowserPolicy(
///         allowedDomains: {
///           'example.com',
///           '*.github.com',
///           '**.google.com',
///         },
///       ),
///     );
///   }
/// }
/// ```
class BrowserPolicy {
  /// Allowed domains.
  ///
  /// ## Example
  ///
  /// See documentation for the class [BrowserPolicy].
  final Set<String> allowedDomains;

  const BrowserPolicy({
    required this.allowedDomains,
  });

  /// Tells whether the URI is allowed.
  bool isUriAllowed(Uri uri) {
    final host = uri.host;
    if (host.isEmpty) {
      return false;
    }
    final patterns = allowedDomains;
    for (var pattern in patterns) {
      {
        final i = pattern.indexOf('://');
        if (i < 0) {
          if (uri.scheme != 'https') {
            continue;
          }
        } else {
          final patternScheme = pattern.substring(0, i);
          if (patternScheme != '*' && uri.scheme != patternScheme) {
            continue;
          }
          pattern = pattern.substring(i + 3);
        }
      }
      if (pattern.startsWith('**.')) {
        if (host.endsWith(pattern.substring(3))) {
          return true;
        }
      }
      if (pattern.startsWith('*.')) {
        if (host.endsWith(pattern.substring(2)) &&
            host.indexOf('.') == host.length - pattern.length + 1) {
          return true;
        }
      }
      // Allow all domains
      if (pattern == '**') {
        return true;
      }
      if (host == pattern) {
        return true;
      }
    }
    return false;
  }
}
