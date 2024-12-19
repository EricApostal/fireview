import 'package:fireview/controller.dart';
import 'package:flutter/widgets.dart';
import 'package:webview_cef/webview_cef.dart';

class FireviewLinuxWidget extends StatefulWidget {
  final FireviewController controller;
  const FireviewLinuxWidget({
    super.key,
    required this.controller,
  });

  @override
  State<FireviewLinuxWidget> createState() => _FireviewLinuxWidgetState();
}

class _FireviewLinuxWidgetState extends State<FireviewLinuxWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: (widget.controller.realController as WebViewController),
      builder: (context, value, child) {
        return (widget.controller.realController as WebViewController).value
            ? 
                (widget.controller.realController as WebViewController)
                    .webviewWidget
            : (widget.controller.realController as WebViewController)
                .loadingWidget;
      },
    );
  }
}
