import 'package:fireview/platforms/io/linux.dart';
import 'package:fireview/platforms/io/mobile.dart';
import 'package:fireview/platforms/io/windows.dart';
import 'package:flutter/widgets.dart';
import 'package:fireview/controller.dart';
import 'package:universal_platform/universal_platform.dart';

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
    switch (UniversalPlatform.value) {
      case UniversalPlatformType.Android:
        return FireviewMobileWidget(controller: widget.controller);
      case UniversalPlatformType.IOS:
        return FireviewMobileWidget(controller: widget.controller);
      case UniversalPlatformType.Linux:
        return FireviewLinuxWidget(controller: widget.controller);
      case UniversalPlatformType.Windows:
        return FireviewWindowsWidget(controller: widget.controller);
      default:
        return const Text("WebView platform not impemented!");
    }
  }
}
