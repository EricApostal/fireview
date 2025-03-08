// import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

// class WebWebViewPlatform extends WebViewPlatform {
//   @override
//   PlatformWebViewController createPlatformWebViewController(
//     PlatformWebViewControllerCreationParams params,
//   ) {
//     return StubPlatformWebViewController(params);
//   }
// }

// class StubPlatformWebViewController extends PlatformWebViewController {
//   StubPlatformWebViewController(super.params)
//       : super.implementation();


//   static void registerWith() {
//     WebViewPlatform.instance = WebWebViewPlatform();
//   }
// }

// class WebWebViewController extends StubPlatformWebViewController {
//   WebWebViewController(WebWebViewControllerCreationParams super.params);
// }

// class WebWebViewControllerCreationParams extends PlatformWebViewControllerCreationParams {
//   const WebWebViewControllerCreationParams() : super();
// }