import 'package:fireview/controller.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_windows/webview_windows.dart';

class FireviewWindowsWidget extends StatefulWidget {
  final FireviewController controller;
  const FireviewWindowsWidget({
    super.key,
    required this.controller,
  });

  @override
  State<FireviewWindowsWidget> createState() => _FireviewWindowsState();
}

class _FireviewWindowsState extends State<FireviewWindowsWidget> {
  @override
  void initState() {
    (widget.controller.realController as WebviewController).ready.then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Webview(
      widget.controller.realController as WebviewController,
    );
  }
}
