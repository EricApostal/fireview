import 'package:fireview/controller.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_cef/webview_cef.dart';

class FireviewLinux extends StatefulWidget {
  final FireviewController controller;
  const FireviewLinux({
    super.key,
    required this.controller,
  });

  @override
  State<FireviewLinux> createState() => _FireviewLinuxState();
}

class _FireviewLinuxState extends State<FireviewLinux> {
  @override
  Widget build(BuildContext context) {
    return WebView(
      widget.controller.realController as WebViewController,
    );
  }
}
