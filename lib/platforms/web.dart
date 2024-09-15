import 'package:flutter/widgets.dart';
import 'package:fireview/controller.dart';

import 'package:flutter_iframe_webview/webview_flutter_web.dart';
import 'package:flutter_jsbridge_sdk/flutter_jsbridge_sdk.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class FireviewWebWidget extends StatefulWidget {
  final FireviewController controller;
  const FireviewWebWidget({
    super.key,
    required this.controller,
  });

  @override
  State<FireviewWebWidget> createState() => _FireviewWebWidgetState();
}

class _FireviewWebWidgetState extends State<FireviewWebWidget> {
  late final WebViewController _controller;

  @override
  void initState() {
    print("running init state");
    late final PlatformWebViewController platform;
    if (WebViewPlatform.instance is WebWebViewPlatform) {
      platform = WebWebViewController(WebWebViewControllerCreationParams());
    } else {
      platform = PlatformWebViewController(
          const PlatformWebViewControllerCreationParams());
    }

    print("setting controller");
    _controller = WebViewController.fromPlatform(platform);
    print(_controller.platform);

    _controller.loadRequest(Uri.parse("https://www.flutter.dev"));
    print("loaded and all that!");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller).build(context);
  }
}
