## Fireview
An all-in-one solution for inline WebView.

## Features
Fireview is a cross-platform WebView supports all major platforms.

Here's how it works
- `webview_flutter` backs Android, iOS, and macOS
- `flutter_iframe_webview` backs web
- `webview_windows` backs Windows
- `webview_cef` backs linux

## How to get working
You can generally just refer to the documentation for the individual packages. The only platform you need extra work for is for Linux, and that can be done by following the Linux instructions at https://github.com/hlwhl/webview_cef.


## How it works
Fireview is pretty simple. Essentially, we take several WebView libraries, and run them using a unified interface. You can find a more complete example in the example file, but here's the jist:

```dart
final FireviewController controller = FireviewController();
await controller.initialize(
    Uri.parse(currentUrl),
    javascriptEnabled: true,
    userAgent: 'Flutter Browser 1.0',
);

// then you can use it in a component like
Fireview(controller: controller)
```

Navigating to a URL can be done with:
```dart
controller.loadUrl(Uri.parse("https://flutter.dev/"));
```
