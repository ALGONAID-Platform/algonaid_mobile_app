import 'package:algonaid_mobail_app/core/common/enums/user_role.dart';
import 'package:algonaid_mobail_app/core/utils/validations/app_validation.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports (المسارات الخاصة بمشروعك)
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:algonaid_mobail_app/core/theme/styles.dart';
import 'package:algonaid_mobail_app/core/widgets/buttons/custom_button.dart';
import 'package:algonaid_mobail_app/core/widgets/shared/textform_field.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:algonaid_mobail_app/features/auth/presentation/widgets/costum_label.dart';
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
    final uiState = context.watch<AuthStateProvider>();
    final authService = context.watch<AuthServiceProvider>();
    return Scaffold(
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
                  CostumLabel(),
                  const SizedBox(height: 32),

                  Center(child: SwapAuthButtonCostum(auth: uiState)),
                  const SizedBox(height: 16),
                  const SignInWithGoogle(),

                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("أو"),
                    ),
                  ),

                  //=========================
                  // user name fields
                  //=========================
                  if (!uiState.isLogin) ...[
                    const Text("الأسم الكامل", style: Styles.textStyle16),
                    const SizedBox(height: 5),
                    CustomTextFormField(
                      controller: _nameController,
                      labelText: "ادخل اسمك الكامل",
                      borderColor: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                  ],
                  //=========================

                  //=========================
                  // email field
                  //=========================
                  const Text(" البريد الإلكتروني", style: Styles.textStyle16),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    controller: _emailController,
                    labelText: "ادخل عنوان البريد الإلكتروني",
                    borderColor: AppColors.primary,
                    validator: (email) => Validator.email(email!),
                  ),
                  //=========================

                  //=========================
                  // password field
                  //=========================
                  const SizedBox(height: 16),
                  const Text(" كلمة السر", style: Styles.textStyle16),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    controller: _passwordController,
                    labelText: "ادخل كلمة المرور",
                    borderColor: AppColors.primary,
                    isPassword: true,
                    suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                  ),
                  const SizedBox(height: 16),
                  //=========================

                  //=========================
                  // role field
                  //=========================
                  if (!uiState.isLogin) ...[
                    const Text("الدور", style: Styles.textStyle16),
                    const SizedBox(height: 5),
                    DropDownButton(auth: uiState),
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
                            color: AppColors.primary,
                            onPressed: () {
                              if (uiState.isLogin) {
                                if (_formKey.currentState!.validate()) {
                                  authService.login(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                }
                              } else {
                                if (_formKey.currentState!.validate()) {
                                  authService.signUp(
                                    username: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    role: uiState.selectedRole!,
                                  );
                                }
                              }
                            },
                            text: uiState.isLogin ? "تسجيل دخول" : "إنشاء حساب",
                            textColor: AppColors.bgLight,
                          ),
                  ),
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
