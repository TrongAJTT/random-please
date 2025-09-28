import 'package:flutter/material.dart';
import '../../widgets/api_management_widget.dart';

class ApiManagementScreen extends StatelessWidget {
  const ApiManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
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
