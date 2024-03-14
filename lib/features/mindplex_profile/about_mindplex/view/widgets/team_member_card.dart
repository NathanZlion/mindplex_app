import 'package:flutter/material.dart';
import 'package:mindplex/features/mindplex_profile/about_mindplex/models/TeamMember.dart';

class TeamMemberCard extends StatelessWidget {
  final TeamMember teamMember;
  const TeamMemberCard({super.key, required this.teamMember});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    print(width);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 400,
          color: Color.fromARGB(255, 3, 70, 93),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(teamMember.profilePic!),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  teamMember.name!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Container(
                  child: Text(
                    teamMember.position!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: width * 0.04,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Spacer(),
                Center(
                  child: Container(
                    width: 40,
                    height: height * 0.067,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      // border: Border.all(
                      //   width: 2,
                      //   color: const Color.fromARGB(208, 178, 178, 178),
                      // ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                          fit: BoxFit.cover,
                          "assets/images/linkedin_white_logo.png"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
