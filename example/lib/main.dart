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
  String? pageTitle;
  String? currentUserAgent;
  bool isJavaScriptEnabled = true;
  
  // Store messages from JavaScript channels
  List<String> jsMessages = [];
  
  @override
  void initState() {
    super.initState();
    urlController.text = currentUrl;
    _initializeWebView();
        controller.titleStream.listen((title) {
      setState(() {
        pageTitle = title;
      });
    });

  }

  Future<void> _initializeWebView() async {
    await controller.initialize(
      Uri.parse(currentUrl),
      userAgent: 'Flutter Browser 1.0',
    );
    
    // Set up JavaScript channel for communication
    await controller.addJavaScriptChannel(
      'Flutter',
      (String message) {
        setState(() {
          jsMessages.add(message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Received: $message')),
          );
        });
      },
    );
    
 
    // Get current user agent
    _getCurrentUserAgent();
    
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _getCurrentUserAgent() async {
    try {
      final userAgent = await controller.evaluateJavascript(
        'navigator.userAgent'
      );
      setState(() {
        currentUserAgent = userAgent?.toString();
      });
    } catch (e) {
      print('Error getting user agent: $e');
    }
  }

  Future<void> _navigateToUrl(String url) async {
    setState(() {
      isLoading = true;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }
      currentUrl = url;
      urlController.text = url;
    });

    await controller.loadUrl(Uri.parse(url));
    
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _toggleJavaScript() async {
    setState(() {
      isJavaScriptEnabled = !isJavaScriptEnabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'JavaScript ${isJavaScriptEnabled ? 'enabled' : 'disabled'}'
        ),
      ),
    );
  }

  Future<void> _testJavaScript() async {
    try {
      await controller.evaluateJavascript('''
        Flutter.postMessage('Hello from JavaScript! Time: ' + new Date().toLocaleTimeString());
      ''');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('JavaScript execution failed - is it enabled?'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _setCookie() async {
    final Uri currentUri = Uri.parse(currentUrl);
    await controller.setCookie(
      currentUri.host,
      'flutter_test',
      'cookie_value_${DateTime.now().millisecondsSinceEpoch}'
    );
    
    // Verify cookie was set by reading it with JavaScript
    final cookieValue = await controller.evaluateJavascript('document.cookie');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Current cookies: $cookieValue')),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Browser Info'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current Title: ${pageTitle ?? "No title"}'),
              const SizedBox(height: 8),
              Text('User Agent: ${currentUserAgent ?? "Unknown"}'),
              const SizedBox(height: 8),
              Text('JavaScript: ${isJavaScriptEnabled ? "Enabled" : "Disabled"}'),
              const SizedBox(height: 16),
              const Text('Recent JavaScript Messages:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...jsMessages.map((msg) => Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                child: Text('• $msg'),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle ?? 'Loading...', 
          style: const TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: controller.goBack,
                  tooltip: 'Go back',
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: controller.goForward,
                  tooltip: 'Go forward',
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => _navigateToUrl(currentUrl),
                  tooltip: 'Refresh',
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
                PopupMenuButton<void Function()>(
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'More options',
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: _toggleJavaScript,
                      child: Text(
                        '${isJavaScriptEnabled ? 'Disable' : 'Enable'} JavaScript'
                      ),
                    ),
                    PopupMenuItem(
                      onTap: _testJavaScript,
                      child: const Text('Test JavaScript'),
                    ),
                    PopupMenuItem(
                      onTap: _setCookie,
                      child: const Text('Set Test Cookie'),
                    ),
                    PopupMenuItem(
                      child: const Text('Clear Cache'),
                      onTap: () async {
                        await controller.clearCache();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cache cleared')),
                          );
                        }
                      },
                    ),
                    PopupMenuItem(
                      onTap: _showInfoDialog,
                      child: const Text('Show Info'),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.home),
                  onPressed: () => _navigateToUrl('https://flutter.dev'),
                  tooltip: 'Go home',
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
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    urlController.dispose();
    controller.dispose();
    super.dispose();
  }
}