import 'package:fireview/controller.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_windows/webview_windows.dart';

class FireviewWindows extends StatefulWidget {
  final FireviewController controller;
  const FireviewWindows({
    super.key,
    required this.controller,
  });

  @override
  State<FireviewWindows> createState() => _FireviewWindowsState();
}

class _FireviewWindowsState extends State<FireviewWindows> {
  @override
  Widget build(BuildContext context) {
    return Webview(
      widget.controller.realController,
    );
  }
}
