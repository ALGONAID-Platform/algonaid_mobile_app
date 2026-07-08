import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailVerifiedSuccessPage extends StatelessWidget {
  const EmailVerifiedSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mark_email_read, size: 100, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'تم تأكيد بريدك بنجاح! 🎉',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'شكراً لك. حسابك الآن مفعل ويمكنك تسجيل الدخول للاستفادة من جميع مميزات المنصة.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go(Routes.auth);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('تسجيل الدخول', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
