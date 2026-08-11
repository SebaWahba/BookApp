import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';

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
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Location',
          style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
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
              _buildTextField('Phone', 'Phone', phoneController, isRequired: true),
              const SizedBox(height: 16),
              _buildTextField('Name', 'Name', nameController, isRequired: true),
              const SizedBox(height: 16),
              _buildTextField('Governorate', 'Governorate', governorateController, isRequired: true),
              const SizedBox(height: 16),
              _buildTextField('City', 'City', cityController, isRequired: true),
              const SizedBox(height: 16),
              _buildTextField('Block', 'Block', blockController, isRequired: true),
              const SizedBox(height: 16),
              _buildTextField('Street name /number', 'Street name /number', streetController, isRequired: true),
              const SizedBox(height: 16),
              _buildTextField('Building name/number', 'Building name/number', buildingController, isRequired: true),
              const SizedBox(height: 16),
              _buildTextField('Floor (option)', 'Floor (option)', floorController),
              const SizedBox(height: 16),
              _buildTextField('Flat(option)', 'Flat(option)', flatController),
              const SizedBox(height: 16),
              _buildTextField('Avenue (option)', 'Avenue (option)', avenueController),
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
                    'Confirmation',
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
    TextEditingController controller, {
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMediumBold.copyWith(color: AppColors.grey800),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          style: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey900),
          validator: isRequired
              ? (value) => (value == null || value.isEmpty)
                  ? 'This field is required'
                  : null
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey400),
            filled: true,
            fillColor: AppColors.grey50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.grey200!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.grey200!),
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