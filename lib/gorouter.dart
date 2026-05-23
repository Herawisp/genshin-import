import 'package:genshin_import/ui/features/authentication/forgot_password_view/view_models/forgot_password_view_model.dart';
import 'package:genshin_import/ui/features/authentication/forgot_password_view/widgets/forgot_password_view.dart';
import 'package:genshin_import/ui/features/authentication/landing_view/landing_view.dart';
import 'package:genshin_import/ui/features/authentication/login_view/view_models/login_view_model.dart';
import 'package:genshin_import/ui/features/authentication/login_view/widgets/login_view.dart';
import 'package:genshin_import/ui/features/authentication/signup_view/view_models/signup_view_model.dart';
import 'package:genshin_import/ui/features/authentication/signup_view/widgets/signup_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingView()
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => SignupViewModel(),
        child: const SignupView(),
      ),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => LoginViewModel(),
        child: const LoginView(),
      ),
    ),
    GoRoute(
      path: '/forgot_password',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => ForgotPasswordViewModel(),
        child: const ForgotPasswordView(),
      ),
    ),
  ],
);