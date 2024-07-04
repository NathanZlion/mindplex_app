import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';
import 'package:mindplex/features/user_profile_displays/view/widgets/followers_overlay.dart';

class UserProfileStatistics extends StatelessWidget {
  const UserProfileStatistics({
    Key? key,
    required this.profileController,
  });
  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    var statistics = [
      {
        "amount": profileController.userProfile.value.friends.toString(),
        "value": "Friends"
      },
      {
        "amount": profileController.userProfile.value.followings.toString(),
        "value": "Following"
      },
      {
        "amount": profileController.userProfile.value.followers.toString(),
        "value": "Followers"
      },
      {
        "amount": profileController.userProfile.value.mpxr.toString(),
        "value": " MPXR"
      }
    ];

    return Container(
      height: 46,
      margin: const EdgeInsets.only(bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var item in statistics)
            GestureDetector(
              onTap: () {
                if (item['value'] == "Followers") {
                  _showFollowersOverlay(context);
                }
                if (item['value'] == "Following") {
                  _showFollowingsOverlay(context);
                }
              },
              child: Row(
                children: [
                  statistics.indexOf(item) != statistics.length - 1
                      ? Column(
                          children: [
                            Text(
                              item['amount'].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              item['value'].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 190, 190, 190),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Obx(
                              () => profileController.isLoadingReputation.value
                                  ? Container(
                                      height: 10,
                                      width: 10,
                                      child: CircularProgressIndicator(
                                        color: Colors.green,
                                      ),
                                    )
                                  : Text(
                                      profileController
                                                  .userProfile.value.mpxr !=
                                              null
                                          ? profileController
                                              .userProfile.value.mpxr!
                                              .toStringAsFixed(3)
                                          : "-",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                            Text(
                              "MPXR",
                              style: TextStyle(
                                color: Color.fromARGB(255, 190, 190, 190),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                  if (statistics.indexOf(item) != statistics.length - 1)
                    Container(
                      height: 40.0,
                      width: 1.0,
                      color: const Color.fromARGB(255, 73, 150, 154),
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showFollowersOverlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FollowersOverlay(
        fetchUserFollowers: true,
        profileController: profileController,
      ),
      // isScrollControlled: true,
    );
  }

  void _showFollowingsOverlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FollowersOverlay(
        fetchUserFollowers: false,
        profileController: profileController,
      ),
    );
  }
}
