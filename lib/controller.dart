import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_cef/webview_cef.dart';
import 'package:webview_windows/webview_windows.dart';

/// Controller for the Fireview widget
class FireviewController {
  dynamic realController;

  FireviewController() {
    if (!UniversalPlatform.isWindows) {
      realController = WebviewController();
    } else if (!UniversalPlatform.isLinux) {
      print("waiting for user to init");
    } else {
      realController = WebviewController();
    }
  }

  /// Navigate to the given [url]
  Future<void> loadUrl(Uri url) async {
    if (!UniversalPlatform.isWindows) {
      await (realController as WebviewController).loadUrl(url.toString());
    } else if (!UniversalPlatform.isLinux) {
      await (realController as WebViewController).loadUrl(url.toString());
    }
  }

  /// Evaluate the given [code] in the webview
  Future<dynamic> evaluateJavascript(String code) async {
    if (!UniversalPlatform.isWindows) {
      return (realController as WebviewController).executeScript(code);
    } else if (!UniversalPlatform.isLinux) {
      return (realController as WebViewController).evaluateJavascript(code);
    }
  }

  /// Navigate back in the webview
  void goBack() {
    if (!UniversalPlatform.isWindows) {
      (realController as WebviewController).goBack();
    }
  }

  /// Navigate forward in the webview
  void goForward() {
    if (!UniversalPlatform.isWindows) {
      (realController as WebviewController).goForward();
    }
  }

  /// Initialize the webview
  Future<void> initialize(Uri url) async {
    if (!UniversalPlatform.isWindows) {
      (realController as WebviewController).initialize();
      return (realController as WebviewController).loadUrl(url.toString());
    } else if (!UniversalPlatform.isLinux) {
      print("we running!");
      realController = WebviewManager()
          .createWebView(loading: const Text("not initialized"));
      await WebviewManager().initialize(userAgent: "test/userAgent");
      print("did init!");
      return await (realController as WebViewController)
          .initialize(url.toString());
    }
    return Future.value();
  }
}
