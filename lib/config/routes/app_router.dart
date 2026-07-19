import 'package:bookapp/config/routes/app_routes.dart';
import 'package:bookapp/features/auth/presentation/forget_password/models/success_type.dart';
import 'package:bookapp/features/auth/presentation/forget_password/models/verification_contact_type.dart';
import 'package:bookapp/features/auth/presentation/forget_password/views/create_new_password_view.dart';
import 'package:bookapp/features/auth/presentation/forget_password/views/reset_password.dart';
import 'package:bookapp/features/auth/presentation/forget_password/views/success_view.dart';
import 'package:bookapp/features/auth/presentation/forget_password/views/verification_code_view.dart';
import 'package:bookapp/features/onbaording/presentation/views/onbaording_view.dart';
import 'package:bookapp/features/splash/presentation/views/splash_view.dart';
import 'package:bookapp/features/auth/presentation/login/views/sign_in_view.dart';
import 'package:bookapp/features/auth/presentation/login/views/sign_up_view.dart';
import 'package:bookapp/features/auth/presentation/forget_password/views/forget_password_method_view.dart';
import 'package:go_router/go_router.dart';

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

          return VerificationCodeView(
            contact: args?.contact ?? '',
            contactType: args?.contactType ?? VerificationContactType.email,
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
          final type = state.extra as VerificationContactType;

          return ResetPassword(
            type: type,
          );
        },
      ),
    ],
  );
}

class VerificationCodeArgs {
  const VerificationCodeArgs({
    required this.contact,
    required this.contactType,
  });

  final String contact;
  final VerificationContactType contactType;
}