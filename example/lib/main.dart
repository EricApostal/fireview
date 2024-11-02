import 'package:fireview/fireview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Browser',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BrowserPage(),
    );
  }
}

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  final FireviewController controller = FireviewController();
  final TextEditingController urlController = TextEditingController();
  bool isLoading = true;
  String currentUrl = 'https://flutter.dev';

  @override
  void initState() {
    super.initState();
    urlController.text = currentUrl;
    _initializeWebView();
  }

  Future<void> _initializeWebView() async {
    await controller.initialize(Uri.parse(currentUrl));
    setState(() {
      isLoading = false;
    });
  }

  void _navigateToUrl(String url) {
    setState(() {
      isLoading = true;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }
      currentUrl = url;
      urlController.text = url;
      controller.loadUrl(Uri.parse(url));
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: controller.goBack,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: controller.goForward,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => _navigateToUrl(currentUrl),
                ),
                Expanded(
                  child: TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: 'Enter URL',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: _navigateToUrl,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () => _navigateToUrl('https://flutter.dev'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Fireview(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }
}