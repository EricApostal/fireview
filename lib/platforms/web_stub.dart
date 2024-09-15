import 'package:flutter/widgets.dart';
import 'package:fireview/controller.dart';

class FireviewWebWidget extends StatefulWidget {
  final FireviewController controller;
  const FireviewWebWidget({
    super.key,
    required this.controller,
  });

  @override
  State<FireviewWebWidget> createState() => _FireviewWebWidgetState();
}

class _FireviewWebWidgetState extends State<FireviewWebWidget> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
