import 'package:fireview/controller.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FireviewMobile extends StatefulWidget {
  final FireviewController controller;
  const FireviewMobile({
    super.key,
    required this.controller,
  });

  @override
  State<FireviewMobile> createState() => _FireviewMobileState();
}

class _FireviewMobileState extends State<FireviewMobile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: widget.controller.realController);
  }
}
