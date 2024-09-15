import 'package:fireview/controller.dart';
import 'package:fireview/platforms/linux.dart';
import 'package:fireview/platforms/windows.dart';
import 'package:flutter/widgets.dart';
import 'package:universal_platform/universal_platform.dart';

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
    if (UniversalPlatform.isWindows) {
      return FireviewWindows(
        controller: widget.controller,
      );
    } else if (UniversalPlatform.isLinux) {
      return FireviewLinux(
        controller: widget.controller,
      );
    }
    return const Text("platform not supported");
  }
}
