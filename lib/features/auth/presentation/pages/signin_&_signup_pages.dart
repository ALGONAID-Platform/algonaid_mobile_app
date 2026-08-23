import 'package:algonaid/core/common/enums/password_strength.dart';
import 'package:algonaid/core/common/extensions/theme_helper.dart';
import 'package:algonaid/core/routes/paths_routes.dart';
import 'package:algonaid/core/utils/validations/app_validation.dart';
import 'package:algonaid/core/widgets/shared/show_dialog.dart';
import 'package:algonaid/core/utils/functions/user_friendly_error.dart';
import 'package:algonaid/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid/features/auth/presentation/widgets/label.dart';
import 'package:algonaid/features/auth/presentation/widgets/signin_with_google.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Imports (المسارات الخاصة بمشروعك)
import 'package:algonaid/core/theme/colors.dart';
import 'package:algonaid/core/widgets/buttons/custom_button.dart';
import 'package:algonaid/core/widgets/shared/textform_field.dart';
import 'package:algonaid/features/auth/presentation/widgets/auth_header.dart';
import 'package:algonaid/features/auth/presentation/widgets/drop_down_bottun.dart';
import 'package:algonaid/features/auth/presentation/widgets/swap_bottons.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'dart:io' show Platform;
import 'package:url_launcher/url_launcher.dart';

class SigninAndSignupPage extends StatefulWidget {
  const SigninAndSignupPage({super.key});

  @override
  State<SigninAndSignupPage> createState() => _SigninAndSignupPageState();
}

class _SigninAndSignupPageState extends State<SigninAndSignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthServiceProvider>();
    return Scaffold(
      backgroundColor: context.background,

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  AuthHeader(),
                  const SizedBox(height: 32),

                  Center(child: SwapAuthButtonCostum(auth: authService)),
                  const SizedBox(height: 16),
                   SignInWithGoogle(auth: authService),
                   Center(child: TextLabel(text: "أو", Vpadding: 8.0)),

                  //=========================
                  // user name fields
                  //=========================
                  if (!authService.isLogin) ...[
                    TextLabel(text: "الأسم الكامل"),
                    const SizedBox(height: 5),
                    CustomTextFormField(
                      controller: _nameController,
                      labelText: "ادخل اسمك الكامل",
                      borderColor: context.primary,
                      validator: (name) =>
                          Validator.length(name, min: 2, max: 50),
                    ),
                    const SizedBox(height: 16),
                  ],
                  //=========================

                  //=========================
                  // email field
                  //=========================
                  TextLabel(text: " البريد الإلكتروني"),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    controller: _emailController,
                    labelText: "ادخل عنوان البريد الإلكتروني",
                    borderColor: context.primary,
                    validator: (email) => Validator.email(email!),
                  ),
                  //=========================

                  //=========================
                  // password field
                  //=========================
                  const SizedBox(height: 16),
                  TextLabel(text: " كلمة السر"),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    controller: _passwordController,
                    labelText: "ادخل كلمة المرور",
                    borderColor: context.primary,
                    isPasswordVisible: authService.isPasswordVisible!,
                    isPassword: true,
                    fillPercentage: authService.showPasswordStrength ?? 0,
                    onChanged: (p0) {
                      authService.checkPassStrength(p0);
                    },
                    onSuffixPressed: () {
                      authService.changePasswordVisiblity();
                    },

                    suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                    validator: (password) => Validator.password(
                      password,
                      strength: PasswordStrength.strong,
                    ),
                  ),
                  const SizedBox(height: 16),

                  //=========================
                  // confirm password field
                  //=========================
                  // if (!authService.isLogin) ...[
                  //   TextLabel(text: " تأكيد كلمة السر"),
                  //   const SizedBox(height: 5),
                  //   CustomTextFormField(
                  //     controller: _confirmPasswordController,
                  //     labelText: "أعد ادخل كلمة المرور",
                  //     borderColor: context.primary,
                  //     isPasswordVisible: authService.isPasswordVisible!,
                  //     isPassword: true,
                  //     onSuffixPressed: () {
                  //       authService.changePasswordVisiblity();
                  //     },
                  //     suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                  //     validator: (password) {
                  //       if (password != _passwordController.text) {
                  //         return "كلمات المرور غير متطابقة";
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  //   const SizedBox(height: 16),
                  // ],

                  //=========================
                  authService.isLogin
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: Text("نسيت كلمة السر؟"),
                            onPressed: () {
                              _showForgotPasswordBottomSheet(context, authService);
                            },
                          ),
                        )
                      : SizedBox.shrink(),

                  // //=========================
                  // // role field
                  // //=========================
                  // if (!authService.isLogin) ...[
                  //   TextLabel(text: "الدور"),
                  //   const SizedBox(height: 5),
                  //   DropDownButton(auth: authService),
                  // ],
                  // const SizedBox(height: 32),
                  //=========================

                  //=========================
                  // signin & signup button
                  //=========================
                  Center(
                    child: authService.isLoading
                        ? CircularProgressIndicator()
                        : CustomButton(
                            color: context.primary,
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              if (authService.isLogin) {
                                await authService.login(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                              } else {
                                // if (authService.selectedRole == null) {
                                //   AppDialog.showDynamicDialog(
                                //     context: context,
                                //     title: "تنبيه",
                                //     message: "يرجى اختيار الدور",
                                //     isError: true,
                                //     showCancelButton: false,
                                //   );
                                //   return;
                                // }
                                await authService.signUp(
                                  username: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  role: authService.selectedRole!,
                                );
                              }

                              if (!context.mounted) return;

                              if (authService.user != null) {
                                // نجاح تسجيل الدخول أو إنشاء الحساب
                                if (!authService.isLogin) {
                                  AppDialog.showDynamicDialog(
                                    context: context,
                                    title: "تم إنشاء الحساب",
                                    message: "تم إنشاء حسابك بنجاح. يرجى التحقق من بريدك الإلكتروني لتأكيد الحساب عبر الرابط المرسل.",
                                    content: _buildSpamWarningWidget(context),
                                    isError: false,
                                    showCancelButton: false,
                                    confirmText: "الانتقال إلى البريد للتحقق",
                                    onConfirm: () async {
                                      if (Platform.isAndroid) {
                                        final intent = const AndroidIntent(
                                          action: 'android.intent.action.MAIN',
                                          category: 'android.intent.category.APP_EMAIL',
                                          flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
                                        );
                                        try {
                                          await intent.launch();
                                        } catch (e) {
                                          // ignore
                                        }
                                      }
                                      authService.setAuthMode(true);
                                    }
                                  );
                                } else {
                                  GoRouter.of(context).go(Routes.homePage);
                                }
                              } else if (authService.errorMessage != null) {
                                AppDialog.showDynamicDialog(
                                  context: context,
                                  title: authService.isLogin ? "تعذر تسجيل الدخول" : "تعذر إنشاء الحساب",
                                  message: toUserFriendlyErrorMessage(
                                    authService.errorMessage,
                                  ),
                                  isError: true,
                                  showCancelButton: false,
                                  confirmText: "حاول مرة أخرى",
                                );
                              }
                            },
                            text: authService.isLogin
                                ? "تسجيل دخول"
                                : "إنشاء حساب",
                            textColor: Colors.white,
                          ),
                  ),

                  //=========================
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          "في حال مواجهة أي مشكلة، تواصل مع الدعم الفني:",
                          style: context.textTheme.labelSmall?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () async {
                            final Uri url = Uri.parse('https://wa.me/967772971739');
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.support_agent_rounded, size: 18, color: context.primary),
                                const SizedBox(width: 6),
                                Text(
                                  "772971739",
                                  style: context.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.primary,
                                  ),
                                  textDirection: TextDirection.ltr,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordBottomSheet(
    BuildContext context,
    AuthServiceProvider authService,
  ) {
    final emailSheetController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: context.colorScheme.onSecondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    "استعادة كلمة المرور",
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextLabel(text: "البريد الإلكتروني"),
                const SizedBox(height: 5),
                CustomTextFormField(
                  controller: emailSheetController,
                  labelText: "ادخل عنوان البريد الإلكتروني الخاص بك",
                  borderColor: context.primary,
                  validator: (email) => Validator.email(email!),
                ),
                const SizedBox(height: 24),
                Center(
                  child: CustomButton(
                    color: context.primary,
                    textColor: Colors.white,
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final email = emailSheetController.text.trim();

                      Navigator.pop(sheetContext); // Close email sheet

                      final successMsg = await authService.forgotPassword(
                        email: email,
                      );

                      if (!context.mounted) return;

                      if (successMsg != null) {
                        // Success: Show a dialog to open email app
                        AppDialog.showDynamicDialog(
                          context: context,
                          title: "تم الإرسال",
                          message: "تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يرجى فتح الإيميل والضغط على الرابط لإنشاء كلمة مرور جديدة.",
                          content: _buildSpamWarningWidget(context),
                          isError: false,
                          showCancelButton: true,
                          cancelText: "إغلاق",
                          confirmText: "فتح الإيميل",
                          onConfirm: () async {
                            if (Platform.isAndroid) {
                              final intent = const AndroidIntent(
                                action: 'android.intent.action.MAIN',
                                category: 'android.intent.category.APP_EMAIL',
                                flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
                              );
                              try {
                                await intent.launch();
                              } catch (e) {
                                // ignore
                              }
                            }
                          },
                        );
                      } else {
                        // Error
                        AppDialog.showDynamicDialog(
                          context: context,
                          title: "خطأ",
                          message: toUserFriendlyErrorMessage(
                            authService.errorMessage,
                          ),
                          isError: true,
                          showCancelButton: false,
                        );
                      }
                    },
                    text: "إرسال رابط إعادة تعيين كلمة المرور",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpamWarningWidget(BuildContext context) {
    return Theme(
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
    );
  }
}
