import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/config/app_assets.dart';
import 'package:bookapp/config/themes/app_colors.dart';
import 'package:bookapp/config/themes/app_text_styles.dart';
import 'package:bookapp/l10n/app_localizations.dart';

class OrderFeedbackView extends ConsumerStatefulWidget {
  const OrderFeedbackView({super.key, this.orderId});
  final String? orderId;

  @override
  ConsumerState<OrderFeedbackView> createState() => _OrderFeedbackViewState();
}

class _OrderFeedbackViewState extends ConsumerState<OrderFeedbackView> {
  int _rating = 4; // 4 yellow stars and 1 grey star matching Figma
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : AppColors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : AppColors.grey900),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              // Success SVG Illustration
              SizedBox(
                width: double.infinity,
                height: 150,
                child: SvgPicture.asset(
                  AppAssets.successSvg,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              // Heading
              Text(
                l10n.youReceivedTheOrder,
                style: AppTextStyles.h4.copyWith(
                  color: isDark ? Colors.white : AppColors.grey900,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 6),
              // Order ID
              Text(
                'Order #${widget.orderId ?? "2930541"}',
                style: AppTextStyles.bodyMediumMedium.copyWith(
                  color: isDark ? Colors.grey[400] : AppColors.grey500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              // Feedback Card Container (Light Purple Background)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : AppColors.primary500.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: isDark ? Colors.grey[800]! : AppColors.primary500.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${l10n.tellUsYourFeedback} ',
                          style: AppTextStyles.bodyLargeSemiBold.copyWith(
                            color: AppColors.primary500,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('🙌', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.feedbackExperienceMessage,
                      style: AppTextStyles.bodySmallRegular.copyWith(
                        color: isDark ? Colors.grey[300] : AppColors.primary500.withOpacity(0.85),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Stars Row (4 yellow, 1 grey)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _rating = index + 1;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              Icons.star_rounded,
                              size: 38,
                              color: index < _rating ? AppColors.yellow : (isDark ? Colors.grey[700] : AppColors.grey300),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    // Write something for us! text (Black/Grey900 & bold)
                    Text(
                      l10n.writeSomethingForUs,
                      style: AppTextStyles.bodyMediumBold.copyWith(
                        color: isDark ? Colors.white : AppColors.grey900, // لون أسود داكن (Black)
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // TextField for review input
                    TextField(
                      controller: _feedbackController,
                      maxLines: 3,
                      style: AppTextStyles.bodyMediumRegular.copyWith(color: isDark ? Colors.white : AppColors.grey900),
                      decoration: InputDecoration(
                        hintText: l10n.feedbackHintText,
                        hintStyle: AppTextStyles.bodyMediumRegular.copyWith(color: AppColors.grey400),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF121212) : AppColors.white,
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: isDark ? Colors.grey[800]! : AppColors.grey200!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: isDark ? Colors.grey[800]! : AppColors.grey200!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColors.primary500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Done Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary500,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    context.go(AppRoutes.home);
                  },
                  child: Text(
                    l10n.done,
                    style: AppTextStyles.bodyLargeSemiBold.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
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