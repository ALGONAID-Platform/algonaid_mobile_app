import 'package:algonaid_mobile_app/core/routes/paths_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailVerifyFailedPage extends StatelessWidget {
  final String? message;
  const EmailVerifyFailedPage({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('فشل التحقق')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 100, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'عذراً، فشل التحقق من الرابط',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                message ?? 'رابط التحقق غير صالح أو منتهي الصلاحية. يرجى محاولة تسجيل الدخول وطلب رابط جديد.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
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
                    child: Text('العودة لتسجيل الدخول', style: TextStyle(fontSize: 18)),
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
