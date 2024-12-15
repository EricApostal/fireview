import 'package:fireview/controller.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FireviewMobileWidget extends StatelessWidget {
  final FireviewController controller;
  const FireviewMobileWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller.realController);
  }
}
