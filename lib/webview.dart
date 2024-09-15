import 'package:fireview/controller.dart';

import 'package:fireview/platforms/stub.dart'
    if (dart.library.js) 'package:fireview/platforms/web.dart'
    if (dart.library.io) 'package:fireview/platforms/io/io.dart';

import 'package:flutter/widgets.dart';

class Fireview extends StatefulWidget {
  final FireviewController controller;
  const Fireview({
    super.key,
    required this.controller,
  });

  @override
  State<Fireview> createState() => _FireviewState();
}

class _FireviewState extends State<Fireview> {
  @override
  Widget build(BuildContext context) {
    return FireviewWidget(controller: widget.controller);
  }
}
