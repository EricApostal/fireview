import 'package:fireview/controller.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class FireviewWeb extends StatefulWidget {
  final FireviewController controller;
  const FireviewWeb({
    super.key,
    required this.controller,
  });

  @override
  State<FireviewWeb> createState() => _FireviewWebState();
}

class _FireviewWebState extends State<FireviewWeb> {
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
