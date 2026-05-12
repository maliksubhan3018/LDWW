import 'package:flutter/material.dart';
import 'package:ldww/features/dashboard_screen.dart';
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

  void navigate() {
    String url = "";

    switch (selectedType) {
      case ConnectionType.name:
        url = "http://localhost/fcc_mart";
        break;

      case ConnectionType.nameIp:
        url = "http://${ipController.text}/fcc_mart";
        break;

      case ConnectionType.url:
        url = urlController.text;
        break;
    }

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
              controller: nameController,
              hint: "Enter Name",
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: ipController,
              hint: "Enter IP Address",
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
                child: Text("Name"),
              ),
              const PopupMenuItem(
                value: ConnectionType.nameIp,
                child: Text("Name + IP"),
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
              ElevatedButton(
                onPressed: navigate,
                child: const Text("Open Dashboard"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}