import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bookapp/core/responsive/app_breakpoints.dart';
import 'package:bookapp/core/theme/extensions/theme_ext.dart';
import 'package:bookapp/l10n/app_localizations.dart';

class PromoOffer {
  final String discount;
  final String code;
  final Color backgroundColor;
  final Color textColor;

  const PromoOffer({
    required this.discount,
    required this.code,
    required this.backgroundColor,
    required this.textColor,
  });
}

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  final List<PromoOffer> offers = const [
    PromoOffer(discount: '50% OFF', code: 'SAVE50', backgroundColor: Color(0xFF5B4583), textColor: Colors.white),
    PromoOffer(discount: '23% OFF', code: 'BOOK23', backgroundColor: Color(0xFFFFC107), textColor: Colors.black),
    PromoOffer(discount: '50% OFF', code: 'CHAPTER50', backgroundColor: Color(0xFF2196F3), textColor: Colors.white),
    PromoOffer(discount: '23% OFF', code: 'READ23', backgroundColor: Color(0xFFFF9800), textColor: Colors.white),
    PromoOffer(discount: '50% OFF', code: 'VIP50', backgroundColor: Color(0xFF121212), textColor: Colors.white),
    PromoOffer(discount: '23% OFF', code: 'SUMMER23', backgroundColor: Color(0xFF4CAF50), textColor: Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isTablet = MediaQuery.sizeOf(context).width >= AppBreakpoints.mobile;
    final maxContentWidth = isTablet ? 900.0 : double.infinity;
    final crossAxisCount = isTablet ? 3 : 2;

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
          l10n.offers,
          style: context.type.h4.copyWith(color: context.colors.title, fontSize: 18.sp),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.couponsAvailable,
                    style: context.type.bodyMediumBold.copyWith(
                      color: context.colors.title,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: offers.length,
                      itemBuilder: (context, index) {
                        final offer = offers[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: offer.backgroundColor,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                offer.discount,
                                style: TextStyle(
                                  color: offer.textColor,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 24.h),
                              SizedBox(
                                width: 90.w,
                                height: 32.h,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(text: offer.code));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${l10n.promoCopied}${offer.code}')),
                                    );
                                  },
                                  child: Text(
                                    l10n.copy,
                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}