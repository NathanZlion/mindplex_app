import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/interaction/controllers/like_dislike_controller.dart';
import 'package:mindplex/features/search/controllers/search_controller.dart';

import '../../../../routes/app_routes.dart';
import '../../../user_profile_displays/controllers/user_profile_controller.dart';
import '../../../user_profile_settings/models/user_profile.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user, required this.index});
  final SearchPageController user;
  final int index;

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    ProfileController profileController = Get.find();
    profileController.getAuthenticatedUser();

    return GestureDetector(
      onTap: () {
        if (authController.isGuestUser.value) {
          authController.guestReminder(context);
        } else {
          Get.toNamed(AppRoutes.profilePage, parameters: {
            "me": "notme",
            "username": user.getSearchedUsers[index].username ?? ""
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(
                        user.getSearchedUsers[index].avatarUrl ?? ""),
                    radius: 20,
                    child: const Material(
                      color: Color.fromARGB(0, 231, 6, 6), //
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.getSearchedUsers[index].firstName! +
                              " " +
                              user.getSearchedUsers[index].lastName!,
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                        Text(
                          user.getSearchedUsers[index].username!,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Obx(() => profileController.authenticatedUser.value.username ==
                    user.getSearchedUsers[index].username
                ? Container()
                : GestureDetector(
                    onTap: () {
                      if (authController.isGuestUser.value) {
                        authController.guestReminder(context);
                      } else if (!user.getSearchedUsers[index]
                          .isSendingFollowRequest!.value) {
                        user.followUnfollowUser(
                            index,
                            user.getSearchedUsers[index].username!,
                            user.getSearchedUsers[index].isFollowing!.value);
                      }
                    },
                    child: Obx(() => Container(
                          width: 75,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 49, 153, 167),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(8),
                          child: user.getSearchedUsers[index]
                                  .isSendingFollowRequest!.value
                              ? Center(
                                  child: Container(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator()),
                                )
                              : user.getSearchedUsers[index].isFollowing!.value
                                  ? Center(
                                      child: Text('Unfollow',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                    )
                                  : Center(
                                      child: Text('follow',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15)),
                                    ),
                        )),
                  )),
          ],
        ),
      ),
    );
  }
}
