import 'package:flutter/material.dart';
import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/utils/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:algonaid/core/widgets/shared/app_snackbar.dart';

class CourseReminderSheet extends StatefulWidget {
  final int courseId;
  final String courseTitle;

  const CourseReminderSheet({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<CourseReminderSheet> createState() => _CourseReminderSheetState();
}

class _CourseReminderSheetState extends State<CourseReminderSheet> {
  bool _isEnabled = false;
  List<int> _selectedDays = [];
  TimeOfDay _selectedTime = const TimeOfDay(hour: 20, minute: 0);

  final List<Map<String, dynamic>> _weekDays = [
    {'name': 'السبت', 'value': DateTime.saturday},
    {'name': 'الأحد', 'value': DateTime.sunday},
    {'name': 'الاثنين', 'value': DateTime.monday},
    {'name': 'الثلاثاء', 'value': DateTime.tuesday},
    {'name': 'الأربعاء', 'value': DateTime.wednesday},
    {'name': 'الخميس', 'value': DateTime.thursday},
    {'name': 'الجمعة', 'value': DateTime.friday},
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingReminder();
  }

  void _loadExistingReminder() {
    final reminder = NotificationService().getCourseReminder(widget.courseId);
    if (reminder != null) {
      setState(() {
        _isEnabled = reminder['isEnabled'] ?? false;
        _selectedDays = List<int>.from(reminder['days'] ?? []);
        final int hour = reminder['hour'] ?? 20;
        final int minute = reminder['minute'] ?? 0;
        _selectedTime = TimeOfDay(hour: hour, minute: minute);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: context.primary,
                  ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        // Auto enable if time picked and no days selected yet
        if (!_isEnabled) _isEnabled = true;
      });
    }
  }

  void _toggleDay(int dayValue) {
    setState(() {
      if (_selectedDays.contains(dayValue)) {
        _selectedDays.remove(dayValue);
      } else {
        _selectedDays.add(dayValue);
      }
      // Auto enable if days are selected
      if (_selectedDays.isNotEmpty && !_isEnabled) {
        _isEnabled = true;
      }
    });
  }

  Future<void> _saveReminder() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    try {
      // Check permission if enabling
      if (_isEnabled) {
        final status = await Permission.notification.status;
        if (status.isDenied) {
          final result = await Permission.notification.request();
          if (result.isDenied) {
            if (mounted) {
              AppSnackBar.show(
                context: context,
                message: 'يرجى تفعيل إذن الإشعارات من إعدادات الهاتف لتلقي التنبيهات.',
                type: SnackBarType.error,
              );
            }
            return;
          }
        }

        // Request exact alarm permission on Android 12+ (API 31+) if needed
        final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
        if (exactAlarmStatus.isDenied) {
          final result = await Permission.scheduleExactAlarm.request();
          if (result.isDenied) {
            debugPrint('Exact alarm permission denied. Reminders will be scheduled with inexact settings.');
          }
        }

        if (_selectedDays.isEmpty) {
          AppSnackBar.show(
            context: context,
            message: 'يرجى تحديد يوم واحد على الأقل للتنبيه.',
            type: SnackBarType.info,
          );
          return;
        }

        await NotificationService().scheduleCourseReminder(
          courseId: widget.courseId,
          courseTitle: widget.courseTitle,
          days: _selectedDays,
          hour: _selectedTime.hour,
          minute: _selectedTime.minute,
        );
      } else {
        await NotificationService().cancelCourseReminder(widget.courseId);
      }

      if (mounted) {
        AppSnackBar.show(
          context: context,
          message: _isEnabled
              ? 'تم تفعيل منبه الدراسة بنجاح! 🔔'
              : 'تم إلغاء تفعيل منبه الدراسة.',
          type: _isEnabled ? SnackBarType.success : SnackBarType.info,
        );
        navigator.pop();
      }
    } catch (e) {
      debugPrint('Error saving reminder: $e');
      if (mounted) {
        AppSnackBar.show(
          context: context,
          message: 'حدث خطأ أثناء حفظ التنبيه: $e',
          type: SnackBarType.error,
        );
      }
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'ص' : 'م';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Switch Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      _isEnabled ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                      color: _isEnabled ? Colors.green : Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'تفعيل التنبيه الأسبوعي',
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Switch.adaptive(
                  value: _isEnabled,
                  activeColor: context.primary,
                  onChanged: (value) {
                    setState(() {
                      _isEnabled = value;
                      // default select today if enabling and list is empty
                      if (_isEnabled && _selectedDays.isEmpty) {
                        _selectedDays = [DateTime.now().weekday];
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Settings Section (visible if enabled)
          AnimatedOpacity(
            opacity: _isEnabled ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_isEnabled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select Time
                  Text(
                    'اختر وقت التنبيه:',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectTime(context),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: context.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: context.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTime(_selectedTime),
                            style: context.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.primary,
                            ),
                          ),
                          Icon(
                            Icons.access_time_filled_rounded,
                            color: context.primary,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Select Days
                  Text(
                    'اختر أيام الدراسة:',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 55,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _weekDays.length,
                      itemBuilder: (context, index) {
                        final day = _weekDays[index];
                        final isSelected = _selectedDays.contains(day['value']);
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: ChoiceChip(
                            label: Text(
                              day['name'],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? Colors.white70 : Colors.black87),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: context.primary,
                            backgroundColor: context.surface,
                            elevation: isSelected ? 2 : 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected
                                    ? context.primary
                                    : (isDark ? Colors.white12 : Colors.black12),
                              ),
                            ),
                            onSelected: (bool selected) {
                              _toggleDay(day['value']);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveReminder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'حفظ التعديلات',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (NotificationService().getCourseReminder(widget.courseId) != null) ...[
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () async {
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final navigator = Navigator.of(context);
                    await NotificationService().cancelCourseReminder(widget.courseId);
                    if (mounted) {
                      AppSnackBar.show(
                        context: context,
                        message: 'تم حذف منبه هذا الكورس بنجاح.',
                        type: SnackBarType.success,
                      );
                      navigator.pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.red, width: 1),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(Icons.delete_forever_rounded),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
