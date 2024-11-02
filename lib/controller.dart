import 'dart:async';

import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_cef/webview_cef.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_windows/webview_windows.dart' as windows;
import 'package:webview_flutter/webview_flutter.dart' as webview;
import 'stubs/webview_web_stub.dart' if (dart.library.html) 'platforms/webview_web.dart';

/// Controller for the Fireview widget that provides a unified API across platforms
class FireviewController {
  dynamic realController;
  bool _isInitialized = false;
  
  final Map<String, void Function(String)> _jsChannels = {};

    // Stream controller for title updates
  final _titleController = StreamController<String?>.broadcast();

  /// Stream of title updates
  Stream<String?> get titleStream => _titleController.stream;

  final List<void Function(String?)> _titleChangeListeners = [];

  /// Get the initialization status
  bool get isInitialized => _isInitialized;

  /// Initialize the webview with the given [url] and optional settings
  Future<void> initialize(
    Uri url, {
    String? userAgent,
    Map<String, String> headers = const {},
  }) async {

    if (UniversalPlatform.isWindows) {
      realController = windows.WebviewController();
      await (realController as windows.WebviewController).initialize();
      if (userAgent != null) {
        await (realController as windows.WebviewController).setUserAgent(userAgent);
      }
      
      (realController as windows.WebviewController).title.listen((title) {
        _titleController.add(title);
      });
      
      await (realController as windows.WebviewController).addScriptToExecuteOnDocumentCreated('''
        window.chrome.webview.addEventListener('message', function(event) {
          if (event.data.channel && window[event.data.channel]) {
            window[event.data.channel].onMessage(event.data.message);
          }
        });
      ''');
      
      await loadUrl(url, headers: headers);
    } else if (UniversalPlatform.isLinux) {
      realController = WebviewManager()
          .createWebView(loading: const Text("Initializing webview..."));
      await WebviewManager().initialize(userAgent: userAgent);

      // Set up Linux title change listener
      (realController as WebViewController).listener?.onTitleChanged = (title) {
        _titleController.add(title);
      };

      await (realController as WebViewController).initialize(url.toString());
    } else if (UniversalPlatform.isWeb) {
      late final PlatformWebViewController platform;
      if (WebViewPlatform.instance is WebWebViewPlatform) {
        // ignore: prefer_const_constructors
        platform = WebWebViewController(WebWebViewControllerCreationParams());
      } else {
        platform = PlatformWebViewController(
            const PlatformWebViewControllerCreationParams());
      }
      realController = webview.WebViewController.fromPlatform(platform);
      
      // Set up Web title change listener
      await (realController as webview.WebViewController).setNavigationDelegate(
        webview.NavigationDelegate(
          onPageFinished: (url) async {
            final title = await getTitle();
            _titleController.add(title);
          },
        ),
      );
      
      if (userAgent != null) {
        await setUserAgent(userAgent);
      }
      await loadUrl(url, headers: headers);
    } else if (UniversalPlatform.isMobile) {
      webview.WebViewController controller = webview.WebViewController();
      await controller.setJavaScriptMode(
        // not every library supports enabling / disabling javascript
           webview.JavaScriptMode.unrestricted
      );
      
      // Set up Mobile title change listener
      await controller.setNavigationDelegate(
        webview.NavigationDelegate(
          onPageFinished: (url) async {
            final title = await getTitle();
            _titleController.add(title);
          },
        ),
      );
      
      if (userAgent != null) {
        await controller.setUserAgent(userAgent);
      }
      realController = controller;
      
      await loadUrl(url, headers: headers);
    }
    
    _isInitialized = true;
  }

  /// Add a listener for title changes
  void addTitleChangeListener(void Function(String?) onTitleChange) {
    _titleChangeListeners.add(onTitleChange);
  }

  /// Remove a title change listener
  void removeTitleChangeListener(void Function(String?) onTitleChange) {
    _titleChangeListeners.remove(onTitleChange);
  }

  /// Navigate to the given [url]
  Future<void> loadUrl(Uri url, {Map<String, String> headers = const {}}) async {
    if (UniversalPlatform.isWindows) {
      await (realController as windows.WebviewController).loadUrl(url.toString());
    } else if (UniversalPlatform.isLinux) {
      await (realController as WebViewController).loadUrl(url.toString());
    } else if (UniversalPlatform.isMobile || UniversalPlatform.isWeb) {
      await (realController as webview.WebViewController)
          .loadRequest(url, method: LoadRequestMethod.get, headers: headers);
    }
  }

  /// Set a cookie for the webview
  Future<void> setCookie(String domain, String name, String value) async {
    if (!_isInitialized) return;

    if (UniversalPlatform.isWindows) {
      await evaluateJavascript(
        "document.cookie='$name=$value;domain=$domain;path=/'"
      );
    } else if (UniversalPlatform.isLinux) {
      await WebviewManager().setCookie(domain, name, value);
    } else if (UniversalPlatform.isMobile || UniversalPlatform.isWeb) {
      await evaluateJavascript(
        "document.cookie='$name=$value;domain=$domain;path=/'"
      );
    }
  }


  /// Set the user agent string
  Future<void> setUserAgent(String userAgent) async {
    if (!_isInitialized) return;

    if (UniversalPlatform.isWindows) {
      await (realController as windows.WebviewController).setUserAgent(userAgent);
    } else if (UniversalPlatform.isLinux) {
      // Linux webview handles user agent during initialization
    } else if (UniversalPlatform.isMobile || UniversalPlatform.isWeb) {
      await (realController as webview.WebViewController).setUserAgent(userAgent);
    }
  }

  /// Get the current page title
  Future<String?> getTitle() async {
    if (!_isInitialized) return null;
    
    try {
      if (UniversalPlatform.isMobile || UniversalPlatform.isWeb) {
        return await (realController as webview.WebViewController).getTitle();
      }
      final result = await evaluateJavascript('document.title');
      return result?.toString();
    } catch (e) {
      debugPrint('Error getting title: $e');
      return null;
    }
  }

  /// Add a JavaScript channel for communication between web content and Flutter
  Future<void> addJavaScriptChannel(
    String name,
    void Function(String) onMessage,
  ) async {
    if (!_isInitialized) return;

    _jsChannels[name] = onMessage;

    if (UniversalPlatform.isWindows) {
      // Subscribe to web messages if this is our first channel
      if (_jsChannels.length == 1) {
        // Listen to the webMessage stream from the Windows controller
        (realController as windows.WebviewController).webMessage.listen((message) {
          try {
            if (message != null) {
              if (message is Map && message['channel'] != null && message['message'] != null) {
                final channelName = message['channel'].toString();
                if (_jsChannels.containsKey(channelName)) {
                  _jsChannels[channelName]?.call(message['message'].toString());
                }
              }
            }
          } catch (e) {
            debugPrint('Error processing WebView2 message: $e');
          }
        });
      }
      
      // WebView2 has some bullshit that's not channels
      // https://learn.microsoft.com/en-us/microsoft-edge/webview2/reference/javascript/webview
      await (realController as windows.WebviewController).executeScript('''
        if (!window.$name) {
          window.$name = {
            postMessage: function(message) {
              window.chrome.webview.postMessage({
                channel: '$name',
                message: message
              });
            }
          };
        }
      ''');

    } else if (UniversalPlatform.isLinux) {
      final channel = JavascriptChannel(
        name: name,
        onMessageReceived: (JavascriptMessage msg) {
          onMessage(msg.message);
        },
      );
      
      await (realController as WebViewController)
          .setJavaScriptChannels({channel});

      // Inject the JavaScript interface
      await (realController as WebViewController).executeJavaScript('''
        window['$name'] = {
          postMessage: function(message) {
            window.$name.postMessage(message);
          }
        };
      ''');
    } else if (UniversalPlatform.isMobile || UniversalPlatform.isWeb) {
      await (realController as webview.WebViewController).addJavaScriptChannel(
        name,
        onMessageReceived: (message) => onMessage(message.message),
      );
    }
  }

  /// Remove a JavaScript channel
  Future<void> removeJavaScriptChannel(String name) async {
    if (!_isInitialized) return;

    _jsChannels.remove(name);

    if (UniversalPlatform.isWindows) {
      await evaluateJavascript('delete window.$name');
    } else if (UniversalPlatform.isLinux) {
      await evaluateJavascript('delete window.$name');
    } else if (UniversalPlatform.isMobile || UniversalPlatform.isWeb) {
      await (realController as webview.WebViewController)
          .removeJavaScriptChannel(name);
    }
  }

  /// Evaluate JavaScript code in the webview
  Future<dynamic> evaluateJavascript(String code) async {
    if (!_isInitialized) {
      throw UnsupportedError('JavaScript execution is disabled');
    }
    
    try {
      if (UniversalPlatform.isWindows) {
        return (realController as windows.WebviewController).executeScript(code);
      } else if (UniversalPlatform.isLinux) {
        return (realController as WebViewController).evaluateJavascript(code);
      } else if (UniversalPlatform.isMobile || UniversalPlatform.isWeb) {
        return (realController as webview.WebViewController)
            .runJavaScriptReturningResult(code);
      }
    } catch (e) {
      debugPrint('JavaScript execution error: $e');
      rethrow;
    }
  }

  /// Navigate back in the webview history
  Future<void> goBack() async {
    if (!_isInitialized) return;

    if (UniversalPlatform.isWindows) {
      await (realController as windows.WebviewController).goBack();
    } else if (UniversalPlatform.isLinux) {
      await (realController as WebViewController).goBack();
    } else if (UniversalPlatform.isMobile || UniversalPlatform.isWeb) {
      await (realController as webview.WebViewController).goBack();
    }
  }

  /// Navigate forward in the webview history
  Future<void> goForward() async {
    if (!_isInitialized) return;

    if (UniversalPlatform.isWindows) {
      await (realController as windows.WebviewController).goForward();
    } else if (UniversalPlatform.isLinux) {
      await (realController as WebViewController).goForward();
    } else if (UniversalPlatform.isMobile || UniversalPlatform.isWeb) {
      await (realController as webview.WebViewController).goForward();
    }
  }

  /// Reload the current page
  Future<void> reload() async {
    if (!_isInitialized) return;

    if (UniversalPlatform.isWindows) {
      await (realController as windows.WebviewController).reload();
    } else if (UniversalPlatform.isLinux) {
      await (realController as WebViewController).reload();
    } else if (UniversalPlatform.isMobile || UniversalPlatform.isWeb) {
      await (realController as webview.WebViewController).reload();
    }
  }

  /// Clear browser cache
  Future<void> clearCache() async {
    if (!_isInitialized) return;

    if (UniversalPlatform.isWindows) {
      await (realController as windows.WebviewController).clearCache();
    } else if (UniversalPlatform.isLinux) {
      // For Linux, use JavaScript to clear what we can
      await evaluateJavascript('''
        caches.keys().then(function(names) {
          for (let name of names)
            caches.delete(name);
        });
        localStorage.clear();
        sessionStorage.clear();
      ''');
    } else if (UniversalPlatform.isMobile || UniversalPlatform.isWeb) {
      await (realController as webview.WebViewController).clearCache();
    }
  }

  /// Dispose of the controller and clean up resources
  Future<void> dispose() async {
    if (!_isInitialized) return;

    await _titleController.close();
    
    if (UniversalPlatform.isWindows) {
      await (realController as windows.WebviewController).dispose();
    } else if (UniversalPlatform.isLinux) {
      await WebviewManager().dispose();
    }
    _jsChannels.clear();
    _isInitialized = false;
  }
}