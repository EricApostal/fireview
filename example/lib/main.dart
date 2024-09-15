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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FireviewController controller = FireviewController();

  void goToUrl() {
    setState(() {
      controller.loadUrl(
        Uri.parse('https://google.com'),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    controller.initialize(
      Uri.parse('https://flutter.dev'),
    );
    print("init!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Fireview(controller: controller),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToUrl,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
