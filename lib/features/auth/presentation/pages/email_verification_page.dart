import 'dart:async';
import 'package:algonaid/core/routes/paths_routes.dart';
import 'package:algonaid/features/auth/presentation/providers/auth_service_provider.dart';
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
        child: SingleChildScrollView(
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
                const SizedBox(height: 16),
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      childrenPadding: const EdgeInsets.all(12),
                      iconColor: Colors.red,
                      collapsedIconColor: Colors.red,
                      title: const Row(
                        children: [
                          Icon(Icons.help_outline_rounded, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Flexible(
                            child: const Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'ملاحظة مهمة: ',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  TextSpan(
                                    text: 'في حال عدم وصول الرسالة إلى البريد الوارد (اضغط هنا)',
                                  ),
                                ],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'في حال لم تجد الرسالة في البريد الوارد، قم بالضغط على القائمة الجانبية في  تطبيق الجيميل، ثم اختر الرسائل غير المرغوب فيها، كما هو موضح بالصورة:',
                                style: TextStyle(fontSize: 12, height: 1.5, color: Colors.black87),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                height: 220, // تكبير الارتفاع
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.red.withOpacity(0.2)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: RawScrollbar(
                                    thumbColor: Colors.red.withOpacity(0.5),
                                    radius: const Radius.circular(8),
                                    thickness: 4,
                                    child: SingleChildScrollView(
                                      reverse: true,
                                      child: Image.network(
                                        'https://user24230.na.imgto.link/public/20260816/photo-2026-08-16-07-56-36.avif',
                                        fit: BoxFit.fitWidth, // ملء العرض والتمرير للأسفل
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const SizedBox(
                                            height: 220,
                                            child: Center(
                                              child: CircularProgressIndicator(color: Colors.red),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
      ),
    );
  }
}
