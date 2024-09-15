import 'package:fireview/controller.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FireviewMobileWidget extends StatefulWidget {
  final FireviewController controller;
  const FireviewMobileWidget({
    super.key,
    required this.controller,
  });

  @override
  State<FireviewMobileWidget> createState() => _FireviewWidgetState();
}

class _FireviewWidgetState extends State<FireviewMobileWidget> {
  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: widget.controller.realController);
  }
}
