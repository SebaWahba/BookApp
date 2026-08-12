import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/features/auth/presentation/email_verification/views/email_verification_view.dart';
import 'package:bookapp/features/auth/presentation/forget_password/models/success_type.dart';
import 'package:bookapp/features/auth/presentation/forget_password/models/verification_contact_type.dart';
import 'package:bookapp/features/auth/presentation/forget_password/views/create_new_password_view.dart';
import 'package:bookapp/features/auth/presentation/forget_password/views/forget_password_method_view.dart';
import 'package:bookapp/features/auth/presentation/forget_password/views/reset_password_view.dart';
import 'package:bookapp/features/auth/presentation/forget_password/views/success_view.dart';
import 'package:bookapp/features/auth/presentation/forget_password/views/verification_code_view.dart';
import 'package:bookapp/features/auth/presentation/login/views/sign_in_view.dart';
import 'package:bookapp/features/auth/presentation/phone_verification/views/input_phone_number_view.dart';
import 'package:bookapp/features/auth/presentation/sign_up/views/sign_up_view.dart';
import 'package:bookapp/features/book_details/presentation/views/menu_detail_view.dart';
import 'package:bookapp/features/books/data/models/book_model.dart';
import 'package:bookapp/features/books/presentation/views/all_books_view.dart';
import 'package:bookapp/features/home/presentation/authors/views/all_authors_view.dart';
import 'package:bookapp/features/home/presentation/views/home_view.dart';
import 'package:bookapp/features/profile/presentation/views/my_account_view.dart';
import 'package:bookapp/features/profile/presentation/views/profile_view.dart';
import 'package:bookapp/features/search/presentation/views/search_view.dart';
import 'package:bookapp/features/onbaording/presentation/views/onbaording_view.dart';
import 'package:bookapp/features/splash/presentation/views/splash_view.dart';
import 'package:bookapp/features/home/presentation/vendors/views/vendors_list_view.dart';
import 'package:bookapp/features/my_favorite/presentation/views/my_favorite_view.dart';

// --- Cart, Checkout & Notifications Views Imports (مصححة بالتهجئة السليمة تماماً) ---
import 'package:bookapp/features/cart/presentation/views/cart_view.dart';
import 'package:bookapp/features/checkout/presenation/views/confirm_order_view.dart';
import 'package:bookapp/features/checkout/presenation/views/set_address_view.dart';
import 'package:bookapp/features/checkout/presenation/set_address_form_view.dart';
import 'package:bookapp/features/checkout/presenation/views/order_success_view.dart';
import 'package:bookapp/features/checkout/presenation/views/order_feedback_view.dart';
import 'package:bookapp/features/notifications/views/notifactions_view.dart';
import 'package:bookapp/features/notifications/views/delivery_notifications_view.dart';
import 'package:bookapp/features/notifications/views/promotion_detail_view.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnbaordingView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const SignInView(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpView(),
      ),
      GoRoute(
        path: AppRoutes.verificationCode,
        builder: (context, state) {
          final args = state.extra as VerificationCodeArgs?;
          final firebaseEmail = FirebaseAuth.instance.currentUser?.email;
          final passedContact = args?.contact ?? '';
          final contactValue =
              (passedContact.isNotEmpty && passedContact != 'user@gmail.com')
              ? passedContact
              : (firebaseEmail ?? 'your_email@gmail.com');

          final contactType =
              args?.contactType ?? VerificationContactType.email;

          return EmailVerificationView(
            email: contactValue,
            onVerified: () {
              if (contactType == VerificationContactType.email) {
                context.pop();
                context.push(AppRoutes.inputPhoneNumber);
              } else {
                context.go(AppRoutes.success, extra: SuccessType.verification);
              }
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.createNewPassword,
        builder: (context, state) => const CreateNewPasswordView(),
      ),
      GoRoute(
        path: AppRoutes.success,
        builder: (context, state) {
          final type = state.extra as SuccessType? ?? SuccessType.resetPassword;
          return SuccessView(type: type);
        },
      ),
      GoRoute(
        path: AppRoutes.forgetPassword,
        builder: (context, state) => const ForgetPasswordMethodView(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) {
          final type =
              state.extra as VerificationContactType? ??
              VerificationContactType.email;
          return ResetPasswordView(type: type);
        },
      ),
      GoRoute(
        path: AppRoutes.forgetPasswordVerification,
        builder: (context, state) => const VerificationCodeView(),
      ),
      GoRoute(
        path: AppRoutes.inputPhoneNumber,
        builder: (context, state) {
          return InputPhoneNumberView(
            onVerified: (phone) {
              context.push(
                AppRoutes.verificationCode,
                extra: VerificationCodeArgs(
                  contact: phone,
                  contactType: VerificationContactType.phone,
                  onVerified: () {},
                ),
              );
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: AppRoutes.allBooks,
        builder: (context, state) => const AllBooksView(),
      ),
      GoRoute(
        path: AppRoutes.vendors,
        builder: (context, state) => const VendorsListView(),
      ),
      GoRoute(
        path: AppRoutes.authors,
        builder: (context, state) => const AllAuthorsView(),
      ),
      GoRoute(
        path: AppRoutes.bookDetails,
        builder: (context, state) {
          final book = state.extra as BookModel;
          return MenuDetailView(bookModel: book);
        },
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const SearchView(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: AppRoutes.myAccount,
        builder: (context, state) => const MyAccountView(),
      ),
      GoRoute(
        path: AppRoutes.myFavorite,
        builder: (context, state) => const MyFavoriteView(),
      ),
      // --- Cart & Checkout Routes ---
      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) => const CartView(),
      ),
      GoRoute(
        path: AppRoutes.confirmOrder,
        builder: (context, state) => const ConfirmOrderView(),
      ),
      GoRoute(
        path: AppRoutes.setAddress,
        builder: (context, state) => const SetAddressView(),
      ),
      GoRoute(
        path: AppRoutes.setAddressForm,
        builder: (context, state) => const SetAddressFormView(),
      ),
      GoRoute(
        path: AppRoutes.orderSuccess,
        builder: (context, state) {
          final orderId = state.extra as String? ?? '';
          return OrderSuccessView(orderId: orderId);
        },
      ),
      GoRoute(
        path: AppRoutes.orderFeedback,
        builder: (context, state) {
          final orderId = state.extra as String?;
          return OrderFeedbackView(orderId: orderId);
        },
      ),
      // --- Notifications & Promotion Routes ---
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsView(),
      ),
      GoRoute(
        path: AppRoutes.promotionDetail,
        builder: (context, state) {
          final promoData = state.extra as Map<String, dynamic>?;
          return PromotionDetailView(promoData: promoData);
        },
      ),
    ],
  );
}

class VerificationCodeArgs {
  const VerificationCodeArgs({
    required this.contact,
    required this.contactType,
    required this.onVerified,
  });

  final String contact;
  final VerificationContactType contactType;
  final VoidCallback onVerified;
}