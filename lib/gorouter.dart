import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/widgets/cards/product_card.dart';
import 'package:genshin_import/ui/core/widgets/navigation_bar/navigation_bar.dart';
import 'package:genshin_import/ui/core/widgets/navigation_bar/navigation_bar_item_data.dart';
import 'package:genshin_import/ui/core/widgets/navigation_bar/navigation_item.dart';
import 'package:genshin_import/ui/features/admin/widgets/admin_main_view.dart';
import 'package:genshin_import/ui/features/admin/widgets/product_form.dart';
import 'package:genshin_import/ui/features/authentication/view_models/forgot_password_view_model.dart';
import 'package:genshin_import/ui/features/authentication/widgets/forgot_password_view.dart';
import 'package:genshin_import/ui/features/authentication/widgets/landing_view.dart';
import 'package:genshin_import/ui/features/authentication/view_models/login_view_model.dart';
import 'package:genshin_import/ui/features/authentication/widgets/login_view.dart';
import 'package:genshin_import/ui/features/authentication/view_models/signup_view_model.dart';
import 'package:genshin_import/ui/features/authentication/widgets/signup_view.dart';
import 'package:genshin_import/ui/features/profile/widgets/change_email_view.dart';
import 'package:genshin_import/ui/features/profile/widgets/change_password_view.dart';
import 'package:genshin_import/ui/features/profile/widgets/change_username_view.dart';
import 'package:genshin_import/ui/features/profile/widgets/profile_view.dart';
import 'package:genshin_import/ui/features/product/widgets/product_detail_view.dart';
import 'package:genshin_import/ui/features/user/widgets/user_main_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final router = GoRouter(
  initialLocation: '/test',

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
    GoRoute(
      path: '/change_username',
      builder: (context, state) => const ChangeUsernameView(),
    ),
    GoRoute(
      path: '/change_email',
      builder: (context, state) => const ChangeEmailView(),
    ),
    GoRoute(
      path: '/change_password',
      builder: (context, state) => const ChangePasswordView(),
    ),
    GoRoute(
      path: '/product_detail',
      builder: (context, state) {
        final extraData = state.extra as Map<String, dynamic>;
        
        final product = extraData['product'] as Product;
        final deletionPage = extraData['deletionPage'] as bool;

        return ProductDetailView(
          product: product, 
          deletionPage: deletionPage,
        );
      },
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminMainView(),
    ),
    GoRoute(
      path: '/user',
      builder: (context, state) => const UserMainView(),
    ),
    GoRoute(
      path: '/test',
      builder: (context, state) => const UserMainView(),
    ),
  ],
);