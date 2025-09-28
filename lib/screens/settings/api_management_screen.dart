import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/api_management_widget.dart';

class ApiManagementScreen extends StatelessWidget {
  const ApiManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.localApiManagement),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ApiManagementWidget(),
            SizedBox(height: 16),
            // Có thể thêm các thông tin bổ sung về API tại đây
          ],
        ),
      ),
    );
  }
}
