// import 'package:flutter/widgets.dart';
// import 'package:fireview/controller.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

// import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
// import 'package:webview_flutter_web/webview_flutter_web.dart'
//     if (dart.library.io) 'package:flutter/widgets.dart' as webview_flutter_web;

// class FireviewWeb extends StatefulWidget {
//   final FireviewController controller;
//   const FireviewWeb({
//     super.key,
//     required this.controller,
//   });

//   @override
//   State<FireviewWeb> createState() => _FireviewWebState();
// }

// class _FireviewWebState extends State<FireviewWeb> {
//   @override
//   void initState() {
//     if (kIsWeb) {
//       WebViewPlatform.instance = webview_flutter_web.WebWebViewPlatform();
//     }
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (kIsWeb) {
//       return PlatformWebViewWidget(
//         PlatformWebViewWidgetCreationParams(
//           controller:
//               widget.controller.realController as PlatformWebViewController,
//         ),
//       ).build(context);
//     }
//     // Return an empty container for non-web platforms
//     return const SizedBox.shrink();
//   }
// }
