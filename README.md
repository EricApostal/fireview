## Fireview
An all-in-one solution for inline WebView.

Warning: This is a work in progress. While we intend to cover 100% of the the controller's functionality, some features are not yet supported on every platform (such as the page title listener on web).

## Features
Fireview is a cross-platform WebView supports all major platforms.

Here's the stack:
- `webview_flutter` backs Android, iOS, and macOS
- `flutter_iframe_webview` backs Web
- `webview_windows` backs Windows
- `webview_cef` backs Linux *warning: this has a large bundle size because we embed chromium*

## How to get working
You can generally just refer to the documentation for the individual packages. The only platform you need extra work for is for Linux, and that can be done by following the Linux instructions at https://github.com/hlwhl/webview_cef.


## How it works
Fireview is pretty simple. Essentially, we take several WebView libraries, and run them using a unified interface. You can find a more complete example in the example file, but here's the jist:

```dart
final FireviewController controller = FireviewController();

// initializes and navigates to the provided url
await controller.initialize(
    Uri.parse("https://www.google.com/"),
    userAgent: 'Flutter Browser 1.0',
);

// then you can use it in a component like
Fireview(controller: controller)
```

Navigating to a URL can be done with:
```dart
controller.loadUrl(Uri.parse("https://flutter.dev/"));
```
