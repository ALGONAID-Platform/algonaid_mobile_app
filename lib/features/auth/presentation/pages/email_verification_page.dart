import 'dart:async';
import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobile_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EmailVerificationPage extends StatefulWidget {
  final String email;
  const EmailVerificationPage({super.key, required this.email});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  int _countdown = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _countdown = 60;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد البريد الإلكتروني')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mark_email_unread_outlined, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'تم إرسال رابط التحقق',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'لقد أرسلنا رابطاً لتأكيد حسابك إلى البريد الإلكتروني:\n${widget.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              const Text(
                'يرجى فتح بريدك والضغط على الرابط لتفعيل حسابك، ثم العودة لتسجيل الدخول.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Consumer<AuthServiceProvider>(
                builder: (context, authProvider, child) {
                  return Column(
                    children: [
                      if (authProvider.isLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: _canResend
                              ? () async {
                                  final success = await authProvider.resendVerificationEmail(widget.email);
                                  if (success) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('تم إرسال رابط جديد إلى بريدك')),
                                      );
                                    }
                                    _startTimer();
                                  } else {
                                    if (context.mounted && authProvider.errorMessage != null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(authProvider.errorMessage!)),
                                      );
                                    }
                                  }
                                }
                              : null,
                          child: Text(_canResend ? 'إعادة إرسال الرابط' : 'إعادة الإرسال بعد $_countdown ثانية'),
                        ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          context.go(Routes.auth);
                        },
                        child: const Text('العودة لتسجيل الدخول'),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
