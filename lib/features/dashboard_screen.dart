import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

class DashboardScreen extends StatefulWidget {
  final String url;
  final String userName;

  const DashboardScreen({
    super.key,
    required this.url,
    required this.userName,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final WebviewController controller = WebviewController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initWebView();
  }

  Future<void> initWebView() async {
    await controller.initialize();

    await controller.setBackgroundColor(Colors.transparent);

    await controller.loadUrl(widget.url);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${widget.userName}"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Webview(controller),
    );
  }
}