import 'package:flutter/material.dart';

import 'package:universal_platform/universal_platform.dart';
import 'package:webview_cef/webview_cef.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import 'package:webview_windows/webview_windows.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;

import 'stubs/webview_web_stub.dart' if (dart.library.html) 'views/webview_web.dart';

/// Controller for the Fireview widget
class FireviewController {
  dynamic realController;

  /// Navigate to the given [url]
  Future<void> loadUrl(Uri url) async {
    if (UniversalPlatform.isWindows) {
      await (realController as WebviewController).loadUrl(url.toString());
    } else if (UniversalPlatform.isLinux) {
      await (realController as WebViewController).loadUrl(url.toString());
    } else if (UniversalPlatform.isMobile || UniversalPlatform.isWeb) {
      (realController as webview.WebViewController).loadRequest(url);
    }
  }

  /// Evaluate the given [code] in the webview
  Future<dynamic> evaluateJavascript(String code) async {
    if (UniversalPlatform.isWindows) {
      return (realController as WebviewController).executeScript(code);
    } else if (UniversalPlatform.isLinux) {
      return (realController as WebViewController).evaluateJavascript(code);
    }
  }

  /// Navigate back in the webview
  void goBack() {
    if (UniversalPlatform.isWindows) {
      (realController as WebviewController).goBack();
    }
  }

  /// Navigate forward in the webview
  void goForward() {
    if (UniversalPlatform.isWindows) {
      (realController as WebviewController).goForward();
    }
  }

  /// Initialize the webview
  Future<void> initialize(Uri url) async {
    if (UniversalPlatform.isWindows) {
      realController = WebviewController();
      await (realController as WebviewController).initialize();
      return await loadUrl(url);
    } else if (UniversalPlatform.isLinux) {
      realController = WebviewManager()
          .createWebView(loading: const Text("Webview has not been initialized..."));
      await WebviewManager().initialize();

      return await (realController as WebViewController)
          .initialize(url.toString());
    } else if (UniversalPlatform.isWeb) {
      late final PlatformWebViewController platform;
      if (WebViewPlatform.instance is WebWebViewPlatform) {
        platform = WebWebViewController(const WebWebViewControllerCreationParams());
      } else {
        platform = PlatformWebViewController(
            const PlatformWebViewControllerCreationParams());
      }
      realController = webview.WebViewController.fromPlatform(platform);
    } else if (UniversalPlatform.isMobile) {
      webview.WebViewController controller = webview.WebViewController();
      realController = controller;

      print("loading URL on mobile!");
      print(url);
      loadUrl(url);

      realController = controller;
    }
    return Future.value();
  }
}