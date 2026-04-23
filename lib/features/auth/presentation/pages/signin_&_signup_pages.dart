import 'package:algonaid_mobail_app/core/common/enums/password_strength.dart';
import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/routes/paths_routes.dart';
import 'package:algonaid_mobail_app/core/utils/validations/app_validation.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/show_dialog.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Imports (المسارات الخاصة بمشروعك)
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/widgets/buttons/custom_button.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/textform_field.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/widgets/auth_header.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/widgets/drop_down_bottun.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/widgets/signin_with_google.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/widgets/swap_bottons.dart';

class SigninAndSignupPage extends StatefulWidget {
  const SigninAndSignupPage({super.key});

  @override
  State<SigninAndSignupPage> createState() => _SigninAndSignupPageState();
}

class _SigninAndSignupPageState extends State<SigninAndSignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                crossAxisAlignment: CrossAxisAlignment.end,
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
                  authService.isLogin
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: Text("نسيت كلمة السر؟"),
                            onPressed: () {},
                          ),
                        )
                      : SizedBox.shrink(),

                  //=========================
                  // role field
                  //=========================
                  if (!authService.isLogin) ...[
                    TextLabel(text: "الدور"),
                    const SizedBox(height: 5),
                    DropDownButton(auth: authService),
                  ],
                  const SizedBox(height: 32),
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
                                if (authService.selectedRole == null) {
                                  AppDialog.showDynamicDialog(
                                    context: context,
                                    title: "تنبيه",
                                    message: "يرجى اختيار الدور",
                                    isError: true,
                                  );
                                  return;
                                }
                                await authService.signUp(
                                  username: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  role: authService.selectedRole!,
                                );
                              }

                              if (!context.mounted) return;

                              if (authService.user != null) {
                                AppDialog.showDynamicDialog(
                                  context: context,
                                  title: "Success",
                                  message: "Welcome Back!",
                                  onConfirm: () =>
                                      GoRouter.of(context).go(Routes.homePage),
                                );
                              } else if (authService.errorMessage != null) {
                                AppDialog.showDynamicDialog(
                                  context: context,
                                  title: "Error",
                                  message: authService.errorMessage!,
                                  isError: true,
                                );
                              }
                            },
                            text: authService.isLogin
                                ? "تسجيل دخول"
                                : "إنشاء حساب",
                            textColor: AppColors.bgLight,
                          ),
                  ),

                  //=========================
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
