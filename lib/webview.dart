import 'package:fireview/controller.dart';
import 'package:fireview/platforms/linux.dart';
import 'package:fireview/platforms/mobile.dart';
import 'package:fireview/platforms/windows.dart';

import 'package:fireview/platforms/web_stub.dart'
    if (dart.library.html) 'package:fireview/platforms/web.dart';

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
    if (UniversalPlatform.isMobile) {
      return FireviewMobileWidget(controller: widget.controller);
    } else if (UniversalPlatform.isLinux) {
      return FireviewLinuxWidget(controller: widget.controller);
    } else if (UniversalPlatform.isWindows) {
      return FireviewWindowsWidget(controller: widget.controller);
    } else if (UniversalPlatform.isWeb) {
      return FireviewWebWidget(controller: widget.controller);
    }
    return Container();
  }
}
