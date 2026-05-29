import 'package:algonaid_mobail_app/core/common/extensions/theme_helper.dart';
import 'package:algonaid_mobail_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({Key? key}) : super(key: key);

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _avatarController;
  late TextEditingController _backgroundController;
  late TextEditingController _gradeController;
  late TextEditingController _birthDateController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final profile = provider.userProfile;
    
    String formattedBirthDate = profile?.birthDate ?? '';
    if (formattedBirthDate.isNotEmpty) {
      try {
        final parsed = DateTime.parse(formattedBirthDate);
        formattedBirthDate = "${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}";
      } catch (e) {
        // keep as is
      }
    }
    
    _nameController = TextEditingController(text: profile?.name ?? '');
    _avatarController = TextEditingController(text: profile?.avatar ?? '');
    _backgroundController = TextEditingController(text: profile?.background ?? '');
    _gradeController = TextEditingController(text: profile?.grade ?? '');
    _birthDateController = TextEditingController(text: formattedBirthDate);
    _addressController = TextEditingController(text: profile?.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarController.dispose();
    _backgroundController.dispose();
    _gradeController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (_birthDateController.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(_birthDateController.text);
      } catch (e) {
        // Fallback to now
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: context.theme.copyWith(
            colorScheme: context.colorScheme.copyWith(
              primary: context.colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() {
        _birthDateController.text = formattedDate;
      });
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        if (_nameController.text.isNotEmpty) 'name': _nameController.text,
        if (_avatarController.text.isNotEmpty) 'avatar': _avatarController.text,
        if (_backgroundController.text.isNotEmpty) 'background': _backgroundController.text,
        if (_gradeController.text.isNotEmpty) 'grade': _gradeController.text,
        if (_birthDateController.text.isNotEmpty) 'birthDate': _birthDateController.text,
        if (_addressController.text.isNotEmpty) 'address': _addressController.text,
      };
      
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      final success = await provider.updateUserProfile(data);
      if (success) {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
              
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildTextField(
                        context,
                        controller: _nameController,
                        label: 'الاسم الكامل',
                        icon: Icons.person_rounded,
                        validator: (value) => value == null || value.isEmpty ? 'الاسم مطلوب' : null,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        context,
                        controller: _gradeController,
                        label: 'الصف الدراسي',
                        icon: Icons.school_rounded,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        context,
                        controller: _birthDateController,
                        label: 'تاريخ الميلاد',
                        icon: Icons.cake_rounded,
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        context,
                        controller: _addressController,
                        label: 'العنوان الحالي',
                        icon: Icons.location_on_rounded,
                      ),
                      const SizedBox(height: 14),
                      _buildTextField(
                        context,
                        controller: _avatarController,
                        label: 'رابط الصورة الشخصية (URL)',
                        icon: Icons.link_rounded,
                      ),
                     
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // زر الحفظ الاحترافي المتجاوب مع حالة التحميل
              Consumer<ProfileProvider>(
                builder: (context, provider, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colorScheme.primary,
                        foregroundColor: context.colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: provider.isUpdatingProfile ? null : _saveProfile,
                      child: provider.isUpdatingProfile
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'حفظ التعديلات',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
        ])
      ),
    );
  }

  // ميثود بناء الحقول الموحدة بلمسة الـ Material 3 الاحترافية
  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      style: context.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: context.textTheme.bodyMedium?.copyWith(
          color: context.colorScheme.onSurface.withOpacity(0.5),
        ),
        prefixIcon: Icon(icon, size: 22, color: context.colorScheme.primary.withOpacity(0.7)),
        filled: true,
        fillColor: context.colorScheme.surfaceContainerLow.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none, // إخفاء الحواف التقليدية الباهتة
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: context.colorScheme.onSurface.withOpacity(0.06), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: context.colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
      ),
    );
  }
}