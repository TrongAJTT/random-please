import 'package:flutter/material.dart';

class GenericSettingsScreen extends StatelessWidget {
  final String title;
  final Widget settingsLayout;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;

  const GenericSettingsScreen({
    super.key,
    required this.title,
    required this.settingsLayout,
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: false,
        actions: actions,
        bottom: bottom,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: settingsLayout,
    );
  }

  // Helper method to create and push this screen
  static void show(
    BuildContext context, {
    required String title,
    required Widget settingsLayout,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GenericSettingsScreen(
          title: title,
          settingsLayout: settingsLayout,
          actions: actions,
          bottom: bottom,
        ),
      ),
    );
  }
}
