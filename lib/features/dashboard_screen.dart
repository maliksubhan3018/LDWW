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

    await controller.setBackgroundColor(
      Colors.transparent,
    );

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
      body: SafeArea(
        child: isLoading
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )

            /// WEBVIEW
            : SizedBox.expand(
                child: Webview(controller),
              ),
      ),

      /// BACK BUTTON
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(
          Icons.arrow_back_ios_new_outlined,
        ),
      ),
    );
  }
}