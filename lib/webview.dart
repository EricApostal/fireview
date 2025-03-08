import 'package:fireview/controller.dart';
import 'package:fireview/platforms/linux.dart';
import 'package:fireview/platforms/mobile.dart';
import 'package:fireview/platforms/windows.dart';

import 'package:fireview/stubs/web_stub.dart'
    if (dart.library.html) 'package:fireview/platforms/web.dart';

import 'package:flutter/widgets.dart';
import 'package:universal_platform/universal_platform.dart';

class Fireview extends StatelessWidget {
  final FireviewController controller;

  const Fireview({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isMobile) {
      return FireviewMobileWidget(controller: controller);
    } else if (UniversalPlatform.isLinux) {
      return FireviewLinuxWidget(controller: controller);
    } else if (UniversalPlatform.isWindows) {
      return FireviewWindowsWidget(controller: controller);
    } else if (UniversalPlatform.isWeb) {
      // return FireviewWebWidget(controller: controller);
    }
    return const Center(
        child: Text(
            "We could not recognize your device, and cannot load the webview."));
  }
}
