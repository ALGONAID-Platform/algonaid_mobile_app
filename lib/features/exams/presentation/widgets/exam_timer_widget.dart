import 'dart:async';
import 'package:flutter/material.dart';

class ExamTimerWidget extends StatefulWidget {
  final int durationMinutes;
  final VoidCallback onTimeUp;

  const ExamTimerWidget({
    Key? key,
    required this.durationMinutes,
    required this.onTimeUp,
  }) : super(key: key);

  @override
  State<ExamTimerWidget> createState() => _ExamTimerWidgetState();
}

class _ExamTimerWidgetState extends State<ExamTimerWidget> {
  late Timer _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationMinutes * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        widget.onTimeUp();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    final isWarning = _remainingSeconds < 60 * 5; // less than 5 minutes

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isWarning ? Colors.red.withOpacity(0.1) : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isWarning ? Colors.red.shade300 : Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 16,
            color: isWarning ? Colors.red : Theme.of(context).iconTheme.color,
          ),
          const SizedBox(width: 4),
          Text(
            '$minutes:$seconds',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isWarning ? Colors.red : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}
