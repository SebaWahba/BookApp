import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/l10n/app_localizations.dart';

class SetAddressFormView extends StatefulWidget {
  const SetAddressFormView({super.key});

  @override
  State<SetAddressFormView> createState() => _SetAddressFormViewState();
}

class _SetAddressFormViewState extends State<SetAddressFormView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController governorateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController blockController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController flatController = TextEditingController();
  final TextEditingController avenueController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    governorateController.dispose();
    cityController.dispose();
    blockController.dispose();
    streetController.dispose();
    buildingController.dispose();
    floorController.dispose();
    flatController.dispose();
    avenueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : AppColors.white,
      appBar: AppBar(
        title: Text(
          l10n.location,
          style: AppTextStyles.h4.copyWith(color: isDark ? Colors.white : AppColors.grey900),
        ),
        centerTitle: true,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.grey900),
          onPressed: () => context.pop(),
        ),
        // تمت إضافة أيقونة الـ Bullseye (GPS) هنا في أقصى اليمين
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: AppColors.primary500),
            onPressed: () {
              // الإجراء عند الضغط على الأيقونة
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(l10n.phone, l10n.phone, phoneController, l10n, isRequired: true, isDark: isDark),
              const SizedBox(height: 16),
              _buildTextField(l10n.name, l10n.name, nameController, l10n, isRequired: true, isDark: isDark),
              const SizedBox(height: 16),
              _buildTextField(l10n.governorate, l10n.governorate, governorateController, l10n, isRequired: true, isDark: isDark),
              const SizedBox(height: 16),
              _buildTextField(l10n.city, l10n.city, cityController, l10n, isRequired: true, isDark: isDark),
              const SizedBox(height: 16),
              _buildTextField(l10n.block, l10n.block, blockController, l10n, isRequired: true, isDark: isDark),
              const SizedBox(height: 16),
              _buildTextField(l10n.streetNameNumber, l10n.streetNameNumber, streetController, l10n, isRequired: true, isDark: isDark),
              const SizedBox(height: 16),
              _buildTextField(l10n.buildingNameNumber, l10n.buildingNameNumber, buildingController, l10n, isRequired: true, isDark: isDark),
              const SizedBox(height: 16),
              _buildTextField(l10n.floorOption, l10n.floorOption, floorController, l10n, isDark: isDark),
              const SizedBox(height: 16),
              _buildTextField(l10n.flatOption, l10n.flatOption, flatController, l10n, isDark: isDark),
              const SizedBox(height: 16),
              _buildTextField(l10n.avenueOption, l10n.avenueOption, avenueController, l10n, isDark: isDark),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.pop();
                    }
                  },
                  child: Text(
                    l10n.confirmation,
                    style: AppTextStyles.bodyLargeSemiBold.copyWith(color: AppColors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
    AppLocalizations l10n, {
    bool isRequired = false,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMediumBold.copyWith(color: isDark ? Colors.grey[300] : AppColors.grey800),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          style: AppTextStyles.bodyMediumRegular.copyWith(color: isDark ? Colors.white : AppColors.grey900),
          validator: isRequired
              ? (value) => (value == null || value.isEmpty)
                  ? l10n.fieldRequired
                  : null
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey400),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E1E1E) : AppColors.grey50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: isDark ? Colors.grey[800]! : AppColors.grey200!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: isDark ? Colors.grey[800]! : AppColors.grey200!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary500),
            ),
          ),
        ),
      ],
    );
  }
}