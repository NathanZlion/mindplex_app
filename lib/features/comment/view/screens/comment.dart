import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mindplex/features/authentication/controllers/auth_controller.dart';
import 'package:mindplex/features/blogs/view/widgets/post_text_editor.dart';
import 'package:mindplex/features/comment/controllers/comment_controller.dart';
import 'package:mindplex/features/comment/view/widgets/comment_preview_overlay.dart';
import 'package:mindplex/features/comment/view/widgets/comment_tile.dart';
import 'package:mindplex/features/comment/view/widgets/custom_comment_text_editor.dart';
import 'package:mindplex/features/drawer/view/widgets/top_user_profile_icon.dart';
import 'package:mindplex/features/user_profile_displays/controllers/DraftedPostsController.dart';
import 'package:mindplex/features/user_profile_displays/controllers/user_profile_controller.dart';

import '../../../../utils/colors.dart';

class MyWidgetComment extends StatelessWidget {
  MyWidgetComment(
      {super.key, required this.post_slug, required this.comment_number});

  final String post_slug;
  final String comment_number;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentController(post_slug: post_slug));
    ProfileController profileController = Get.find();

    final theme = Theme.of(context);
    AuthController authController = Get.find();
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          color: Color(0xFF0c2b46),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Obx(
                () => Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Comments (${comment_number})',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 16,
                            color: commentSectionColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TopUserProfileIcon(
                            openDrawer: false,
                            profileController: profileController,
                            authController: authController),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: CustomCommentTextEditor(
                                commentController: controller,
                                showBulletList: false,
                                showNumberList: false,
                              )),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  commentSectionColor)),
                          onPressed: () {
                            if (authController.isGuestUser.value) {
                              authController.guestReminder(context);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => CommentPreviewOverlay(
                                        commentController: controller,
                                        profileController: profileController,
                                        authController: authController,
                                        currentComment: controller
                                            .commentTextEditingController.text,
                                      ));
                            }
                          },
                          child: Text(
                            'Preview',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => controller.loadingComments.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: commentSectionColor,
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: controller.comments.length,
                                itemBuilder: ((context, index) {
                                  var commentOwned = controller
                                          .comments[index].commentAuthor ==
                                      controller.userName;

                                  return Column(
                                    children: [
                                      CommentTile(
                                        index: index,
                                        isOwned: commentOwned,
                                        commentController: controller,
                                        comment: controller.comments[index],
                                        isSubComment: false,
                                      ),
                                      Obx(
                                        () => Container(
                                          margin: EdgeInsets.only(left: 12),
                                          padding: EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                                      width: 2,
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              103,
                                                              232,
                                                              107)))),
                                          child: controller.loadingCommentReply
                                                      .value &&
                                                  index >=
                                                      controller
                                                          .startPosition.value
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.green,
                                                  ),
                                                )
                                              : controller.comments[index]
                                                          .replies ==
                                                      null
                                                  ? SizedBox.shrink()
                                                  : ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      itemCount: controller
                                                          .comments[index]
                                                          .replies!
                                                          .length,
                                                      itemBuilder:
                                                          (context, index2) {
                                                        var replyOwned = controller
                                                                .comments[index]
                                                                .replies![
                                                                    index2]
                                                                .commentAuthor ==
                                                            controller.userName;
                                                        return CommentTile(
                                                          index: index,
                                                          isOwned: replyOwned,
                                                          commentController:
                                                              controller,
                                                          isSubComment: true,
                                                          comment: controller
                                                              .comments[index]
                                                              .replies![index2],
                                                          parent: controller
                                                              .comments[index],
                                                        );
                                                      }),
                                        ),
                                      ),
                                      const Divider(),
                                    ],
                                  );
                                }),
                              ),
                            ),
                    ),
                    if (controller.moreCommentsAvailable.value)
                      SizedBox(
                        child: TextButton(
                          onPressed: () {
                            controller.fetchMoreComments();
                          },
                          child: controller.loadingMoreComments.value
                              ? SizedBox(
                                  width: 80,
                                  child: LinearProgressIndicator(
                                    color: commentSectionColor,
                                  ),
                                )
                              : Text("More comments",
                                  style: TextStyle(
                                    color: commentSectionColor,
                                  )),
                        ),
                      ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
