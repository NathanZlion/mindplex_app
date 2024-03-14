import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/utils/network/connection-info.dart';
import 'package:mindplex/routes/app_routes.dart';
import 'package:page_transition/page_transition.dart';

import 'features/authentication/view/screens/auth.dart';
import 'main.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final ConnectionInfoImpl connectionChecker = Get.put(
      ConnectionInfoImpl(connectionChecker: InternetConnectionChecker()));
  AuthController authController = Get.put(AuthController());
  Future<void> loadUserInfo() async {
    if (authController.isAuthenticated.value) {
      ProfileController profileController = Get.put(ProfileController());
      await profileController.getAuthenticatedUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    authController.checkAuthentication();
    loadUserInfo();
    return Scaffold(
      body: Obx(
        () => authController.checkingTokenValidity.value
            ? AnimatedContainer(
                duration: Duration(seconds: 2),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                  'assets/images/logo.png',
                ))),
              )
            : AnimatedSplashScreen(
                splash: Image.asset(
                  'assets/images/logo.png',
                ),
                duration: 2000,
                curve: Curves.easeInOut,
                splashIconSize: 350,
                splashTransition: SplashTransition.rotationTransition,
                animationDuration: const Duration(milliseconds: 1500),
                backgroundColor: Colors.white,
                pageTransitionType: PageTransitionType.fade,
                nextRoute: !authController.isAuthenticated.value
                    ? AppRoutes.authPage
                    : AppRoutes.landingPage,
                nextScreen: Obx(() => !authController.isAuthenticated.value
                    ? const AuthPage()
                    : const MyHomePage(title: "Mindplex")),
              ),
      ),
    );
  }
}
