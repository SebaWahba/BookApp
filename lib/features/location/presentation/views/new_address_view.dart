import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:bookapp/core/responsive/app_breakpoints.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/core/components/buttons/primary_button.dart';
import 'package:bookapp/core/components/inputs/app_text_field.dart';
import 'package:bookapp/core/constants/app_spacing.dart';
import 'package:bookapp/core/utils/snackbar_utils.dart';
import 'package:bookapp/l10n/app_localizations.dart';
import '../../domain/entities/address_entity.dart';
import '../providers/location_controller.dart';
import '../widgets/address_type_selector.dart';

class NewAddressView extends ConsumerStatefulWidget {
  const NewAddressView({super.key, this.initialAddress});

  final AddressEntity? initialAddress;

  @override
  ConsumerState<NewAddressView> createState() => _NewAddressViewState();
}

class _NewAddressViewState extends ConsumerState<NewAddressView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _addressController;
  late String _addressType;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController(
      text: widget.initialAddress?.address ?? '',
    );
    _addressType = widget.initialAddress?.addressType ?? 'home';
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveAddress(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    final success = await ref
        .read(locationControllerProvider.notifier)
        .saveAddress(
          address: _addressController.text,
          addressType: _addressType,
        );

    if (!mounted) return;

    if (success) {
      SnackbarUtils.showSuccess(context, l10n.addressSavedSuccessfully);
      context.pop();
      return;
    }

    SnackbarUtils.showError(context, l10n.failedToSaveAddress);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isSaving = ref.watch(locationControllerProvider).isLoading;
    final isTablet = MediaQuery.sizeOf(context).width >= AppBreakpoints.mobile;
    final maxContentWidth = isTablet ? 800.0 : double.infinity;

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: context.colors.title),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          l10n.newAddress,
          style: context.type.h4.copyWith(color: context.colors.title, fontSize: 18.sp),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppSpacing.xl.h),
                    Text(
                      l10n.addressType,
                      style: context.type.bodyMediumMedium.copyWith(
                        color: context.colors.title,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    AddressTypeSelector(
                      homeLabel: l10n.home,
                      officeLabel: l10n.office,
                      selectedType: _addressType,
                      onChanged: isSaving
                          ? (_) {}
                          : (type) => setState(() => _addressType = type),
                    ),
                    SizedBox(height: AppSpacing.xl.h),
                    Text(
                      l10n.address,
                      style: context.type.bodyMediumMedium.copyWith(
                        color: context.colors.title,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm.h),
                    AppTextField(
                      controller: _addressController,
                      hintText: l10n.address,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return l10n.addressRequired;
                        }
                        return null;
                      },
                    ),
                    const Spacer(),
                    PrimaryButton(
                      text: isSaving ? l10n.savingButton : l10n.saveAddress,
                      onPressed: isSaving ? null : () => _saveAddress(l10n),
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}