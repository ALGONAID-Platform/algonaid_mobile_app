import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import 'package:algonaid/core/common/extensions/theme_helper.dart';

class CustomUpgradeCard extends StatefulWidget {
  final Upgrader upgrader;
  
  const CustomUpgradeCard({Key? key, required this.upgrader}) : super(key: key);

  @override
  State<CustomUpgradeCard> createState() => _CustomUpgradeCardState();
}

class _CustomUpgradeCardState extends State<CustomUpgradeCard> {
  bool _dismissed = false;
  bool _isAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkUpdate();
  }

  Future<void> _checkUpdate() async {
    await widget.upgrader.initialize();
    if (mounted) {
      setState(() {
        _isAvailable = widget.upgrader.isUpdateAvailable() || widget.upgrader.state.debugDisplayAlways;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dismissed || !_isAvailable) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: context.primary.withOpacity(0.08),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.primary.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.system_update_alt, color: context.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'يتوفر تحديث جديد',
                    style: TextStyle(
                      color: context.primary, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 14
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'قم بالتحديث للحصول على الميزات الجديدة',
                    style: TextStyle(
                      color: context.textTheme.bodySmall?.color, 
                      fontSize: 12
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                widget.upgrader.sendUserToAppStore();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                minimumSize: const Size(60, 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('تحديث', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(Icons.close, color: context.textTheme.bodySmall?.color, size: 20),
              onPressed: () {
                setState(() {
                  _dismissed = true;
                });
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
