import 'package:fireview/controller.dart';
import 'package:flutter/widgets.dart';

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
  Widget build(BuildContext context) {
    return const Text("WebView platform not impemented!");
  }
}
