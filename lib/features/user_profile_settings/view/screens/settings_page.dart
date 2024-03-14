import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';

import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_settings/controllers/settings_controller.dart';
import 'package:mindplex/features/user_profile_settings/view/screens/personal_settings.dart';
import 'package:mindplex/features/user_profile_settings/view/screens/preference.dart';
import 'package:mindplex/features/user_profile_settings/view/screens/recommendation.dart';

import '../../../../routes/app_routes.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/no_internet_card_widget.dart';
import 'change_password.dart';
import 'general_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() {
    return _SettingsPage();
  }
}

class _SettingsPage extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    settingsController.fetchUserInfo(profileController.authenticatedUser.value.username!);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  AuthController authController = Get.put(AuthController());

  ProfileController profileController = Get.put(ProfileController());

  SettingsController settingsController = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBackgroundColor,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40, left: 5, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'Edit Profile',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: const Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 35,
              decoration: BoxDecoration(
                color: Color.fromARGB(50, 118, 118, 128),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                controller: _tabController,
                isScrollable: true,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber.shade400),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white,
                tabs: [
                  Tab(
                    text: 'General',
                  ),
                  Tab(
                    text: 'Edit Profile',
                  ),
                  Tab(
                    text: "Password",
                  ),
                  Tab(
                    text: 'Recommendation',
                  ),
                  Tab(
                    text: "Settings",
                  )
                ],
              ),
            ),
          ),
          Obx(() => !profileController.isConnected.value?
          noInternetCard(() {
            profileController.getUserProfile(username:profileController.authenticatedUser.value.username!);
          }):Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Content for Tab 1
                GeneralSettings(),
                // Content for Tab 2
                PersonalSettingsPage(),
                ChangePasswordPage(),
                // Content for Tab 3
                RecommendationPage(),

                PreferencePage()
              ],
            ),
          ),),
        ],
      ),
    );
  }
}
