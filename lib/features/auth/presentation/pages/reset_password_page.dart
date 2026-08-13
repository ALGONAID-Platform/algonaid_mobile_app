import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:algonaid/core/common/enums/password_strength.dart';
import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/routes/paths_routes.dart';
import 'package:algonaid/core/utils/validations/app_validation.dart';
import 'package:algonaid/core/widgets/shared/show_dialog.dart';
import 'package:algonaid/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid/features/auth/presentation/widgets/label.dart';
import 'package:algonaid/core/widgets/buttons/custom_button.dart';
import 'package:algonaid/core/widgets/shared/textform_field.dart';
import 'package:algonaid/features/auth/presentation/widgets/auth_header.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;
  const ResetPasswordPage({super.key, required this.token});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // حالة التحقق من التوكن عند فتح الصفحة
  bool _isValidatingToken = true;
  bool _isTokenValid = false;

  @override
  void initState() {
    super.initState();
    _validateToken();
  }

  /// يتحقق من صلاحية التوكن عند فتح الصفحة
  Future<void> _validateToken() async {
    final authService = Provider.of<AuthServiceProvider>(context, listen: false);
    final isValid = await authService.validateResetToken(widget.token);

    if (!mounted) return;

    if (!isValid) {
      // التوكن منتهي أو تم استخدامه — أظهر رسالة وارجع لتسجيل الدخول
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppDialog.showDynamicDialog(
          context: context,
          title: 'رابط منتهي الصلاحية',
          message:
              'هذا الرابط منتهي الصلاحية أو تم استخدامه من قبل. يرجى طلب رابط جديد لإعادة تعيين كلمة المرور.',
          isError: true,
          showCancelButton: false,
          confirmText: 'العودة لتسجيل الدخول',
          onConfirm: () {
            if (mounted) context.go(Routes.auth);
          },
        );
      });
    }

    setState(() {
      _isValidatingToken = false;
      _isTokenValid = isValid;
    });
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      AppDialog.showDynamicDialog(
        context: context,
        title: 'خطأ',
        message: 'كلمات المرور غير متطابقة',
        isError: true,
        showCancelButton: false,
      );
      return;
    }

    setState(() => _isLoading = true);

    final authService = Provider.of<AuthServiceProvider>(context, listen: false);
    final successMsg = await authService.resetPassword(
      token: widget.token,
      newPassword: _newPasswordController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (successMsg != null) {
      AppDialog.showDynamicDialog(
        context: context,
        title: 'تم بنجاح',
        message: 'تم تعيين كلمة المرور الجديدة بنجاح. يمكنك الآن تسجيل الدخول.',
        isError: false,
        showCancelButton: false,
        confirmText: 'تسجيل الدخول',
        onConfirm: () {
          if (mounted) context.go(Routes.auth);
        },
      );
    } else {
      AppDialog.showDynamicDialog(
        context: context,
        title: 'فشل إعادة التعيين',
        message: authService.errorMessage ?? 'حدث خطأ غير معروف',
        isError: true,
        showCancelButton: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('إعادة تعيين كلمة المرور'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: _isValidatingToken
            // أثناء التحقق من التوكن: مؤشر تحميل
            ? const Center(child: CircularProgressIndicator())
            // التوكن غير صالح: صفحة فارغة (الحوار سيظهر تلقائياً)
            : !_isTokenValid
                ? const SizedBox.shrink()
                // التوكن صالح: اعرض نموذج تغيير كلمة المرور
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          AuthHeader(),
                          const SizedBox(height: 40),
                          TextLabel(text: 'كلمة المرور الجديدة'),
                          const SizedBox(height: 5),
                          CustomTextFormField(
                            controller: _newPasswordController,
                            labelText: 'أدخل كلمة المرور الجديدة',
                            borderColor: context.primary,
                            isPassword: true,
                            isPasswordVisible: _isNewPasswordVisible,
                            onSuffixPressed: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
                              });
                            },
                            validator: (password) => Validator.password(
                              password,
                              strength: PasswordStrength.strong,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextLabel(text: 'تأكيد كلمة المرور الجديدة'),
                          const SizedBox(height: 5),
                          CustomTextFormField(
                            controller: _confirmPasswordController,
                            labelText: 'أعد إدخال كلمة المرور',
                            borderColor: context.primary,
                            isPassword: true,
                            isPasswordVisible: _isConfirmPasswordVisible,
                            onSuffixPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                            validator: (password) => Validator.password(
                              password,
                              strength: PasswordStrength.strong,
                            ),
                          ),
                          const SizedBox(height: 40),
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : CustomButton(
                                  color: context.primary,
                                  textColor: Colors.white,
                                  onPressed: _resetPassword,
                                  text: 'تغيير كلمة المرور',
                                ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
