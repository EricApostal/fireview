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
    return ValueListenableBuilder(
      valueListenable: (widget.controller.realController as WebViewController),
      builder: (context, value, child) {
        return (widget.controller.realController as WebViewController).value
            ? Expanded(
                child: (widget.controller.realController as WebViewController)
                    .webviewWidget)
            : (widget.controller.realController as WebViewController)
                .loadingWidget;
      },
    );
  }
}
