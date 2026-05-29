import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/app_empty_state.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: context.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text('الإشعارات'),
      ),
      body: const AppEmptyState(
        icon: Icons.notifications_active_outlined,
        title: 'لا توجد إشعارات حالياً',
        subtitle: 'سنقوم بإعلامك فور وصول أي تحديث أو رسالة جديدة',
      ),
      ),
    );
  }
}
