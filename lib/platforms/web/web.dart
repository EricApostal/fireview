import 'package:flutter/widgets.dart';
import 'package:fireview/controller.dart';

import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';

class FireviewWidget extends StatefulWidget {
  final FireviewController controller;
  const FireviewWidget({
    super.key,
    required this.controller,
  });

  @override
  State<FireviewWidget> createState() => _FireviewWidgetState();
}

class _FireviewWidgetState extends State<FireviewWidget> {
  @override
  void initState() {
    WebViewPlatform.instance = WebWebViewPlatform();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWebViewWidget(
      PlatformWebViewWidgetCreationParams(
        controller:
            widget.controller.realController as PlatformWebViewController,
      ),
    ).build(context);
  }
}
