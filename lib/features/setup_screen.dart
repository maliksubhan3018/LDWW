import 'package:flutter/material.dart';
import 'package:ldww/features/dashboard_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../widgets/custom_textfield.dart';

enum ConnectionType {
  name,
  nameIp,
  url,
}

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ipController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  ConnectionType selectedType = ConnectionType.name;

  /// -----------------------------------
  /// BUILD URL
  /// -----------------------------------
  String getUrl() {
    switch (selectedType) {
      case ConnectionType.name:
        return "http://localhost/fcc_mart";

      case ConnectionType.nameIp:
        return "http://${ipController.text.trim()}/fcc_mart";

      case ConnectionType.url:
        String url = urlController.text.trim();

        // Auto add http
        if (!url.startsWith("http://") &&
            !url.startsWith("https://")) {
          url = "http://$url";
        }

        return url;
    }
  }

  /// -----------------------------------
  /// OPEN INSIDE APP WEBVIEW
  /// -----------------------------------
  void navigate() {
    final url = getUrl();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          url: url,
          userName: nameController.text,
        ),
      ),
    );
  }

  /// -----------------------------------
  /// OPEN IN CHROME
  /// -----------------------------------
  Future<void> openInChrome() async {
    try {
      final String url = getUrl();

      final Uri uri = Uri.parse(url);

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint("Chrome launch error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Unable to open browser",
          ),
        ),
      );
    }
  }

  /// -----------------------------------
  /// DYNAMIC FIELDS
  /// -----------------------------------
  Widget buildFields() {
    switch (selectedType) {
      case ConnectionType.name:
        return CustomTextField(
          controller: nameController,
          hint: "Enter Name",
        );

      case ConnectionType.nameIp:
        return Column(
          children: [
            CustomTextField(
              controller: ipController,
              hint: "Enter IP Address",
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: nameController,
              hint: "Enter Name",
            ),
          ],
        );

      case ConnectionType.url:
        return CustomTextField(
          controller: urlController,
          hint: "Enter URL",
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("POS Setup"),
        actions: [
          PopupMenuButton<ConnectionType>(
            onSelected: (value) {
              setState(() {
                selectedType = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: ConnectionType.name,
                child: Text("Host"),
              ),
              const PopupMenuItem(
                value: ConnectionType.nameIp,
                child: Text("IP + Host"),
              ),
              const PopupMenuItem(
                value: ConnectionType.url,
                child: Text("URL"),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildFields(),

              const SizedBox(height: 20),

              /// -----------------------------------
              /// OPEN INSIDE APPLICATION
              /// -----------------------------------
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: navigate,
                  child: const Text(
                    "Continue to Connect",
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// -----------------------------------
              /// OPEN IN CHROME
              /// -----------------------------------
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: openInChrome,
                  child: const Text(
                    "Continue to Chrome",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}